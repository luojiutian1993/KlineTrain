import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/stock_filter_repository.dart';
import '../data/models/stock_filter_result_model.dart';
import '../core/enums/stock_filter_condition.dart';

final battleStockProvider =
    StateNotifierProvider<BattleStockNotifier, BattleStockState>((ref) {
  return BattleStockNotifier();
});

class BattleStockState {
  final List<StockFilterResultModel> stocks;
  final StockFilterResultModel? selectedStock;
  final bool isLoading;
  final String? error;
  final StockFilterCondition? condition;
  final DateTime? startDate;
  final DateTime? endDate;

  const BattleStockState({
    this.stocks = const [],
    this.selectedStock,
    this.isLoading = false,
    this.error,
    this.condition,
    this.startDate,
    this.endDate,
  });

  BattleStockState copyWith({
    List<StockFilterResultModel>? stocks,
    StockFilterResultModel? selectedStock,
    bool? isLoading,
    String? error,
    StockFilterCondition? condition,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return BattleStockState(
      stocks: stocks ?? this.stocks,
      selectedStock: selectedStock ?? this.selectedStock,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      condition: condition ?? this.condition,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class BattleStockNotifier extends StateNotifier<BattleStockState> {
  final StockFilterRepository _repository;

  BattleStockNotifier({StockFilterRepository? repository})
      : _repository = repository ?? StockFilterRepository(),
        super(const BattleStockState());

  Future<void> loadStocks({
    required StockFilterCondition condition,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      condition: condition,
      startDate: startDate,
      endDate: endDate,
    );

    try {
      final result = await _repository.filterStocks(
        condition: condition,
        startDate: startDate,
        endDate: endDate,
      );

      state = state.copyWith(
        isLoading: false,
        stocks: result.items,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载股票失败: ${e.toString()}',
      );
    }
  }

  void selectStock(StockFilterResultModel stock) {
    state = state.copyWith(selectedStock: stock);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
