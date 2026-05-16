import 'package:json_annotation/json_annotation.dart';
import '../../core/enums/stock_filter_condition.dart';

part 'stock_filter_condition_model.g.dart';

/// 选股条件模型
@JsonSerializable()
class StockFilterConditionModel {
  final String code;
  final String name;
  final String direction;
  final int sortOrder;
  final String? description;
  final String? formula;

  StockFilterConditionModel({
    required this.code,
    required this.name,
    required this.direction,
    required this.sortOrder,
    this.description,
    this.formula,
  });

  factory StockFilterConditionModel.fromJson(Map<String, dynamic> json) =>
      _$StockFilterConditionModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockFilterConditionModelToJson(this);

  factory StockFilterConditionModel.fromEnum(StockFilterCondition condition) {
    return StockFilterConditionModel(
      code: condition.name,
      name: condition.label,
      direction: condition.direction.name,
      sortOrder: condition.sortOrder,
      description: _getDescription(condition),
      formula: _getFormula(condition),
    );
  }

  static List<StockFilterConditionModel> get all =>
      StockFilterCondition.values
          .where((c) => c != StockFilterCondition.random)
          .map(StockFilterConditionModel.fromEnum)
          .toList();

  static String? _getDescription(StockFilterCondition condition) {
    return switch (condition) {
      StockFilterCondition.allTimeHigh => '当前收盘价是上市以来最高',
      StockFilterCondition.yearHigh => '当前收盘价是过去一年最高',
      StockFilterCondition.day200High => '当前收盘价是过去200个交易日最高',
      StockFilterCondition.return30dTop => '过去30日涨幅排名前50%',
      StockFilterCondition.return15dTop => '过去15日涨幅排名前50%',
      StockFilterCondition.limitUp => '当日收盘价等于最高价',
      StockFilterCondition.consecutiveLimitUp => '连续2日收盘价等于最高价',
      StockFilterCondition.volumePriceUp => '成交量涨5%+，股价涨2%',
      StockFilterCondition.upTrend => '10/20/50日均线向上且多头排列',
      StockFilterCondition.allTimeLow => '当前收盘价是上市以来最低',
      StockFilterCondition.yearLow => '当前收盘价是过去一年最低',
      StockFilterCondition.day200Low => '当前收盘价是过去200个交易日最低',
      StockFilterCondition.loss30dTop => '过去30日跌幅排名前50%',
      StockFilterCondition.loss15dTop => '过去15日跌幅排名前50%',
      StockFilterCondition.downTrend => '10/20/50日均线向下且空头排列',
      StockFilterCondition.limitDown => '当日收盘价等于最低价',
      StockFilterCondition.consecutiveLimitDown => '连续2日收盘价等于最低价',
      _ => null,
    };
  }

  static String? _getFormula(StockFilterCondition condition) {
    return switch (condition) {
      StockFilterCondition.allTimeHigh => 'close[t] = MAX(close[上市日..t])',
      StockFilterCondition.yearHigh => 'close[t] = MAX(close[t-252..t])',
      StockFilterCondition.day200High => 'close[t] = MAX(close[t-200..t])',
      StockFilterCondition.return30dTop => 'PERCENT_RANK(return_30d) <= 0.5',
      StockFilterCondition.return15dTop => 'PERCENT_RANK(return_15d) <= 0.5',
      StockFilterCondition.limitUp => 'close[t] = high[t]',
      StockFilterCondition.consecutiveLimitUp => 'close[t]=high[t] AND close[t-1]=high[t-1]',
      StockFilterCondition.volumePriceUp => 'volume[t]/volume[t-1]>1.05 AND close[t]/close[t-1]>1.02',
      StockFilterCondition.upTrend => 'MA10>MA20>MA50 AND angle(MA10)>angle(MA20)>angle(MA50)',
      StockFilterCondition.allTimeLow => 'close[t] = MIN(close[上市日..t])',
      StockFilterCondition.yearLow => 'close[t] = MIN(close[t-252..t])',
      StockFilterCondition.day200Low => 'close[t] = MIN(close[t-200..t])',
      StockFilterCondition.loss30dTop => 'PERCENT_RANK(loss_30d) <= 0.5',
      StockFilterCondition.loss15dTop => 'PERCENT_RANK(loss_15d) <= 0.5',
      StockFilterCondition.downTrend => 'MA10<MA20<MA50 AND angle(MA10)<angle(MA20)<angle(MA50)',
      StockFilterCondition.limitDown => 'close[t] = low[t]',
      StockFilterCondition.consecutiveLimitDown => 'close[t]=low[t] AND close[t-1]=low[t-1]',
      _ => null,
    };
  }
}
