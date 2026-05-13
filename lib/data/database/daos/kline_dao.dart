import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';

part 'kline_dao.g.dart';

/// K线相关数据访问对象
@DriftAccessor(tables: [Markets, Symbols, KlineData])
class KlineDao extends DatabaseAccessor<AppDatabase> with _$KlineDaoMixin {
  KlineDao(super.db);

  /// 获取所有启用的市场
  Future<List<Market>> getMarkets() {
    return (select(markets)
          ..where((t) => t.enabled.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// 获取所有启用的标的
  Future<List<Symbol>> getSymbols({String? marketCode}) {
    final query = select(symbols)..where((t) => t.enabled.equals(true));
    if (marketCode != null) {
      query.where((t) => t.marketCode.equals(marketCode));
    }
    return query.get();
  }

  /// 通过代码获取标的
  Future<Symbol?> getSymbolByCode(String code) {
    return (select(symbols)..where((t) => t.symbol.equals(code)))
        .getSingleOrNull();
  }

  /// 添加或更新标的
  Future<void> upsertSymbol(SymbolsCompanion symbol) {
    return into(symbols).insertOnConflictUpdate(symbol);
  }

  /// 获取指定标的的K线数据
  Future<List<KlineDataData>> getKlineData(
    String symbol,
    String period, {
    DateTime? startDate,
    DateTime? endDate,
    int limit = 1000,
  }) {
    final query = select(klineData)
      ..where((t) => t.symbol.equals(symbol))
      ..where((t) => t.period.equals(period));

    if (startDate != null) {
      query.where((t) => t.tradeDate.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((t) => t.tradeDate.isSmallerOrEqualValue(endDate));
    }

    query
      ..orderBy([(t) => OrderingTerm.asc(t.tradeDate)])
      ..limit(limit);

    return query.get();
  }

  /// 批量插入K线数据
  Future<void> batchInsertKline(List<KlineDataCompanion> data) {
    return batch((batch) {
      batch.insertAllOnConflictUpdate(klineData, data);
    });
  }

  /// 删除指定标的的K线数据
  Future<int> deleteKlineData(String symbol, String period) {
    return (delete(klineData)
          ..where((t) => t.symbol.equals(symbol))
          ..where((t) => t.period.equals(period)))
        .go();
  }

  /// 获取K线数据条数
  Future<int> countKlineData(String symbol, String period) async {
    final countQuery = klineData.symbol.count();
    final query = selectOnly(klineData)
      ..addColumns([countQuery])
      ..where(klineData.symbol.equals(symbol))
      ..where(klineData.period.equals(period));
    final result = await query.getSingle();
    return result.read(countQuery) ?? 0;
  }
}
