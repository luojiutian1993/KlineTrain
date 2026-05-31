import 'package:json_annotation/json_annotation.dart';

part 'kline_model.g.dart';

@JsonSerializable()
class KlineModel {
  final String symbol;
  final int timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final double turnover;
  final double? turnoverRate;
  final double? amount;

  KlineModel({
    required this.symbol,
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.turnover,
    this.turnoverRate,
    this.amount,
  });

  factory KlineModel.fromJson(Map<String, dynamic> json) =>
      _$KlineModelFromJson(json);

  Map<String, dynamic> toJson() => _$KlineModelToJson(this);

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);

  bool get isUp => close >= open;

  double get change => close - open;

  double get changePercent => ((close - open) / open) * 100;
}

@JsonSerializable()
class KlineResponse {
  final int code;
  final String message;
  final List<KlineModel> data;

  KlineResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory KlineResponse.fromJson(Map<String, dynamic> json) =>
      _$KlineResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KlineResponseToJson(this);
}

class KlineData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  KlineData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}

class VolumeData {
  final double volume;
  final bool isUp;

  VolumeData({
    required this.volume,
    required this.isUp,
  });
}

class MacdData {
  final double macd;
  final double diff;
  final double dea;

  MacdData({
    required this.macd,
    required this.diff,
    required this.dea,
  });
}

class KdjData {
  final double k;
  final double d;
  final double j;

  KdjData({
    required this.k,
    required this.d,
    required this.j,
  });
}

class RsiData {
  final double rsi;

  const RsiData({required this.rsi});
}

class BollData {
  final double mb;
  final double up;
  final double dn;

  BollData({
    required this.mb,
    required this.up,
    required this.dn,
  });
}

class DmiData {
  final double plusDi;
  final double minusDi;
  final double adx;

  DmiData({
    required this.plusDi,
    required this.minusDi,
    required this.adx,
  });
}

class DmaData {
  final double dma;
  final double ama;

  DmaData({
    required this.dma,
    required this.ama,
  });
}
