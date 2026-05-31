// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kline_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KlineModel _$KlineModelFromJson(Map<String, dynamic> json) => KlineModel(
      symbol: json['symbol'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      turnover: (json['turnover'] as num).toDouble(),
      turnoverRate: (json['turnoverRate'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$KlineModelToJson(KlineModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'timestamp': instance.timestamp,
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
      'close': instance.close,
      'volume': instance.volume,
      'turnover': instance.turnover,
      'turnoverRate': instance.turnoverRate,
      'amount': instance.amount,
    };

KlineResponse _$KlineResponseFromJson(Map<String, dynamic> json) =>
    KlineResponse(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => KlineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KlineResponseToJson(KlineResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
