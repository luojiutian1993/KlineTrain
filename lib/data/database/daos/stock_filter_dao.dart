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
      {String? marketCode, List<String>? marketCodes}) {
    final query = select(symbols)..where((t) => t.enabled.equals(true));

    if (marketCodes != null && marketCodes.isNotEmpty) {
      query.where((t) => t.marketCode.isIn(marketCodes));
    } else if (marketCode != null) {
      query.where((t) => t.marketCode.equals(marketCode));
    }

    return query.get();
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

    // 使用自定义SQL查询，因为数据库中存储的是日期字符串
    final minResult = await customSelect(
      'SELECT MIN(trade_date) as min_date FROM kline_data WHERE period = ?',
      variables: [const Variable('day')],
    ).getSingle();

    final maxResult = await customSelect(
      'SELECT MAX(trade_date) as max_date FROM kline_data WHERE period = ?',
      variables: [const Variable('day')],
    ).getSingle();

    final minDateStr = minResult.read<String?>('min_date');
    final maxDateStr = maxResult.read<String?>('max_date');

    appLogger.i('查询到的日期字符串: min=$minDateStr, max=$maxDateStr');

    return (
      minDateStr != null ? _stringToDate(minDateStr) : DateTime(2000, 1, 1),
      maxDateStr != null ? _stringToDate(maxDateStr) : DateTime.now(),
    );
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
    switch (condition) {
      case StockFilterCondition.allTimeHigh:
        return _filterSingleSymbolCheck(
          (symbol) => checkAllTimeHigh(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.yearHigh:
        return _filterSingleSymbolCheck(
          (symbol) => checkYearHigh(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.day200High:
        return _filterSingleSymbolCheck(
          (symbol) => check200DayHigh(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.return30dTop:
        return getReturn30dTop50(date,
            startDate: startDate, endDate: endDate, marketCodes: marketCodes);
      case StockFilterCondition.return15dTop:
        return getReturn15dTop50(date,
            startDate: startDate, endDate: endDate, marketCodes: marketCodes);
      case StockFilterCondition.limitUp:
        return _filterSingleSymbolCheck(
          (symbol) => checkLimitUp(symbol, date),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.consecutiveLimitUp:
        return _filterSingleSymbolCheck(
          (symbol) => checkConsecutiveLimitUp(symbol, date),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.volumePriceUp:
        return _filterSingleSymbolCheck(
          (symbol) => checkVolumePriceUp(symbol, date),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.upTrend:
        return _filterSingleSymbolCheck(
          (symbol) => checkUpTrend(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.allTimeLow:
        return _filterSingleSymbolCheck(
          (symbol) => checkAllTimeLow(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.yearLow:
        return _filterSingleSymbolCheck(
          (symbol) => checkYearLow(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.day200Low:
        return _filterSingleSymbolCheck(
          (symbol) => check200DayLow(symbol, date),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.loss30dTop:
        return getLoss30dTop50(date,
            startDate: startDate, endDate: endDate, marketCodes: marketCodes);
      case StockFilterCondition.loss15dTop:
        return getLoss15dTop50(date,
            startDate: startDate, endDate: endDate, marketCodes: marketCodes);
      case StockFilterCondition.downTrend:
        return _filterSingleSymbolCheck(
          (symbol) => checkDownTrend(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.limitDown:
        return _filterSingleSymbolCheck(
          (symbol) => checkLimitDown(symbol, date),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
      case StockFilterCondition.consecutiveLimitDown:
        return _filterSingleSymbolCheck(
          (symbol) => checkConsecutiveLimitDown(symbol, date),
          marketCode: marketCode,
          marketCodes: marketCodes,
        );
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
    final results = <String>[];

    for (final symbol in allSymbols) {
      try {
        if (await check(symbol.symbol)) {
          results.add(symbol.symbol);
        }
      } catch (e) {
        continue;
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
