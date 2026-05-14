import 'package:drift/drift.dart';
import 'training_sessions_table.dart';
import 'users_table.dart';

/// 操作日志表
class OperationLogs extends Table {
  /// 日志ID
  IntColumn get id => integer().autoIncrement()();

  /// 会话ID
  IntColumn get sessionId => integer().references(TrainingSessions, #id)();

  /// 用户ID
  IntColumn get userId => integer().references(Users, #id)();

  /// 动作类型: reveal_kline/buy/sell/set_order/cancel_order/next_period/skip
  TextColumn get action => text()();

  /// 详细信息 (JSON)
  TextColumn get detail => text().nullable()();

  /// K线日期
  TextColumn get tradeDate => text()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
