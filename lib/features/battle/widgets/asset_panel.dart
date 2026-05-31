import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';
import 'package:kline_trainer/shared/constants/app_colors.dart';

class AssetPanel extends ConsumerWidget {
  const AssetPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(battleProvider);

    final profitColor = state.totalProfitLoss >= 0 ? Colors.red : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: const BoxDecoration(
        border:
            Border(top: BorderSide(color: AppColors.borderGray, width: 0.5)),
      ),
      child: Row(
        children: [
          _buildInfoItem('市值', state.marketValue.toStringAsFixed(2)),
          const SizedBox(width: 12),
          _buildInfoItem('盈亏',
              '${state.totalProfitLoss >= 0 ? '+' : ''}${state.totalProfitLoss.toStringAsFixed(2)}',
              color: profitColor),
          const SizedBox(width: 12),
          _buildInfoItem('持仓/可用',
              '${state.positionQuantity.toStringAsFixed(0)}/${state.positionQuantity.toStringAsFixed(0)}'),
          const SizedBox(width: 12),
          _buildInfoItem('成本/现价',
              '${state.positionCost.toStringAsFixed(2)}/${state.currentPrice.toStringAsFixed(2)}'),
          const SizedBox(width: 12),
          _buildInfoItem('总资产/可用',
              '${state.totalAssets.toStringAsFixed(0)}/${state.accountBalance.toStringAsFixed(0)}'),
          const SizedBox(width: 12),
          _buildInfoItem('总盈亏',
              '${state.profitRate >= 0 ? '+' : ''}${state.profitRate.toStringAsFixed(2)}%',
              color: profitColor),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 10, color: color ?? Colors.black),
        ),
      ],
    );
  }
}
