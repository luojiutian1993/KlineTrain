import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/database_service.dart';
import '../data/database/daos/market_dao.dart';
import '../data/database/daos/kline_dao.dart';
import '../data/models/kline_model.dart';
import '../data/models/market_sector_model.dart';
import '../shared/constants/market_sectors.dart';

class SelectionState {
  final String? selectedCondition;
  final MarketSectorModel? selectedSector;
  final List<KlineModel> klineData;
  final bool isLoading;
  final String? error;
  final String? selectedStockCode;
  final String? selectedStockName;

  const SelectionState({
    this.selectedCondition,
    this.selectedSector,
    this.klineData = const [],
    this.isLoading = false,
    this.error,
    this.selectedStockCode,
    this.selectedStockName,
  });

  SelectionState copyWith({
    String? selectedCondition,
    MarketSectorModel? selectedSector,
    List<KlineModel>? klineData,
    bool? isLoading,
    String? error,
    String? selectedStockCode,
    String? selectedStockName,
  }) {
    return SelectionState(
      selectedCondition: selectedCondition ?? this.selectedCondition,
      selectedSector: selectedSector ?? this.selectedSector,
      klineData: klineData ?? this.klineData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedStockCode: selectedStockCode ?? this.selectedStockCode,
      selectedStockName: selectedStockName ?? this.selectedStockName,
    );
  }

  bool get hasKlineData => klineData.isNotEmpty;
  bool get canStartTraining => hasKlineData && selectedStockCode != null;
}

class SelectionNotifier extends StateNotifier<SelectionState> {
  final MarketDao _marketDao;
  final KlineDao _klineDao;

  SelectionNotifier(this._marketDao, this._klineDao) : super(const SelectionState());

  void setCondition(String condition) {
    state = state.copyWith(selectedCondition: condition);
  }

  void setSector(MarketSectorModel sector) {
    state = state.copyWith(selectedSector: sector);
  }

  Future<void> executeSelection() async {
    final sector = state.selectedSector;

    if (sector == null || state.selectedCondition == null) {
      state = state.copyWith(error: '请先选择板块和条件');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final marketSector = MarketSectors.findById(sector.id);

      if (marketSector == null) {
        state = state.copyWith(isLoading: false, error: '未知的板块');
        return;
      }

      final symbols = await _marketDao.getSymbolsByMarketType(marketSector.marketType);

      if (symbols.isEmpty) {
        state = state.copyWith(isLoading: false, error: '该板块暂无股票数据');
        return;
      }

      final symbol = symbols.first;
      final klineDataList = await _klineDao.getKlineData(
        symbol.symbol,
        'day',
        limit: 100,
      );

      final klineModels = klineDataList.map((k) => KlineModel(
        symbol: k.symbol,
        timestamp: k.tradeDate.millisecondsSinceEpoch,
        open: k.open.toDouble(),
        high: k.high.toDouble(),
        low: k.low.toDouble(),
        close: k.close.toDouble(),
        volume: k.volume.toDouble(),
        turnover: k.amount.toDouble(),
      )).toList();

      state = state.copyWith(
        isLoading: false,
        klineData: klineModels,
        selectedStockCode: symbol.symbol,
        selectedStockName: symbol.name,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '选股失败: ${e.toString()}',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const SelectionState();
  }
}

final selectionProvider = StateNotifierProvider<SelectionNotifier, SelectionState>((ref) {
  final marketDao = DatabaseService.instance.marketDao;
  final klineDao = DatabaseService.instance.klineDao;
  return SelectionNotifier(marketDao, klineDao);
});