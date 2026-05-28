import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';

class AssetPanel extends ConsumerWidget {
  const AssetPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(battleProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBalanceInfo(state.accountBalance),
          if (state.hasPosition) ...[
            const SizedBox(width: 8),
            _buildPositionInfo(
              state.positionQuantity,
              state.positionCost,
              state.profitRate,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceInfo(double balance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '¥${balance.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          '可用',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPositionInfo(
    double quantity,
    double cost,
    double profitRate,
  ) {
    final profitColor = profitRate >= 0 ? Colors.red : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${quantity.toStringAsFixed(0)}股 / ${cost.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          '盈亏 ${profitRate >= 0 ? '+' : ''}${profitRate.toStringAsFixed(2)}%',
          style: TextStyle(
            fontSize: 10,
            color: profitColor,
          ),
        ),
      ],
    );
  }
}
