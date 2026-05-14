import 'package:drift/drift.dart';
import 'training_sessions_table.dart';
import 'users_table.dart';

/// 条件单表
class ConditionalOrders extends Table {
  /// 条件单ID
  IntColumn get id => integer().autoIncrement()();

  /// 会话ID
  IntColumn get sessionId => integer().references(TrainingSessions, #id)();

  /// 用户ID
  IntColumn get userId => integer().references(Users, #id)();

  /// 标的代码
  TextColumn get symbol => text()();

  /// 市场代码
  TextColumn get marketCode => text()();

  /// 类型: take_profit/stop_loss/condition/buy_limit/sell_limit/grid
  TextColumn get type => text()();

  /// 触发类型: price/reach/cross
  TextColumn get triggerType => text()();

  /// 目标价格
  RealColumn get targetPrice => real().nullable()();

  /// 止损价格
  RealColumn get stopPrice => real().nullable()();

  /// 网格上限
  RealColumn get upperPrice => real().nullable()();

  /// 网格下限
  RealColumn get lowerPrice => real().nullable()();

  /// 网格数量
  IntColumn get gridCount => integer().nullable()();

  /// 网格步长
  RealColumn get gridStep => real().nullable()();

  /// 已触发网格
  IntColumn get gridFilled => integer().withDefault(const Constant(0))();

  /// 委托数量
  IntColumn get quantity => integer()();

  /// 状态: active/triggered/cancelled/expired
  TextColumn get status => text()();

  /// 触发时间
  DateTimeColumn get triggerTime => dateTime().nullable()();

  /// 过期时间
  DateTimeColumn get expireTime => dateTime().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
