import 'package:json_annotation/json_annotation.dart';

part 'position_model.g.dart';

@JsonSerializable()
class PositionModel {
  final String id;
  final String symbol;
  final String direction;
  final double openPrice;
  final double currentPrice;
  final double quantity;
  final double margin;
  final double profit;
  final double profitPercent;
  final int openTime;
  final bool isClosed;

  PositionModel({
    required this.id,
    required this.symbol,
    required this.direction,
    required this.openPrice,
    required this.currentPrice,
    required this.quantity,
    required this.margin,
    required this.profit,
    required this.profitPercent,
    required this.openTime,
    required this.isClosed,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) =>
      _$PositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PositionModelToJson(this);

  DateTime get openDateTime => DateTime.fromMillisecondsSinceEpoch(openTime);
}
