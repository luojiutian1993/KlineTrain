import 'package:drift/drift.dart';
import 'users_table.dart';

/// 交易模式表
class TradingPatterns extends Table {
  /// 模式ID
  IntColumn get id => integer().autoIncrement()();

  /// 用户ID
  IntColumn get userId => integer().references(Users, #id)();

  /// 模式类型: breakout/reversal/trend_following/range_trading/mean_reversion
  TextColumn get patternType => text()();

  /// 出现频率
  RealColumn get occurrenceRate => real()();

  /// 成功率
  RealColumn get successRate => real()();

  /// 平均收益率
  RealColumn get avgProfitRate => real()();

  /// 样本数量
  IntColumn get sampleCount => integer()();

  /// 触发条件 (JSON)
  TextColumn get conditions => text().nullable()();

  /// 参数配置 (JSON)
  TextColumn get parameters => text().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
