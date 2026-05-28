import 'dart:math';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/repositories/kline_repository.dart';
import 'package:kline_trainer/features/battle/models/battle_config.dart';

class StockService {
  final DatabaseService _db;
  final KlineRepository _repository;

  StockService({
    DatabaseService? db,
    KlineRepository? repository,
  })  : _db = db ?? DatabaseService.instance,
        _repository = repository ?? KlineRepository();

  Future<StockInfo> loadStock(String symbol) async {
    final symbols = await _db.klineDao.getSymbols();
    final matching = symbols.where((s) => s.symbol == symbol).toList();

    if (matching.isNotEmpty) {
      final s = matching.first;
      return StockInfo(
        symbol: s.symbol,
        name: s.name ?? s.symbol,
        marketCode: s.marketCode ?? '',
      );
    }

    return StockInfo(
      symbol: symbol,
      name: symbol,
      marketCode: '',
    );
  }

  Future<CandidateStock?> randomSelect() async {
    final candidates = await _db.klineDao.getSymbolsWithMinKlineData(
      minDays: BattleConfig.minKlineDataDays,
    );

    if (candidates.isEmpty) {
      return null;
    }

    final random = Random();
    final shuffled = List.of(candidates)..shuffle(random);

    for (int i = 0; i < shuffled.length && i < 3; i++) {
      final candidate = shuffled[i];
      final symbol = candidate['symbol'] ?? '';
      final marketCode = candidate['marketCode'] ?? '';

      if (symbol.isEmpty) continue;

      final stockInfo = await loadStock(symbol);
      return CandidateStock(
        symbol: symbol,
        name: stockInfo.name,
        marketCode: marketCode,
      );
    }

    return null;
  }

  Future<List<KlineModel>> loadKlineData({
    required String symbol,
    DateTime? startDate,
    int days = 250,
  }) async {
    if (symbol.isEmpty) {
      throw ArgumentError('股票代码不能为空');
    }

    final end = startDate ?? DateTime(2023, 3, 31);
    final start = end.subtract(Duration(days: BattleConfig.defaultHistoryDays));
    final finalEnd = end.add(Duration(days: BattleConfig.defaultTrainingDays));

    return _repository.fetchKlineDataFromDbWithDateRange(
      symbol: symbol,
      period: 'day',
      startTime: start,
      endTime: finalEnd,
    );
  }

}

class StockInfo {
  final String symbol;
  final String name;
  final String marketCode;

  const StockInfo({
    required this.symbol,
    required this.name,
    required this.marketCode,
  });
}

class CandidateStock {
  final String symbol;
  final String name;
  final String marketCode;

  const CandidateStock({
    required this.symbol,
    required this.name,
    required this.marketCode,
  });
}
