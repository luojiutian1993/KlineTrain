import 'dart:async';

import '../database/database_service.dart';
import '../database/daos/stock_filter_dao.dart';
import '../database/app_database.dart';
import '../models/stock_filter_condition_model.dart';
import '../models/stock_filter_result_model.dart';
import '../../core/enums/stock_filter_condition.dart';
import '../../shared/utils/logger.dart';

/// 选股查询超时时间（秒）
const _kFilterTimeoutSeconds = 60;

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
    final stopwatch = Stopwatch()..start();

    final (minDate, maxDate) = await _stockFilterDao.getKlineDateRange();
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
          stopwatch.stop();
          appLogger.i('选股完成(缓存), 耗时: ${stopwatch.elapsedMilliseconds}ms');
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

      // 添加超时机制
      final symbols = await _withTimeout(
        _stockFilterDao.filterByCondition(
          condition,
          effectiveEndDate,
          marketCode: marketCode,
          startDate: conditionStartDate,
          endDate: effectiveEndDate,
          marketCodes: subMarketCodes,
        ),
        timeout: Duration(seconds: _kFilterTimeoutSeconds),
        operationName: 'filterByCondition(${condition.name})',
      );

      appLogger.i('选股完成: 共 ${symbols.length} 支股票满足条件');

      final items = await _withTimeout(
        _getStockDetails(symbols, effectiveEndDate,
            startDate: conditionStartDate, endDate: effectiveEndDate),
        timeout: Duration(seconds: _kFilterTimeoutSeconds ~/ 2),
        operationName: '_getStockDetails',
      );

      if (useCache && condition != StockFilterCondition.random) {
        await _stockFilterDao.saveFilterResults(
            effectiveEndDate, condition, symbols);
        appLogger.i('选股结果已缓存');
      }

      stopwatch.stop();
      appLogger.i('选股完成, 耗时: ${stopwatch.elapsedMilliseconds}ms');

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
      stopwatch.stop();
      appLogger.e('选股失败, 耗时: ${stopwatch.elapsedMilliseconds}ms',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 带超时的异步操作包装
  Future<T> _withTimeout<T>(
    Future<T> future, {
    required Duration timeout,
    required String operationName,
  }) async {
    final completer = Completer<T>();
    final timer = Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException('$operationName 操作超时，超过 ${timeout.inSeconds} 秒'),
        );
      }
    });

    future.then((value) {
      if (!completer.isCompleted) {
        timer.cancel();
        completer.complete(value);
      }
    }).catchError((error) {
      if (!completer.isCompleted) {
        timer.cancel();
        completer.completeError(error);
      }
    });

    return completer.future;
  }

  Future<List<StockFilterResultModel>> _getStockDetails(
    List<String> symbols,
    DateTime date, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final results = <StockFilterResultModel>[];

    if (symbols.isEmpty) return results;

    appLogger.i('开始获取 ${symbols.length} 支股票的详情...');

    // 一次性获取所有标的信息，避免循环查询
    final symbolList = await _stockFilterDao.getActiveSymbols();
    final symbolMap = {for (var s in symbolList) s.symbol: s};

    for (final symbolCode in symbols) {
      try {
        final symbol = symbolMap[symbolCode];
        if (symbol == null) {
          appLogger.w('标的不存在: $symbolCode');
          continue;
        }

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

    appLogger.i('股票详情获取完成，共 ${results.length} 条');
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
