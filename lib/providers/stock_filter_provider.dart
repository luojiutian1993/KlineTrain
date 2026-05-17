import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/stock_filter_repository.dart';
import '../data/models/stock_filter_condition_model.dart';
import '../data/models/stock_filter_result_model.dart';
import '../core/enums/stock_filter_condition.dart';
import '../shared/utils/logger.dart';

class StockFilterState {
  final StockFilterCondition? selectedCondition;
  final StockTimeRange? timeRange;
  final List<String> selectedMarkets;
  final List<StockFilterConditionModel> availableConditions;
  final StockFilterResultResponse? filterResult;
  final bool isLoading;
  final String? error;
  final int? filterCount;
  final String? selectedStockCode;
  final String? selectedStockName;
  final StockFilterResultModel? selectedStock;

  const StockFilterState({
    this.selectedCondition,
    this.timeRange,
    this.selectedMarkets = const [],
    this.availableConditions = const [],
    this.filterResult,
    this.isLoading = false,
    this.error,
    this.filterCount,
    this.selectedStockCode,
    this.selectedStockName,
    this.selectedStock,
  });

  StockFilterState copyWith({
    StockFilterCondition? selectedCondition,
    StockTimeRange? timeRange,
    List<String>? selectedMarkets,
    List<StockFilterConditionModel>? availableConditions,
    StockFilterResultResponse? filterResult,
    bool? isLoading,
    String? error,
    int? filterCount,
    String? selectedStockCode,
    String? selectedStockName,
    StockFilterResultModel? selectedStock,
  }) {
    return StockFilterState(
      selectedCondition: selectedCondition ?? this.selectedCondition,
      timeRange: timeRange ?? this.timeRange,
      selectedMarkets: selectedMarkets ?? this.selectedMarkets,
      availableConditions: availableConditions ?? this.availableConditions,
      filterResult: filterResult ?? this.filterResult,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterCount: filterCount ?? this.filterCount,
      selectedStockCode: selectedStockCode ?? this.selectedStockCode,
      selectedStockName: selectedStockName ?? this.selectedStockName,
      selectedStock: selectedStock ?? this.selectedStock,
    );
  }

  String? get selectedConditionLabel => selectedCondition?.label;

  bool get hasResults => filterResult != null && filterResult!.items.isNotEmpty;

  bool get hasSelectedStock => selectedStockCode != null;

  bool get canStartTraining => hasResults && hasSelectedStock && !isLoading;
}

class StockFilterNotifier extends StateNotifier<StockFilterState> {
  final StockFilterRepository _repository;

  StockFilterNotifier({StockFilterRepository? repository})
      : _repository = repository ?? StockFilterRepository(),
        super(const StockFilterState()) {
    _initialize();
  }

  void _initialize() {
    final conditions = _repository.getAllConditions();
    state = state.copyWith(availableConditions: conditions);
  }

  void selectCondition(StockFilterCondition condition) {
    state = state.copyWith(
      selectedCondition: condition,
      filterResult: null,
      error: null,
    );

    if (condition != StockFilterCondition.random) {
      executeFilter();
    }
  }

  void selectConditionByLabel(String label) {
    final condition = StockFilterCondition.fromString(label);
    selectCondition(condition);
  }

  void setTimeRange(StockTimeRange timeRange) {
    state = state.copyWith(timeRange: timeRange);
    if (state.selectedCondition != null &&
        state.selectedCondition != StockFilterCondition.random) {
      executeFilter();
    }
  }

  void toggleMarket(String marketCode) {
    final current = List<String>.from(state.selectedMarkets);
    if (current.contains(marketCode)) {
      current.remove(marketCode);
    } else {
      current.add(marketCode);
    }
    state = state.copyWith(selectedMarkets: current);
    if (state.selectedCondition != null &&
        state.selectedCondition != StockFilterCondition.random) {
      executeFilter();
    }
  }

  void selectAllMarkets() {
    state = state.copyWith(selectedMarkets: ['XSHG', 'XSHE']);
    if (state.selectedCondition != null &&
        state.selectedCondition != StockFilterCondition.random) {
      executeFilter();
    }
  }

  void clearMarkets() {
    state = state.copyWith(selectedMarkets: []);
  }

  Future<void> executeFilter({
    DateTime? date,
    String? marketCode,
    StockTimeRange? timeRange,
  }) async {
    final condition = state.selectedCondition;
    if (condition == null) {
      state = state.copyWith(error: '请先选择选股条件');
      return;
    }

    final effectiveTimeRange = timeRange ?? state.timeRange;
    final startDate = effectiveTimeRange?.startDate;
    final endDate = effectiveTimeRange?.endDate;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.filterStocks(
        condition: condition,
        date: date,
        marketCode: marketCode,
        startDate: startDate,
        endDate: endDate,
      );

      state = state.copyWith(
        isLoading: false,
        filterResult: result,
        filterCount: result.total,
      );

      appLogger.i('选股完成: ${result.total} 支股票');
    } catch (e, stackTrace) {
      appLogger.e('选股失败', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: '选股失败: ${e.toString()}',
      );
    }
  }

  Future<void> updateFilterCount({DateTime? date, String? marketCode}) async {
    final condition = state.selectedCondition;
    if (condition == null || condition == StockFilterCondition.random) {
      state = state.copyWith(filterCount: null);
      return;
    }

    try {
      final count = await _repository.getFilterCount(
        condition: condition,
        date: date,
        marketCode: marketCode,
      );
      state = state.copyWith(filterCount: count);
    } catch (e) {
      appLogger.w('获取选股数量失败', error: e);
      state = state.copyWith(filterCount: null);
    }
  }

  Future<StockFilterResultModel?> getRandomStock({String? marketCode}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final stock = await _repository.getRandomStock(marketCode: marketCode);
      state = state.copyWith(isLoading: false);
      return stock;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '随机选股失败: ${e.toString()}',
      );
      return null;
    }
  }

  void selectStock(StockFilterResultModel stock) {
    state = state.copyWith(
      selectedStock: stock,
      selectedStockCode: stock.symbol,
      selectedStockName: stock.symbolName,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const StockFilterState();
    _initialize();
  }
}

final stockFilterProvider =
    StateNotifierProvider<StockFilterNotifier, StockFilterState>((ref) {
  return StockFilterNotifier();
});

final selectedConditionProvider = Provider<StockFilterCondition?>((ref) {
  return ref.watch(stockFilterProvider).selectedCondition;
});

final filterResultProvider = Provider<StockFilterResultResponse?>((ref) {
  return ref.watch(stockFilterProvider).filterResult;
});

final filterCountProvider = Provider<int?>((ref) {
  return ref.watch(stockFilterProvider).filterCount;
});

final isFilteringProvider = Provider<bool>((ref) {
  return ref.watch(stockFilterProvider).isLoading;
});
