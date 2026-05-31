import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/database/daos/holiday_dao.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/repositories/kline_repository.dart';
import 'package:kline_trainer/data/services/data_sufficiency_checker.dart';
import 'package:kline_trainer/data/services/trading_day_calculator.dart';
import 'package:kline_trainer/features/battle/services/training_config_service.dart';

class StockSelectionResult {
  final String? symbol;
  final List<KlineModel> data;
  final DataSufficiencyResult? sufficiencyCheck;
  final bool isAutoSelected;
  final String? error;

  StockSelectionResult({
    this.symbol,
    required this.data,
    this.sufficiencyCheck,
    required this.isAutoSelected,
    this.error,
  });
}

class StockSelector {
  final KlineRepository _repository;
  final HolidayDao _holidayDao;
  final TradingDayCalculator _tradingDayCalculator;
  final DataSufficiencyChecker _sufficiencyChecker;
  final DatabaseService _dbService;

  StockSelector({
    required KlineRepository repository,
    required HolidayDao holidayDao,
    required TradingDayCalculator tradingDayCalculator,
    required DataSufficiencyChecker sufficiencyChecker,
    required DatabaseService dbService,
  })  : _repository = repository,
        _holidayDao = holidayDao,
        _tradingDayCalculator = tradingDayCalculator,
        _sufficiencyChecker = sufficiencyChecker,
        _dbService = dbService;

  Future<StockSelectionResult> selectSufficientStock({
    DateTime? preferredStartDate,
    required int totalRequiredDays,
  }) async {
    final symbolsData = await _dbService.klineDao.getSymbols();
    final symbols = symbolsData.map((s) => s.symbol).toList();

    for (final symbol in symbols) {
      print('🔵 [StockSelector] 检查股票: $symbol');

      final data = await _loadKlineDataForSymbol(symbol, preferredStartDate);
      if (data.isEmpty) {
        print('⚠️ [StockSelector] 股票 $symbol 无数据');
        continue;
      }

      final sufficiencyCheck = await _sufficiencyChecker.checkSufficiency(
        data: data,
        requiredTradingDays: totalRequiredDays,
      );

      if (sufficiencyCheck.isSufficient) {
        print('✅ [StockSelector] 找到数据充足的股票: $symbol');
        print('  - 可用交易日: ${sufficiencyCheck.availableDays}');
        print('  - 需求交易日: ${sufficiencyCheck.requiredDays}');
        print('  - 自动选择: ${preferredStartDate == null}');

        return StockSelectionResult(
          symbol: symbol,
          data: data,
          sufficiencyCheck: sufficiencyCheck,
          isAutoSelected: preferredStartDate == null,
        );
      } else {
        print(
            '⚠️ [StockSelector] 股票 $symbol 数据不足，可用: ${sufficiencyCheck.availableDays}，需求: ${sufficiencyCheck.requiredDays}');
      }
    }

    print('🔴 [StockSelector] 没有找到数据充足的股票');

    return StockSelectionResult(
      symbol: null,
      data: [],
      sufficiencyCheck: null,
      isAutoSelected: false,
      error: '没有找到数据充足的股票',
    );
  }

  Future<List<KlineModel>> _loadKlineDataForSymbol(
      String symbol, DateTime? startDate) async {
    final configService = TrainingConfigService(_dbService);
    final trainingDays = await configService.getTrainingDays();
    final preloadDays = await configService.getPreloadDays();
    final indicatorPreloadDays = await configService.getIndicatorPreloadDays();
    final totalRequiredDays = trainingDays + preloadDays + indicatorPreloadDays;

    final estimatedCalendarDays =
        await _tradingDayCalculator.tradingDaysToCalendarDays(
      totalRequiredDays,
      DateTime.now(),
    );

    DateTime dataStartTime;
    if (startDate != null) {
      final totalCalendarDays =
          await _tradingDayCalculator.tradingDaysToCalendarDays(
        preloadDays + indicatorPreloadDays,
        startDate,
      );
      dataStartTime = startDate.subtract(Duration(days: totalCalendarDays));
    } else {
      dataStartTime =
          DateTime.now().subtract(Duration(days: estimatedCalendarDays));
    }

    return await _repository.fetchKlineDataFromDbWithDateRange(
      symbol: symbol,
      period: 'day',
      startTime: dataStartTime,
      endTime: DateTime.now(),
    );
  }
}
