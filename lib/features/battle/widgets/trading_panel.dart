import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/models/battle_state.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';

class TradingPanel extends ConsumerWidget {
  const TradingPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(battleProvider);
    final notifier = ref.read(battleProvider.notifier);

    final isReplayMode = state.isReplayMode;
    final canTrade = state.canTrade && !isReplayMode;
    final hasPosition = state.hasPosition;

    final progress = state.trainingProgress;
    final totalDays = state.trainingDays;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
      ),
      child: Row(
        children: [
          _buildButton(context, '换股', () => notifier.initializeRandom()),
          const SizedBox(width: 8),
          _buildButton(context, '条件单', () => _showFeatureInDev(context)),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTradeButton('买入', Colors.red, canTrade, () {
              notifier.buy(state.currentPrice, 100);
            }),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTradeButton(
              hasPosition ? '卖出' : '空仓',
              hasPosition ? Colors.green : Colors.grey,
              canTrade && hasPosition,
              () => notifier.sell(state.currentPrice, state.positionQuantity),
            ),
          ),
          const SizedBox(width: 8),
          _buildProgressDisplay(progress, totalDays),
          const SizedBox(width: 8),
          _buildNextButton(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: 56,
      height: 38,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
        onPressed: onPressed,
        child: Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.black)),
      ),
    );
  }

  Widget _buildTradeButton(
      String label, Color color, bool enabled, VoidCallback onPressed) {
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color : Colors.grey[300],
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: enabled ? onPressed : null,
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildProgressDisplay(int progress, int totalDays) {
    return Container(
      width: 60,
      height: 38,
      alignment: Alignment.center,
      child: Text(
        '$progress天',
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _buildNextButton(
      BuildContext context, BattleState state, Battle notifier) {
    final label = state.isReplayMode
        ? '已结束'
        : state.phase == TrainingPhase.opening
            ? '看盘'
            : '下一步';

    return SizedBox(
      width: 60,
      height: 38,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: state.isReplayMode ? Colors.grey[300] : Colors.blue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: state.isReplayMode
            ? null
            : () {
                if (state.phase == TrainingPhase.opening) {
                  notifier.setPhase(TrainingPhase.closing);
                } else {
                  notifier.nextDay();
                }
              },
        child: Text(label, style: const TextStyle(fontSize: 11)),
      ),
    );
  }

  void _showFeatureInDev(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('条件单功能开发中'), duration: Duration(seconds: 1)),
    );
  }
}
