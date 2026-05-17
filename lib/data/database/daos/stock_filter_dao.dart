import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';
import '../../../core/enums/stock_filter_condition.dart';

part 'stock_filter_dao.g.dart';

/// 选股算法数据访问对象
@DriftAccessor(
    tables: [Symbols, KlineData, StockFilterResults, DailyStockStats])
class StockFilterDao extends DatabaseAccessor<AppDatabase>
    with _$StockFilterDaoMixin {
  StockFilterDao(super.db);

  Future<List<Symbol>> getActiveSymbols({String? marketCode}) {
    final query = select(symbols)..where((t) => t.enabled.equals(true));
    if (marketCode != null) {
      query.where((t) => t.marketCode.equals(marketCode));
    }
    return query.get();
  }

  Future<KlineDataData?> getKlineDataForDate(
      String symbol, String period, DateTime date) {
    return (select(klineData)
          ..where((t) => t.symbol.equals(symbol))
          ..where((t) => t.period.equals(period))
          ..where((t) => t.tradeDate.equals(date)))
        .getSingleOrNull();
  }

  Future<KlineDataData?> getLastKlineDataInRange(String symbol, String period,
      DateTime startDate, DateTime endDate) async {
    return (select(klineData)
          ..where((t) => t.symbol.equals(symbol))
          ..where((t) => t.period.equals(period))
          ..where((t) => t.tradeDate.isBiggerOrEqualValue(startDate))
          ..where((t) => t.tradeDate.isSmallerOrEqualValue(endDate))
          ..orderBy([(t) => OrderingTerm.desc(t.tradeDate)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<KlineDataData>> getKlineDataBefore(
    String symbol,
    String period,
    DateTime date,
    int days, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    DateTime effectiveStartDate = startDate ?? DateTime(1990, 1, 1);
    DateTime effectiveEndDate = endDate ?? date;

    return (select(klineData)
          ..where((t) => t.symbol.equals(symbol))
          ..where((t) => t.period.equals(period))
          ..where((t) => t.tradeDate.isBiggerOrEqualValue(effectiveStartDate))
          ..where((t) => t.tradeDate.isSmallerOrEqualValue(effectiveEndDate))
          ..orderBy([(t) => OrderingTerm.desc(t.tradeDate)])
          ..limit(days))
        .get();
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
    DateTime effectiveStartDate = startDate ?? DateTime(1990, 1, 1);
    DateTime effectiveEndDate = endDate ?? date;

    final result = await (selectOnly(klineData)
          ..addColumns([klineData.close.max()])
          ..where(klineData.symbol.equals(symbol))
          ..where(klineData.period.equals('day'))
          ..where(klineData.tradeDate.isBiggerOrEqualValue(effectiveStartDate))
          ..where(klineData.tradeDate.isSmallerOrEqualValue(effectiveEndDate)))
        .getSingle();
    return result.read(klineData.close.max()) ?? 0.0;
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

  Future<bool> check200DayHigh(String symbol, DateTime date) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final day200Data = await getKlineDataBefore(symbol, 'day', date, 200);
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
    DateTime effectiveStartDate = startDate ?? DateTime(1990, 1, 1);
    DateTime effectiveEndDate = endDate ?? date;

    final result = await (selectOnly(klineData)
          ..addColumns([klineData.close.min()])
          ..where(klineData.symbol.equals(symbol))
          ..where(klineData.period.equals('day'))
          ..where(klineData.tradeDate.isBiggerOrEqualValue(effectiveStartDate))
          ..where(klineData.tradeDate.isSmallerOrEqualValue(effectiveEndDate)))
        .getSingle();
    return result.read(klineData.close.min()) ?? double.infinity;
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
      {DateTime? startDate, DateTime? endDate}) async {
    final allSymbols = await getActiveSymbols();
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
      {DateTime? startDate, DateTime? endDate}) async {
    final allSymbols = await getActiveSymbols();
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
      {DateTime? startDate, DateTime? endDate}) async {
    final allSymbols = await getActiveSymbols();
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
      {DateTime? startDate, DateTime? endDate}) async {
    final allSymbols = await getActiveSymbols();
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
  }) async {
    switch (condition) {
      case StockFilterCondition.allTimeHigh:
        return _filterSingleSymbolCheck(
          (symbol) => checkAllTimeHigh(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
        );
      case StockFilterCondition.yearHigh:
        return _filterSingleSymbolCheck(
          (symbol) => checkYearHigh(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
        );
      case StockFilterCondition.day200High:
        return _filterSingleSymbolCheck(
          (symbol) => check200DayHigh(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.return30dTop:
        return getReturn30dTop50(date, startDate: startDate, endDate: endDate);
      case StockFilterCondition.return15dTop:
        return getReturn15dTop50(date, startDate: startDate, endDate: endDate);
      case StockFilterCondition.limitUp:
        return _filterSingleSymbolCheck(
          (symbol) => checkLimitUp(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.consecutiveLimitUp:
        return _filterSingleSymbolCheck(
          (symbol) => checkConsecutiveLimitUp(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.volumePriceUp:
        return _filterSingleSymbolCheck(
          (symbol) => checkVolumePriceUp(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.upTrend:
        return _filterSingleSymbolCheck(
          (symbol) => checkUpTrend(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
        );
      case StockFilterCondition.allTimeLow:
        return _filterSingleSymbolCheck(
          (symbol) => checkAllTimeLow(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
        );
      case StockFilterCondition.yearLow:
        return _filterSingleSymbolCheck(
          (symbol) => checkYearLow(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
        );
      case StockFilterCondition.day200Low:
        return _filterSingleSymbolCheck(
          (symbol) => check200DayLow(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.loss30dTop:
        return getLoss30dTop50(date, startDate: startDate, endDate: endDate);
      case StockFilterCondition.loss15dTop:
        return getLoss15dTop50(date, startDate: startDate, endDate: endDate);
      case StockFilterCondition.downTrend:
        return _filterSingleSymbolCheck(
          (symbol) => checkDownTrend(symbol, date,
              startDate: startDate, endDate: endDate),
          marketCode: marketCode,
        );
      case StockFilterCondition.limitDown:
        return _filterSingleSymbolCheck(
          (symbol) => checkLimitDown(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.consecutiveLimitDown:
        return _filterSingleSymbolCheck(
          (symbol) => checkConsecutiveLimitDown(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.random:
        return _getRandomSymbols(marketCode: marketCode);
    }
  }

  Future<List<String>> _filterSingleSymbolCheck(
    Future<bool> Function(String) check, {
    String? marketCode,
  }) async {
    final allSymbols = await getActiveSymbols(marketCode: marketCode);
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
      {String? marketCode, int count = 10}) async {
    final allSymbols = await getActiveSymbols(marketCode: marketCode);
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
