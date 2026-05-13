import 'package:drift/drift.dart';
import 'users_table.dart';

/// 用户详情表
class UserProfiles extends Table {
  /// 用户ID (主键)
  IntColumn get userId => integer().references(Users, #id, onDelete: KeyAction.cascade)();

  /// 真实姓名
  TextColumn get realName => text().nullable()();

  /// 身份证号 (加密)
  TextColumn get idCard => text().nullable()();

  /// 性别: male/female/other
  TextColumn get gender => text().nullable()();

  /// 生日
  DateTimeColumn get birthday => dateTime().nullable()();

  /// 所在地区
  TextColumn get region => text().nullable()();

  /// 交易经验年限
  TextColumn get tradingExperience => text().nullable()();

  /// 投资目标
  TextColumn get investmentGoal => text().nullable()();

  /// 风险承受能力
  TextColumn get riskTolerance => text().nullable()();

  /// 偏好市场 (JSON)
  TextColumn get favoriteMarkets => text().nullable()();

  /// 个人简介
  TextColumn get bio => text().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId};
}
