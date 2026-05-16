import 'package:drift/drift.dart';

/// 选股结果缓存表
/// 用于缓存每日选股计算结果，避免重复计算
class StockFilterResults extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get filterDate => dateTime()();

  TextColumn get conditionType => text()();

  TextColumn get symbol => text()();

  TextColumn get marketCode => text()();

  TextColumn get symbolName => text()();

  RealColumn get closePrice => real()();

  RealColumn get changePercent => real()();

  TextColumn get extraData => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
        'UNIQUE(filter_date, condition_type, symbol)',
      ];
}
