import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/database_service.dart';
import '../data/database/daos/kline_dao.dart';
import '../data/repositories/stock_filter_repository.dart';
import '../data/models/kline_model.dart';
import '../data/models/market_sector_model.dart';
import '../data/models/stock_filter_result_model.dart';
import '../core/enums/stock_filter_condition.dart';

class SelectionState {
  final String? selectedCondition;
  final MarketSectorModel? selectedSector;
  final StockTimeRange? timeRange;
  final List<KlineModel> klineData;
  final bool isLoading;
  final String? error;
  final String? selectedStockCode;
  final String? selectedStockName;
  final StockFilterResultModel? selectedStock;
  final List<StockFilterResultModel> filteredStocks;

  const SelectionState({
    this.selectedCondition,
    this.selectedSector,
    this.timeRange,
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
    MarketSectorModel? selectedSector,
    StockTimeRange? timeRange,
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
      selectedSector: selectedSector ?? this.selectedSector,
      timeRange: timeRange ?? this.timeRange,
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
  bool get canStartTraining => hasKlineData && selectedStockCode != null;
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

  void setSector(MarketSectorModel sector) {
    state = state.copyWith(selectedSector: sector);
  }

  void setTimeRange(StockTimeRange timeRange) {
    state = state.copyWith(timeRange: timeRange);
  }

  Future<void> _executeStockFilter() async {
    final conditionLabel = state.selectedCondition;
    if (conditionLabel == null) return;

    final condition = StockFilterCondition.fromString(conditionLabel);

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _stockFilterRepository.filterStocks(
        condition: condition,
        marketCode: state.selectedSector?.code,
        startDate: state.timeRange?.startDate,
        endDate: state.timeRange?.endDate,
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
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载K线数据失败: ${e.toString()}',
      );
    }
  }

  Future<void> executeSelection() async {
    final sector = state.selectedSector;

    if (sector == null || state.selectedCondition == null) {
      state = state.copyWith(error: '请先选择板块和条件');
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
