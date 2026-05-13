import 'package:drift/drift.dart';
import 'users_table.dart';

/// 用户偏好设置表
class UserPreferences extends Table {
  /// 用户ID (主键)
  IntColumn get userId => integer().references(Users, #id, onDelete: KeyAction.cascade)();

  /// 主题模式: system/light/dark
  TextColumn get themeMode => text().withDefault(const Constant('system'))();

  /// 语言: zh/en
  TextColumn get language => text().withDefault(const Constant('zh'))();

  /// 文字缩放比例
  RealColumn get textScale => real().withDefault(const Constant(1.0))();

  /// 音效开关
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();

  /// 通知开关
  BoolColumn get notificationEnabled => boolean().withDefault(const Constant(true))();

  /// 自动刷新开关
  BoolColumn get autoRefresh => boolean().withDefault(const Constant(true))();

  /// 刷新间隔(秒)
  IntColumn get refreshInterval => integer().withDefault(const Constant(30))();

  /// 默认市场: A股
  TextColumn get defaultMarket => text().withDefault(const Constant('A股'))();

  /// 默认周期: day
  TextColumn get defaultPeriod => text().withDefault(const Constant('day'))();

  /// 默认指标 (JSON)
  TextColumn get indicators => text().nullable()();

  /// 显示网格线
  BoolColumn get showGridLines => boolean().withDefault(const Constant(true))();

  /// 显示成交量
  BoolColumn get showVolume => boolean().withDefault(const Constant(true))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId};
}
