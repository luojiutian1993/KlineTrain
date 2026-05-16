import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/models/recent_trade_model.dart';

final recentTradesProvider =
    AsyncNotifierProvider<RecentTradesNotifier, List<RecentTradeModel>>(
  RecentTradesNotifier.new,
);

class RecentTradesNotifier extends AsyncNotifier<List<RecentTradeModel>> {
  static const int defaultUserId = 1;
  static const int defaultLimit = 10;

  @override
  Future<List<RecentTradeModel>> build() async {
    return _loadRecentTrades();
  }

  Future<List<RecentTradeModel>> _loadRecentTrades() async {
    try {
      final dbService = DatabaseService.instance;
      final tradesData = await dbService.trainingDao.getRecentTradesWithSymbol(
        defaultUserId,
        limit: defaultLimit,
      );

      return tradesData.map((data) {
        return RecentTradeModel(
          id: data['id'] as int,
          sessionId: data['sessionId'] as int,
          symbol: data['symbol'] as String,
          symbolName: data['symbolName'] as String,
          marketCode: data['marketCode'] as String,
          type: data['type'] as String,
          price: data['price'] as double,
          quantity: data['quantity'] as int,
          amount: data['amount'] as double,
          profit: data['profit'] as double,
          profitRate: data['profitRate'] as double,
          tradeDate: data['tradeDate'] as String,
          createdAt: data['createdAt'] as DateTime,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadRecentTrades());
  }
}