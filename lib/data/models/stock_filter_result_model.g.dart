// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_filter_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockFilterResultModel _$StockFilterResultModelFromJson(
        Map<String, dynamic> json) =>
    StockFilterResultModel(
      symbol: json['symbol'] as String,
      symbolName: json['symbolName'] as String,
      marketCode: json['marketCode'] as String,
      closePrice: (json['closePrice'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      extraData: json['extraData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StockFilterResultModelToJson(
        StockFilterResultModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'symbolName': instance.symbolName,
      'marketCode': instance.marketCode,
      'closePrice': instance.closePrice,
      'changePercent': instance.changePercent,
      'extraData': instance.extraData,
    };

StockFilterResultResponse _$StockFilterResultResponseFromJson(
        Map<String, dynamic> json) =>
    StockFilterResultResponse(
      condition: json['condition'] as String,
      conditionName: json['conditionName'] as String,
      date: DateTime.parse(json['date'] as String),
      total: (json['total'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map(
              (e) => StockFilterResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StockFilterResultResponseToJson(
        StockFilterResultResponse instance) =>
    <String, dynamic>{
      'condition': instance.condition,
      'conditionName': instance.conditionName,
      'date': instance.date.toIso8601String(),
      'total': instance.total,
      'items': instance.items,
    };
