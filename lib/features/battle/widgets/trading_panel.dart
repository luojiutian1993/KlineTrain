import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/models/battle_state.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';

class TradingPanel extends ConsumerWidget {
  final VoidCallback? onBuy;
  final VoidCallback? onSell;

  const TradingPanel({
    super.key,
    this.onBuy,
    this.onSell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(battleProvider);
    final notifier = ref.read(battleProvider.notifier);

    final isReplayMode = state.isReplayMode;
    final canTrade = state.canTrade && !isReplayMode;
    final hasPosition = state.hasPosition;

    final progress = state.trainingProgress;
    final totalDays = state.trainingDays;

    return Row(
      children: [
        _buildChangeStockButton(context, notifier),
        const SizedBox(width: 4),
        _buildConditionalOrderButton(context),
        const SizedBox(width: 4),
        Expanded(
          child: _buildBuyButton(
            context,
            state,
            notifier,
            canTrade,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _buildSellButton(
            context,
            state,
            notifier,
            canTrade && hasPosition,
          ),
        ),
        const SizedBox(width: 4),
        _buildProgressIndicator(progress, totalDays),
        const SizedBox(width: 4),
        _buildNextDayButton(state, notifier, context),
      ],
    );
  }

  Widget _buildChangeStockButton(BuildContext context, Battle notifier) {
    return SizedBox(
      width: 44,
      height: 36,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: () {
          notifier.reset();
        },
        child: const Text(
          '换股',
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildConditionalOrderButton(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 36,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('条件单功能开发中'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: const Text(
          '条件',
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildBuyButton(
    BuildContext context,
    BattleState state,
    Battle notifier,
    bool canTrade,
  ) {
    final buttonText = state.isReplayMode ? '已结束' : '买入';
    final buttonColor = state.isReplayMode ? Colors.grey : Colors.red;

    return SizedBox(
      height: 36,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: canTrade ? () => notifier.buy(state.currentPrice, 100) : null,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildSellButton(
    BuildContext context,
    BattleState state,
    Battle notifier,
    bool canSell,
  ) {
    final buttonText = state.isReplayMode
        ? '已结束'
        : (state.hasPosition ? '卖出' : '空仓');
    final buttonColor = state.isReplayMode
        ? Colors.grey
        : (state.hasPosition ? Colors.green : Colors.grey);

    return SizedBox(
      height: 36,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: canSell ? () => notifier.sell(state.currentPrice, state.positionQuantity) : null,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int progress, int totalDays) {
    return SizedBox(
      width: 50,
      height: 36,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '$progress/$totalDays',
          style: TextStyle(
            fontSize: 11,
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNextDayButton(
    BattleState state,
    Battle notifier,
    BuildContext context,
  ) {
    final phaseText = state.phase == TrainingPhase.opening ? '看盘' : '收盘';

    return SizedBox(
      width: 50,
      height: 36,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: () {
          if (state.phase == TrainingPhase.opening) {
            notifier.setPhase(TrainingPhase.closing);
          } else {
            notifier.nextDay();
          }
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            phaseText,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
