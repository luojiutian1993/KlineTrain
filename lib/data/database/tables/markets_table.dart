import 'package:drift/drift.dart';

/// 市场配置表
class Markets extends Table {
  /// 市场ID
  IntColumn get id => integer().autoIncrement()();

  /// 市场代码: A股/SH/SZ/HK/US/FUTURES
  TextColumn get code => text().unique()();

  /// 市场名称
  TextColumn get name => text()();

  /// 市场描述
  TextColumn get description => text().nullable()();

  /// 货币单位
  TextColumn get currency => text()();

  /// 是否启用
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  /// 排序顺序
  IntColumn get sortOrder => integer().withDefault(const Constant(1))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
