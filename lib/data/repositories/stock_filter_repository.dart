import '../database/database_service.dart';
import '../database/daos/stock_filter_dao.dart';
import '../database/app_database.dart';
import '../models/stock_filter_condition_model.dart';
import '../models/stock_filter_result_model.dart';
import '../../core/enums/stock_filter_condition.dart';
import '../../shared/utils/logger.dart';

class StockFilterRepository {
  final StockFilterDao _stockFilterDao;

  StockFilterRepository({StockFilterDao? stockFilterDao})
      : _stockFilterDao =
            stockFilterDao ?? DatabaseService.instance.stockFilterDao;

  List<StockFilterConditionModel> getAllConditions() {
    return StockFilterConditionModel.all;
  }

  Future<StockFilterResultResponse> filterStocks({
    required StockFilterCondition condition,
    DateTime? date,
    String? marketCode,
    DateTime? startDate,
    DateTime? endDate,
    bool useCache = true,
    DateTime? trainingStartDate,
    int trainingDays = 150,
    List<String>? subMarketCodes,
  }) async {
    final (minDate, maxDate) = await _stockFilterDao.getKlineDateRange();
    // 使用用户选择的时间范围的结束日期作为筛选目标日期
    final effectiveEndDate = endDate ?? date ?? maxDate ?? DateTime.now();
    final conditionStartDate = startDate ?? minDate;

    appLogger.i(
      '开始选股: condition=${condition.name}, '
      'conditionStartDate=$conditionStartDate, '
      'conditionEndDate=$effectiveEndDate, '
      'trainingDays=$trainingDays',
    );

    try {
      if (useCache && condition != StockFilterCondition.random) {
        final hasCache =
            await _stockFilterDao.hasCachedResults(effectiveEndDate, condition);
        if (hasCache) {
          appLogger.i('使用缓存的选股结果');
          final cachedResults = await _stockFilterDao.getCachedFilterResults(
            effectiveEndDate,
            condition,
          );
          return StockFilterResultResponse(
            condition: condition.name,
            conditionName: condition.label,
            date: effectiveEndDate,
            total: cachedResults.length,
            items: cachedResults
                .map((r) => StockFilterResultModel(
                      symbol: r.symbol,
                      symbolName: r.symbolName,
                      marketCode: r.marketCode,
                      closePrice: r.closePrice,
                      changePercent: r.changePercent,
                    ))
                .toList(),
            trainingStartDate: trainingStartDate,
            trainingDays: trainingDays,
          );
        }
      }

      final symbols = await _stockFilterDao.filterByCondition(
        condition,
        effectiveEndDate,
        marketCode: marketCode,
        startDate: conditionStartDate,
        endDate: effectiveEndDate,
        marketCodes: subMarketCodes,
      );

      appLogger.i('选股完成: 共 ${symbols.length} 支股票满足条件');

      final items = await _getStockDetails(symbols, effectiveEndDate,
          startDate: conditionStartDate, endDate: effectiveEndDate);

      if (useCache && condition != StockFilterCondition.random) {
        await _stockFilterDao.saveFilterResults(
            effectiveEndDate, condition, symbols);
        appLogger.i('选股结果已缓存');
      }

      return StockFilterResultResponse(
        condition: condition.name,
        conditionName: condition.label,
        date: effectiveEndDate,
        total: items.length,
        items: items,
        trainingStartDate: trainingStartDate,
        trainingDays: trainingDays,
      );
    } catch (e, stackTrace) {
      appLogger.e('选股失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<StockFilterResultModel>> _getStockDetails(
    List<String> symbols,
    DateTime date, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final results = <StockFilterResultModel>[];

    for (final symbolCode in symbols) {
      try {
        final symbolList = await _stockFilterDao.getActiveSymbols();
        final symbol = symbolList.firstWhere(
          (s) => s.symbol == symbolCode,
          orElse: () => throw Exception('Symbol not found'),
        );

        KlineDataData? klineData;
        if (startDate != null && endDate != null) {
          klineData = await _stockFilterDao.getLastKlineDataInRange(
            symbolCode,
            'day',
            startDate,
            endDate,
          );
        } else {
          klineData = await _stockFilterDao.getKlineDataForDate(
            symbolCode,
            'day',
            date,
          );
        }

        results.add(StockFilterResultModel(
          symbol: symbolCode,
          symbolName: symbol.name,
          marketCode: symbol.marketCode,
          closePrice: klineData?.close ?? symbol.lastPrice ?? 0,
          changePercent: symbol.change ?? 0,
        ));
      } catch (e) {
        appLogger.w('获取股票详情失败: $symbolCode', error: e);
        continue;
      }
    }

    return results;
  }

  Future<StockFilterResultModel?> getRandomStock({String? marketCode}) async {
    final results = await _stockFilterDao.filterByCondition(
      StockFilterCondition.random,
      DateTime.now(),
      marketCode: marketCode,
    );

    if (results.isEmpty) return null;

    final symbolCode = results.first;
    final details = await _getStockDetails([symbolCode], DateTime.now());

    return details.isNotEmpty ? details.first : null;
  }

  Future<int> getFilterCount({
    required StockFilterCondition condition,
    DateTime? date,
    String? marketCode,
  }) async {
    final targetDate = date ?? DateTime.now();

    final hasCache =
        await _stockFilterDao.hasCachedResults(targetDate, condition);
    if (hasCache) {
      final cached =
          await _stockFilterDao.getCachedFilterResults(targetDate, condition);
      return cached.length;
    }

    final symbols = await _stockFilterDao.filterByCondition(
      condition,
      targetDate,
      marketCode: marketCode,
    );

    return symbols.length;
  }

  Future<void> clearCache({DateTime? date}) async {
    appLogger.i('清除选股缓存: date=$date');
  }
}
