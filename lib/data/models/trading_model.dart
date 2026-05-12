import 'package:json_annotation/json_annotation.dart';

part 'trading_model.g.dart';

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

@JsonSerializable()
class OrderModel {
  final String id;
  final String symbol;
  final String type;
  final String direction;
  final double price;
  final double quantity;
  final double filledQuantity;
  final String status;
  final int createTime;

  OrderModel({
    required this.id,
    required this.symbol,
    required this.type,
    required this.direction,
    required this.price,
    required this.quantity,
    required this.filledQuantity,
    required this.status,
    required this.createTime,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  DateTime get createDateTime => DateTime.fromMillisecondsSinceEpoch(createTime);
}

@JsonSerializable()
class AccountModel {
  final String userId;
  final double balance;
  final double availableBalance;
  final double usedMargin;
  final double frozenBalance;
  final double totalProfit;
  final double todayProfit;

  AccountModel({
    required this.userId,
    required this.balance,
    required this.availableBalance,
    required this.usedMargin,
    required this.frozenBalance,
    required this.totalProfit,
    required this.todayProfit,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
