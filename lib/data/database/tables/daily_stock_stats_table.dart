import 'package:drift/drift.dart';

/// 每日股票统计数据表
/// 用于存储预计算的涨跌幅、均线等数据，加速选股查询
class DailyStockStats extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get tradeDate => dateTime()();

  TextColumn get symbol => text()();

  TextColumn get marketCode => text()();

  RealColumn get closePrice => real()();

  RealColumn get openPrice => real()();

  RealColumn get highPrice => real()();

  RealColumn get lowPrice => real()();

  RealColumn get volume => real()();

  RealColumn get return15d => real().nullable()();

  RealColumn get return30d => real().nullable()();

  RealColumn get ma10 => real().nullable()();

  RealColumn get ma20 => real().nullable()();

  RealColumn get ma50 => real().nullable()();

  RealColumn get ma200 => real().nullable()();

  RealColumn get historicalHigh => real().nullable()();

  RealColumn get historicalLow => real().nullable()();

  RealColumn get yearHigh => real().nullable()();

  RealColumn get yearLow => real().nullable()();

  BoolColumn get isLimitUp => boolean().withDefault(const Constant(false))();

  BoolColumn get isLimitDown => boolean().withDefault(const Constant(false))();

  IntColumn get listingDays => integer().withDefault(const Constant(0))();

  BoolColumn get isSuspended => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
        'UNIQUE(trade_date, symbol)',
      ];
}
