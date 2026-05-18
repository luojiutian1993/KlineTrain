import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/database_service.dart';
import '../data/database/daos/kline_dao.dart';
import '../data/repositories/stock_filter_repository.dart';
import '../data/models/kline_model.dart';
import '../data/models/stock_filter_result_model.dart';
import '../core/enums/stock_filter_condition.dart';

class SelectionState {
  final String? selectedCondition;
  final String selectedMarket;
  final List<String> selectedSubMarkets;
  final DateTime? trainingStartDate;
  final int trainingDays;
  final List<KlineModel> klineData;
  final bool isLoading;
  final String? error;
  final String? selectedStockCode;
  final String? selectedStockName;
  final StockFilterResultModel? selectedStock;
  final List<StockFilterResultModel> filteredStocks;

  const SelectionState({
    this.selectedCondition,
    this.selectedMarket = 'CN',
    this.selectedSubMarkets = const [],
    this.trainingStartDate,
    this.trainingDays = 150,
    this.klineData = const [],
    this.isLoading = false,
    this.error,
    this.selectedStockCode,
    this.selectedStockName,
    this.selectedStock,
    this.filteredStocks = const [],
  });

  SelectionState copyWith({
    String? selectedCondition,
    String? selectedMarket,
    List<String>? selectedSubMarkets,
    DateTime? trainingStartDate,
    int? trainingDays,
    List<KlineModel>? klineData,
    bool? isLoading,
    String? error,
    String? selectedStockCode,
    String? selectedStockName,
    StockFilterResultModel? selectedStock,
    List<StockFilterResultModel>? filteredStocks,
  }) {
    return SelectionState(
      selectedCondition: selectedCondition ?? this.selectedCondition,
      selectedMarket: selectedMarket ?? this.selectedMarket,
      selectedSubMarkets: selectedSubMarkets ?? this.selectedSubMarkets,
      trainingStartDate: trainingStartDate ?? this.trainingStartDate,
      trainingDays: trainingDays ?? this.trainingDays,
      klineData: klineData ?? this.klineData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedStockCode: selectedStockCode ?? this.selectedStockCode,
      selectedStockName: selectedStockName ?? this.selectedStockName,
      selectedStock: selectedStock ?? this.selectedStock,
      filteredStocks: filteredStocks ?? this.filteredStocks,
    );
  }

  bool get hasKlineData => klineData.isNotEmpty;
  bool get canStartTraining => hasKlineData && selectedStockCode != null && trainingStartDate != null;
  bool get hasFilteredStocks => filteredStocks.isNotEmpty;
}

class SelectionNotifier extends StateNotifier<SelectionState> {
  final KlineDao _klineDao;
  final StockFilterRepository _stockFilterRepository;

  SelectionNotifier(
    this._klineDao, {
    StockFilterRepository? stockFilterRepository,
  })  : _stockFilterRepository =
            stockFilterRepository ?? StockFilterRepository(),
        super(const SelectionState());

  void setCondition(String condition) {
    state = state.copyWith(
      selectedCondition: condition,
      selectedStock: null,
      selectedStockCode: null,
      selectedStockName: null,
    );

    _executeStockFilter();
  }

  void setMarket(String market) {
    state = state.copyWith(selectedMarket: market);
  }

  void setSubMarkets(List<String> subMarkets) {
    state = state.copyWith(selectedSubMarkets: subMarkets);
    _executeStockFilter();
  }

  void setTrainingStartDate(DateTime date) {
    state = state.copyWith(
      trainingStartDate: date,
      selectedStock: null,
      selectedStockCode: null,
      selectedStockName: null,
    );

    _executeStockFilter();
  }

  Future<void> _executeStockFilter() async {
    final conditionLabel = state.selectedCondition;
    if (conditionLabel == null) return;

    final condition = StockFilterCondition.fromString(conditionLabel);
    final trainingStartDate = state.trainingStartDate;

    if (trainingStartDate == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _stockFilterRepository.filterStocks(
        condition: condition,
        trainingStartDate: trainingStartDate,
        trainingDays: state.trainingDays,
        subMarketCodes: state.selectedSubMarkets.isNotEmpty ? state.selectedSubMarkets : null,
      );

      state = state.copyWith(
        isLoading: false,
        filteredStocks: result.items,
      );

      if (result.items.isNotEmpty) {
        await selectStock(result.items.first);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '选股失败: ${e.toString()}',
      );
    }
  }

  Future<void> selectStock(StockFilterResultModel stock) async {
    state = state.copyWith(
      selectedStock: stock,
      selectedStockCode: stock.symbol,
      selectedStockName: stock.symbolName,
      isLoading: true,
    );

    try {
      final trainingStartDate = state.trainingStartDate;
      if (trainingStartDate != null) {
        final endDate = trainingStartDate.add(Duration(days: state.trainingDays));
        final klineDataList = await _klineDao.getKlineDataRange(
          stock.symbol,
          'day',
          trainingStartDate.subtract(const Duration(days: 30)),
          endDate,
        );

        final klineModels = klineDataList
            .map((k) => KlineModel(
                  symbol: k.symbol,
                  timestamp: k.tradeDate.millisecondsSinceEpoch,
                  open: k.open.toDouble(),
                  high: k.high.toDouble(),
                  low: k.low.toDouble(),
                  close: k.close.toDouble(),
                  volume: k.volume.toDouble(),
                  turnover: k.amount.toDouble(),
                ))
            .toList();

        state = state.copyWith(
          isLoading: false,
          klineData: klineModels,
        );
      } else {
        final klineDataList = await _klineDao.getKlineData(
          stock.symbol,
          'day',
          limit: 100,
        );

        final klineModels = klineDataList
            .map((k) => KlineModel(
                  symbol: k.symbol,
                  timestamp: k.tradeDate.millisecondsSinceEpoch,
                  open: k.open.toDouble(),
                  high: k.high.toDouble(),
                  low: k.low.toDouble(),
                  close: k.close.toDouble(),
                  volume: k.volume.toDouble(),
                  turnover: k.amount.toDouble(),
                ))
            .toList();

        state = state.copyWith(
          isLoading: false,
          klineData: klineModels,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载K线数据失败: ${e.toString()}',
      );
    }
  }

  Future<void> executeSelection() async {
    if (state.selectedCondition == null || state.trainingStartDate == null) {
      state = state.copyWith(error: '请先选择选股条件和等待时间生成');
      return;
    }

    await _executeStockFilter();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const SelectionState();
  }
}

final selectionProvider =
    StateNotifierProvider<SelectionNotifier, SelectionState>((ref) {
  final klineDao = DatabaseService.instance.klineDao;
  return SelectionNotifier(klineDao);
});
