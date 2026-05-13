import 'package:drift/drift.dart';
import 'users_table.dart';

/// 用户习惯分析表
class UserHabits extends Table {
  /// 用户ID
  IntColumn get userId => integer().references(Users, #id, onDelete: KeyAction.cascade)();

  /// 习惯类型: trading_time/preferred_market/preferred_period/trading_style/risk_behavior
  TextColumn get habitType => text()();

  /// 习惯值 (JSON或字符串)
  TextColumn get value => text()();

  /// 置信度 (0-1)
  RealColumn get confidence => real()();

  /// 样本数量
  IntColumn get sampleSize => integer()();

  /// 最后更新时间
  DateTimeColumn get lastUpdated => dateTime().withDefault(currentDateAndTime)();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 联合主键
  @override
  Set<Column> get primaryKey => {userId, habitType};
}
