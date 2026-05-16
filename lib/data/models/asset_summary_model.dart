class AssetSummaryModel {
  final double initialCapital;
  final double currentCapital;
  final double totalProfit;
  final double profitRate;
  final int totalTradeCount;
  final int totalTradeDays;
  final int winCount;
  final double winRate;
  final double maxProfit;
  final double maxLoss;
  final double maxDrawdown;
  final double annualizedReturn;
  final double sharpeRatio;
  final double profitLossRatio;

  const AssetSummaryModel({
    this.initialCapital = 100000.0,
    this.currentCapital = 100000.0,
    this.totalProfit = 0.0,
    this.profitRate = 0.0,
    this.totalTradeCount = 0,
    this.totalTradeDays = 0,
    this.winCount = 0,
    this.winRate = 0.0,
    this.maxProfit = 0.0,
    this.maxLoss = 0.0,
    this.maxDrawdown = 0.0,
    this.annualizedReturn = 0.0,
    this.sharpeRatio = 0.0,
    this.profitLossRatio = 0.0,
  });

  AssetSummaryModel copyWith({
    double? initialCapital,
    double? currentCapital,
    double? totalProfit,
    double? profitRate,
    int? totalTradeCount,
    int? totalTradeDays,
    int? winCount,
    double? winRate,
    double? maxProfit,
    double? maxLoss,
    double? maxDrawdown,
    double? annualizedReturn,
    double? sharpeRatio,
    double? profitLossRatio,
  }) {
    return AssetSummaryModel(
      initialCapital: initialCapital ?? this.initialCapital,
      currentCapital: currentCapital ?? this.currentCapital,
      totalProfit: totalProfit ?? this.totalProfit,
      profitRate: profitRate ?? this.profitRate,
      totalTradeCount: totalTradeCount ?? this.totalTradeCount,
      totalTradeDays: totalTradeDays ?? this.totalTradeDays,
      winCount: winCount ?? this.winCount,
      winRate: winRate ?? this.winRate,
      maxProfit: maxProfit ?? this.maxProfit,
      maxLoss: maxLoss ?? this.maxLoss,
      maxDrawdown: maxDrawdown ?? this.maxDrawdown,
      annualizedReturn: annualizedReturn ?? this.annualizedReturn,
      sharpeRatio: sharpeRatio ?? this.sharpeRatio,
      profitLossRatio: profitLossRatio ?? this.profitLossRatio,
    );
  }

  static const AssetSummaryModel defaultValue = AssetSummaryModel();
}
