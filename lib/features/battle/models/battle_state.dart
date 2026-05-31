import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/models/trade_point_model.dart';

enum TrainingPhase {
  opening,
  closing,
}

class BattleState {
  final String currentSymbol;
  final String currentSymbolName;
  final String currentMarketCode;
  final DateTime? trainingStartDate;
  final int trainingDays;
  final int historyDays;
  final int initialStartIndex; // 新增：保存训练起始索引
  final TrainingPhase phase;
  final bool isReplayMode;
  final bool hasAvailableData;
  final String? errorMessage;

  final double accountBalance;
  final double initialBalance;
  final double positionQuantity;
  final double positionCost;
  final double totalProfitLoss;

  final List<KlineModel> allKlineData;
  final List<TradePoint> tradePoints;

  final int currentDayIndex;
  final int visibleStartIndex;
  final int visibleKlineCount;
  final double zoomScale;

  final String selectedPeriod;
  final String selectedTopIndicator;
  final String selectedBottomIndicator;

  final bool isLoading;

  const BattleState({
    this.currentSymbol = 'SH600000',
    this.currentSymbolName = '',
    this.currentMarketCode = '',
    this.trainingStartDate,
    this.trainingDays = 150,
    this.historyDays = 100,
    this.initialStartIndex = 100, // 默认值
    this.phase = TrainingPhase.opening,
    this.isReplayMode = false,
    this.hasAvailableData = true,
    this.errorMessage,
    this.accountBalance = 100000.0,
    this.initialBalance = 100000.0,
    this.positionQuantity = 0.0,
    this.positionCost = 0.0,
    this.totalProfitLoss = 0.0,
    this.allKlineData = const [],
    this.tradePoints = const [],
    this.currentDayIndex = 0,
    this.visibleStartIndex = 0,
    this.visibleKlineCount = 20,
    this.zoomScale = 1.0,
    this.selectedPeriod = '日K',
    this.selectedTopIndicator = '成交量',
    this.selectedBottomIndicator = 'MACD',
    this.isLoading = false,
  });

  BattleState copyWith({
    String? currentSymbol,
    String? currentSymbolName,
    String? currentMarketCode,
    DateTime? trainingStartDate,
    int? trainingDays,
    int? historyDays,
    int? initialStartIndex,
    TrainingPhase? phase,
    bool? isReplayMode,
    bool? hasAvailableData,
    String? errorMessage,
    double? accountBalance,
    double? initialBalance,
    double? positionQuantity,
    double? positionCost,
    double? totalProfitLoss,
    List<KlineModel>? allKlineData,
    List<TradePoint>? tradePoints,
    int? currentDayIndex,
    int? visibleStartIndex,
    int? visibleKlineCount,
    double? zoomScale,
    String? selectedPeriod,
    String? selectedTopIndicator,
    String? selectedBottomIndicator,
    bool? isLoading,
  }) {
    return BattleState(
      currentSymbol: currentSymbol ?? this.currentSymbol,
      currentSymbolName: currentSymbolName ?? this.currentSymbolName,
      currentMarketCode: currentMarketCode ?? this.currentMarketCode,
      trainingStartDate: trainingStartDate ?? this.trainingStartDate,
      trainingDays: trainingDays ?? this.trainingDays,
      historyDays: historyDays ?? this.historyDays,
      initialStartIndex: initialStartIndex ?? this.initialStartIndex,
      phase: phase ?? this.phase,
      isReplayMode: isReplayMode ?? this.isReplayMode,
      hasAvailableData: hasAvailableData ?? this.hasAvailableData,
      errorMessage: errorMessage,
      accountBalance: accountBalance ?? this.accountBalance,
      initialBalance: initialBalance ?? this.initialBalance,
      positionQuantity: positionQuantity ?? this.positionQuantity,
      positionCost: positionCost ?? this.positionCost,
      totalProfitLoss: totalProfitLoss ?? this.totalProfitLoss,
      allKlineData: allKlineData ?? this.allKlineData,
      tradePoints: tradePoints ?? this.tradePoints,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
      visibleStartIndex: visibleStartIndex ?? this.visibleStartIndex,
      visibleKlineCount: visibleKlineCount ?? this.visibleKlineCount,
      zoomScale: zoomScale ?? this.zoomScale,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedTopIndicator: selectedTopIndicator ?? this.selectedTopIndicator,
      selectedBottomIndicator:
          selectedBottomIndicator ?? this.selectedBottomIndicator,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get canStartTraining => hasAvailableData && !isLoading;

  bool get hasPosition => positionQuantity > 0;

  double get positionValue => positionQuantity * (currentKline?.close ?? 0);

  KlineModel? get currentKline {
    if (allKlineData.isEmpty ||
        currentDayIndex < 0 ||
        currentDayIndex >= allKlineData.length) {
      return null;
    }
    return allKlineData[currentDayIndex];
  }

  double get previousClose {
    if (currentDayIndex > 0 && currentDayIndex < allKlineData.length) {
      return allKlineData[currentDayIndex - 1].close;
    }
    return 0.0;
  }

  double get currentPrice {
    if (currentKline == null) return 0.0;
    return phase == TrainingPhase.opening
        ? currentKline!.open
        : currentKline!.close;
  }

  int get trainingProgress {
    final day = currentDayIndex - initialStartIndex + 1;
    if (day < 1) return 1;
    if (day > trainingDays) return trainingDays;
    return day;
  }

  double get profitRate {
    if (positionCost <= 0) return 0;
    return ((currentPrice - positionCost) / positionCost) * 100;
  }

  double get totalAssets {
    return accountBalance + positionValue;
  }

  bool get canTrade =>
      !isReplayMode && hasAvailableData && phase == TrainingPhase.closing;

  double get marketValue => positionValue;
}
