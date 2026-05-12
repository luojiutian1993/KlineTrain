// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trading_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionModel _$PositionModelFromJson(Map<String, dynamic> json) =>
    PositionModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      direction: json['direction'] as String,
      openPrice: (json['openPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      margin: (json['margin'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      profitPercent: (json['profitPercent'] as num).toDouble(),
      openTime: (json['openTime'] as num).toInt(),
      isClosed: json['isClosed'] as bool,
    );

Map<String, dynamic> _$PositionModelToJson(PositionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'direction': instance.direction,
      'openPrice': instance.openPrice,
      'currentPrice': instance.currentPrice,
      'quantity': instance.quantity,
      'margin': instance.margin,
      'profit': instance.profit,
      'profitPercent': instance.profitPercent,
      'openTime': instance.openTime,
      'isClosed': instance.isClosed,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      type: json['type'] as String,
      direction: json['direction'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      filledQuantity: (json['filledQuantity'] as num).toDouble(),
      status: json['status'] as String,
      createTime: (json['createTime'] as num).toInt(),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'type': instance.type,
      'direction': instance.direction,
      'price': instance.price,
      'quantity': instance.quantity,
      'filledQuantity': instance.filledQuantity,
      'status': instance.status,
      'createTime': instance.createTime,
    };

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      userId: json['userId'] as String,
      balance: (json['balance'] as num).toDouble(),
      availableBalance: (json['availableBalance'] as num).toDouble(),
      usedMargin: (json['usedMargin'] as num).toDouble(),
      frozenBalance: (json['frozenBalance'] as num).toDouble(),
      totalProfit: (json['totalProfit'] as num).toDouble(),
      todayProfit: (json['todayProfit'] as num).toDouble(),
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'balance': instance.balance,
      'availableBalance': instance.availableBalance,
      'usedMargin': instance.usedMargin,
      'frozenBalance': instance.frozenBalance,
      'totalProfit': instance.totalProfit,
      'todayProfit': instance.todayProfit,
    };
