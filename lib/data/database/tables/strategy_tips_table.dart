import 'package:drift/drift.dart';

/// 策略技巧表
class StrategyTips extends Table {
  /// 技巧ID
  IntColumn get id => integer().autoIncrement()();

  /// 技巧代码 (唯一)
  TextColumn get code => text().unique()();

  /// 策略名称
  TextColumn get title => text()();

  /// 策略描述
  TextColumn get description => text()();

  /// 分类: entry/exit/risk_management/position_sizing
  TextColumn get category => text()();

  /// 有效性评分 (0-1)
  RealColumn get effectiveness => real()();

  /// 验证用户数
  IntColumn get verifiedUsers => integer()();

  /// 使用条件 (JSON)
  TextColumn get conditions => text()();

  /// 策略规则 (JSON)
  TextColumn get rules => text()();

  /// 使用示例 (JSON)
  TextColumn get examples => text().nullable()();

  /// 注意事项
  TextColumn get notes => text().nullable()();

  /// 是否启用
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
