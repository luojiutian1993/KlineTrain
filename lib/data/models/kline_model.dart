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

  KlineModel({
    required this.symbol,
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.turnover,
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

class KdjData {
  final double k;
  final double d;
  final double j;

  const KdjData({
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
  final double upper;
  final double mid;
  final double lower;

  BollData({
    required this.upper,
    required this.mid,
    required this.lower,
  });
}
