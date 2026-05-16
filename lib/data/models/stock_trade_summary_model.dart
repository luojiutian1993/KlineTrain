class StockTradeSummaryModel {
  final String symbol;
  final String symbolName;
  final String marketCode;
  final int sessionCount;
  final int totalTradeCount;
  final double totalProfit;
  final double profitRate;
  final int winCount;
  final double winRate;
  final DateTime? lastTradeDate;

  const StockTradeSummaryModel({
    required this.symbol,
    required this.symbolName,
    required this.marketCode,
    required this.sessionCount,
    required this.totalTradeCount,
    required this.totalProfit,
    required this.profitRate,
    required this.winCount,
    required this.winRate,
    this.lastTradeDate,
  });

  bool get isWin => totalProfit > 0;

  String get displaySymbol {
    final prefix = marketCode.toUpperCase() == 'SH' ? 'SH' : 'SZ';
    return '$prefix $symbol';
  }

  String get displayProfit => totalProfit >= 0
      ? '+¥${totalProfit.toStringAsFixed(2)}'
      : '-¥${totalProfit.abs().toStringAsFixed(2)}';
  String get displayProfitRate => profitRate >= 0
      ? '+${profitRate.toStringAsFixed(2)}%'
      : '${profitRate.toStringAsFixed(2)}%';
  String get displayWinRate => '${winRate.toStringAsFixed(1)}%';
  String get displayTradeCount => '$totalTradeCount笔';

  String get marketPrefix {
    if (marketCode.toUpperCase() == 'SH') return 'SH';
    if (marketCode.toUpperCase() == 'SZ') return 'SZ';
    return marketCode;
  }

  String get displayCode => '$marketPrefix $symbol';

  static StockTradeSummaryModel get defaultValue => StockTradeSummaryModel(
        symbol: '',
        symbolName: '',
        marketCode: '',
        sessionCount: 0,
        totalTradeCount: 0,
        totalProfit: 0,
        profitRate: 0,
        winCount: 0,
        winRate: 0,
      );
}
