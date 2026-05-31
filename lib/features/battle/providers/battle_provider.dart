import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/models/trade_point_model.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/repositories/kline_repository.dart';
import 'package:kline_trainer/features/battle/models/battle_state.dart';
import 'package:kline_trainer/features/battle/models/battle_config.dart';
import 'package:kline_trainer/features/battle/trading_calculator.dart';
import 'package:kline_trainer/data/utils/indicator_calculator.dart';

part 'battle_provider.g.dart';

@riverpod
class Battle extends _$Battle {
  final KlineRepository _repository = KlineRepository();

  @override
  BattleState build() {
    return const BattleState();
  }

  Future<void> initializeWithSymbol({
    required String symbol,
    String? name,
    String? marketCode,
    DateTime? startDate,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      print(
          '🔵 [BattleProvider] initializeWithSymbol: symbol=$symbol, startDate=$startDate');
      final klineData = await _loadKlineData(symbol, startDate);
      print(
          '🔵 [BattleProvider] initializeWithSymbol: klineData.length=${klineData.length}');

      if (klineData.isEmpty) {
        print('🔴 [BattleProvider] initializeWithSymbol: K线数据为空');
        state = state.copyWith(
          isLoading: false,
          hasAvailableData: false,
          errorMessage: '数据库中暂无合格股票，请先同步数据',
        );
        return;
      }

      final startDayIndex = _findStartDayIndex(klineData, startDate);
      print(
          '🔵 [BattleProvider] initializeWithSymbol: startDayIndex=$startDayIndex');

      // 计算实际可用的训练天数
      final availableTrainingDays = klineData.length - startDayIndex;
      final trainingDays = availableTrainingDays > 0
          ? availableTrainingDays.clamp(1, BattleConfig.defaultTrainingDays)
          : 1;

      // 确保visibleStartIndex有效
      final visibleStartIndex =
          (startDayIndex - BattleConfig.defaultVisibleKlineCount + 1)
              .clamp(0, startDayIndex);

      print(
          '🔵 [BattleProvider] initializeWithSymbol: trainingDays=$trainingDays, visibleStartIndex=$visibleStartIndex');

      state = state.copyWith(
        currentSymbol: symbol,
        currentSymbolName: name ?? symbol,
        currentMarketCode: marketCode ?? '',
        trainingStartDate: startDate,
        allKlineData: klineData,
        currentDayIndex: startDayIndex >= 0
            ? startDayIndex.clamp(0, klineData.length - 1)
            : 0,
        initialStartIndex: startDayIndex >= 0
            ? startDayIndex.clamp(0, klineData.length - 1)
            : 0,
        visibleStartIndex: visibleStartIndex,
        trainingDays: trainingDays,
        phase: TrainingPhase.opening,
        isLoading: false,
        hasAvailableData: true,
        tradePoints: [],
      );
      print('🔵 [BattleProvider] initializeWithSymbol: 状态更新完成');
    } catch (e, stackTrace) {
      print('🔴 [BattleProvider] initializeWithSymbol 异常: $e');
      print('🔴 [BattleProvider] 堆栈: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        hasAvailableData: false,
        errorMessage: '数据加载失败，请检查网络后重试',
      );
    }
  }

  Future<void> initializeRandom() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      print('🔵 [BattleProvider] initializeRandom: 开始随机选股');
      final candidate = await _findQualifiedStock();
      print(
          '🔵 [BattleProvider] initializeRandom: 选股结果: ${candidate?.symbol ?? 'null'}');

      if (candidate == null) {
        state = state.copyWith(
          isLoading: false,
          hasAvailableData: false,
          errorMessage: '数据库中暂无合格股票，请先同步数据',
        );
        return;
      }

      print(
          '🔵 [BattleProvider] initializeRandom: 开始初始化股票 ${candidate.symbol}');
      await initializeWithSymbol(
        symbol: candidate.symbol,
        name: candidate.symbol,
        marketCode: candidate.marketCode,
      );
      print('🔵 [BattleProvider] initializeRandom: 初始化完成');
    } catch (e, stackTrace) {
      print('🔴 [BattleProvider] initializeRandom 异常: $e');
      print('🔴 [BattleProvider] 堆栈: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        hasAvailableData: false,
        errorMessage: '数据加载失败，请检查网络后重试',
      );
    }
  }

  Future<void> loadReplayMode(int sessionId) async {
    state = state.copyWith(isLoading: true, isReplayMode: true);

    try {
      final dbService = DatabaseService.instance;
      final session = await dbService.trainingDao.getSession(sessionId);
      final trades = await dbService.trainingDao.getSessionTrades(sessionId);

      if (session == null) {
        state = state.copyWith(
          isLoading: false,
          hasAvailableData: false,
          errorMessage: '未找到训练记录',
        );
        return;
      }

      await initializeWithSymbol(
        symbol: session.symbol,
        name: session.symbol,
        marketCode: session.marketCode,
        startDate: session.startDate,
      );

      final klineData = state.allKlineData;
      final tradePoints = <TradePoint>[];

      for (final trade in trades) {
        final tradeDate = DateTime.parse(trade.tradeDate ?? '');
        final tradeIndex = klineData.indexWhere((k) {
          final kDate = k.dateTime;
          return kDate.year == tradeDate.year &&
              kDate.month == tradeDate.month &&
              kDate.day == tradeDate.day;
        });

        if (tradeIndex >= 0) {
          tradePoints.add(TradePoint(
            index: tradeIndex,
            price: trade.price ?? 0,
            isBuy: trade.type == 'buy',
            label: trade.type == 'buy' ? 'B' : 'S',
            date: tradeDate,
            tradeId: trade.id,
            quantity: trade.quantity ?? 0,
          ));
        }
      }

      state = state.copyWith(
        isLoading: false,
        currentDayIndex: klineData.length - 1,
        initialStartIndex: klineData.length - 1,
        phase: TrainingPhase.closing,
        tradePoints: tradePoints,
        accountBalance: session.currentCapital,
        totalProfitLoss: session.totalProfit ?? 0,
        trainingDays: session.endDate.difference(session.startDate).inDays + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasAvailableData: false,
        errorMessage: '复盘数据加载失败',
      );
    }
  }

  Future<void> loadRetrainMode(int sessionId) async {
    state = state.copyWith(isReplayMode: false);

    final dbService = DatabaseService.instance;
    final session = await dbService.trainingDao.getSession(sessionId);

    if (session != null) {
      await initializeWithSymbol(
        symbol: session.symbol,
        name: session.symbol,
        marketCode: session.marketCode,
        startDate: session.startDate,
      );
    }
  }

  Future<_CandidateStock?> _findQualifiedStock() async {
    final dbService = DatabaseService.instance;
    final stockMaps =
        await dbService.klineDao.getSymbolsWithMinKlineData(minDays: 210);

    if (stockMaps.isEmpty) {
      return null;
    }

    final random = Random();
    final shuffled = List.of(stockMaps)..shuffle(random);

    for (int i = 0; i < shuffled.length && i < 3; i++) {
      final candidate = shuffled[i];
      final symbol = candidate['symbol'] ?? '';
      final marketCode = candidate['marketCode'] ?? '';

      final klineData = await dbService.klineDao.getKlineData(
        symbol,
        'day',
        limit: 220,
      );

      if (klineData.length >= 210) {
        return _CandidateStock(symbol: symbol, marketCode: marketCode);
      }
    }

    return null;
  }

  Future<List<KlineModel>> _loadKlineData(
    String symbol,
    DateTime? startDate,
  ) async {
    // 首先尝试获取该股票的所有K线数据
    List<KlineModel> data = await _repository.fetchKlineDataFromDb(
      symbol: symbol,
      period: 'day',
      limit: 10000, // 足够大的数量获取所有数据
    );

    if (data.isEmpty) {
      // 如果没有数据，尝试通过API获取（但根据需求文档，应该优先使用数据库数据）
      data = await _repository.fetchKlineData(
        symbol: symbol,
        timeframe: 'day',
        limit: BattleConfig.defaultHistoryDays +
            BattleConfig.defaultTrainingDays +
            50,
      );
    }

    return data;
  }

  int _findStartDayIndex(List<KlineModel> data, DateTime? targetDate) {
    if (data.isEmpty) return -1;

    if (targetDate == null) {
      // 如果没有指定日期，从数据的合适位置开始（确保有足够的历史数据和训练空间）
      final minRequiredDays =
          BattleConfig.defaultHistoryDays + BattleConfig.defaultTrainingDays;
      if (data.length >= minRequiredDays) {
        return BattleConfig.defaultHistoryDays;
      } else if (data.length > BattleConfig.defaultHistoryDays) {
        return BattleConfig.defaultHistoryDays;
      } else {
        return data.length ~/ 2; // 数据不够时从中间开始
      }
    }

    // 查找目标日期
    for (int i = 0; i < data.length; i++) {
      final klineDate = DateTime.fromMillisecondsSinceEpoch(data[i].timestamp);
      if (klineDate.year == targetDate.year &&
          klineDate.month == targetDate.month &&
          klineDate.day == targetDate.day) {
        return i;
      }
    }

    // 如果找不到精确日期，找第一个大于目标日期的
    for (int i = 0; i < data.length; i++) {
      final klineDate = DateTime.fromMillisecondsSinceEpoch(data[i].timestamp);
      if (klineDate.isAfter(targetDate) ||
          klineDate.isAtSameMomentAs(targetDate)) {
        return i;
      }
    }

    return data.isNotEmpty ? data.length - 1 : -1;
  }

  void nextDay() {
    if (state.currentDayIndex >= state.allKlineData.length - 1) {
      return;
    }

    final newIndex = state.currentDayIndex + 1;
    state = state.copyWith(
      currentDayIndex: newIndex,
      phase: TrainingPhase.closing,
      visibleStartIndex: max(0, newIndex - state.visibleKlineCount + 1),
    );
  }

  void setPhase(TrainingPhase phase) {
    state = state.copyWith(phase: phase);
  }

  void handleNextStep() {
    if (state.isReplayMode) {
      if (state.phase == TrainingPhase.opening) {
        setPhase(TrainingPhase.closing);
      } else {
        if (state.currentDayIndex < state.allKlineData.length - 1) {
          nextDay();
          setPhase(TrainingPhase.opening);
        }
      }
      return;
    }

    if (state.phase == TrainingPhase.opening) {
      setPhase(TrainingPhase.closing);
    } else {
      if (state.currentDayIndex < state.allKlineData.length - 1) {
        nextDay();
        setPhase(TrainingPhase.opening);
      }
    }
  }

  void previousDay() {
    if (state.currentDayIndex <= state.historyDays) {
      return;
    }

    final newIndex = state.currentDayIndex - 1;
    state = state.copyWith(
      currentDayIndex: newIndex,
      phase: TrainingPhase.opening,
      visibleStartIndex: max(0, newIndex - state.visibleKlineCount + 1),
    );
  }

  Future<void> buy(double price, double quantity) async {
    if (state.isReplayMode) return;
    if (quantity <= 0) return;

    final result = TradingCalculator.calculateBuy(
      accountBalance: state.accountBalance,
      currentPrice: price,
      positionRatio: 1.0,
      currentPositionQuantity: state.positionQuantity,
      currentPositionCost: state.positionCost,
    );

    if (!result.success) return;

    final newTradePoint = TradePoint(
      index: state.currentDayIndex,
      price: price,
      isBuy: true,
      label: 'B${state.tradePoints.where((t) => t.isBuy).length + 1}',
      date: DateTime.now(),
      tradeId: state.tradePoints.length,
      quantity: quantity.toInt(),
    );

    state = state.copyWith(
      accountBalance: result.remainingBalance,
      positionQuantity: state.positionQuantity + result.quantity,
      positionCost: result.newPositionCost,
      tradePoints: [...state.tradePoints, newTradePoint],
    );
  }

  Future<void> sell(double price, double quantity) async {
    if (state.isReplayMode || !state.hasPosition) return;
    if (quantity <= 0) return;

    final result = TradingCalculator.calculateSell(
      currentPositionQuantity: state.positionQuantity,
      currentPositionCost: state.positionCost,
      currentPrice: price,
      positionRatio: 1.0,
      accountBalance: state.accountBalance,
    );

    if (!result.success) return;

    final profit = (price - state.positionCost) * quantity;
    final newTradePoint = TradePoint(
      index: state.currentDayIndex,
      price: price,
      isBuy: false,
      label: 'S${state.tradePoints.where((t) => !t.isBuy).length + 1}',
      date: DateTime.now(),
      tradeId: state.tradePoints.length,
      quantity: quantity.toInt(),
    );

    state = state.copyWith(
      accountBalance: result.remainingBalance,
      positionQuantity: state.positionQuantity - result.quantity,
      positionCost: result.newPositionCost > 0 ? state.positionCost : 0.0,
      totalProfitLoss: state.totalProfitLoss + profit,
      tradePoints: [...state.tradePoints, newTradePoint],
    );
  }

  void zoomIn() {
    final newZoom = (state.zoomScale * 1.2).clamp(0.0286, 3.0);
    final newCount = (20 / newZoom).round().clamp(10, 700);
    state = state.copyWith(
      zoomScale: newZoom,
      visibleKlineCount: newCount.clamp(1, state.currentDayIndex + 1),
    );
  }

  void zoomOut() {
    final newZoom = (state.zoomScale / 1.2).clamp(0.0286, 3.0);
    final newCount = (20 / newZoom).round().clamp(10, 700);
    state = state.copyWith(
      zoomScale: newZoom,
      visibleKlineCount: newCount.clamp(1, state.currentDayIndex + 1),
    );
  }

  void slideLeft() {
    if (state.visibleStartIndex <= 0) return;
    state = state.copyWith(
      visibleStartIndex: max(0, state.visibleStartIndex - 5),
    );
  }

  void slideRight() {
    final maxStart = (state.currentDayIndex + 1 - state.visibleKlineCount)
        .clamp(0, state.currentDayIndex);
    if (state.visibleStartIndex >= maxStart) return;
    state = state.copyWith(
      visibleStartIndex: min(maxStart, state.visibleStartIndex + 5),
    );
  }

  void updateTopIndicator(String indicator) {
    state = state.copyWith(selectedTopIndicator: indicator);
  }

  void updateBottomIndicator(String indicator) {
    state = state.copyWith(selectedBottomIndicator: indicator);
  }

  void updatePeriod(String period) {
    state = state.copyWith(selectedPeriod: period);
  }

  void reset() {
    state = const BattleState();
  }

  List<KlineData> get displayKlineData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.allKlineData
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .map((e) => KlineData(
              date: e.dateTime,
              open: e.open,
              high: e.high,
              low: e.low,
              close: e.close,
              volume: e.volume,
            ))
        .toList();
  }

  List<TradePoint> get visibleTradePoints {
    if (state.tradePoints.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.tradePoints
        .where((point) =>
            point.index >= startIndex &&
            point.index < startIndex + state.visibleKlineCount)
        .map((point) => TradePoint(
              index: point.index - startIndex,
              price: point.price,
              isBuy: point.isBuy,
              label: point.label,
              date: point.date,
              tradeId: point.tradeId,
              quantity: point.quantity,
            ))
        .toList();
  }

  List<MacdData> get displayMacdData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    final fullData = state.allKlineData.take(endIndex).toList();

    if (fullData.length < 26) return [];

    final macdResult = IndicatorCalculator.calculateMACD(fullData);
    final macdOffset = fullData.length - macdResult.macd.length;

    final result = <MacdData>[];
    for (int i = startIndex; i < endIndex; i++) {
      final macdIndex = i - macdOffset;
      if (macdIndex >= 0 && macdIndex < macdResult.macd.length) {
        result.add(MacdData(
          macd: macdResult.macd[macdIndex],
          diff: macdResult.dif[macdIndex],
          dea: macdResult.dea[macdIndex],
        ));
      } else {
        result.add(MacdData(macd: 0, diff: 0, dea: 0));
      }
    }

    return result;
  }

  List<VolumeData> get displayVolumes {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.allKlineData
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .map((e) => VolumeData(volume: e.volume, isUp: e.isUp))
        .toList();
  }

  List<double> get ma5Data {
    return _calculateMA(displayKlineData, 5);
  }

  List<double> get ma10Data {
    return _calculateMA(displayKlineData, 10);
  }

  List<double> get ma30Data {
    return _calculateMA(displayKlineData, 30);
  }

  List<double> _calculateMA(List<KlineData> data, int period) {
    final result = <double>[];
    for (int i = 0; i < data.length; i++) {
      if (i < period - 1) {
        result.add(0);
      } else {
        double sum = 0;
        for (int j = i - period + 1; j <= i; j++) {
          sum += data[j].close;
        }
        result.add(sum / period);
      }
    }
    return result;
  }

  List<KdjData> get displayKdjData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    final fullData = state.allKlineData.take(endIndex).toList();

    if (fullData.length < 9) return [];

    final kdjResult = IndicatorCalculator.calculateKDJ(fullData);
    final kdjOffset = fullData.length - kdjResult.k.length;

    final result = <KdjData>[];
    for (int i = startIndex; i < endIndex; i++) {
      final kdjIndex = i - kdjOffset;
      if (kdjIndex >= 0 && kdjIndex < kdjResult.k.length) {
        result.add(KdjData(
          k: kdjResult.k[kdjIndex],
          d: kdjResult.d[kdjIndex],
          j: kdjResult.j[kdjIndex],
        ));
      } else {
        result.add(KdjData(k: 50, d: 50, j: 50));
      }
    }

    return result;
  }

  List<double> get displayRsiData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    final fullData = state.allKlineData.take(endIndex).toList();

    if (fullData.length < 14) return [];

    final rsiResult = IndicatorCalculator.calculateRSI(fullData);
    final rsiOffset = fullData.length - rsiResult.values.length;

    final result = <double>[];
    for (int i = startIndex; i < endIndex; i++) {
      final rsiIndex = i - rsiOffset;
      if (rsiIndex >= 0 && rsiIndex < rsiResult.values.length) {
        result.add(rsiResult.values[rsiIndex]);
      } else {
        result.add(50);
      }
    }

    return result;
  }

  List<BollData> get displayBollData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    final fullData = state.allKlineData.take(endIndex).toList();

    if (fullData.length < 20) return [];

    final bollResult = IndicatorCalculator.calculateBoll(fullData);
    final bollOffset = fullData.length - bollResult.mb.length;

    final result = <BollData>[];
    for (int i = startIndex; i < endIndex; i++) {
      final bollIndex = i - bollOffset;
      if (bollIndex >= 0 && bollIndex < bollResult.mb.length) {
        result.add(BollData(
          mb: bollResult.mb[bollIndex],
          up: bollResult.up[bollIndex],
          dn: bollResult.dn[bollIndex],
        ));
      } else {
        result.add(BollData(mb: 0, up: 0, dn: 0));
      }
    }

    return result;
  }

  List<DmiData> get displayDmiData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    final fullData = state.allKlineData.take(endIndex).toList();

    if (fullData.length < 14) return [];

    final dmiResult = IndicatorCalculator.calculateDMI(fullData);
    final dmiOffset = fullData.length - dmiResult.plusDI.length;

    final result = <DmiData>[];
    for (int i = startIndex; i < endIndex; i++) {
      final dmiIndex = i - dmiOffset;
      if (dmiIndex >= 0 && dmiIndex < dmiResult.plusDI.length) {
        result.add(DmiData(
          plusDi: dmiResult.plusDI[dmiIndex],
          minusDi: dmiResult.minusDI[dmiIndex],
          adx: dmiIndex < dmiResult.adx.length ? dmiResult.adx[dmiIndex] : 0,
        ));
      } else {
        result.add(DmiData(plusDi: 0, minusDi: 0, adx: 0));
      }
    }

    return result;
  }

  List<double> get displayCciData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    final fullData = state.allKlineData.take(endIndex).toList();

    if (fullData.length < 14) return [];

    final cciResult = IndicatorCalculator.calculateCCI(fullData);
    final cciOffset = fullData.length - cciResult.values.length;

    final result = <double>[];
    for (int i = startIndex; i < endIndex; i++) {
      final cciIndex = i - cciOffset;
      if (cciIndex >= 0 && cciIndex < cciResult.values.length) {
        result.add(cciResult.values[cciIndex]);
      } else {
        result.add(0);
      }
    }

    return result;
  }

  List<double> get displayWrData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    final fullData = state.allKlineData.take(endIndex).toList();

    if (fullData.length < 14) return [];

    final wrResult = IndicatorCalculator.calculateWR(fullData);
    final wrOffset = fullData.length - wrResult.values.length;

    final result = <double>[];
    for (int i = startIndex; i < endIndex; i++) {
      final wrIndex = i - wrOffset;
      if (wrIndex >= 0 && wrIndex < wrResult.values.length) {
        result.add(wrResult.values[wrIndex]);
      } else {
        result.add(-50);
      }
    }

    return result;
  }

  List<double> get displayObvData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    final fullData = state.allKlineData.take(endIndex).toList();

    final obvResult = IndicatorCalculator.calculateOBV(fullData);
    final obvOffset = fullData.length - obvResult.values.length;

    final result = <double>[];
    for (int i = startIndex; i < endIndex; i++) {
      final obvIndex = i - obvOffset;
      if (obvIndex >= 0 && obvIndex < obvResult.values.length) {
        result.add(obvResult.values[obvIndex]);
      } else {
        result.add(0);
      }
    }

    return result;
  }

  List<DmaData> get displayDmaData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    final fullData = state.allKlineData.take(endIndex).toList();

    if (fullData.length < 50) return [];

    final dmaResult = IndicatorCalculator.calculateDMA(fullData);
    final dmaOffset = fullData.length - dmaResult.dma.length;

    final result = <DmaData>[];
    for (int i = startIndex; i < endIndex; i++) {
      final dmaIndex = i - dmaOffset;
      if (dmaIndex >= 0 && dmaIndex < dmaResult.dma.length) {
        result.add(DmaData(
          dma: dmaResult.dma[dmaIndex],
          ama: dmaIndex < dmaResult.ama.length ? dmaResult.ama[dmaIndex] : 0,
        ));
      } else {
        result.add(DmaData(dma: 0, ama: 0));
      }
    }

    return result;
  }

  List<double> get displayBbiData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    final fullData = state.allKlineData.take(endIndex).toList();

    if (fullData.length < 24) return [];

    final bbiResult = IndicatorCalculator.calculateBBI(fullData);
    final bbiOffset = fullData.length - bbiResult.values.length;

    final result = <double>[];
    for (int i = startIndex; i < endIndex; i++) {
      final bbiIndex = i - bbiOffset;
      if (bbiIndex >= 0 && bbiIndex < bbiResult.values.length) {
        result.add(bbiResult.values[bbiIndex]);
      } else {
        result.add(0);
      }
    }

    return result;
  }
}

class _CandidateStock {
  final String symbol;
  final String marketCode;
  const _CandidateStock({required this.symbol, required this.marketCode});
}
