import 'package:json_annotation/json_annotation.dart';

part 'stock_filter_result_model.g.dart';

/// 选股结果模型
@JsonSerializable()
class StockFilterResultModel {
  final String symbol;
  final String symbolName;
  final String marketCode;
  final double closePrice;
  final double changePercent;
  final Map<String, dynamic>? extraData;

  StockFilterResultModel({
    required this.symbol,
    required this.symbolName,
    required this.marketCode,
    required this.closePrice,
    required this.changePercent,
    this.extraData,
  });

  factory StockFilterResultModel.fromJson(Map<String, dynamic> json) =>
      _$StockFilterResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockFilterResultModelToJson(this);

  bool get isUp => changePercent >= 0;

  String get changePercentDisplay {
    final sign = changePercent >= 0 ? '+' : '';
    return '$sign${changePercent.toStringAsFixed(2)}%';
  }
}

/// 选股结果列表响应
@JsonSerializable()
class StockFilterResultResponse {
  final String condition;
  final String conditionName;
  final DateTime date;
  final int total;
  final List<StockFilterResultModel> items;
  final DateTime? trainingStartDate;
  final int? trainingDays;

  StockFilterResultResponse({
    required this.condition,
    required this.conditionName,
    required this.date,
    required this.total,
    required this.items,
    this.trainingStartDate,
    this.trainingDays,
  });

  factory StockFilterResultResponse.fromJson(Map<String, dynamic> json) =>
      _$StockFilterResultResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StockFilterResultResponseToJson(this);
}
