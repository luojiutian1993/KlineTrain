import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/models/battle_config.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';

class IndicatorPanel extends ConsumerWidget {
  const IndicatorPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(battleProvider);
    final notifier = ref.read(battleProvider.notifier);

    return Column(
      children: [
        _buildIndicatorSelector(
          '顶部指标',
          state.selectedTopIndicator,
          (value) => notifier.updateTopIndicator(value),
        ),
        const SizedBox(height: 4),
        _buildIndicatorSelector(
          '底部指标',
          state.selectedBottomIndicator,
          (value) => notifier.updateBottomIndicator(value),
        ),
      ],
    );
  }

  Widget _buildIndicatorSelector(
    String label,
    String selectedIndicator,
    Function(String) onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ),
        Expanded(
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<String>(
              value: selectedIndicator,
              isExpanded: true,
              underline: const SizedBox(),
              style: const TextStyle(fontSize: 11),
              items: BattleConfig.indicators.map((indicator) {
                return DropdownMenuItem(
                  value: indicator,
                  child: Text(indicator),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
