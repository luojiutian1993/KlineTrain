import 'package:drift/drift.dart';

/// K线历史数据表
class KlineData extends Table {
  /// 标的代码
  TextColumn get symbol => text()();

  /// 市场代码
  TextColumn get marketCode => text()();

  /// 周期: day/week/month/year/1min/5min/15min/30min/60min
  TextColumn get period => text()();

  /// 交易日期时间
  DateTimeColumn get tradeDate => dateTime()();

  /// 开盘价
  RealColumn get open => real()();

  /// 收盘价
  RealColumn get close => real()();

  /// 最高价
  RealColumn get high => real()();

  /// 最低价
  RealColumn get low => real()();

  /// 成交量
  RealColumn get volume => real()();

  /// 成交额
  RealColumn get amount => real()();

  /// 换手率
  RealColumn get turnoverRate => real().nullable()();

  /// 市盈率
  RealColumn get pe => real().nullable()();

  /// 市净率
  RealColumn get pb => real().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 联合主键: symbol + period + tradeDate
  @override
  Set<Column> get primaryKey => {symbol, period, tradeDate};
}
