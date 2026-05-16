import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/models/asset_summary_model.dart';

final assetSummaryProvider =
    AsyncNotifierProvider<AssetSummaryNotifier, AssetSummaryModel>(
  AssetSummaryNotifier.new,
);

class AssetSummaryNotifier extends AsyncNotifier<AssetSummaryModel> {
  static const int defaultUserId = 1;

  @override
  Future<AssetSummaryModel> build() async {
    return _loadAssetSummary();
  }

  Future<AssetSummaryModel> _loadAssetSummary() async {
    try {
      final dbService = DatabaseService.instance;
      final data = await dbService.trainingDao.getUserAssetSummary(defaultUserId);

      return AssetSummaryModel(
        initialCapital: (data['initialCapital'] as double?) ?? 100000.0,
        currentCapital: (data['currentCapital'] as double?) ?? 100000.0,
        totalProfit: (data['totalProfit'] as double?) ?? 0.0,
        profitRate: (data['profitRate'] as double?) ?? 0.0,
        totalTradeCount: (data['totalTradeCount'] as int?) ?? 0,
        totalTradeDays: (data['totalTradeDays'] as int?) ?? 0,
        winCount: (data['winCount'] as int?) ?? 0,
        winRate: (data['winRate'] as double?) ?? 0.0,
        maxProfit: (data['maxProfit'] as double?) ?? 0.0,
        maxLoss: (data['maxLoss'] as double?) ?? 0.0,
        maxDrawdown: (data['maxDrawdown'] as double?) ?? 0.0,
        annualizedReturn: (data['annualizedReturn'] as double?) ?? 0.0,
        sharpeRatio: 0.0,
        profitLossRatio: 0.0,
      );
    } catch (e) {
      return AssetSummaryModel.defaultValue;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadAssetSummary());
  }
}