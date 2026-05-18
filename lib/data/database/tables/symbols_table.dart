import 'package:drift/drift.dart';
import 'markets_table.dart';

/// 标的信息表
class Symbols extends Table {
  /// 标的ID
  IntColumn get id => integer().autoIncrement()();

  /// 标的代码: 如SH600519
  TextColumn get symbol => text().unique()();

  /// 标的名称
  TextColumn get name => text()();

  /// 市场代码
  TextColumn get marketCode => text().references(Markets, #code)();

  /// 行业分类
  TextColumn get industry => text().nullable()();

  /// 板块
  TextColumn get sector => text().nullable()();

  /// 最新价格
  RealColumn get lastPrice => real().nullable()();

  /// 涨跌幅
  RealColumn get change => real().nullable()();

  /// 每手数量
  IntColumn get lotSize => integer().nullable()();

  /// 最小变动价位
  RealColumn get minTick => real().nullable()();

  /// 是否启用
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  /// 创建时间
  TextColumn get createdAt => text().nullable()();

  /// 更新时间
  TextColumn get updatedAt => text().nullable()();
}
