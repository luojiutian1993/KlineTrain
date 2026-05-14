import 'package:drift/drift.dart';
import 'training_sessions_table.dart';
import 'users_table.dart';
import 'positions_table.dart';

/// 交易记录表
class Trades extends Table {
  /// 交易ID
  IntColumn get id => integer().autoIncrement()();

  /// 会话ID
  IntColumn get sessionId => integer().references(TrainingSessions, #id)();

  /// 用户ID
  IntColumn get userId => integer().references(Users, #id)();

  /// 标的代码
  TextColumn get symbol => text()();

  /// 市场代码
  TextColumn get marketCode => text()();

  /// 类型: buy/sell
  TextColumn get type => text()();

  /// 订单类型: market/limit/stop
  TextColumn get orderType => text().withDefault(const Constant('market'))();

  /// 成交价格
  RealColumn get price => real()();

  /// 成交数量
  IntColumn get quantity => integer()();

  /// 成交金额
  RealColumn get amount => real()();

  /// 手续费
  RealColumn get fee => real().withDefault(const Constant(0.0))();

  /// 单笔盈亏
  RealColumn get profit => real().withDefault(const Constant(0.0))();

  /// 单笔收益率
  RealColumn get profitRate => real().withDefault(const Constant(0.0))();

  /// 持仓ID
  IntColumn get positionId => integer().nullable().references(Positions, #id)();

  /// K线日期标识
  TextColumn get tradeDate => text()();

  /// 触发来源: manual/condition/grid/system
  TextColumn get triggerSource => text().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
