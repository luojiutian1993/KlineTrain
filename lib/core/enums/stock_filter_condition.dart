import 'dart:ui';

/// 选股条件类型枚举
enum StockFilterCondition {
  // 趋势向上类 (9种)
  allTimeHigh('历史新高', FilterDirection.up, 1),
  yearHigh('一年新高', FilterDirection.up, 2),
  day200High('200日新高', FilterDirection.up, 3),
  return30dTop('30日涨幅前50%', FilterDirection.up, 4),
  return15dTop('15日涨幅前50%', FilterDirection.up, 5),
  limitUp('涨停', FilterDirection.up, 6),
  consecutiveLimitUp('连板', FilterDirection.up, 7),
  volumePriceUp('量价齐升', FilterDirection.up, 8),
  upTrend('上升趋势', FilterDirection.up, 9),

  // 趋势向下类 (9种)
  allTimeLow('历史新低', FilterDirection.down, 10),
  yearLow('一年新低', FilterDirection.down, 11),
  day200Low('200日新低', FilterDirection.down, 12),
  loss30dTop('30日跌幅前50%', FilterDirection.down, 13),
  loss15dTop('15日跌幅前50%', FilterDirection.down, 14),
  downTrend('下降趋势', FilterDirection.down, 15),
  limitDown('跌停', FilterDirection.down, 16),
  consecutiveLimitDown('连续跌停', FilterDirection.down, 17),

  // 随机
  random('随机', FilterDirection.neutral, 0);

  final String label;
  final FilterDirection direction;
  final int sortOrder;

  const StockFilterCondition(this.label, this.direction, this.sortOrder);

  bool get isUpDirection => direction == FilterDirection.up;
  bool get isDownDirection => direction == FilterDirection.down;
  bool get isRandom => this == StockFilterCondition.random;

  static List<StockFilterCondition> get allConditions =>
      values.where((c) => c != StockFilterCondition.random).toList();

  static List<StockFilterCondition> get upTrendConditions =>
      values.where((c) => c.direction == FilterDirection.up).toList();

  static List<StockFilterCondition> get downTrendConditions =>
      values.where((c) => c.direction == FilterDirection.down).toList();

  static StockFilterCondition fromString(String value) {
    return StockFilterCondition.values.firstWhere(
      (e) => e.label == value || e.name == value,
      orElse: () => StockFilterCondition.random,
    );
  }
}

/// 筛选方向
enum FilterDirection {
  up('向上', 0xFFFF0000),
  down('向下', 0xFF00FF00),
  neutral('中性', 0xFF9E9E9E);

  final String label;
  final int colorValue;

  const FilterDirection(this.label, this.colorValue);

  Color get color => Color(colorValue);
}

/// 时间范围类型
enum TimeRangeType {
  recent1Year('近1年'),
  recent3Years('近3年'),
  recent5Years('近5年'),
  custom('自定义');

  final String label;
  const TimeRangeType(this.label);
}

/// 时间范围模型
class StockTimeRange {
  final TimeRangeType type;
  final DateTime? startDate;
  final DateTime? endDate;

  const StockTimeRange({
    required this.type,
    this.startDate,
    this.endDate,
  });

  factory StockTimeRange.recent1Year() {
    final now = DateTime.now();
    return StockTimeRange(
      type: TimeRangeType.recent1Year,
      startDate: DateTime(now.year - 1, now.month, now.day),
      endDate: now,
    );
  }

  factory StockTimeRange.recent3Years() {
    final now = DateTime.now();
    return StockTimeRange(
      type: TimeRangeType.recent3Years,
      startDate: DateTime(now.year - 3, now.month, now.day),
      endDate: now,
    );
  }

  factory StockTimeRange.recent5Years() {
    final now = DateTime.now();
    return StockTimeRange(
      type: TimeRangeType.recent5Years,
      startDate: DateTime(now.year - 5, now.month, now.day),
      endDate: now,
    );
  }

  factory StockTimeRange.custom(DateTime start, DateTime end) {
    return StockTimeRange(
      type: TimeRangeType.custom,
      startDate: start,
      endDate: end,
    );
  }

  String get displayLabel {
    String formatDate(DateTime date) {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    switch (type) {
      case TimeRangeType.recent1Year:
      case TimeRangeType.recent3Years:
      case TimeRangeType.recent5Years:
        if (startDate != null && endDate != null) {
          return '${formatDate(startDate!)} ~ ${formatDate(endDate!)}';
        }
        return type.label;
      case TimeRangeType.custom:
        if (startDate != null && endDate != null) {
          return '${formatDate(startDate!)} ~ ${formatDate(endDate!)}';
        }
        return '自定义';
    }
  }

  @override
  String toString() => 'StockTimeRange($type: $startDate ~ $endDate)';
}
