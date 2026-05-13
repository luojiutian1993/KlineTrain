import 'package:drift/drift.dart';

/// 用户基础信息表
class Users extends Table {
  /// 用户ID
  IntColumn get id => integer().autoIncrement()();

  /// 手机号
  TextColumn get phone => text().unique().withLength(min: 11, max: 11)();

  /// 加密密码
  TextColumn get password => text()();

  /// 用户昵称
  TextColumn get nickname => text().nullable()();

  /// 头像URL
  TextColumn get avatar => text().nullable()();

  /// 邮箱
  TextColumn get email => text().nullable()();

  /// 会员等级(1-10)
  IntColumn get memberLevel => integer().withDefault(const Constant(1))();

  /// 经验值
  IntColumn get experience => integer().withDefault(const Constant(0))();

  /// 累计盈亏
  RealColumn get totalProfit => real().withDefault(const Constant(0.0))();

  /// 累计训练天数
  IntColumn get totalTrainingDays => integer().withDefault(const Constant(0))();

  /// 日均训练时长(分钟)
  RealColumn get avgDailyDuration => real().withDefault(const Constant(0.0))();

  /// 总胜率
  RealColumn get overallWinRate => real().withDefault(const Constant(0.0))();

  /// 平均收益率
  RealColumn get avgProfitRate => real().withDefault(const Constant(0.0))();

  /// 状态: active/inactive/banned
  TextColumn get status => text().withDefault(const Constant('active'))();

  /// 最后登录时间
  DateTimeColumn get lastLoginAt => dateTime().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
