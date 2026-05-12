// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_model.dart';

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
