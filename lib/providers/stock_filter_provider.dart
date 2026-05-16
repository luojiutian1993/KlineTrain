import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/stock_filter_repository.dart';
import '../data/models/stock_filter_condition_model.dart';
import '../data/models/stock_filter_result_model.dart';
import '../core/enums/stock_filter_condition.dart';
import '../shared/utils/logger.dart';

class StockFilterState {
  final StockFilterCondition? selectedCondition;
  final List<StockFilterConditionModel> availableConditions;
  final StockFilterResultResponse? filterResult;
  final bool isLoading;
  final String? error;
  final int? filterCount;

  const StockFilterState({
    this.selectedCondition,
    this.availableConditions = const [],
    this.filterResult,
    this.isLoading = false,
    this.error,
    this.filterCount,
  });

  StockFilterState copyWith({
    StockFilterCondition? selectedCondition,
    List<StockFilterConditionModel>? availableConditions,
    StockFilterResultResponse? filterResult,
    bool? isLoading,
    String? error,
    int? filterCount,
  }) {
    return StockFilterState(
      selectedCondition: selectedCondition ?? this.selectedCondition,
      availableConditions: availableConditions ?? this.availableConditions,
      filterResult: filterResult ?? this.filterResult,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterCount: filterCount ?? this.filterCount,
    );
  }

  String? get selectedConditionLabel => selectedCondition?.label;

  bool get hasResults => filterResult != null && filterResult!.items.isNotEmpty;

  bool get canStartTraining => hasResults && !isLoading;
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

  Future<void> executeFilter({DateTime? date, String? marketCode}) async {
    final condition = state.selectedCondition;
    if (condition == null) {
      state = state.copyWith(error: '请先选择选股条件');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.filterStocks(
        condition: condition,
        date: date,
        marketCode: marketCode,
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
