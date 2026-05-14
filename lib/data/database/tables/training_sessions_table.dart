import 'package:drift/drift.dart';
import 'users_table.dart';

/// 训练会话表
class TrainingSessions extends Table {
  /// 会话ID
  IntColumn get id => integer().autoIncrement()();

  /// 用户ID
  IntColumn get userId => integer().references(Users, #id)();

  /// 标的代码
  TextColumn get symbol => text()();

  /// 市场代码
  TextColumn get marketCode => text()();

  /// 周期
  TextColumn get period => text()();

  /// 开始日期
  DateTimeColumn get startDate => dateTime()();

  /// 结束日期
  DateTimeColumn get endDate => dateTime()();

  /// 初始资金
  RealColumn get initialCapital => real().withDefault(const Constant(100000.0))();

  /// 当前资金
  RealColumn get currentCapital => real().withDefault(const Constant(100000.0))();

  /// 总盈亏
  RealColumn get totalProfit => real().withDefault(const Constant(0.0))();

  /// 收益率
  RealColumn get profitRate => real().withDefault(const Constant(0.0))();

  /// 交易次数
  IntColumn get tradeCount => integer().withDefault(const Constant(0))();

  /// 盈利次数
  IntColumn get winCount => integer().withDefault(const Constant(0))();

  /// 胜率
  RealColumn get winRate => real().withDefault(const Constant(0.0))();

  /// 最大回撤
  RealColumn get maxDrawdown => real().withDefault(const Constant(0.0))();

  /// 平均持仓时长(天)
  RealColumn get avgHoldDuration => real().withDefault(const Constant(0.0))();

  /// 盈亏比
  RealColumn get profitLossRatio => real().withDefault(const Constant(0.0))();

  /// 条件单数量
  IntColumn get conditionOrderCount => integer().withDefault(const Constant(0))();

  /// 条件单触发数
  IntColumn get conditionOrderTriggered => integer().withDefault(const Constant(0))();

  /// 使用的策略 (JSON)
  TextColumn get strategyUsed => text().nullable()();

  /// 状态: active/finished/stopped/lost
  TextColumn get status => text()();

  /// 开始时间
  DateTimeColumn get startTime => dateTime().nullable()();

  /// 结束时间
  DateTimeColumn get endTime => dateTime().nullable()();

  /// 训练时长(分钟)
  IntColumn get duration => integer().withDefault(const Constant(0))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
