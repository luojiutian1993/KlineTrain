class PositionItem {
  final String id;
  final String label;
  final double ratio;

  const PositionItem({
    required this.id,
    required this.label,
    required this.ratio,
  });

  PositionItem copyWith({
    String? id,
    String? label,
    double? ratio,
  }) {
    return PositionItem(
      id: id ?? this.id,
      label: label ?? this.label,
      ratio: ratio ?? this.ratio,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          ratio == other.ratio;

  @override
  int get hashCode => id.hashCode ^ label.hashCode ^ ratio.hashCode;
}

List<PositionItem> defaultBuyPositions = [
  PositionItem(id: '1', label: '全仓', ratio: 1.0),
  PositionItem(id: '2', label: '1/2仓', ratio: 1 / 2),
  PositionItem(id: '3', label: '1/3仓', ratio: 1 / 3),
  PositionItem(id: '4', label: '1/4仓', ratio: 1 / 4),
  PositionItem(id: '5', label: '2/3仓', ratio: 2 / 3),
];

List<PositionItem> defaultSellPositions = [
  PositionItem(id: '1', label: '全仓', ratio: 1.0),
  PositionItem(id: '2', label: '1/2仓', ratio: 1 / 2),
  PositionItem(id: '3', label: '1/3仓', ratio: 1 / 3),
  PositionItem(id: '4', label: '1/4仓', ratio: 1 / 4),
  PositionItem(id: '5', label: '2/3仓', ratio: 2 / 3),
];

class PositionConfig {
  static List<PositionItem> buyPositions = List.from(defaultBuyPositions);
  static List<PositionItem> sellPositions = List.from(defaultSellPositions);
  static bool skipBuyConfirm = false;

  static void resetToDefault() {
    buyPositions = List.from(defaultBuyPositions);
    sellPositions = List.from(defaultSellPositions);
    skipBuyConfirm = false;
  }

  static void saveBuyPositions(List<PositionItem> positions) {
    buyPositions = positions;
  }

  static void saveSellPositions(List<PositionItem> positions) {
    sellPositions = positions;
  }
}

class PositionCalculator {
  static double calculateQuantity(double maxQuantity, double ratio) {
    if (maxQuantity <= 0 || ratio <= 0) return 0;
    double quantity = maxQuantity * ratio;
    quantity = (quantity / 100).floor() * 100;
    return quantity.clamp(0, maxQuantity);
  }

  static double calculateMaxBuyQuantity(double accountBalance, double currentPrice) {
    if (currentPrice <= 0) return 0;
    return ((accountBalance / currentPrice / 100).floor() * 100).toDouble();
  }
}
