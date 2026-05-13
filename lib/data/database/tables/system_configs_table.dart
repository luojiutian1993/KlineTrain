import 'package:drift/drift.dart';

/// 系统配置表
class SystemConfigs extends Table {
  /// 配置键 (主键)
  TextColumn get key => text()();

  /// 配置值
  TextColumn get value => text()();

  /// 配置描述
  TextColumn get description => text().nullable()();

  /// 分类
  TextColumn get category => text().withDefault(const Constant('general'))();

  /// 是否公开
  BoolColumn get isPublic => boolean().withDefault(const Constant(true))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}
