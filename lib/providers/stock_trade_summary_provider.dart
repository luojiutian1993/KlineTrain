import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/models/stock_trade_summary_model.dart';

final stockTradeSummaryProvider = AsyncNotifierProvider<
    StockTradeSummaryNotifier, List<StockTradeSummaryModel>>(
  StockTradeSummaryNotifier.new,
);

class StockTradeSummaryNotifier
    extends AsyncNotifier<List<StockTradeSummaryModel>> {
  static const int defaultUserId = 1;
  static const int defaultLimit = 10;

  @override
  Future<List<StockTradeSummaryModel>> build() async {
    return _loadStockTradeSummary();
  }

  Future<List<StockTradeSummaryModel>> _loadStockTradeSummary() async {
    try {
      final dbService = DatabaseService.instance;
      final tradesData = await dbService.trainingDao.getRecentTradesWithSymbol(
        defaultUserId,
        limit: 100,
      );

      if (tradesData.isEmpty) {
        return [];
      }

      final Map<String, List<Map<String, dynamic>>> groupedTrades = {};
      for (final trade in tradesData) {
        final symbol = trade['symbol'] as String;
        final marketCode = trade['marketCode'] as String;
        final key = '${marketCode}_$symbol';
        groupedTrades.putIfAbsent(key, () => []).add(trade);
      }

      final List<StockTradeSummaryModel> summaries = [];

      for (final entry in groupedTrades.entries) {
        final trades = entry.value;
        if (trades.isEmpty) continue;

        final firstTrade = trades.first;
        final symbol = firstTrade['symbol'] as String;
        final symbolName = firstTrade['symbolName'] as String;
        final marketCode = firstTrade['marketCode'] as String;

        double totalProfit = 0;
        double totalProfitRate = 0;
        int winCount = 0;
        DateTime? lastTradeDate;

        for (final trade in trades) {
          totalProfit += (trade['profit'] as double?) ?? 0;
          totalProfitRate += (trade['profitRate'] as double?) ?? 0;
          if ((trade['profit'] as double? ?? 0) > 0) {
            winCount++;
          }
          final createdAt = trade['createdAt'] as DateTime?;
          if (createdAt != null &&
              (lastTradeDate == null || createdAt.isAfter(lastTradeDate))) {
            lastTradeDate = createdAt;
          }
        }

        final winRate =
            trades.length > 0 ? (winCount / trades.length) * 100 : 0.0;
        final avgProfitRate =
            trades.length > 0 ? totalProfitRate / trades.length : 0.0;

        summaries.add(StockTradeSummaryModel(
          symbol: symbol,
          symbolName: symbolName,
          marketCode: marketCode,
          sessionCount: _countUniqueSessions(trades),
          totalTradeCount: trades.length,
          totalProfit: totalProfit,
          profitRate: avgProfitRate,
          winCount: winCount,
          winRate: winRate,
          lastTradeDate: lastTradeDate,
        ));
      }

      summaries.sort((a, b) {
        final aDate = a.lastTradeDate;
        final bDate = b.lastTradeDate;
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate);
      });

      return summaries.take(defaultLimit).toList();
    } catch (e) {
      return [];
    }
  }

  int _countUniqueSessions(List<Map<String, dynamic>> trades) {
    final Set<int> sessionIds = {};
    for (final trade in trades) {
      sessionIds.add(trade['sessionId'] as int);
    }
    return sessionIds.length;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadStockTradeSummary());
  }
}
