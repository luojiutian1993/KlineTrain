import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';
import '../../../core/enums/stock_filter_condition.dart';
import '../../../shared/utils/logger.dart';

part 'stock_filter_dao.g.dart';

/// 选股算法数据访问对象
@DriftAccessor(
    tables: [Symbols, KlineData, StockFilterResults, DailyStockStats])
class StockFilterDao extends DatabaseAccessor<AppDatabase>
    with _$StockFilterDaoMixin {
  StockFilterDao(super.db);

  Future<List<Symbol>> getActiveSymbols(
      {String? marketCode, List<String>? marketCodes}) async {
    appLogger.i(
        'getActiveSymbols - marketCode: $marketCode, marketCodes: $marketCodes');

    // 过滤掉无效的市场代码
    List<String>? validMarketCodes;
    if (marketCodes != null && marketCodes.isNotEmpty) {
      validMarketCodes = marketCodes
          .where((code) => ['XSHG', 'XSHE', 'HKEX'].contains(code))
          .toList();
      appLogger.i('过滤后有效的市场代码: $validMarketCodes');
    }

    final query = select(symbols)..where((t) => t.enabled.equals(true));

    if (validMarketCodes != null && validMarketCodes.isNotEmpty) {
      query.where((t) => t.marketCode.isIn(validMarketCodes!));
    } else if (marketCode != null) {
      query.where((t) => t.marketCode.equals(marketCode));
    }

    final result = await query.get();
    appLogger.i('getActiveSymbols - 返回 ${result.length} 个标的');
    return result;
  }

  String _mapMarketCode(String marketCode) {
    switch (marketCode) {
      case 'XSHG':
        return 'SH';
      case 'XSHE':
        return 'SZ';
      case 'HKEX':
        return 'HK';
      case 'NASDAQ':
      case 'NYSE':
        return 'US';
      default:
        return marketCode;
    }
  }

  /// 日期转字符串格式 "YYYY-MM-DD"
  String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 字符串转日期 "YYYY-MM-DD"
  DateTime _stringToDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return DateTime(
            int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      }
    } catch (e) {
      // 如果解析失败，返回默认日期
    }
    return DateTime(2000, 1, 1);
  }

  /// 从 QueryRow 构建 KlineDataData 对象
  KlineDataData _buildKlineDataFromRow(QueryRow row) {
    final tradeDateStr = row.read<String>('trade_date');
    return KlineDataData(
      symbol: row.read<String>('symbol'),
      marketCode: row.read<String>('market_code'),
      period: row.read<String>('period'),
      tradeDate: _stringToDate(tradeDateStr),
      open: row.read<double>('open'),
      close: row.read<double>('close'),
      high: row.read<double>('high'),
      low: row.read<double>('low'),
      volume: row.read<double>('volume'),
      amount: row.read<double>('amount'),
      turnoverRate: row.read<double?>('turnover_rate'),
      pe: row.read<double?>('pe'),
      pb: row.read<double?>('pb'),
      createdAt: DateTime.now(),
    );
  }

  /// 获取有K线数据的最近日期
  Future<DateTime?> getLatestKlineDate() async {
    final result = await customSelect(
      'SELECT MAX(trade_date) as max_date FROM kline_data WHERE period = ?',
      variables: [const Variable('day')],
    ).getSingle();
    final dateStr = result.read<String?>('max_date');
    return dateStr != null ? _stringToDate(dateStr) : null;
  }

  /// 获取K线数据库的时间范围
  Future<(DateTime, DateTime)> getKlineDateRange() async {
    appLogger.i('开始查询K线数据日期范围...');

    try {
      // 先检查是否有数据
      final countResult = await (selectOnly(klineData)
            ..addColumns([klineData.symbol.count()])
            ..where(klineData.period.equals('day')))
          .getSingle();

      final count = countResult.read(klineData.symbol.count());
      if (count == null || count == 0) {
        appLogger.w('K线数据表为空，返回默认日期范围');
        return (DateTime(2000, 1, 1), DateTime.now());
      }

      final minResult = await (selectOnly(klineData)
            ..addColumns([klineData.tradeDate.min()])
            ..where(klineData.period.equals('day')))
          .getSingle();

      final maxResult = await (selectOnly(klineData)
            ..addColumns([klineData.tradeDate.max()])
            ..where(klineData.period.equals('day')))
          .getSingle();

      final minDate = minResult.read(klineData.tradeDate.min());
      final maxDate = maxResult.read(klineData.tradeDate.max());

      appLogger.i('查询到的日期范围: min=$minDate, max=$maxDate');

      return (
        minDate ?? DateTime(2000, 1, 1),
        maxDate ?? DateTime.now(),
      );
    } catch (e, stackTrace) {
      appLogger.e('查询K线日期范围失败', error: e, stackTrace: stackTrace);
      return (DateTime(2000, 1, 1), DateTime.now());
    }
  }

  /// 批量获取多个标的的K线数据
  Future<Map<String, List<KlineDataData>>> getBatchKlineData(
    List<String> symbols,
    String period,
    DateTime startDate,
    DateTime endDate, {
    int? limit,
  }) async {
    appLogger.i('批量获取 ${symbols.length} 个标的的K线数据...');

    final query = select(klineData)
      ..where((t) => t.symbol.isIn(symbols))
      ..where((t) => t.period.equals(period))
      ..where((t) => t.tradeDate.isBiggerOrEqualValue(startDate))
      ..where((t) => t.tradeDate.isSmallerOrEqualValue(endDate));

    if (limit != null) {
      query.limit(limit * symbols.length);
    }

    final results = await query.get();
    final grouped = <String, List<KlineDataData>>{};

    for (final data in results) {
      grouped.putIfAbsent(data.symbol, () => []).add(data);
    }

    // 按日期排序
    for (final list in grouped.values) {
      list.sort((a, b) => b.tradeDate.compareTo(a.tradeDate));
    }

    appLogger.i('批量查询完成，获取到 ${results.length} 条K线数据');
    return grouped;
  }

  /// 批量获取多个标的在指定日期的K线数据
  Future<Map<String, KlineDataData?>> getBatchKlineDataForDate(
    List<String> symbols,
    String period,
    DateTime date,
  ) async {
    appLogger.i('批量获取 ${symbols.length} 个标的在 $date 的K线数据...');

    final result = <String, KlineDataData?>{};
    if (symbols.isEmpty) return result;

    // 使用子查询获取每个标的在指定日期或最近日期的数据
    final results = await customSelect(
      '''
      SELECT k.* FROM kline_data k
      INNER JOIN (
        SELECT symbol, MAX(trade_date) as max_date 
        FROM kline_data 
        WHERE symbol IN (${symbols.map((_) => '?').join(',')}) 
          AND period = ? 
          AND trade_date <= ?
        GROUP BY symbol
      ) sub ON k.symbol = sub.symbol AND k.trade_date = sub.max_date
      WHERE k.period = ?
      ''',
      variables: [
        ...symbols.map((s) => Variable(s)),
        const Variable('day'),
        Variable(date),
        const Variable('day'),
      ],
    ).get();

    for (final row in results) {
      final kline = _buildKlineDataFromRow(row);
      result[kline.symbol] = kline;
    }

    // 确保所有标的都有记录（即使没有数据）
    for (final symbol in symbols) {
      result.putIfAbsent(symbol, () => null);
    }

    appLogger.i('批量日期查询完成');
    return result;
  }

  /// 批量计算多个标的的历史最高收盘价
  Future<Map<String, double>> getBatchHistoricalMaxClose(
    List<String> symbols,
    DateTime date, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    appLogger.i('批量计算 ${symbols.length} 个标的的历史最高收盘价...');

    final result = <String, double>{};
    if (symbols.isEmpty) return result;

    final effectiveStartDate = startDate ?? DateTime(1990, 1, 1);
    final effectiveEndDate = endDate ?? date;

    final results = await customSelect(
      '''
      SELECT symbol, MAX(close) as max_close 
      FROM kline_data 
      WHERE symbol IN (${symbols.map((_) => '?').join(',')}) 
        AND period = ? 
        AND trade_date >= ? 
        AND trade_date <= ?
      GROUP BY symbol
      ''',
      variables: [
        ...symbols.map((s) => Variable(s)),
        const Variable('day'),
        Variable(effectiveStartDate),
        Variable(effectiveEndDate),
      ],
    ).get();

    for (final row in results) {
      result[row.read<String>('symbol')] =
          row.read<double?>('max_close') ?? 0.0;
    }

    for (final symbol in symbols) {
      result.putIfAbsent(symbol, () => 0.0);
    }

    appLogger.i('批量历史最高计算完成');
    return result;
  }

  Future<KlineDataData?> getKlineDataForDate(
      String symbol, String period, DateTime date) async {
    final dateStr = _dateToString(date);
    final results = await customSelect(
      'SELECT * FROM kline_data WHERE symbol = ? AND period = ? AND trade_date = ? LIMIT 1',
      variables: [Variable(symbol), Variable(period), Variable(dateStr)],
    ).get();

    if (results.isEmpty) return null;

    return _buildKlineDataFromRow(results.first);
  }

  Future<KlineDataData?> getLastKlineDataInRange(String symbol, String period,
      DateTime startDate, DateTime endDate) async {
    final startDateStr = _dateToString(startDate);
    final endDateStr = _dateToString(endDate);

    final results = await customSelect(
      'SELECT * FROM kline_data WHERE symbol = ? AND period = ? AND trade_date >= ? AND trade_date <= ? ORDER BY trade_date DESC LIMIT 1',
      variables: [
        Variable(symbol),
        Variable(period),
        Variable(startDateStr),
        Variable(endDateStr)
      ],
    ).get();

    if (results.isEmpty) return null;

    return _buildKlineDataFromRow(results.first);
  }

  Future<List<KlineDataData>> getKlineDataBefore(
    String symbol,
    String period,
    DateTime date,
    int days, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final dateStr = _dateToString(date);
    final effectiveStartDate =
        startDate != null ? _dateToString(startDate) : '1990-01-01';
    final effectiveEndDate = endDate != null ? _dateToString(endDate) : dateStr;

    final results = await customSelect(
      'SELECT * FROM kline_data WHERE symbol = ? AND period = ? AND trade_date >= ? AND trade_date <= ? ORDER BY trade_date DESC LIMIT ?',
      variables: [
        Variable(symbol),
        Variable(period),
        Variable(effectiveStartDate),
        Variable(effectiveEndDate),
        Variable(days)
      ],
    ).get();

    return results.map((row) => _buildKlineDataFromRow(row)).toList();
  }

  Future<bool> checkAllTimeHigh(String symbol, DateTime date,
      {DateTime? startDate, DateTime? endDate}) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final historicalMax = await _getHistoricalMaxClose(symbol, date,
        startDate: startDate, endDate: endDate);
    return (currentData.close - historicalMax).abs() < 0.0001;
  }

  Future<double> _getHistoricalMaxClose(String symbol, DateTime date,
      {DateTime? startDate, DateTime? endDate}) async {
    final effectiveStartDateStr =
        startDate != null ? _dateToString(startDate) : '1990-01-01';
    final effectiveEndDateStr =
        endDate != null ? _dateToString(endDate) : _dateToString(date);

    final result = await customSelect(
      'SELECT MAX(close) as max_close FROM kline_data WHERE symbol = ? AND period = ? AND trade_date >= ? AND trade_date <= ?',
      variables: [
        Variable(symbol),
        const Variable('day'),
        Variable(effectiveStartDateStr),
        Variable(effectiveEndDateStr)
      ],
    ).getSingle();

    return result.read<double?>('max_close') ?? 0.0;
  }

  Future<bool> checkYearHigh(String symbol, DateTime date,
      {DateTime? startDate, DateTime? endDate}) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final yearData = await getKlineDataBefore(symbol, 'day', date, 252,
        startDate: startDate, endDate: endDate);
    if (yearData.isEmpty) return false;

    final maxClose =
        yearData.map((d) => d.close).reduce((a, b) => a > b ? a : b);
    return (currentData.close - maxClose).abs() < 0.0001;
  }

  Future<bool> check200DayHigh(String symbol, DateTime date,
      {DateTime? startDate, DateTime? endDate}) async {
    KlineDataData? currentData;
    if (startDate != null && endDate != null) {
      currentData =
          await getLastKlineDataInRange(symbol, 'day', startDate, endDate);
    } else {
      currentData = await getKlineDataForDate(symbol, 'day', date);
    }
    if (currentData == null) return false;

    final day200Data = await getKlineDataBefore(symbol, 'day', date, 200,
        startDate: startDate, endDate: endDate);
    if (day200Data.isEmpty) return false;

    final maxClose =
        day200Data.map((d) => d.close).reduce((a, b) => a > b ? a : b);
    return (currentData.close - maxClose).abs() < 0.0001;
  }

  Future<bool> checkAllTimeLow(String symbol, DateTime date,
      {DateTime? startDate, DateTime? endDate}) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final historicalMin = await _getHistoricalMinClose(symbol, date,
        startDate: startDate, endDate: endDate);
    return (currentData.close - historicalMin).abs() < 0.0001;
  }

  Future<double> _getHistoricalMinClose(String symbol, DateTime date,
      {DateTime? startDate, DateTime? endDate}) async {
    final effectiveStartDateStr =
        startDate != null ? _dateToString(startDate) : '1990-01-01';
    final effectiveEndDateStr =
        endDate != null ? _dateToString(endDate) : _dateToString(date);

    final result = await customSelect(
      'SELECT MIN(close) as min_close FROM kline_data WHERE symbol = ? AND period = ? AND trade_date >= ? AND trade_date <= ?',
      variables: [
        Variable(symbol),
        const Variable('day'),
        Variable(effectiveStartDateStr),
        Variable(effectiveEndDateStr)
      ],
    ).getSingle();

    return result.read<double?>('min_close') ?? double.infinity;
  }

  Future<bool> checkYearLow(String symbol, DateTime date,
      {DateTime? startDate, DateTime? endDate}) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final yearData = await getKlineDataBefore(symbol, 'day', date, 252,
        startDate: startDate, endDate: endDate);
    if (yearData.isEmpty) return false;

    final minClose =
        yearData.map((d) => d.close).reduce((a, b) => a < b ? a : b);
    return (currentData.close - minClose).abs() < 0.0001;
  }

  Future<bool> check200DayLow(String symbol, DateTime date) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final day200Data = await getKlineDataBefore(symbol, 'day', date, 200);
    if (day200Data.isEmpty) return false;

    final minClose =
        day200Data.map((d) => d.close).reduce((a, b) => a < b ? a : b);
    return (currentData.close - minClose).abs() < 0.0001;
  }

  Future<double?> calculateReturnNDays(String symbol, DateTime date, int n,
      {DateTime? startDate, DateTime? endDate}) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return null;

    final pastData = await getKlineDataBefore(symbol, 'day', date, n,
        startDate: startDate, endDate: endDate);
    if (pastData.length < n) return null;

    final nDaysAgoClose = pastData.last.close;
    if (nDaysAgoClose == 0) return null;

    return ((currentData.close / nDaysAgoClose) - 1) * 100;
  }

  Future<List<String>> getReturn30dTop50(DateTime date,
      {DateTime? startDate,
      DateTime? endDate,
      List<String>? marketCodes}) async {
    final allSymbols = await getActiveSymbols(marketCodes: marketCodes);
    final returns = <String, double>{};

    for (final symbol in allSymbols) {
      final ret = await calculateReturnNDays(symbol.symbol, date, 30,
          startDate: startDate, endDate: endDate);
      if (ret != null) {
        returns[symbol.symbol] = ret;
      }
    }

    if (returns.isEmpty) return [];

    final sorted = returns.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final cutoffIndex = (sorted.length * 0.5).ceil();
    return sorted.take(cutoffIndex).map((e) => e.key).toList();
  }

  Future<List<String>> getReturn15dTop50(DateTime date,
      {DateTime? startDate,
      DateTime? endDate,
      List<String>? marketCodes}) async {
    final allSymbols = await getActiveSymbols(marketCodes: marketCodes);
    final returns = <String, double>{};

    for (final symbol in allSymbols) {
      final ret = await calculateReturnNDays(symbol.symbol, date, 15,
          startDate: startDate, endDate: endDate);
      if (ret != null) {
        returns[symbol.symbol] = ret;
      }
    }

    if (returns.isEmpty) return [];

    final sorted = returns.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final cutoffIndex = (sorted.length * 0.5).ceil();
    return sorted.take(cutoffIndex).map((e) => e.key).toList();
  }

  Future<List<String>> getLoss30dTop50(DateTime date,
      {DateTime? startDate,
      DateTime? endDate,
      List<String>? marketCodes}) async {
    final allSymbols = await getActiveSymbols(marketCodes: marketCodes);
    final losses = <String, double>{};

    for (final symbol in allSymbols) {
      final ret = await calculateReturnNDays(symbol.symbol, date, 30,
          startDate: startDate, endDate: endDate);
      if (ret != null) {
        losses[symbol.symbol] = -ret;
      }
    }

    if (losses.isEmpty) return [];

    final sorted = losses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final cutoffIndex = (sorted.length * 0.5).ceil();
    return sorted.take(cutoffIndex).map((e) => e.key).toList();
  }

  Future<List<String>> getLoss15dTop50(DateTime date,
      {DateTime? startDate,
      DateTime? endDate,
      List<String>? marketCodes}) async {
    final allSymbols = await getActiveSymbols(marketCodes: marketCodes);
    final losses = <String, double>{};

    for (final symbol in allSymbols) {
      final ret = await calculateReturnNDays(symbol.symbol, date, 15,
          startDate: startDate, endDate: endDate);
      if (ret != null) {
        losses[symbol.symbol] = -ret;
      }
    }

    if (losses.isEmpty) return [];

    final sorted = losses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final cutoffIndex = (sorted.length * 0.5).ceil();
    return sorted.take(cutoffIndex).map((e) => e.key).toList();
  }

  Future<bool> checkLimitUp(String symbol, DateTime date) async {
    final data = await getKlineDataForDate(symbol, 'day', date);
    if (data == null) return false;
    return (data.close - data.high).abs() < 0.0001;
  }

  Future<bool> checkConsecutiveLimitUp(String symbol, DateTime date) async {
    final today = await getKlineDataForDate(symbol, 'day', date);
    if (today == null || (today.close - today.high).abs() > 0.0001) {
      return false;
    }

    final yesterdayData = await getKlineDataBefore(symbol, 'day', date, 2);
    if (yesterdayData.length < 2) return false;

    final yesterday = yesterdayData[0];
    return (yesterday.close - yesterday.high).abs() < 0.0001;
  }

  Future<bool> checkLimitDown(String symbol, DateTime date) async {
    final data = await getKlineDataForDate(symbol, 'day', date);
    if (data == null) return false;
    return (data.close - data.low).abs() < 0.0001;
  }

  Future<bool> checkConsecutiveLimitDown(String symbol, DateTime date) async {
    final today = await getKlineDataForDate(symbol, 'day', date);
    if (today == null || (today.close - today.low).abs() > 0.0001) {
      return false;
    }

    final yesterdayData = await getKlineDataBefore(symbol, 'day', date, 2);
    if (yesterdayData.length < 2) return false;

    final yesterday = yesterdayData[0];
    return (yesterday.close - yesterday.low).abs() < 0.0001;
  }

  Future<bool> checkVolumePriceUp(String symbol, DateTime date) async {
    final today = await getKlineDataForDate(symbol, 'day', date);
    if (today == null) return false;

    final yesterdayData = await getKlineDataBefore(symbol, 'day', date, 2);
    if (yesterdayData.length < 2) return false;

    final yesterday = yesterdayData[0];
    if (yesterday.close == 0 || yesterday.volume == 0) return false;

    final priceIncrease = (today.close / yesterday.close) - 1;
    final volumeIncrease = (today.volume / yesterday.volume) - 1;

    return priceIncrease > 0.02 && volumeIncrease > 0.05;
  }

  Future<double?> calculateMA(String symbol, DateTime date, int n,
      {DateTime? startDate, DateTime? endDate}) async {
    final data = await getKlineDataBefore(symbol, 'day', date, n,
        startDate: startDate, endDate: endDate);
    if (data.length < n) return null;

    final sum = data.take(n).fold<double>(0, (acc, d) => acc + d.close);
    return sum / n;
  }

  Future<bool> checkUpTrend(String symbol, DateTime date,
      {DateTime? startDate, DateTime? endDate}) async {
    final data = await getKlineDataBefore(symbol, 'day', date, 55,
        startDate: startDate, endDate: endDate);
    if (data.length < 55) return false;

    final ma10 = await calculateMA(symbol, date, 10,
        startDate: startDate, endDate: endDate);
    final ma20 = await calculateMA(symbol, date, 20,
        startDate: startDate, endDate: endDate);
    final ma50 = await calculateMA(symbol, date, 50,
        startDate: startDate, endDate: endDate);

    if (ma10 == null || ma20 == null || ma50 == null) return false;

    final yesterday = data[0].tradeDate;
    final ma10Yesterday = await calculateMA(symbol, yesterday, 10);
    final ma20Yesterday = await calculateMA(symbol, yesterday, 20);
    final ma50Yesterday = await calculateMA(symbol, yesterday, 50);

    if (ma10Yesterday == null ||
        ma20Yesterday == null ||
        ma50Yesterday == null) {
      return false;
    }

    final ma10Up = ma10 > ma10Yesterday;
    final ma20Up = ma20 > ma20Yesterday;
    final ma50Up = ma50 > ma50Yesterday;

    final bullishAlignment = ma10 > ma20 && ma20 > ma50;

    final angle10 = (ma10 - ma10Yesterday) / ma10Yesterday;
    final angle20 = (ma20 - ma20Yesterday) / ma20Yesterday;
    final angle50 = (ma50 - ma50Yesterday) / ma50Yesterday;

    final angleIncreasing =
        angle10 > angle20 - 0.0001 && angle20 > angle50 - 0.0001;

    return ma10Up && ma20Up && ma50Up && bullishAlignment && angleIncreasing;
  }

  Future<bool> checkDownTrend(String symbol, DateTime date,
      {DateTime? startDate, DateTime? endDate}) async {
    final data = await getKlineDataBefore(symbol, 'day', date, 55,
        startDate: startDate, endDate: endDate);
    if (data.length < 55) return false;

    final ma10 = await calculateMA(symbol, date, 10,
        startDate: startDate, endDate: endDate);
    final ma20 = await calculateMA(symbol, date, 20,
        startDate: startDate, endDate: endDate);
    final ma50 = await calculateMA(symbol, date, 50,
        startDate: startDate, endDate: endDate);

    if (ma10 == null || ma20 == null || ma50 == null) return false;

    final yesterday = data[0].tradeDate;
    final ma10Yesterday = await calculateMA(symbol, yesterday, 10);
    final ma20Yesterday = await calculateMA(symbol, yesterday, 20);
    final ma50Yesterday = await calculateMA(symbol, yesterday, 50);

    if (ma10Yesterday == null ||
        ma20Yesterday == null ||
        ma50Yesterday == null) {
      return false;
    }

    final ma10Down = ma10 < ma10Yesterday;
    final ma20Down = ma20 < ma20Yesterday;
    final ma50Down = ma50 < ma50Yesterday;

    final bearishAlignment = ma10 < ma20 && ma20 < ma50;

    final angle10 = (ma10 - ma10Yesterday) / ma10Yesterday;
    final angle20 = (ma20 - ma20Yesterday) / ma20Yesterday;
    final angle50 = (ma50 - ma50Yesterday) / ma50Yesterday;

    final angleDecreasing =
        angle10 < angle20 + 0.0001 && angle20 < angle50 + 0.0001;

    return ma10Down &&
        ma20Down &&
        ma50Down &&
        bearishAlignment &&
        angleDecreasing;
  }

  Future<List<String>> filterByCondition(
    StockFilterCondition condition,
    DateTime date, {
    String? marketCode,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? marketCodes,
  }) async {
    // 获取所有活跃标的
    final allSymbols = await getActiveSymbols(
      marketCode: marketCode,
      marketCodes: marketCodes,
    );
    final symbolCodes = allSymbols.map((s) => s.symbol).toList();

    switch (condition) {
      case StockFilterCondition.allTimeHigh:
        return batchCheckAllTimeHigh(symbolCodes, date,
            startDate: startDate, endDate: endDate);
      case StockFilterCondition.yearHigh:
        return batchCheckYearHigh(symbolCodes, date,
            startDate: startDate, endDate: endDate);
      case StockFilterCondition.day200High:
        return batchCheck200DayHigh(symbolCodes, date,
            startDate: startDate, endDate: endDate);
      case StockFilterCondition.return30dTop:
        return getReturn30dTop50(date,
            startDate: startDate, endDate: endDate, marketCodes: marketCodes);
      case StockFilterCondition.return15dTop:
        return getReturn15dTop50(date,
            startDate: startDate, endDate: endDate, marketCodes: marketCodes);
      case StockFilterCondition.limitUp:
        return batchCheckLimitUp(symbolCodes, date);
      case StockFilterCondition.consecutiveLimitUp:
        return batchCheckConsecutiveLimitUp(symbolCodes, date);
      case StockFilterCondition.volumePriceUp:
        return batchCheckVolumePriceUp(symbolCodes, date);
      case StockFilterCondition.upTrend:
        return batchCheckTrend(symbolCodes, date, true,
            startDate: startDate, endDate: endDate);
      case StockFilterCondition.allTimeLow:
        return batchCheckAllTimeLow(symbolCodes, date,
            startDate: startDate, endDate: endDate);
      case StockFilterCondition.yearLow:
        return batchCheckYearLow(symbolCodes, date,
            startDate: startDate, endDate: endDate);
      case StockFilterCondition.day200Low:
        return batchCheck200DayLow(symbolCodes, date);
      case StockFilterCondition.loss30dTop:
        return getLoss30dTop50(date,
            startDate: startDate, endDate: endDate, marketCodes: marketCodes);
      case StockFilterCondition.loss15dTop:
        return getLoss15dTop50(date,
            startDate: startDate, endDate: endDate, marketCodes: marketCodes);
      case StockFilterCondition.downTrend:
        return batchCheckTrend(symbolCodes, date, false,
            startDate: startDate, endDate: endDate);
      case StockFilterCondition.limitDown:
        return batchCheckLimitDown(symbolCodes, date);
      case StockFilterCondition.consecutiveLimitDown:
        return batchCheckConsecutiveLimitDown(symbolCodes, date);
      case StockFilterCondition.random:
        return _getRandomSymbols(
            marketCode: marketCode, marketCodes: marketCodes);
    }
  }

  Future<List<String>> _filterSingleSymbolCheck(
    Future<bool> Function(String) check, {
    String? marketCode,
    List<String>? marketCodes,
  }) async {
    final allSymbols = await getActiveSymbols(
      marketCode: marketCode,
      marketCodes: marketCodes,
    );

    appLogger.i('_filterSingleSymbolCheck - 开始检查 ${allSymbols.length} 个标的...');

    if (allSymbols.isEmpty) return [];

    // 将标的分批处理，避免内存过大
    const batchSize = 100;
    final results = <String>[];

    for (var i = 0; i < allSymbols.length; i += batchSize) {
      final batch = allSymbols.sublist(
        i,
        i + batchSize > allSymbols.length ? allSymbols.length : i + batchSize,
      );

      // 并行处理批次内的标的
      final futures = batch.map((symbol) async {
        try {
          if (await check(symbol.symbol)) {
            return symbol.symbol;
          }
        } catch (e) {
          // 忽略单个标的的错误
        }
        return null;
      });

      final batchResults = await Future.wait(futures);
      results.addAll(batchResults.where((s) => s != null).cast<String>());
    }

    appLogger.i('_filterSingleSymbolCheck - 完成，共找到 ${results.length} 个符合条件的标的');
    return results;
  }

  /// 批量检查历史新高（优化版本）
  Future<List<String>> batchCheckAllTimeHigh(
    List<String> symbols,
    DateTime date, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的历史新高...');

    if (symbols.isEmpty) return [];

    // 批量获取K线数据和历史最高
    final currentDataMap = await getBatchKlineDataForDate(symbols, 'day', date);
    final maxCloseMap = await getBatchHistoricalMaxClose(
      symbols,
      date,
      startDate: startDate,
      endDate: endDate,
    );

    final results = <String>[];
    for (final symbol in symbols) {
      final current = currentDataMap[symbol];
      final maxClose = maxCloseMap[symbol];

      if (current != null && maxClose != null && maxClose > 0) {
        if ((current.close - maxClose).abs() < 0.0001) {
          results.add(symbol);
        }
      }
    }

    appLogger.i('批量历史新高检查完成，找到 ${results.length} 个符合条件的标的');
    return results;
  }

  /// 批量检查趋势（优化版本）
  Future<List<String>> batchCheckTrend(
    List<String> symbols,
    DateTime date,
    bool isUpTrend, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的${isUpTrend ? '上升' : '下降'}趋势...');

    if (symbols.isEmpty) return [];

    // 批量获取K线数据（需要60天数据来计算MA）
    final effectiveStartDate = startDate ?? DateTime(1990, 1, 1);
    final klineDataMap = await getBatchKlineData(
      symbols,
      'day',
      effectiveStartDate,
      endDate ?? date,
      limit: 60,
    );

    final results = <String>[];
    for (final symbol in symbols) {
      final klineList = klineDataMap[symbol];
      if (klineList == null || klineList.length < 55) continue;

      // 计算MA
      final ma10 = _calculateMAFromList(klineList.take(10).toList());
      final ma20 = _calculateMAFromList(klineList.take(20).toList());
      final ma50 = _calculateMAFromList(klineList.take(50).toList());

      if (ma10 == null || ma20 == null || ma50 == null) continue;

      // 计算昨日MA
      if (klineList.length < 56) continue;
      final ma10Yesterday =
          _calculateMAFromList(klineList.skip(1).take(10).toList());
      final ma20Yesterday =
          _calculateMAFromList(klineList.skip(1).take(20).toList());
      final ma50Yesterday =
          _calculateMAFromList(klineList.skip(1).take(50).toList());

      if (ma10Yesterday == null ||
          ma20Yesterday == null ||
          ma50Yesterday == null) {
        continue;
      }

      // 判断趋势
      final ma10Up = ma10 > ma10Yesterday;
      final ma20Up = ma20 > ma20Yesterday;
      final ma50Up = ma50 > ma50Yesterday;

      final bullishAlignment = ma10 > ma20 && ma20 > ma50;
      final bearishAlignment = ma10 < ma20 && ma20 < ma50;

      final angle10 = (ma10 - ma10Yesterday) / ma10Yesterday;
      final angle20 = (ma20 - ma20Yesterday) / ma20Yesterday;
      final angle50 = (ma50 - ma50Yesterday) / ma50Yesterday;

      final angleIncreasing =
          angle10 > angle20 - 0.0001 && angle20 > angle50 - 0.0001;
      final angleDecreasing =
          angle10 < angle20 + 0.0001 && angle20 < angle50 + 0.0001;

      bool matches;
      if (isUpTrend) {
        matches =
            ma10Up && ma20Up && ma50Up && bullishAlignment && angleIncreasing;
      } else {
        matches = !ma10Up &&
            !ma20Up &&
            !ma50Up &&
            bearishAlignment &&
            angleDecreasing;
      }

      if (matches) {
        results.add(symbol);
      }
    }

    appLogger.i('批量趋势检查完成，找到 ${results.length} 个符合条件的标的');
    return results;
  }

  /// 从K线数据列表计算MA
  double? _calculateMAFromList(List<KlineDataData> data) {
    if (data.isEmpty) return null;
    final sum = data.fold<double>(0, (acc, d) => acc + d.close);
    return sum / data.length;
  }

  /// 批量检查年内新高
  Future<List<String>> batchCheckYearHigh(
    List<String> symbols,
    DateTime date, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的年内新高...');

    if (symbols.isEmpty) return [];

    final yearStart = DateTime(date.year, 1, 1);
    final effectiveStartDate = startDate != null && startDate.isAfter(yearStart)
        ? startDate
        : yearStart;

    final currentDataMap = await getBatchKlineDataForDate(symbols, 'day', date);
    final maxCloseMap = await getBatchHistoricalMaxClose(
      symbols,
      date,
      startDate: effectiveStartDate,
      endDate: endDate,
    );

    final results = <String>[];
    for (final symbol in symbols) {
      final current = currentDataMap[symbol];
      final maxClose = maxCloseMap[symbol];

      if (current != null && maxClose != null && maxClose > 0) {
        if ((current.close - maxClose).abs() < 0.0001) {
          results.add(symbol);
        }
      }
    }

    return results;
  }

  /// 批量检查200日新高
  Future<List<String>> batchCheck200DayHigh(
    List<String> symbols,
    DateTime date, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的200日新高...');

    if (symbols.isEmpty) return [];

    final day200Ago = date.subtract(const Duration(days: 200));
    final effectiveStartDate = startDate != null && startDate.isAfter(day200Ago)
        ? startDate
        : day200Ago;

    final currentDataMap = await getBatchKlineDataForDate(symbols, 'day', date);
    final maxCloseMap = await getBatchHistoricalMaxClose(
      symbols,
      date,
      startDate: effectiveStartDate,
      endDate: endDate,
    );

    final results = <String>[];
    for (final symbol in symbols) {
      final current = currentDataMap[symbol];
      final maxClose = maxCloseMap[symbol];

      if (current != null && maxClose != null && maxClose > 0) {
        if ((current.close - maxClose).abs() < 0.0001) {
          results.add(symbol);
        }
      }
    }

    return results;
  }

  /// 批量检查涨停
  Future<List<String>> batchCheckLimitUp(
      List<String> symbols, DateTime date) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的涨停...');

    if (symbols.isEmpty) return [];

    final klineDataMap = await getBatchKlineDataForDate(symbols, 'day', date);

    final results = <String>[];
    for (final symbol in symbols) {
      final kline = klineDataMap[symbol];
      if (kline != null) {
        if ((kline.high - kline.close).abs() < 0.0001) {
          final change = (kline.close - kline.open) / kline.open;
          if (change > 0.098) {
            results.add(symbol);
          }
        }
      }
    }

    return results;
  }

  /// 批量检查连续涨停
  Future<List<String>> batchCheckConsecutiveLimitUp(
      List<String> symbols, DateTime date) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的连续涨停...');

    if (symbols.isEmpty) return [];

    // 需要获取今天和昨天的数据
    final klineDataMap = await getBatchKlineData(
      symbols,
      'day',
      date.subtract(const Duration(days: 5)),
      date,
      limit: 3,
    );

    final results = <String>[];
    for (final symbol in symbols) {
      final klineList = klineDataMap[symbol];
      if (klineList == null || klineList.length < 2) continue;

      final today = klineList[0];
      final yesterday = klineList[1];

      // 今天涨停
      final todayLimitUp = (today.high - today.close).abs() < 0.0001 &&
          (today.close - today.open) / today.open > 0.098;

      // 昨天涨停
      final yesterdayLimitUp =
          (yesterday.high - yesterday.close).abs() < 0.0001 &&
              (yesterday.close - yesterday.open) / yesterday.open > 0.098;

      if (todayLimitUp && yesterdayLimitUp) {
        results.add(symbol);
      }
    }

    return results;
  }

  /// 批量检查量价齐升
  Future<List<String>> batchCheckVolumePriceUp(
      List<String> symbols, DateTime date) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的量价齐升...');

    if (symbols.isEmpty) return [];

    final klineDataMap = await getBatchKlineData(
      symbols,
      'day',
      date.subtract(const Duration(days: 5)),
      date,
      limit: 3,
    );

    final results = <String>[];
    for (final symbol in symbols) {
      final klineList = klineDataMap[symbol];
      if (klineList == null || klineList.length < 2) continue;

      final today = klineList[0];
      final yesterday = klineList[1];

      if (yesterday.close == 0 || yesterday.volume == 0) continue;

      final priceIncrease = (today.close / yesterday.close) - 1;
      final volumeIncrease = (today.volume / yesterday.volume) - 1;

      if (priceIncrease > 0.02 && volumeIncrease > 0.05) {
        results.add(symbol);
      }
    }

    return results;
  }

  /// 批量检查历史新低
  Future<List<String>> batchCheckAllTimeLow(
    List<String> symbols,
    DateTime date, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的历史新低...');

    if (symbols.isEmpty) return [];

    final currentDataMap = await getBatchKlineDataForDate(symbols, 'day', date);

    // 批量查询历史最低
    final effectiveStartDate = startDate ?? DateTime(1990, 1, 1);
    final effectiveEndDate = endDate ?? date;

    final results = await customSelect(
      '''
      SELECT symbol, MIN(close) as min_close 
      FROM kline_data 
      WHERE symbol IN (${symbols.map((_) => '?').join(',')}) 
        AND period = ? 
        AND trade_date >= ? 
        AND trade_date <= ?
      GROUP BY symbol
      ''',
      variables: [
        ...symbols.map((s) => Variable(s)),
        const Variable('day'),
        Variable(effectiveStartDate),
        Variable(effectiveEndDate),
      ],
    ).get();

    final minCloseMap = <String, double>{};
    for (final row in results) {
      minCloseMap[row.read<String>('symbol')] =
          row.read<double?>('min_close') ?? 0.0;
    }

    final resultList = <String>[];
    for (final symbol in symbols) {
      final current = currentDataMap[symbol];
      final minClose = minCloseMap[symbol];

      if (current != null && minClose != null && minClose > 0) {
        if ((current.close - minClose).abs() < 0.0001) {
          resultList.add(symbol);
        }
      }
    }

    return resultList;
  }

  /// 批量检查年内新低
  Future<List<String>> batchCheckYearLow(
    List<String> symbols,
    DateTime date, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的年内新低...');

    if (symbols.isEmpty) return [];

    final yearStart = DateTime(date.year, 1, 1);
    final effectiveStartDate = startDate != null && startDate.isAfter(yearStart)
        ? startDate
        : yearStart;

    final currentDataMap = await getBatchKlineDataForDate(symbols, 'day', date);

    final results = await customSelect(
      '''
      SELECT symbol, MIN(close) as min_close 
      FROM kline_data 
      WHERE symbol IN (${symbols.map((_) => '?').join(',')}) 
        AND period = ? 
        AND trade_date >= ? 
        AND trade_date <= ?
      GROUP BY symbol
      ''',
      variables: [
        ...symbols.map((s) => Variable(s)),
        const Variable('day'),
        Variable(effectiveStartDate),
        Variable(endDate ?? date),
      ],
    ).get();

    final minCloseMap = <String, double>{};
    for (final row in results) {
      minCloseMap[row.read<String>('symbol')] =
          row.read<double?>('min_close') ?? 0.0;
    }

    final resultList = <String>[];
    for (final symbol in symbols) {
      final current = currentDataMap[symbol];
      final minClose = minCloseMap[symbol];

      if (current != null && minClose != null && minClose > 0) {
        if ((current.close - minClose).abs() < 0.0001) {
          resultList.add(symbol);
        }
      }
    }

    return resultList;
  }

  /// 批量检查200日新低
  Future<List<String>> batchCheck200DayLow(
      List<String> symbols, DateTime date) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的200日新低...');

    if (symbols.isEmpty) return [];

    final day200Ago = date.subtract(const Duration(days: 200));

    final currentDataMap = await getBatchKlineDataForDate(symbols, 'day', date);

    final results = await customSelect(
      '''
      SELECT symbol, MIN(close) as min_close 
      FROM kline_data 
      WHERE symbol IN (${symbols.map((_) => '?').join(',')}) 
        AND period = ? 
        AND trade_date >= ? 
        AND trade_date <= ?
      GROUP BY symbol
      ''',
      variables: [
        ...symbols.map((s) => Variable(s)),
        const Variable('day'),
        Variable(day200Ago),
        Variable(date),
      ],
    ).get();

    final minCloseMap = <String, double>{};
    for (final row in results) {
      minCloseMap[row.read<String>('symbol')] =
          row.read<double?>('min_close') ?? 0.0;
    }

    final resultList = <String>[];
    for (final symbol in symbols) {
      final current = currentDataMap[symbol];
      final minClose = minCloseMap[symbol];

      if (current != null && minClose != null && minClose > 0) {
        if ((current.close - minClose).abs() < 0.0001) {
          resultList.add(symbol);
        }
      }
    }

    return resultList;
  }

  /// 批量检查跌停
  Future<List<String>> batchCheckLimitDown(
      List<String> symbols, DateTime date) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的跌停...');

    if (symbols.isEmpty) return [];

    final klineDataMap = await getBatchKlineDataForDate(symbols, 'day', date);

    final results = <String>[];
    for (final symbol in symbols) {
      final kline = klineDataMap[symbol];
      if (kline != null) {
        if ((kline.close - kline.low).abs() < 0.0001) {
          final change = (kline.close - kline.open) / kline.open;
          if (change < -0.098) {
            results.add(symbol);
          }
        }
      }
    }

    return results;
  }

  /// 批量检查连续跌停
  Future<List<String>> batchCheckConsecutiveLimitDown(
      List<String> symbols, DateTime date) async {
    appLogger.i('批量检查 ${symbols.length} 个标的的连续跌停...');

    if (symbols.isEmpty) return [];

    final klineDataMap = await getBatchKlineData(
      symbols,
      'day',
      date.subtract(const Duration(days: 5)),
      date,
      limit: 3,
    );

    final results = <String>[];
    for (final symbol in symbols) {
      final klineList = klineDataMap[symbol];
      if (klineList == null || klineList.length < 2) continue;

      final today = klineList[0];
      final yesterday = klineList[1];

      final todayLimitDown = (today.close - today.low).abs() < 0.0001 &&
          (today.close - today.open) / today.open < -0.098;

      final yesterdayLimitDown =
          (yesterday.close - yesterday.low).abs() < 0.0001 &&
              (yesterday.close - yesterday.open) / yesterday.open < -0.098;

      if (todayLimitDown && yesterdayLimitDown) {
        results.add(symbol);
      }
    }

    return results;
  }

  Future<List<String>> _getRandomSymbols(
      {String? marketCode, int count = 10, List<String>? marketCodes}) async {
    final allSymbols = await getActiveSymbols(
      marketCode: marketCode,
      marketCodes: marketCodes,
    );
    allSymbols.shuffle();
    return allSymbols.take(count).map((s) => s.symbol).toList();
  }

  Future<void> saveFilterResults(
    DateTime date,
    StockFilterCondition condition,
    List<String> symbols,
  ) async {
    final dateOnly = DateTime(date.year, date.month, date.day);

    await (delete(stockFilterResults)
          ..where((t) => t.filterDate.equals(dateOnly))
          ..where((t) => t.conditionType.equals(condition.name)))
        .go();

    final symbolData = await getActiveSymbols();
    final symbolMap = {for (var s in symbolData) s.symbol: s};

    final companions = symbols.map((symbolCode) {
      final symbol = symbolMap[symbolCode];
      return StockFilterResultsCompanion(
        filterDate: Value(dateOnly),
        conditionType: Value(condition.name),
        symbol: Value(symbolCode),
        marketCode: Value(symbol?.marketCode ?? ''),
        symbolName: Value(symbol?.name ?? symbolCode),
        closePrice: const Value(0),
        changePercent: const Value(0),
      );
    }).toList();

    await batch((batch) {
      batch.insertAll(stockFilterResults, companions);
    });
  }

  Future<List<StockFilterResult>> getCachedFilterResults(
    DateTime date,
    StockFilterCondition condition,
  ) {
    final dateOnly = DateTime(date.year, date.month, date.day);

    return (select(stockFilterResults)
          ..where((t) => t.filterDate.equals(dateOnly))
          ..where((t) => t.conditionType.equals(condition.name)))
        .get();
  }

  Future<bool> hasCachedResults(
      DateTime date, StockFilterCondition condition) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final count = await (selectOnly(stockFilterResults)
          ..addColumns([stockFilterResults.id.count()])
          ..where(stockFilterResults.filterDate.equals(dateOnly))
          ..where(stockFilterResults.conditionType.equals(condition.name)))
        .getSingle();
    return (count.read(stockFilterResults.id.count()) ?? 0) > 0;
  }
}
