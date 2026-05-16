class RecentTradeModel {
  final int id;
  final int sessionId;
  final String symbol;
  final String symbolName;
  final String marketCode;
  final String type;
  final double price;
  final int quantity;
  final double amount;
  final double profit;
  final double profitRate;
  final String tradeDate;
  final DateTime createdAt;
  final String? positionStatus;

  const RecentTradeModel({
    required this.id,
    required this.sessionId,
    required this.symbol,
    required this.symbolName,
    required this.marketCode,
    required this.type,
    required this.price,
    required this.quantity,
    required this.amount,
    required this.profit,
    required this.profitRate,
    required this.tradeDate,
    required this.createdAt,
    this.positionStatus,
  });

  bool get isBuy => type.toLowerCase() == 'buy';
  bool get isWin => profit > 0;

  String get displayType => isBuy ? '买入' : '卖出';
  String get displayQuantity => '${quantity}股';
  String get displayProfit => profit >= 0
      ? '+¥${profit.toStringAsFixed(2)}'
      : '-¥${profit.abs().toStringAsFixed(2)}';
  String get displayProfitRate => profitRate >= 0
      ? '+${profitRate.toStringAsFixed(1)}%'
      : '${profitRate.toStringAsFixed(1)}%';

  String get marketPrefix {
    if (marketCode.toUpperCase() == 'SH') return 'SH';
    if (marketCode.toUpperCase() == 'SZ') return 'SZ';
    return marketCode;
  }

  String get displayCode => '$marketPrefix $symbol';

  static RecentTradeModel get defaultValue => RecentTradeModel(
        id: 0,
        sessionId: 0,
        symbol: '',
        symbolName: '',
        marketCode: '',
        type: 'buy',
        price: 0,
        quantity: 0,
        amount: 0,
        profit: 0,
        profitRate: 0,
        tradeDate: '',
        createdAt: DateTime.now(),
      );
}
