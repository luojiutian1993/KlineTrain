import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/models/trade_point_model.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/database/daos/holiday_dao.dart';
import 'package:kline_trainer/data/repositories/kline_repository.dart';
import 'package:kline_trainer/features/battle/models/battle_state.dart';
import 'package:kline_trainer/features/battle/models/battle_config.dart';
import 'package:kline_trainer/features/battle/trading_calculator.dart';
import 'package:kline_trainer/features/battle/services/training_config_service.dart';
import 'package:kline_trainer/features/battle/services/indicator_cache_service.dart';
import 'package:kline_trainer/data/utils/indicator_calculator.dart';
import 'package:kline_trainer/data/services/trading_day_calculator.dart';
import 'package:kline_trainer/data/services/data_sufficiency_checker.dart';
import 'package:kline_trainer/data/services/stock_selector.dart';

part 'battle_provider.g.dart';

@riverpod
class Battle extends _$Battle {
  final KlineRepository _repository = KlineRepository();
  late final TradingDayCalculator _tradingDayCalculator;
  late final DataSufficiencyChecker _sufficiencyChecker;
  late final StockSelector _stockSelector;

  @override
  BattleState build() {
    _initializeServices();
    return const BattleState();
  }

  void _initializeServices() {
    final holidayDao = DatabaseService.instance.db.holidayDao;
    _tradingDayCalculator = TradingDayCalculator(holidayDao);
    _sufficiencyChecker = DataSufficiencyChecker(holidayDao);
    _stockSelector = StockSelector(
      repository: _repository,
      holidayDao: holidayDao,
      tradingDayCalculator: _tradingDayCalculator,
      sufficiencyChecker: _sufficiencyChecker,
      dbService: DatabaseService.instance,
    );
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

      var klineData = await _loadKlineData(symbol, startDate);
      var currentSymbol = symbol;
      var currentStartDate = startDate;

      final configService = TrainingConfigService(DatabaseService.instance);
      final totalRequiredDays = await configService.getRequiredTradingDays();

      var sufficiencyCheck = await _sufficiencyChecker.checkSufficiency(
        data: klineData,
        requiredTradingDays: totalRequiredDays,
      );

      if (!sufficiencyCheck.isSufficient) {
        print('⚠️ [BattleProvider] 当前股票数据不足，自动切换...');

        final stockSelection = await _stockSelector.selectSufficientStock(
          preferredStartDate: startDate,
          totalRequiredDays: totalRequiredDays,
        );

        if (stockSelection.symbol != null) {
          print('✅ [BattleProvider] 已切换到数据充足的股票: ${stockSelection.symbol}');

          if (stockSelection.isAutoSelected) {
            print('ℹ️ [BattleProvider] 随机选择了数据充足的股票');
          } else {
            print(
                'ℹ️ [BattleProvider] 原股票数据不足，已自动切换到 ${stockSelection.symbol}');
          }

          currentSymbol = stockSelection.symbol!;
          klineData = stockSelection.data;
          sufficiencyCheck = stockSelection.sufficiencyCheck!;
          currentStartDate = stockSelection.isAutoSelected ? null : startDate;
        } else {
          print('🔴 [BattleProvider] 没有找到数据充足的股票');

          state = state.copyWith(
            isLoading: false,
            hasAvailableData: false,
            errorMessage: '没有找到数据充足的股票，请同步更多数据',
          );
          return;
        }
      }

      print(
          '🔵 [BattleProvider] initializeWithSymbol: klineData.length=${klineData.length}');
      print('🔵 [BattleProvider] 数据充足性: ${sufficiencyCheck.isSufficient}');

      if (klineData.isEmpty) {
        print('🔴 [BattleProvider] initializeWithSymbol: K线数据为空');
        state = state.copyWith(
          isLoading: false,
          hasAvailableData: false,
          errorMessage: '数据库中暂无合格股票，请先同步数据',
        );
        return;
      }

      final startDayIndex = _findStartDayIndex(klineData, currentStartDate);
      print(
          '🔵 [BattleProvider] initializeWithSymbol: startDayIndex=$startDayIndex');

      // 计算实际可用的训练天数
      final availableTrainingDays = klineData.length - startDayIndex;
      final trainingDays = availableTrainingDays > 0
          ? availableTrainingDays.clamp(1, BattleConfig.defaultTrainingDays)
          : 1;

      // 预计算所有指标数据（与 K 线数据一一对应）
      final computed = _precomputeIndicators(klineData);

      // 确保visibleStartIndex有效
      final visibleStartIndex =
          (startDayIndex - BattleConfig.defaultVisibleKlineCount + 1)
              .clamp(0, startDayIndex);

      print(
          '🔵 [BattleProvider] initializeWithSymbol: trainingDays=$trainingDays, visibleStartIndex=$visibleStartIndex');

      state = state.copyWith(
        currentSymbol: currentSymbol,
        currentSymbolName: name ?? currentSymbol,
        currentMarketCode: marketCode ?? '',
        trainingStartDate: currentStartDate,
        allKlineData: klineData,
        precomputedVolumes: computed['volumes'] as List<VolumeData>,
        precomputedMacd: computed['macd'] as List<MacdData>,
        precomputedKdj: computed['kdj'] as List<KdjData>,
        precomputedRsi: computed['rsi'] as List<double>,
        precomputedBoll: computed['boll'] as List<BollData>,
        precomputedDmi: computed['dmi'] as List<DmiData>,
        precomputedCci: computed['cci'] as List<double>,
        precomputedWr: computed['wr'] as List<double>,
        precomputedObv: computed['obv'] as List<double>,
        precomputedDma: computed['dma'] as List<DmaData>,
        precomputedBbi: computed['bbi'] as List<double>,
        precomputedMa5: computed['ma5'] as List<double>,
        precomputedMa10: computed['ma10'] as List<double>,
        precomputedMa30: computed['ma30'] as List<double>,
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

  /// 预计算所有指标数据，确保与 K 线数据一一对应
  Map<String, dynamic> _precomputeIndicators(List<KlineModel> data) {
    final volumes = data
        .map((d) => VolumeData(volume: d.volume, isUp: d.close >= d.open))
        .toList();

    final closes = data.map((d) => d.close).toList();
    final ma5 = _computeFullMA(closes, 5);
    final ma10 = _computeFullMA(closes, 10);
    final ma30 = _computeFullMA(closes, 30);

    // 计算 MACD（完整数组，长度与 data 一致）
    final macdResult = IndicatorCalculator.calculateMACD(data);
    final macdData = List.generate(data.length, (i) {
      return MacdData(
        macd: macdResult.macd[i],
        diff: macdResult.dif[i],
        dea: macdResult.dea[i],
      );
    });

    // 计算 KDJ（完整数组，长度与 data 一致）
    final kdjResult = IndicatorCalculator.calculateKDJ(data);
    final kdjData = List.generate(data.length, (i) {
      return KdjData(
        k: kdjResult.k[i],
        d: kdjResult.d[i],
        j: kdjResult.j[i],
      );
    });

    // 计算 RSI（完整数组，长度与 data 一致）
    final rsiResult = IndicatorCalculator.calculateRSI(data);
    final rsiData = rsiResult.values;

    // 计算 BOLL（完整数组，长度与 data 一致）
    final bollResult = IndicatorCalculator.calculateBoll(data);
    final bollData = List.generate(data.length, (i) {
      return BollData(
        mb: bollResult.mb[i],
        up: bollResult.up[i],
        dn: bollResult.dn[i],
      );
    });

    // 计算 DMI（完整数组，长度与 data 一致）
    final dmiResult = IndicatorCalculator.calculateDMI(data);
    final dmiData = List.generate(data.length, (i) {
      return DmiData(
        plusDi: dmiResult.plusDI[i],
        minusDi: dmiResult.minusDI[i],
        adx: dmiResult.adx[i],
      );
    });

    // 计算 CCI（完整数组，长度与 data 一致）
    final cciResult = IndicatorCalculator.calculateCCI(data);
    final cciData = cciResult.values;

    // 计算 WR（完整数组，长度与 data 一致）
    final wrResult = IndicatorCalculator.calculateWR(data);
    final wrData = wrResult.values;

    // 计算 OBV（完整数组，长度与 data 一致）
    final obvResult = IndicatorCalculator.calculateOBV(data);
    final obvData = obvResult.values;

    // 计算 DMA（完整数组，长度与 data 一致）
    final dmaResult = IndicatorCalculator.calculateDMA(data);
    final dmaData = List.generate(data.length, (i) {
      return DmaData(
        dma: dmaResult.dma[i],
        ama: dmaResult.ama[i],
      );
    });

    // 计算 BBI（完整数组，长度与 data 一致）
    final bbiResult = IndicatorCalculator.calculateBBI(data);
    final bbiData = bbiResult.values;

    return {
      'volumes': volumes,
      'macd': macdData,
      'kdj': kdjData,
      'rsi': rsiData,
      'boll': bollData,
      'dmi': dmiData,
      'cci': cciData,
      'wr': wrData,
      'obv': obvData,
      'dma': dmaData,
      'bbi': bbiData,
      'ma5': ma5,
      'ma10': ma10,
      'ma30': ma30,
    };
  }

  /// 计算完整的 MA 数组，长度与数据一致
  List<double> _computeFullMA(List<double> data, int period) {
    final result = List<double>.filled(data.length, 0);
    for (int i = 0; i < data.length; i++) {
      int start = max(0, i - period + 1);
      double sum = 0;
      for (int j = start; j <= i; j++) {
        sum += data[j];
      }
      result[i] = sum / (i - start + 1);
    }
    return result;
  }

  Future<List<KlineModel>> _loadKlineData(
    String symbol,
    DateTime? startDate,
  ) async {
    final configService = TrainingConfigService(DatabaseService.instance);

    final trainingDays = await configService.getTrainingDays();
    final preloadDays = await configService.getPreloadDays();
    final indicatorPreloadDays = await configService.getIndicatorPreloadDays();
    final totalRequiredDays = await configService.getRequiredTradingDays();

    // 多查询 20 天，保证满足前端需求的天数
    final bufferDays = 20;

    DateTime dataStartTime;
    final dataEndTime = DateTime.now();

    // 估算日历天数：工作日 * 1.5（考虑周末和节假日）
    // 然后加上缓冲天数
    final estimatedCalendarDays = (totalRequiredDays * 1.5).ceil() + bufferDays;

    if (startDate != null) {
      // 从训练起始日期往前推算：预加载 + 指标前置 + 缓冲
      final totalPreloadDays = preloadDays + indicatorPreloadDays;
      final preloadCalendarDays = (totalPreloadDays * 1.5).ceil() + bufferDays;
      dataStartTime = startDate.subtract(Duration(days: preloadCalendarDays));
    } else {
      dataStartTime =
          dataEndTime.subtract(Duration(days: estimatedCalendarDays));
    }

    print('🔵 [BattleProvider] 数据加载计算:');
    print('  - 训练天数（工作日）: $trainingDays');
    print('  - 预加载天数（工作日）: $preloadDays');
    print('  - 指标前置天数（工作日）: $indicatorPreloadDays');
    print('  - 总交易日: $totalRequiredDays');
    print('  - 缓冲天数: $bufferDays');
    print('  - 估算日历天: $estimatedCalendarDays');
    print('  - 数据加载范围: $dataStartTime ~ $dataEndTime');

    List<KlineModel> data = await _repository.fetchKlineDataFromDbWithDateRange(
      symbol: symbol,
      period: 'day',
      startTime: dataStartTime,
      endTime: dataEndTime,
    );

    if (data.isEmpty) {
      print('🔴 [BattleProvider] 没有找到K线数据，尝试获取所有数据');
      data = await _repository.fetchKlineDataFromDb(
        symbol: symbol,
        period: 'day',
        limit: 10000,
      );

      if (data.isNotEmpty) {
        final firstDate =
            DateTime.fromMillisecondsSinceEpoch(data.first.timestamp);
        final availableDays = dataEndTime.difference(firstDate).inDays;
        print(
            '⚠️ [BattleProvider] 数据加载范围不足，可用: $availableDays 天，估算需求: $estimatedCalendarDays 天');
      }
    }

    return data;
  }

  Future<Map<String, dynamic>?> _loadDataForRange({
    required String symbol,
    required int visibleKlineCount,
    required DateTime visibleStart,
    required DateTime visibleEnd,
  }) async {
    final cacheService = IndicatorCacheService();
    final configService = TrainingConfigService(DatabaseService.instance);

    final cacheKey = '$symbol\_$visibleKlineCount';
    final cached = cacheService.get(cacheKey);

    if (cached != null &&
        !visibleStart.isBefore(cached.startDate) &&
        !visibleEnd.isAfter(cached.endDate)) {
      print('🔵 [BattleProvider] 缓存命中: $cacheKey');
      return {
        'klineData': cached.klineData,
        'indicators': cached.indicators,
      };
    }

    final indicatorPreloadDays = await configService.getIndicatorPreloadDays();
    final dataStart =
        visibleStart.subtract(Duration(days: indicatorPreloadDays));

    print('🔵 [BattleProvider] 按需加载: $dataStart ~ $visibleEnd');

    final extendedData = await _repository.fetchKlineDataFromDbWithDateRange(
      symbol: symbol,
      period: 'day',
      startTime: dataStart,
      endTime: visibleEnd,
    );

    if (extendedData.isEmpty) {
      return null;
    }

    final indicators = _precomputeAllIndicators(extendedData);

    final cache = IndicatorCache(
      cacheKey: cacheKey,
      dataLength: extendedData.length,
      startDate: dataStart,
      endDate: visibleEnd,
      klineData: extendedData,
      indicators: indicators,
      createdAt: DateTime.now(),
    );
    cacheService.put(cache);

    return {
      'klineData': extendedData,
      'indicators': indicators,
    };
  }

  Map<String, dynamic> _precomputeAllIndicators(List<KlineModel> data) {
    if (data.isEmpty) {
      return {
        'volumes': <VolumeData>[],
        'ma5': <double>[],
        'ma10': <double>[],
        'ma30': <double>[],
        'macd': <MacdData>[],
        'kdj': <KdjData>[],
        'rsi': <double>[],
        'boll': <BollData>[],
        'dmi': <DmiData>[],
        'cci': <double>[],
        'wr': <double>[],
        'obv': <double>[],
        'dma': <DmaData>[],
        'bbi': <double>[],
      };
    }

    final closes = data.map((d) => d.close).toList();
    final volumes = data
        .map((d) => VolumeData(volume: d.volume, isUp: d.close >= d.open))
        .toList();

    final ma5 = IndicatorCalculator.calculateSMA(closes, 5);
    final ma10 = IndicatorCalculator.calculateSMA(closes, 10);
    final ma30 = IndicatorCalculator.calculateSMA(closes, 30);

    final macdResult = IndicatorCalculator.calculateMACD(data);
    final macdData = <MacdData>[];
    for (int i = 0; i < macdResult.macd.length; i++) {
      macdData.add(MacdData(
        macd: macdResult.macd[i],
        diff: i < macdResult.dif.length ? macdResult.dif[i] : 0,
        dea: i < macdResult.dea.length ? macdResult.dea[i] : 0,
      ));
    }

    final kdjResult = IndicatorCalculator.calculateKDJ(data);
    final kdjData = <KdjData>[];
    for (int i = 0; i < kdjResult.k.length; i++) {
      kdjData.add(KdjData(
        k: kdjResult.k[i],
        d: kdjResult.d[i],
        j: kdjResult.j[i],
      ));
    }

    final rsiResult = IndicatorCalculator.calculateRSI(data);
    final bollResult = IndicatorCalculator.calculateBoll(data);
    final bollData = <BollData>[];
    for (int i = 0; i < bollResult.mb.length; i++) {
      bollData.add(BollData(
        mb: bollResult.mb[i],
        up: bollResult.up[i],
        dn: bollResult.dn[i],
      ));
    }

    final dmiResult = IndicatorCalculator.calculateDMI(data);
    final dmiData = <DmiData>[];
    for (int i = 0; i < dmiResult.plusDI.length; i++) {
      dmiData.add(DmiData(
        plusDi: dmiResult.plusDI[i],
        minusDi: dmiResult.minusDI[i],
        adx: dmiResult.adx[i],
      ));
    }

    final cciResult = IndicatorCalculator.calculateCCI(data);
    final wrResult = IndicatorCalculator.calculateWR(data);
    final obvResult = IndicatorCalculator.calculateOBV(data);

    final dmaResult = IndicatorCalculator.calculateDMA(data);
    final dmaData = <DmaData>[];
    for (int i = 0; i < dmaResult.dma.length; i++) {
      dmaData.add(DmaData(
        dma: dmaResult.dma[i],
        ama: dmaResult.ama[i],
      ));
    }

    final bbiResult = IndicatorCalculator.calculateBBI(data);

    print(
        '🔵 [BattleProvider] 预计算指标: ma5[0..4]=[${ma5.take(5).toList()}], macd[0..4]=[${macdData.take(5).map((m) => m.macd).toList()}]');

    return {
      'volumes': volumes,
      'ma5': ma5,
      'ma10': ma10,
      'ma30': ma30,
      'macd': macdData,
      'kdj': kdjData,
      'rsi': rsiResult.values,
      'boll': bollData,
      'dmi': dmiData,
      'cci': cciResult.values,
      'wr': wrResult.values,
      'obv': obvResult.values,
      'dma': dmaData,
      'bbi': bbiResult.values,
    };
  }

  String _generateCacheKey(String symbol, int visibleKlineCount) {
    return '${symbol}_$visibleKlineCount';
  }

  bool _coversRange(
    IndicatorCache cache,
    DateTime requestStart,
    DateTime requestEnd,
  ) {
    return !requestStart.isBefore(cache.startDate) &&
        !requestEnd.isAfter(cache.endDate);
  }

  void _applyCachedData(IndicatorCache cache) {
    state = state.copyWith(
      allKlineData: cache.klineData,
      precomputedMa5: (cache.indicators['ma5'] as List<double>?) ?? [],
      precomputedMa10: (cache.indicators['ma10'] as List<double>?) ?? [],
      precomputedMa30: (cache.indicators['ma30'] as List<double>?) ?? [],
    );
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

  bool zoomIn() {
    final newCount = (state.visibleKlineCount / BattleConfig.zoomFactor)
        .round()
        .clamp(BattleConfig.minVisibleKlineCount,
            BattleConfig.maxVisibleKlineCount);

    if (newCount <= BattleConfig.minVisibleKlineCount) {
      final shouldAlert = _shouldShowBoundaryAlert(state.lastZoomBoundaryTime);
      if (shouldAlert) {
        state = state.copyWith(
          visibleKlineCount: BattleConfig.minVisibleKlineCount,
          lastZoomBoundaryTime: DateTime.now(),
        );
      } else {
        state = state.copyWith(
            visibleKlineCount: BattleConfig.minVisibleKlineCount);
      }
      return shouldAlert;
    }

    final newStart = max(0, state.currentDayIndex - newCount + 1);
    state = state.copyWith(
      visibleKlineCount: newCount.clamp(1, state.currentDayIndex + 1),
      visibleStartIndex: newStart,
    );
    return false;
  }

  bool zoomOut() {
    final newCount = (state.visibleKlineCount * BattleConfig.zoomFactor)
        .round()
        .clamp(BattleConfig.minVisibleKlineCount,
            BattleConfig.maxVisibleKlineCount);

    if (newCount >= BattleConfig.maxVisibleKlineCount) {
      final shouldAlert = _shouldShowBoundaryAlert(state.lastZoomBoundaryTime);
      if (shouldAlert) {
        state = state.copyWith(
          visibleKlineCount: BattleConfig.maxVisibleKlineCount,
          lastZoomBoundaryTime: DateTime.now(),
        );
      } else {
        state = state.copyWith(
            visibleKlineCount: BattleConfig.maxVisibleKlineCount);
      }
      return shouldAlert;
    }

    final newStart = max(0, state.currentDayIndex - newCount + 1);
    state = state.copyWith(
      visibleKlineCount: newCount.clamp(1, state.currentDayIndex + 1),
      visibleStartIndex: newStart,
    );
    return false;
  }

  bool slideLeft() {
    final newStart = state.visibleStartIndex - BattleConfig.slideStepCount;

    if (newStart <= 0) {
      final shouldAlert = _shouldShowBoundaryAlert(state.lastLeftBoundaryTime);
      if (shouldAlert) {
        state = state.copyWith(
          visibleStartIndex: 0,
          lastLeftBoundaryTime: DateTime.now(),
        );
      } else {
        state = state.copyWith(visibleStartIndex: 0);
      }
      return shouldAlert;
    }

    state = state.copyWith(visibleStartIndex: newStart);
    return false;
  }

  bool slideRight() {
    final maxStart = (state.currentDayIndex + 1 - state.visibleKlineCount)
        .clamp(0, state.currentDayIndex);
    final newStart = state.visibleStartIndex + BattleConfig.slideStepCount;

    if (newStart >= maxStart) {
      final shouldAlert = _shouldShowBoundaryAlert(state.lastRightBoundaryTime);
      if (shouldAlert) {
        state = state.copyWith(
          visibleStartIndex: maxStart,
          lastRightBoundaryTime: DateTime.now(),
        );
      } else {
        state = state.copyWith(visibleStartIndex: maxStart);
      }
      return shouldAlert;
    }

    state = state.copyWith(visibleStartIndex: newStart);
    return false;
  }

  bool _shouldShowBoundaryAlert(DateTime? lastTime) {
    if (lastTime == null) return true;
    final diff = DateTime.now().difference(lastTime).inSeconds;
    return diff >= BattleConfig.boundaryDebounceSeconds;
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

    return state.precomputedMacd
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .toList();
  }

  List<VolumeData> get displayVolumes {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.precomputedVolumes
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .toList();
  }

  List<double> get ma5Data {
    if (state.allKlineData.isEmpty) return [];

    final displayCloses = displayKlineData.map((e) => e.close).toList();
    return _computeMA(displayCloses, 5);
  }

  List<double> get ma10Data {
    if (state.allKlineData.isEmpty) return [];

    final displayCloses = displayKlineData.map((e) => e.close).toList();
    return _computeMA(displayCloses, 10);
  }

  List<double> get ma30Data {
    if (state.allKlineData.isEmpty) return [];

    final displayCloses = displayKlineData.map((e) => e.close).toList();
    return _computeMA(displayCloses, 30);
  }

  List<double> _computeMA(List<double> data, int period) {
    final result = <double>[];
    for (int i = 0; i < data.length; i++) {
      if (i < period - 1) {
        result.add(0);
      } else {
        double sum = 0;
        for (int j = i - period + 1; j <= i; j++) {
          sum += data[j];
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

    return state.precomputedKdj
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .toList();
  }

  List<double> get displayRsiData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.precomputedRsi
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .toList();
  }

  List<BollData> get displayBollData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.precomputedBoll
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .toList();
  }

  List<DmiData> get displayDmiData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.precomputedDmi
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .toList();
  }

  List<double> get displayCciData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.precomputedCci
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .toList();
  }

  List<double> get displayWrData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.precomputedWr
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .toList();
  }

  List<double> get displayObvData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.precomputedObv
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .toList();
  }

  List<DmaData> get displayDmaData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.precomputedDma
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .toList();
  }

  List<double> get displayBbiData {
    if (state.allKlineData.isEmpty) return [];

    final endIndex =
        (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
    final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
    final startIndex = state.visibleStartIndex.clamp(0, maxStart);

    return state.precomputedBbi
        .skip(startIndex)
        .take(min(state.visibleKlineCount, endIndex - startIndex))
        .toList();
  }
}

class _CandidateStock {
  final String symbol;
  final String marketCode;
  const _CandidateStock({required this.symbol, required this.marketCode});
}
