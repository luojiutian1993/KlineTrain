import 'package:json_annotation/json_annotation.dart';
import '../../shared/constants/market_sectors.dart';

part 'market_sector_model.g.dart';

@JsonSerializable()
class MarketSectorModel {
  final String id;
  final String name;
  final String marketType;
  final String icon;
  final String code;
  final int stockCount;
  final String? description;
  @JsonKey(defaultValue: false)
  final bool isSelected;

  MarketSectorModel({
    required this.id,
    required this.name,
    required this.marketType,
    required this.icon,
    required this.code,
    this.stockCount = 0,
    this.description,
    this.isSelected = false,
  });

  factory MarketSectorModel.fromJson(Map<String, dynamic> json) =>
      _$MarketSectorModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarketSectorModelToJson(this);

  MarketType get marketTypeEnum {
    switch (marketType) {
      case 'aShare':
        return MarketType.aShare;
      case 'hkStock':
        return MarketType.hkStock;
      case 'usStock':
        return MarketType.usStock;
      case 'futures':
        return MarketType.futures;
      case 'crypto':
        return MarketType.crypto;
      default:
        return MarketType.aShare;
    }
  }

  static MarketSectorModel fromSector(MarketSector sector,
      {bool selected = false}) {
    return MarketSectorModel(
      id: sector.id,
      name: sector.name,
      marketType: sector.marketType.name,
      icon: sector.icon,
      code: sector.code,
      stockCount: sector.stockCount,
      description: sector.description,
      isSelected: selected,
    );
  }

  MarketSectorModel copyWith({
    String? id,
    String? name,
    String? marketType,
    String? icon,
    String? code,
    int? stockCount,
    String? description,
    bool? isSelected,
  }) {
    return MarketSectorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      marketType: marketType ?? this.marketType,
      icon: icon ?? this.icon,
      code: code ?? this.code,
      stockCount: stockCount ?? this.stockCount,
      description: description ?? this.description,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
