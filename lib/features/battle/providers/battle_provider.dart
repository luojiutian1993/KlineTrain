import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/models/trade_point_model.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/repositories/kline_repository.dart';
import 'package:kline_trainer/features/battle/models/battle_state.dart';
import 'package:kline_trainer/features/battle/models/battle_config.dart';
import 'package:kline_trainer/features/battle/trading_calculator.dart';

part 'battle_provider.g.dart';

@riverpod
class Battle extends _$Battle {
  final KlineRepository _repository = KlineRepository();

  @override
  BattleState build() {
    return const BattleState();
  }

  Future<void> initializeWithSymbol({
    required String symbol,
    String? name,
    String? marketCode,
    DateTime? startDate,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final klineData = await _loadKlineData(symbol, startDate);

      if (klineData.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          hasAvailableData: false,
          errorMessage: '数据库中暂无合格股票，请先同步数据',
        );
        return;
      }

      state = state.copyWith(
        currentSymbol: symbol,
        currentSymbolName: name ?? symbol,
        currentMarketCode: marketCode ?? '',
        trainingStartDate: startDate,
        allKlineData: klineData,
        currentDayIndex: BattleConfig.defaultHistoryDays,
        visibleStartIndex: BattleConfig.defaultHistoryDays -
            BattleConfig.defaultVisibleKlineCount +
            1,
        phase: TrainingPhase.opening,
        isLoading: false,
        hasAvailableData: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasAvailableData: false,
        errorMessage: '数据加载失败，请检查网络后重试',
      );
    }
  }

  Future<void> initializeRandom() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final candidate = await _findQualifiedStock();
      if (candidate == null) {
        state = state.copyWith(
          isLoading: false,
          hasAvailableData: false,
          errorMessage: '数据库中暂无合格股票，请先同步数据',
        );
        return;
      }

      await initializeWithSymbol(
        symbol: candidate.symbol,
        name: candidate.symbol,
        marketCode: candidate.marketCode,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasAvailableData: false,
        errorMessage: '数据加载失败，请检查网络后重试',
      );
    }
  }

  Future<_CandidateStock?> _findQualifiedStock() async {
    final dbService = DatabaseService.instance;
    final stockMaps =
        await dbService.klineDao.getSymbolsWithMinKlineData(minDays: 210);

    if (stockMaps.isEmpty) {
      return null;
    }

    final random = Random();
    final shuffled = List.of(stockMaps)..shuffle(random);

    for (int i = 0; i < shuffled.length && i < 3; i++) {
      final candidate = shuffled[i];
      final symbol = candidate['symbol'] ?? '';
      final marketCode = candidate['marketCode'] ?? '';

      final klineData = await dbService.klineDao.getKlineData(
        symbol,
        'day',
        limit: 220,
      );

      if (klineData.length >= 210) {
        return _CandidateStock(symbol: symbol, marketCode: marketCode);
      }
    }

    return null;
  }

  Future<List<KlineModel>> _loadKlineData(
    String symbol,
    DateTime? startDate,
  ) async {
    final start = startDate?.subtract(
          Duration(days: BattleConfig.defaultHistoryDays),
        ) ??
        DateTime(2023, 3, 31).subtract(
          Duration(days: BattleConfig.defaultHistoryDays),
        );
    final end = startDate?.add(
          Duration(days: BattleConfig.defaultTrainingDays),
        ) ??
        DateTime(2023, 3, 31).add(
          Duration(days: BattleConfig.defaultTrainingDays),
        );

    return _repository.fetchKlineDataFromDbWithDateRange(
      symbol: symbol,
      period: 'day',
      startTime: start,
      endTime: end,
    );
  }

  void nextDay() {
    if (state.currentDayIndex >= state.allKlineData.length - 1) {
      return;
    }

    final newIndex = state.currentDayIndex + 1;
    state = state.copyWith(
      currentDayIndex: newIndex,
      phase: TrainingPhase.closing,
      visibleStartIndex:
          max(0, newIndex - state.visibleKlineCount + 1),
    );
  }

  void previousDay() {
    if (state.currentDayIndex <= state.historyDays) {
      return;
    }

    final newIndex = state.currentDayIndex - 1;
    state = state.copyWith(
      currentDayIndex: newIndex,
      phase: TrainingPhase.opening,
      visibleStartIndex:
          max(0, newIndex - state.visibleKlineCount + 1),
    );
  }

  void setPhase(TrainingPhase phase) {
    state = state.copyWith(phase: phase);
  }

  Future<void> buy(double price, double quantity) async {
    if (state.isReplayMode) return;

    final result = TradingCalculator.calculateBuy(
      accountBalance: state.accountBalance,
      currentPrice: price,
      positionRatio: 1.0,
      currentPositionQuantity: state.positionQuantity,
      currentPositionCost: state.positionCost,
    );

    if (!result.success) {
      return;
    }

    final newTradePoint = TradePoint(
      index: state.currentDayIndex,
      price: price,
      isBuy: true,
      label: 'B${state.tradePoints.where((t) => t.isBuy).length + 1}',
      date: DateTime.now(),
      tradeId: state.tradePoints.length,
      quantity: quantity.toInt(),
    );

    state = state.copyWith(
      accountBalance: result.remainingBalance,
      positionQuantity: state.positionQuantity + result.quantity,
      positionCost: result.newPositionCost,
      tradePoints: [...state.tradePoints, newTradePoint],
    );
  }

  Future<void> sell(double price, double quantity) async {
    if (state.isReplayMode || !state.hasPosition) return;

    final result = TradingCalculator.calculateSell(
      currentPositionQuantity: state.positionQuantity,
      currentPositionCost: state.positionCost,
      currentPrice: price,
      positionRatio: 1.0,
      accountBalance: state.accountBalance,
    );

    if (!result.success) {
      return;
    }

    final profit = (price - state.positionCost) * quantity;
    final newTradePoint = TradePoint(
      index: state.currentDayIndex,
      price: price,
      isBuy: false,
      label: 'S${state.tradePoints.where((t) => !t.isBuy).length + 1}',
      date: DateTime.now(),
      tradeId: state.tradePoints.length,
      quantity: quantity.toInt(),
    );

    state = state.copyWith(
      accountBalance: result.remainingBalance,
      positionQuantity: state.positionQuantity - result.quantity,
      positionCost:
          result.newPositionCost > 0 ? state.positionCost : 0.0,
      totalProfitLoss: state.totalProfitLoss + profit,
      tradePoints: [...state.tradePoints, newTradePoint],
    );
  }

  void updateTopIndicator(String indicator) {
    state = state.copyWith(selectedTopIndicator: indicator);
  }

  void updateBottomIndicator(String indicator) {
    state = state.copyWith(selectedBottomIndicator: indicator);
  }

  void updatePeriod(String period) {
    state = state.copyWith(selectedPeriod: period);
  }

  void reset() {
    state = const BattleState();
  }
}

class _CandidateStock {
  final String symbol;
  final String marketCode;

  const _CandidateStock({required this.symbol, required this.marketCode});
}