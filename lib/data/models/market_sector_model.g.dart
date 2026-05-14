// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_sector_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketSectorModel _$MarketSectorModelFromJson(Map<String, dynamic> json) =>
    MarketSectorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      marketType: json['marketType'] as String,
      icon: json['icon'] as String,
      code: json['code'] as String,
      stockCount: (json['stockCount'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$MarketSectorModelToJson(MarketSectorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'marketType': instance.marketType,
      'icon': instance.icon,
      'code': instance.code,
      'stockCount': instance.stockCount,
      'description': instance.description,
      'isSelected': instance.isSelected,
    };
