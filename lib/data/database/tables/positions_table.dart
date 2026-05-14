import 'package:drift/drift.dart';
import 'training_sessions_table.dart';
import 'users_table.dart';

/// 持仓表
class Positions extends Table {
  /// 持仓ID
  IntColumn get id => integer().autoIncrement()();

  /// 会话ID
  IntColumn get sessionId => integer().references(TrainingSessions, #id)();

  /// 用户ID
  IntColumn get userId => integer().references(Users, #id)();

  /// 标的代码
  TextColumn get symbol => text()();

  /// 市场代码
  TextColumn get marketCode => text()();

  /// 持仓数量
  IntColumn get quantity => integer()();

  /// 平均成本
  RealColumn get avgCost => real()();

  /// 当前价格
  RealColumn get currentPrice => real()();

  /// 浮动盈亏
  RealColumn get profitLoss => real()();

  /// 浮动盈亏率
  RealColumn get profitLossRate => real()();

  /// 开仓时间
  DateTimeColumn get openTime => dateTime()();

  /// 平仓时间
  DateTimeColumn get closeTime => dateTime().nullable()();

  /// 状态: open/closed/forced_close
  TextColumn get status => text()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
