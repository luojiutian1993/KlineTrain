import 'dart:async';
import 'dart:math';
import 'package:logger/logger.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/repositories/kline_repository.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';
import 'training_state.dart';

typedef StateChangeListener = void Function(TrainingState state);

class TrainingManager {
  final Logger _logger = Logger();
  final KlineRepository _repository = KlineRepository();

  TrainingState _state = const TrainingState();
  StateChangeListener? _listener;

  TrainingState get state => _state;

  void addListener(StateChangeListener listener) {
    _listener = listener;
  }

  void removeListener() {
    _listener = null;
  }

  void _notifyListener() {
    _listener?.call(_state);
  }

  void _updateState(TrainingState Function(TrainingState) updater) {
    _state = updater(_state);
    _notifyListener();
  }

  Future<void> initializeRandomStock() async {
    _logger.d('初始化随机选股');

    try {
      _updateState((s) => s.copyWith(isLoading: true, errorMessage: null));

      final dbService = DatabaseService.instance;
      final symbols = await dbService.klineDao.getSymbols();

      final stockMaps = <Map<String, String>>[];
      for (final symbol in symbols) {
        final klineData = await dbService.klineDao.getKlineData(
          symbol.symbol,
          'day',
          limit: 210,
        );
        if (klineData.length >= 210) {
          stockMaps.add({
            'symbol': symbol.symbol,
            'marketCode': symbol.marketCode,
          });
        }
      }

      _logger.d('找到 ${stockMaps.length} 只符合条件的股票');

      if (stockMaps.isNotEmpty) {
        final randomIndex = Random().nextInt(stockMaps.length);
        final selectedStock = stockMaps[randomIndex];

        _updateState((s) => s.copyWith(
              currentSymbol: selectedStock['symbol'] ?? '',
              currentMarketCode: selectedStock['marketCode'] ?? '',
              currentSymbolName: selectedStock['symbol'] ?? '',
              trainingStartDate: DateTime(2025, 1, 1),
              hasAvailableData: true,
              errorMessage: null,
            ));

        await loadKlineData();
      } else {
        _updateState((s) => s.copyWith(
              hasAvailableData: false,
              errorMessage: '暂无可训练股票',
              isLoading: false,
            ));
      }
    } catch (e) {
      _logger.e('随机选股失败: $e');
      _updateState((s) => s.copyWith(
            hasAvailableData: false,
            errorMessage: '数据加载失败',
            isLoading: false,
          ));
    }
  }

  Future<void> loadKlineData() async {
    _logger.d('加载K线数据: ${_state.currentSymbol}');

    if (_state.currentSymbol.isEmpty) {
      _logger.w('股票代码为空，跳过加载');
      return;
    }

    try {
      _updateState((s) => s.copyWith(isLoading: true));

      final startDate = _state.trainingStartDate ?? DateTime(2023, 3, 31);
      final startTime = startDate.subtract(Duration(days: _state.historyDays));
      final endTime = startDate.add(Duration(days: _state.trainingDays));

      List<KlineModel> data =
          await _repository.fetchKlineDataFromDbWithDateRange(
        symbol: _state.currentSymbol,
        period: 'day',
        startTime: startTime,
        endTime: endTime,
      );

      if (data.isEmpty) {
        data = _generateMockData(
            _state.currentSymbol, _state.trainingDays + _state.historyDays);
        _logger.w('数据库无数据，使用模拟数据');
      }

      _updateState((s) => s.copyWith(
            allKlineData: data,
            currentDayIndex: s.historyDays,
            visibleStartIndex: max(0, s.historyDays - s.visibleKlineCount + 1),
            phase: TrainingPhase.opening,
            isLoading: false,
            hasAvailableData: true,
          ));
    } catch (e) {
      _logger.e('加载K线数据失败: $e');
      _updateState((s) => s.copyWith(
            errorMessage: '加载K线数据失败: $e',
            isLoading: false,
          ));
    }
  }

  void goToNextDay() {
    if (_state.currentDayIndex >= _state.allKlineData.length - 1) {
      _logger.w('已经是最后一天');
      return;
    }

    _updateState((s) {
      final newIndex = s.currentDayIndex + 1;
      return s.copyWith(
        currentDayIndex: newIndex,
        phase: TrainingPhase.opening,
        visibleStartIndex: max(0, newIndex - s.visibleKlineCount + 1),
      );
    });
  }

  void goToPreviousDay() {
    if (_state.currentDayIndex <= _state.historyDays) {
      _logger.w('已经是训练第一天');
      return;
    }

    _updateState((s) {
      final newIndex = s.currentDayIndex - 1;
      return s.copyWith(
        currentDayIndex: newIndex,
        phase: TrainingPhase.opening,
        visibleStartIndex: max(0, newIndex - s.visibleKlineCount + 1),
      );
    });
  }

  void setPhase(TrainingPhase phase) {
    _updateState((s) => s.copyWith(phase: phase));
  }

  void updateIndicatorSelection({String? top, String? bottom}) {
    _updateState((s) => s.copyWith(
          selectedTopIndicator: top ?? s.selectedTopIndicator,
          selectedBottomIndicator: bottom ?? s.selectedBottomIndicator,
        ));
  }

  void updatePeriod(String period) {
    _updateState((s) => s.copyWith(selectedPeriod: period));
  }

  void reset() {
    _updateState((_) => const TrainingState());
  }

  List<KlineModel> _generateMockData(String symbol, int count) {
    final data = <KlineModel>[];
    final now = DateTime.now();
    final random = Random(12345);
    double basePrice = 10.0;

    for (int i = count - 1; i >= 0; i--) {
      final timestamp = now.subtract(Duration(days: i)).millisecondsSinceEpoch;
      final open = basePrice + (i % 10 - 5) * 0.1;
      final close = open + (i % 7 - 3) * 0.15;
      final high = close > open ? close + 0.2 : open + 0.2;
      final low = close < open ? close - 0.2 : open - 0.2;

      final baseVolume = 10000000.0;
      final periodicVariation = sin(i / 10) * 3000000.0;
      final randomVariation = (random.nextDouble() - 0.5) * 4000000.0;
      final volume = (baseVolume + periodicVariation + randomVariation).clamp(
        3000000.0,
        30000000.0,
      );

      data.add(
        KlineModel(
          symbol: symbol,
          timestamp: timestamp,
          open: double.parse(open.toStringAsFixed(2)),
          high: double.parse(high.toStringAsFixed(2)),
          low: double.parse(low.toStringAsFixed(2)),
          close: double.parse(close.toStringAsFixed(2)),
          volume: volume,
          turnover: volume * close,
        ),
      );

      basePrice = close;
    }

    return data;
  }
}
