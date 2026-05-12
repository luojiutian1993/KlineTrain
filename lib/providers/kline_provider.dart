import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/repositories/kline_repository.dart';

part 'kline_provider.g.dart';

@riverpod
class KlineData extends _$KlineData {
  @override
  Future<List<KlineModel>> build() async {
    return ref.watch(klineRepositoryProvider).fetchKlineData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.watch(klineRepositoryProvider).fetchKlineData(),
    );
  }

  Future<void> loadMore(String symbol, int limit) async {
    final currentData = state.valueOrNull ?? [];
    final newData = await ref.watch(klineRepositoryProvider).fetchKlineData(
          symbol: symbol,
          limit: limit,
        );
    state = AsyncData([...currentData, ...newData]);
  }
}

@riverpod
String selectedSymbol(SelectedSymbolRef ref) {
  return 'SH600000';
}

@riverpod
String timeFrame(TimeFrameRef ref) {
  return 'day';
}
