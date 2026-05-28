import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/models/battle_state.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';

class TrainingService {
  final Ref _ref;

  TrainingService(this._ref);

  BattleState get _state => _ref.read(battleProvider);
  Battle get _notifier => _ref.read(battleProvider.notifier);

  void start({
    required String symbol,
    String? name,
    String? marketCode,
    DateTime? startDate,
  }) {
    _notifier.initializeWithSymbol(
      symbol: symbol,
      name: name,
      marketCode: marketCode,
      startDate: startDate,
    );
  }

  void startRandom() {
    _notifier.initializeRandom();
  }

  void dayForward() {
    _notifier.nextDay();
  }

  void dayBackward() {
    _notifier.previousDay();
  }

  void goToDay(int dayIndex) {
    final state = _state;
    if (dayIndex < state.historyDays || dayIndex >= state.allKlineData.length) {
      return;
    }

    while (state.currentDayIndex < dayIndex) {
      _notifier.nextDay();
    }
  }

  void setPhaseOpening() {
    _notifier.setPhase(TrainingPhase.opening);
  }

  void setPhaseClosing() {
    _notifier.setPhase(TrainingPhase.closing);
  }

  void reset() {
    _notifier.reset();
  }

  bool get canGoForward {
    final state = _state;
    return state.currentDayIndex < state.allKlineData.length - 1;
  }

  bool get canGoBackward {
    final state = _state;
    return state.currentDayIndex > state.historyDays;
  }

  bool get isAtEnd {
    final state = _state;
    return state.currentDayIndex >= state.allKlineData.length - 1;
  }

  bool get isAtStart {
    final state = _state;
    return state.currentDayIndex <= state.historyDays;
  }

  int get trainingProgress {
    final state = _state;
    return state.currentDayIndex - state.historyDays + 1;
  }

  int get totalTrainingDays {
    final state = _state;
    return state.trainingDays;
  }

  TrainingStats get stats {
    final state = _state;
    final trades = state.tradePoints;
    final buyCount = trades.where((t) => t.isBuy).length;
    final sellCount = trades.where((t) => !t.isBuy).length;
    final winTrades = <int, double>{};

    for (final trade in trades) {
      if (!trade.isBuy) {
        final price = trade.price;
        final cost = trade.quantity * price;
        final revenue = trade.quantity * price;
        final profit = revenue - cost;
        winTrades[trade.tradeId] = profit;
      }
    }

    final totalProfit = winTrades.values.fold(0.0, (a, b) => a + b);

    return TrainingStats(
      currentDay: trainingProgress,
      totalDays: totalTrainingDays,
      buyCount: buyCount,
      sellCount: sellCount,
      totalProfit: totalProfit,
      winRate: buyCount > 0 ? (sellCount / buyCount * 100) : 0,
    );
  }
}

class TrainingStats {
  final int currentDay;
  final int totalDays;
  final int buyCount;
  final int sellCount;
  final double totalProfit;
  final double winRate;

  const TrainingStats({
    required this.currentDay,
    required this.totalDays,
    required this.buyCount,
    required this.sellCount,
    required this.totalProfit,
    required this.winRate,
  });
}
