import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';
import '../../../shared/constants/market_sectors.dart';

part 'market_dao.g.dart';

@DriftAccessor(tables: [Markets, Symbols, KlineData])
class MarketDao extends DatabaseAccessor<AppDatabase> with _$MarketDaoMixin {
  MarketDao(super.db);

  Future<List<Market>> getMarkets() {
    return (select(markets)
          ..where((t) => t.enabled.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<List<Symbol>> getSymbols({String? marketCode}) {
    final query = select(symbols)..where((t) => t.enabled.equals(true));
    if (marketCode != null) {
      query.where((t) => t.marketCode.equals(marketCode));
    }
    return query.get();
  }

  Future<List<Symbol>> getSymbolsByMarketType(MarketType marketType) {
    final marketCode = marketType.code;
    return getSymbols(marketCode: marketCode);
  }

  Future<Symbol?> getSymbolByCode(String code) {
    return (select(symbols)..where((t) => t.symbol.equals(code)))
        .getSingleOrNull();
  }

  Future<void> upsertMarket(MarketsCompanion market) {
    return into(markets).insertOnConflictUpdate(market);
  }

  Future<void> upsertSymbol(SymbolsCompanion symbol) {
    return into(symbols).insertOnConflictUpdate(symbol);
  }

  Future<int> getSymbolCount(String marketCode) async {
    final countQuery = symbols.symbol.count();
    final query = selectOnly(symbols)
      ..addColumns([countQuery])
      ..where(symbols.marketCode.equals(marketCode))
      ..where(symbols.enabled.equals(true));
    final result = await query.getSingle();
    return result.read(countQuery) ?? 0;
  }
}