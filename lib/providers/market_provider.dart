import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/market_sector_model.dart';
import '../shared/constants/market_sectors.dart';

class MarketState {
  final List<MarketSectorModel> sectors;
  final String? selectedSectorId;
  final bool isLoading;
  final String? error;

  const MarketState({
    this.sectors = const [],
    this.selectedSectorId,
    this.isLoading = false,
    this.error,
  });

  MarketState copyWith({
    List<MarketSectorModel>? sectors,
    String? selectedSectorId,
    bool? isLoading,
    String? error,
  }) {
    return MarketState(
      sectors: sectors ?? this.sectors,
      selectedSectorId: selectedSectorId ?? this.selectedSectorId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  MarketSectorModel? get selectedSector {
    if (selectedSectorId == null) return null;
    try {
      return sectors.firstWhere((s) => s.id == selectedSectorId);
    } catch (_) {
      return sectors.isNotEmpty ? sectors.first : null;
    }
  }
}

class MarketNotifier extends StateNotifier<MarketState> {
  MarketNotifier() : super(const MarketState()) {
    _init();
  }

  void _init() {
    _loadSectors();
  }

  void _loadSectors() {
    state = state.copyWith(isLoading: true);

    try {
      final localSectors = MarketSectors.allSectors.map((s) {
        final isSelected = s.id == state.selectedSectorId;
        return MarketSectorModel.fromSector(s, selected: isSelected);
      }).toList();

      state = MarketState(
        sectors: localSectors,
        selectedSectorId: state.selectedSectorId ?? localSectors.first.id,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载板块失败: ${e.toString()}',
      );
    }
  }

  void selectSector(String sectorId) {
    final updatedSectors = state.sectors.map((s) {
      return MarketSectorModel(
        id: s.id,
        name: s.name,
        marketType: s.marketType,
        icon: s.icon,
        code: s.code,
        stockCount: s.stockCount,
        description: s.description,
        isSelected: s.id == sectorId,
      );
    }).toList();

    state = state.copyWith(
      sectors: updatedSectors,
      selectedSectorId: sectorId,
    );
  }

  void selectMarketType(MarketType marketType) {
    final sector = MarketSectors.allSectors
        .where((s) => s.marketType == marketType)
        .firstOrNull;
    if (sector != null) {
      selectSector(sector.id);
    }
  }

  void refresh() {
    _loadSectors();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final marketProvider =
    StateNotifierProvider<MarketNotifier, MarketState>((ref) {
  return MarketNotifier();
});

final selectedMarketTypeProvider = Provider<MarketType?>((ref) {
  final marketState = ref.watch(marketProvider);
  final sector = marketState.selectedSector;
  if (sector == null) return null;
  return MarketSectors.findById(sector.id)?.marketType ?? sector.marketTypeEnum;
});

final selectedSectorProvider = Provider<MarketSectorModel?>((ref) {
  final marketState = ref.watch(marketProvider);
  return marketState.selectedSector;
});
