import 'package:drift/drift.dart';

/// 版本历史表
class VersionHistory extends Table {
  /// 版本ID
  IntColumn get id => integer().autoIncrement()();

  /// 版本号
  TextColumn get version => text()();

  /// 更新标题
  TextColumn get title => text()();

  /// 更新内容 (JSON)
  TextColumn get changes => text()();

  /// 是否重大更新
  BoolColumn get isMajor => boolean().withDefault(const Constant(false))();

  /// 发布日期
  DateTimeColumn get releaseDate => dateTime().withDefault(currentDateAndTime)();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
