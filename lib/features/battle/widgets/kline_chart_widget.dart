import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';
import 'package:kline_trainer/features/battle/models/battle_state.dart';
import 'package:kline_trainer/data/models/kline_model.dart';

class KlineChartWidget extends ConsumerWidget {
  const KlineChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(battleProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!state.hasAvailableData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? '暂无数据',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(battleProvider.notifier).initializeRandom();
              },
              child: const Text('重新加载'),
            ),
          ],
        ),
      );
    }

    final klineData = _buildKlineData(state);
    final ma5 = _calculateMA(klineData, 5);
    final ma10 = _calculateMA(klineData, 10);
    final ma30 = _calculateMA(klineData, 30);

    return KlineChart(
      klineData: klineData,
      ma5: ma5,
      ma10: ma10,
      ma30: ma30,
      volumes: _buildVolumeData(state),
      macdData: _buildMacdData(state),
      tradePoints: state.tradePoints,
      currentOpenPrice: state.currentKline?.open,
      positionCost: state.positionCost,
    );
  }

  List<KlineData> _buildKlineData(BattleState state) {
    final visibleData = _getVisibleKlineData(state);
    return visibleData.map((k) {
      return KlineData(
        date: DateTime.fromMillisecondsSinceEpoch(k.timestamp),
        open: k.open,
        high: k.high,
        low: k.low,
        close: k.close,
        volume: k.volume,
      );
    }).toList();
  }

  List<KlineModel> _getVisibleKlineData(BattleState state) {
    if (state.allKlineData.isEmpty) {
      return [];
    }

    final start =
        state.visibleStartIndex.clamp(0, state.allKlineData.length - 1);
    final end =
        (start + state.visibleKlineCount).clamp(0, state.allKlineData.length);

    return state.allKlineData.sublist(start, end);
  }

  List<double> _calculateMA(List<KlineData> data, int period) {
    final result = <double>[];

    for (int i = 0; i < data.length; i++) {
      if (i < period - 1) {
        result.add(0);
        continue;
      }

      double sum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sum += data[j].close;
      }
      result.add(sum / period);
    }

    return result;
  }

  List<VolumeData> _buildVolumeData(BattleState state) {
    final visibleData = _getVisibleKlineData(state);
    final List<VolumeData> result = [];

    for (int i = 0; i < visibleData.length; i++) {
      final k = visibleData[i];
      final prevClose = i > 0 ? visibleData[i - 1].close : k.open;
      result.add(VolumeData(
        volume: k.volume,
        isUp: k.close >= prevClose,
      ));
    }

    return result;
  }

  List<MacdData> _buildMacdData(BattleState state) {
    final visibleData = _getVisibleKlineData(state);
    if (visibleData.length < 26) {
      return [];
    }

    final closes = visibleData.map((k) => k.close).toList();
    final macdResult = _calculateMACD(closes);

    return macdResult.map((m) {
      return MacdData(
        macd: m['macd'] ?? 0,
        diff: m['diff'] ?? 0,
        dea: m['dea'] ?? 0,
      );
    }).toList();
  }

  List<Map<String, double>> _calculateMACD(List<double> closes) {
    final result = <Map<String, double>>[];

    if (closes.length < 26) return result;

    final ema12 = _calculateEMA(closes, 12);
    final ema26 = _calculateEMA(closes, 26);

    final diffList = <double>[];
    final deaList = <double>[];

    for (int i = 0; i < closes.length; i++) {
      if (i < 25) {
        result.add({'macd': 0, 'diff': 0, 'dea': 0});
        diffList.add(0);
        deaList.add(0);
        continue;
      }

      final diff = ema12[i] - ema26[i];
      diffList.add(diff);

      double dea = 0;
      if (i >= 34) {
        dea = ((deaList[i - 1] * 8) + (diff * 2)) / 10;
      } else {
        dea = diff;
      }
      deaList.add(dea);

      final macd = (diff - dea) * 2;
      result.add({'macd': macd, 'diff': diff, 'dea': dea});
    }

    return result;
  }

  List<double> _calculateEMA(List<double> data, int period) {
    final result = <double>[];
    if (data.length < period) return result;

    double ema = data.sublist(0, period).reduce((a, b) => a + b) / period;

    for (int i = 0; i < period; i++) {
      result.add(ema);
    }

    final multiplier = 2.0 / (period + 1);
    for (int i = period; i < data.length; i++) {
      ema = (data[i] - ema) * multiplier + ema;
      result.add(ema);
    }

    return result;
  }
}
