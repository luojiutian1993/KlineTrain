import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';

class KlineChartContainer extends ConsumerWidget {
  const KlineChartContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(battleProvider);
    final notifier = ref.read(battleProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 0.5)),
      ),
      child: KlineChart(
        klineData: notifier.displayKlineData,
        ma5: notifier.ma5Data,
        ma10: notifier.ma10Data,
        ma30: notifier.ma30Data,
        volumes: notifier.displayVolumes,
        macdData: notifier.displayMacdData,
        tradePoints: notifier.visibleTradePoints,
        currentOpenPrice: state.currentKline?.open,
        positionCost: state.hasPosition ? state.positionCost : null,
      ),
    );
  }
}