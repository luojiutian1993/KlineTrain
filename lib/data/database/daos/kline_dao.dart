import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';

part 'kline_dao.g.dart';

/// K线相关数据访问对象
@DriftAccessor(tables: [Markets, Symbols, KlineData])
class KlineDao extends DatabaseAccessor<AppDatabase> with _$KlineDaoMixin {
  KlineDao(super.db);



  /// 获取所有启用的市场
  Future<List<Market>> getMarkets() {
    return (select(markets)
          ..where((t) => t.enabled.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// 获取所有启用的标的
  Future<List<Symbol>> getSymbols({String? marketCode}) {
    final query = select(symbols)..where((t) => t.enabled.equals(true));
    if (marketCode != null) {
      query.where((t) => t.marketCode.equals(marketCode));
    }
    return query.get();
  }

  /// 通过代码获取标的
  Future<Symbol?> getSymbolByCode(String code) {
    return (select(symbols)..where((t) => t.symbol.equals(code)))
        .getSingleOrNull();
  }

  /// 添加或更新标的
  Future<void> upsertSymbol(SymbolsCompanion symbol) {
    return into(symbols).insertOnConflictUpdate(symbol);
  }

  /// 获取指定标的的K线数据
  Future<List<KlineDataData>> getKlineData(
    String symbol,
    String period, {
    DateTime? startDate,
    DateTime? endDate,
    int limit = 1000,
  }) async {
    final buffer = StringBuffer(
      'SELECT * FROM kline_data WHERE symbol = ? AND period = ?',
    );
    final List<Variable> variables = [
      Variable.withString(symbol),
      Variable.withString(period),
    ];

    if (startDate != null) {
      buffer.write(' AND trade_date >= ?');
      variables.add(Variable.withString(_dateToString(startDate)));
    }
    if (endDate != null) {
      buffer.write(' AND trade_date <= ?');
      variables.add(Variable.withString(_dateToString(endDate)));
    }

    buffer.write(' ORDER BY trade_date ASC LIMIT ?');
    variables.add(Variable.withInt(limit));

    final results = await customSelect(
      buffer.toString(),
      variables: variables,
      readsFrom: {klineData},
    ).get();

    return results.map((row) => _buildKlineDataFromRow(row)).toList();
  }

  /// 日期转字符串格式 "YYYY-MM-DD"
  String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 字符串转日期 "YYYY-MM-DD"
  DateTime _stringToDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length >= 3) {
        return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      }
    } catch (e) {
      // 如果解析失败，返回默认日期
    }
    return DateTime(2000, 1, 1);
  }

  /// 从 QueryRow 构建 KlineDataData 对象
  KlineDataData _buildKlineDataFromRow(QueryRow row) {
    final tradeDateStr = row.readString('trade_date');
    return KlineDataData(
      symbol: row.readString('symbol'),
      marketCode: row.readString('market_code'),
      period: row.readString('period'),
      tradeDate: _stringToDate(tradeDateStr),
      open: row.readDouble('open'),
      close: row.readDouble('close'),
      high: row.readDouble('high'),
      low: row.readDouble('low'),
      volume: row.readDouble('volume'),
      amount: row.readDouble('amount'),
      turnoverRate: row.readNullable<double>('turnover_rate'),
      pe: row.readNullable<double>('pe'),
      pb: row.readNullable<double>('pb'),
      createdAt: DateTime.now(),
    );
  }

  /// 从日线数据聚合周线数据
  Future<List<KlineDataData>> aggregateWeeklyKline(String symbol) {
    return customSelect(
      '''
      SELECT 
        symbol,
        market_code,
        'week' as period,
        date_trunc('week', trade_date) + INTERVAL '4 days' as trade_date,
        FIRST_VALUE(open) OVER (PARTITION BY symbol, date_trunc('week', trade_date) ORDER BY trade_date) as open,
        MAX(high) OVER (PARTITION BY symbol, date_trunc('week', trade_date)) as high,
        MIN(low) OVER (PARTITION BY symbol, date_trunc('week', trade_date)) as low,
        LAST_VALUE(close) OVER (PARTITION BY symbol, date_trunc('week', trade_date) ORDER BY trade_date) as close,
        SUM(volume) OVER (PARTITION BY symbol, date_trunc('week', trade_date)) as volume,
        SUM(amount) OVER (PARTITION BY symbol, date_trunc('week', trade_date)) as amount
      FROM kline_data
      WHERE symbol = ? AND period = 'day'
      ORDER BY trade_date
      ''',
      variables: [Variable.withString(symbol)],
      readsFrom: {klineData},
    ).map((row) => KlineDataData(
          symbol: row.readString(klineData.symbol.name),
          marketCode: row.readString(klineData.marketCode.name),
          period: 'week',
          tradeDate: row.readDateTime('trade_date'),
          open: row.readDouble(klineData.open.name),
          high: row.readDouble(klineData.high.name),
          low: row.readDouble(klineData.low.name),
          close: row.readDouble(klineData.close.name),
          volume: row.readDouble(klineData.volume.name),
          amount: row.readDouble(klineData.amount.name),
          createdAt: DateTime.now(),
        )).get() as Future<List<KlineDataData>>;
  }

  /// 从日线数据聚合月线数据
  Future<List<KlineDataData>> aggregateMonthlyKline(String symbol) {
    return customSelect(
      '''
      SELECT 
        symbol,
        market_code,
        'month' as period,
        date_trunc('month', trade_date) + INTERVAL '1 month - 1 day' as trade_date,
        FIRST_VALUE(open) OVER (PARTITION BY symbol, date_trunc('month', trade_date) ORDER BY trade_date) as open,
        MAX(high) OVER (PARTITION BY symbol, date_trunc('month', trade_date)) as high,
        MIN(low) OVER (PARTITION BY symbol, date_trunc('month', trade_date)) as low,
        LAST_VALUE(close) OVER (PARTITION BY symbol, date_trunc('month', trade_date) ORDER BY trade_date) as close,
        SUM(volume) OVER (PARTITION BY symbol, date_trunc('month', trade_date)) as volume,
        SUM(amount) OVER (PARTITION BY symbol, date_trunc('month', trade_date)) as amount
      FROM kline_data
      WHERE symbol = ? AND period = 'day'
      ORDER BY trade_date
      ''',
      variables: [Variable.withString(symbol)],
      readsFrom: {klineData},
    ).map((row) => KlineDataData(
          symbol: row.readString(klineData.symbol.name),
          marketCode: row.readString(klineData.marketCode.name),
          period: 'month',
          tradeDate: row.readDateTime('trade_date'),
          open: row.readDouble(klineData.open.name),
          high: row.readDouble(klineData.high.name),
          low: row.readDouble(klineData.low.name),
          close: row.readDouble(klineData.close.name),
          volume: row.readDouble(klineData.volume.name),
          amount: row.readDouble(klineData.amount.name),
          createdAt: DateTime.now(),
        )).get() as Future<List<KlineDataData>>;
  }

  /// 从日线数据聚合季线数据
  Future<List<KlineDataData>> aggregateQuarterlyKline(String symbol) {
    return customSelect(
      '''
      SELECT 
        symbol,
        market_code,
        'quarter' as period,
        CASE 
          WHEN strftime('%m', trade_date) BETWEEN '01' AND '03' THEN date(date_trunc('year', trade_date), '+2 months', 'start of month', '+1 month', '-1 day')
          WHEN strftime('%m', trade_date) BETWEEN '04' AND '06' THEN date(date_trunc('year', trade_date), '+5 months', 'start of month', '+1 month', '-1 day')
          WHEN strftime('%m', trade_date) BETWEEN '07' AND '09' THEN date(date_trunc('year', trade_date), '+8 months', 'start of month', '+1 month', '-1 day')
          ELSE date(date_trunc('year', trade_date), '+11 months', 'start of month', '+1 month', '-1 day')
        END as trade_date,
        FIRST_VALUE(open) OVER (PARTITION BY symbol, 
          CASE 
            WHEN strftime('%m', trade_date) BETWEEN '01' AND '03' THEN 1
            WHEN strftime('%m', trade_date) BETWEEN '04' AND '06' THEN 2
            WHEN strftime('%m', trade_date) BETWEEN '07' AND '09' THEN 3
            ELSE 4
          END ORDER BY trade_date) as open,
        MAX(high) OVER (PARTITION BY symbol, 
          CASE 
            WHEN strftime('%m', trade_date) BETWEEN '01' AND '03' THEN 1
            WHEN strftime('%m', trade_date) BETWEEN '04' AND '06' THEN 2
            WHEN strftime('%m', trade_date) BETWEEN '07' AND '09' THEN 3
            ELSE 4
          END) as high,
        MIN(low) OVER (PARTITION BY symbol, 
          CASE 
            WHEN strftime('%m', trade_date) BETWEEN '01' AND '03' THEN 1
            WHEN strftime('%m', trade_date) BETWEEN '04' AND '06' THEN 2
            WHEN strftime('%m', trade_date) BETWEEN '07' AND '09' THEN 3
            ELSE 4
          END) as low,
        LAST_VALUE(close) OVER (PARTITION BY symbol, 
          CASE 
            WHEN strftime('%m', trade_date) BETWEEN '01' AND '03' THEN 1
            WHEN strftime('%m', trade_date) BETWEEN '04' AND '06' THEN 2
            WHEN strftime('%m', trade_date) BETWEEN '07' AND '09' THEN 3
            ELSE 4
          END ORDER BY trade_date) as close,
        SUM(volume) OVER (PARTITION BY symbol, 
          CASE 
            WHEN strftime('%m', trade_date) BETWEEN '01' AND '03' THEN 1
            WHEN strftime('%m', trade_date) BETWEEN '04' AND '06' THEN 2
            WHEN strftime('%m', trade_date) BETWEEN '07' AND '09' THEN 3
            ELSE 4
          END) as volume,
        SUM(amount) OVER (PARTITION BY symbol, 
          CASE 
            WHEN strftime('%m', trade_date) BETWEEN '01' AND '03' THEN 1
            WHEN strftime('%m', trade_date) BETWEEN '04' AND '06' THEN 2
            WHEN strftime('%m', trade_date) BETWEEN '07' AND '09' THEN 3
            ELSE 4
          END) as amount
      FROM kline_data
      WHERE symbol = ? AND period = 'day'
      ORDER BY trade_date
      ''',
      variables: [Variable.withString(symbol)],
      readsFrom: {klineData},
    ).map((row) => KlineDataData(
          symbol: row.readString(klineData.symbol.name),
          marketCode: row.readString(klineData.marketCode.name),
          period: 'quarter',
          tradeDate: row.readDateTime('trade_date'),
          open: row.readDouble(klineData.open.name),
          high: row.readDouble(klineData.high.name),
          low: row.readDouble(klineData.low.name),
          close: row.readDouble(klineData.close.name),
          volume: row.readDouble(klineData.volume.name),
          amount: row.readDouble(klineData.amount.name),
          createdAt: DateTime.now(),
        )).get() as Future<List<KlineDataData>>;
  }

  /// 从日线数据聚合年线数据
  Future<List<KlineDataData>> aggregateYearlyKline(String symbol) {
    return customSelect(
      '''
      SELECT 
        symbol,
        market_code,
        'year' as period,
        date_trunc('year', trade_date) + INTERVAL '1 year - 1 day' as trade_date,
        FIRST_VALUE(open) OVER (PARTITION BY symbol, date_trunc('year', trade_date) ORDER BY trade_date) as open,
        MAX(high) OVER (PARTITION BY symbol, date_trunc('year', trade_date)) as high,
        MIN(low) OVER (PARTITION BY symbol, date_trunc('year', trade_date)) as low,
        LAST_VALUE(close) OVER (PARTITION BY symbol, date_trunc('year', trade_date) ORDER BY trade_date) as close,
        SUM(volume) OVER (PARTITION BY symbol, date_trunc('year', trade_date)) as volume,
        SUM(amount) OVER (PARTITION BY symbol, date_trunc('year', trade_date)) as amount
      FROM kline_data
      WHERE symbol = ? AND period = 'day'
      ORDER BY trade_date
      ''',
      variables: [Variable.withString(symbol)],
      readsFrom: {klineData},
    ).map((row) => KlineDataData(
          symbol: row.readString(klineData.symbol.name),
          marketCode: row.readString(klineData.marketCode.name),
          period: 'year',
          tradeDate: row.readDateTime('trade_date'),
          open: row.readDouble(klineData.open.name),
          high: row.readDouble(klineData.high.name),
          low: row.readDouble(klineData.low.name),
          close: row.readDouble(klineData.close.name),
          volume: row.readDouble(klineData.volume.name),
          amount: row.readDouble(klineData.amount.name),
          createdAt: DateTime.now(),
        )).get() as Future<List<KlineDataData>>;
  }

  /// 批量插入K线数据
  Future<void> batchInsertKline(List<KlineDataCompanion> data) {
    return batch((batch) {
      batch.insertAllOnConflictUpdate(klineData, data);
    });
  }

  /// 删除指定标的的K线数据
  Future<int> deleteKlineData(String symbol, String period) {
    return (delete(klineData)
          ..where((t) => t.symbol.equals(symbol))
          ..where((t) => t.period.equals(period)))
        .go();
  }

  /// 获取K线数据条数
  Future<int> countKlineData(String symbol, String period) async {
    final countResult = await customSelect(
      'SELECT COUNT(*) as count FROM kline_data WHERE symbol = ? AND period = ?',
      variables: [Variable.withString(symbol), Variable.withString(period)],
    ).getSingle();
    
    return countResult.read<int>('count');
  }

  /// 获取指定时间范围内的K线数据
  Future<List<KlineDataData>> getKlineDataRange(
    String symbol,
    String period,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final results = await customSelect(
      'SELECT * FROM kline_data WHERE symbol = ? AND period = ? AND trade_date >= ? AND trade_date <= ? ORDER BY trade_date ASC',
      variables: [
        Variable.withString(symbol),
        Variable.withString(period),
        Variable.withString(_dateToString(startTime)),
        Variable.withString(_dateToString(endTime)),
      ],
      readsFrom: {klineData},
    ).get();

    return results.map((row) => _buildKlineDataFromRow(row)).toList();
  }
}
