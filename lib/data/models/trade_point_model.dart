class TradePoint {
  final int index;
  final double price;
  final bool isBuy;
  final String label;
  final DateTime date;
  final int tradeId;
  final int quantity;

  TradePoint({
    required this.index,
    required this.price,
    required this.isBuy,
    required this.label,
    required this.date,
    required this.tradeId,
    required this.quantity,
  });
}
