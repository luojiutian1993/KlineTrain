import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/market_provider.dart';
import '../../../shared/constants/market_sectors.dart';
import '../../../theme/app_theme.dart';

class MarketSectorSelector extends ConsumerWidget {
  const MarketSectorSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketState = ref.watch(marketProvider);
    final selectedSector = marketState.selectedSector;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择市场',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.muted,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedSector?.id,
            hint: const Text('请选择市场板块'),
            isExpanded: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
            icon: const Icon(Icons.arrow_drop_down, color: AppTheme.muted),
            items: MarketSectors.allSectors.map((sector) {
              return DropdownMenuItem<String>(
                value: sector.id,
                child: Row(
                  children: [
                    Text(
                      sector.icon,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        sector.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      sector.marketType.label,
                      style: TextStyle(fontSize: 11, color: AppTheme.muted),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(marketProvider.notifier).selectSector(value);
              }
            },
            style: const TextStyle(color: AppTheme.fg),
          ),
        ),
      ],
    );
  }
}