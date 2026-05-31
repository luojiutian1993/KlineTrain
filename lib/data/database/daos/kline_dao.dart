import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';
import 'package:logger/logger.dart';

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
  /// 使用自定义SQL避免drift自动解析DateTime时的格式问题
  Future<List<KlineDataData>> getKlineData(
    String symbol,
    String period, {
    DateTime? startDate,
    DateTime? endDate,
    int limit = 1000,
  }) async {
    String sql = '''
      SELECT 
        symbol,
        market_code,
        period,
        trade_date,
        open,
        high,
        low,
        close,
        volume,
        amount,
        turnover_rate,
        pe,
        pb,
        created_at
      FROM kline_data
      WHERE symbol = ? AND period = ?
      ORDER BY trade_date ASC
      LIMIT ?
    ''';

    final variables = [
      Variable.withString(symbol),
      Variable.withString(period),
      Variable.withInt(limit),
    ];

    if (startDate != null) {
      sql = sql.replaceFirst('WHERE', 'WHERE trade_date >= ? AND');
      variables.insert(0, Variable.withString(_dateTimeToString(startDate)));
    }
    if (endDate != null) {
      sql = sql.replaceFirst('WHERE', 'WHERE trade_date <= ? AND');
      variables.insert(0, Variable.withString(_dateTimeToString(endDate)));
    }

    final query = customSelect(sql, variables: variables);
    final results = await query.get();

    return results.map((row) {
      final rowData = row.data;
      return KlineDataData(
        symbol: rowData['symbol']?.toString() ?? '',
        marketCode: rowData['market_code']?.toString() ?? '',
        period: rowData['period']?.toString() ?? '',
        tradeDate: _parseDateTimeFromString(rowData['trade_date']?.toString() ?? ''),
        open: (rowData['open'] as num?)?.toDouble() ?? 0.0,
        high: (rowData['high'] as num?)?.toDouble() ?? 0.0,
        low: (rowData['low'] as num?)?.toDouble() ?? 0.0,
        close: (rowData['close'] as num?)?.toDouble() ?? 0.0,
        volume: (rowData['volume'] as num?)?.toDouble() ?? 0.0,
        amount: (rowData['amount'] as num?)?.toDouble() ?? 0.0,
        turnoverRate: (rowData['turnover_rate'] as num?)?.toDouble(),
        pe: (rowData['pe'] as num?)?.toDouble(),
        pb: (rowData['pb'] as num?)?.toDouble(),
        createdAt: _parseDateTimeFromString(rowData['created_at']?.toString() ?? ''),
      );
    }).toList();
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
    )
        .map((row) => KlineDataData(
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
            ))
        .get() as Future<List<KlineDataData>>;
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
    )
        .map((row) => KlineDataData(
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
            ))
        .get() as Future<List<KlineDataData>>;
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
    )
        .map((row) => KlineDataData(
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
            ))
        .get() as Future<List<KlineDataData>>;
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
    )
        .map((row) => KlineDataData(
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
            ))
        .get() as Future<List<KlineDataData>>;
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
    final countQuery = klineData.symbol.count();
    final query = selectOnly(klineData)
      ..addColumns([countQuery])
      ..where(klineData.symbol.equals(symbol))
      ..where(klineData.period.equals(period));
    final result = await query.getSingle();
    return result.read(countQuery) ?? 0;
  }

  /// 获取有完整K线数据的股票列表
  /// 用于随机选股功能
  ///
  /// [minDays]: 最少需要的日线数据天数（默认210天：150天训练 + 60天预热）
  /// [marketCodes]: 市场代码列表（如['SH', 'SZ']）
  ///
  /// → AC-002, AC-011
  Future<List<Symbol>> getSymbolsWithCompleteKlineData({
    int minDays = 210,
    List<String>? marketCodes,
  }) async {
    final allSymbols = await getSymbols();

    final result = <Symbol>[];
    for (final symbol in allSymbols) {
      if (marketCodes != null && marketCodes.isNotEmpty) {
        final symbolPrefix = _extractMarketPrefix(symbol.symbol);
        if (!_matchesMarketCode(symbolPrefix, marketCodes)) {
          continue;
        }
      }

      final count = await countKlineData(symbol.symbol, 'day');
      if (count >= minDays) {
        result.add(symbol);
      }
    }

    return result;
  }

  /// 直接从 kline_data 表查询有足够数据的股票列表
  /// 用于随机选股功能 - 不依赖 symbols 表
  ///
  /// [minDays]: 最少需要的日线数据天数（默认210天：150天训练 + 60天预热）
  ///
  /// 返回: 包含 symbol（纯数字格式）和 market_code 的列表
  /// → AC-006, AC-007
  Future<List<Map<String, String>>> getSymbolsWithMinKlineData({
    int minDays = 210,
  }) async {
    print('🟣🟣🟣 [getSymbolsWithMinKlineData] 开始查询, minDays=$minDays');

    final query = customSelect(
      '''
      SELECT DISTINCT symbol, market_code
      FROM kline_data
      WHERE period = 'day'
      GROUP BY symbol, market_code
      HAVING COUNT(*) >= ?
      ORDER BY symbol
      ''',
      variables: [Variable.withInt(minDays)],
      readsFrom: {klineData},
    );

    final results = await query.get();
    print('🟣🟣🟣 [getSymbolsWithMinKlineData] 查询结果: ${results.length} 条');

    final stockList = results.map((row) {
      final data = row.data;
      return {
        'symbol': data['symbol']?.toString() ?? '',
        'marketCode': data['market_code']?.toString() ?? '',
      };
    }).toList();

    return stockList;
  }

  String _extractMarketPrefix(String symbol) {
    if (symbol.startsWith('SH') && symbol.length > 2) {
      return 'SH';
    } else if (symbol.startsWith('SZ') && symbol.length > 2) {
      return 'SZ';
    }
    return '';
  }

  bool _matchesMarketCode(String prefix, List<String> marketCodes) {
    for (final code in marketCodes) {
      if (prefix == code) return true;
    }
    return false;
  }

  /// 标准化symbol格式：移除市场前缀(SH/SZ)或后缀(.XSHE/.XSHG)
  String _normalizeSymbolForQuery(String symbol) {
    String normalized = symbol;

    // 移除市场前缀 (SH, SZ, XSHE, XSHG)
    if (normalized.startsWith('SH') && normalized.length > 2) {
      normalized = normalized.substring(2);
    } else if (normalized.startsWith('SZ') && normalized.length > 2) {
      normalized = normalized.substring(2);
    }
    // 移除市场后缀 (.XSHE, .XSHG)
    else if (normalized.contains('.')) {
      normalized = normalized.split('.')[0];
    }

    return normalized;
  }

  /// DateTime转Unix时间戳（秒）
  int _dateTimeToTimestamp(DateTime dt) {
    return dt.millisecondsSinceEpoch ~/ 1000;
  }

  /// 获取指定时间范围内的K线数据
  /// 使用原始SQL直接过滤日期，手动解析DateTime避免Drift二次解析问题
  Future<List<KlineDataData>> getKlineDataRange(
    String symbol,
    String period,
    DateTime startTime,
    DateTime endTime,
  ) async {
    print('🟣🟣🟣 [6.DAO查询] getKlineDataRange 开始');

    final String normalizedSymbol = _normalizeSymbolForQuery(symbol);
    final String startDateStr = _dateTimeToString(startTime);
    final String endDateStr = _dateTimeToString(endTime);

    print('🟣🟣🟣 [6.DAO查询] 参数详情:');
    print('🟣🟣🟣   - 原始symbol: $symbol');
    print('🟣🟣🟣   - 标准化symbol: $normalizedSymbol');
    print('🟣🟣🟣   - period: $period');
    print('🟣🟣🟣   - startDate: $startDateStr');
    print('🟣🟣🟣   - endDate: $endDateStr');

    final query = customSelect(
      '''
      SELECT 
        symbol,
        market_code,
        period,
        trade_date,
        open,
        high,
        low,
        close,
        volume,
        amount,
        created_at
      FROM kline_data
      WHERE (symbol = ? OR symbol = ?)
        AND period = ?
        AND trade_date >= ?
        AND trade_date <= ?
      ORDER BY trade_date ASC
      ''',
      variables: [
        Variable.withString(symbol),
        Variable.withString(normalizedSymbol),
        Variable.withString(period),
        Variable.withString('$startDateStr 00:00:00'),
        Variable.withString('$endDateStr 23:59:59'),
      ],
    );

    print('🟣🟣🟣 [6.DAO查询] 执行SQL查询...');
    final results = await query.get();

    final dataList = results.map((row) {
      final rowData = row.data;
      final tradeDateStr = rowData['trade_date']?.toString() ?? '';
      final createdAtStr = rowData['created_at']?.toString() ?? '';

      return KlineDataData(
        symbol: rowData['symbol']?.toString() ?? '',
        marketCode: rowData['market_code']?.toString() ?? '',
        period: rowData['period']?.toString() ?? '',
        tradeDate: _parseDateTimeFromString(tradeDateStr),
        open: (rowData['open'] as num?)?.toDouble() ?? 0.0,
        high: (rowData['high'] as num?)?.toDouble() ?? 0.0,
        low: (rowData['low'] as num?)?.toDouble() ?? 0.0,
        close: (rowData['close'] as num?)?.toDouble() ?? 0.0,
        volume: (rowData['volume'] as num?)?.toDouble() ?? 0.0,
        amount: (rowData['amount'] as num?)?.toDouble() ?? 0.0,
        createdAt: _parseDateTimeFromString(createdAtStr),
      );
    }).toList();

    print('🟣🟣🟣 [6.DAO查询] 查询结果: ${dataList.length} 条');
    return dataList;
  }

  /// 从字符串解析DateTime，使用多种格式兼容
  DateTime _parseDateTimeFromString(String value) {
    if (value == null || value.isEmpty) {
      return DateTime.now();
    }

    try {
      if (value.contains('T')) {
        return DateTime.parse(value);
      } else if (value.contains(' ')) {
        return DateTime.parse(value.replaceAll(' ', 'T'));
      } else {
        return DateTime.parse('${value}T00:00:00');
      }
    } catch (e) {
      final parts = value.split(RegExp(r'[-/]'));
      if (parts.length >= 3) {
        final year = int.tryParse(parts[0].trim());
        final month = int.tryParse(parts[1].trim());
        final day = int.tryParse(parts[2].trim());
        if (year != null && month != null && day != null) {
          return DateTime(year, month, day);
        }
      }
    }
    return DateTime.now();
  }

  String _dateTimeToString(DateTime dt) {
    final String year = dt.year.toString();
    final String month = dt.month.toString().padLeft(2, '0');
    final String day = dt.day.toString().padLeft(2, '0');
    return year + '-' + month + '-' + day;
  }

  DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    } else if (value is int) {
      // Unix时间戳（秒）
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    } else if (value is String) {
      try {
        if (value.contains('T')) {
          return DateTime.parse(value);
        } else if (value.contains(' ')) {
          return DateTime.parse(value.replaceAll(' ', 'T'));
        } else {
          return DateTime.parse('${value}T00:00:00');
        }
      } catch (e) {
        final parts = value.split(RegExp(r'[-/]'));
        if (parts.length >= 3) {
          final year = int.tryParse(parts[0].trim());
          final month = int.tryParse(parts[1].trim());
          final day = int.tryParse(parts[2].trim());
          if (year != null && month != null && day != null) {
            return DateTime(year, month, day);
          }
        }
        rethrow;
      }
    }
    throw ArgumentError(
        'Cannot parse DateTime from $value (type: ${value.runtimeType})');
  }

  KlineDataData _parseKlineDataFromRow(QueryRow row) {
    return KlineDataData(
      symbol: row.readString('symbol'),
      marketCode: row.readString('market_code'),
      period: row.readString('period'),
      tradeDate: _parseDateTime(row.read<dynamic>('trade_date')),
      open: row.readDouble('open'),
      high: row.readDouble('high'),
      low: row.readDouble('low'),
      close: row.readDouble('close'),
      volume: row.readDouble('volume'),
      amount: row.readDouble('amount'),
      createdAt: _parseDateTime(row.read<dynamic>('created_at')),
    );
  }
}
