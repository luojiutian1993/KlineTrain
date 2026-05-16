// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_filter_condition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockFilterConditionModel _$StockFilterConditionModelFromJson(
        Map<String, dynamic> json) =>
    StockFilterConditionModel(
      code: json['code'] as String,
      name: json['name'] as String,
      direction: json['direction'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      description: json['description'] as String?,
      formula: json['formula'] as String?,
    );

Map<String, dynamic> _$StockFilterConditionModelToJson(
        StockFilterConditionModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'direction': instance.direction,
      'sortOrder': instance.sortOrder,
      'description': instance.description,
      'formula': instance.formula,
    };
