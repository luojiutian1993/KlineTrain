import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/models/battle_state.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class StockInfoBar extends ConsumerWidget {
  const StockInfoBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(battleProvider);

    final currentData = state.currentKline;
    final prevClose = state.previousClose;

    double basePrice;
    String priceLabel;

    if (state.phase == TrainingPhase.opening) {
      basePrice = currentData?.open ?? 0;
      priceLabel = '开';
    } else {
      basePrice = currentData?.close ?? 0;
      priceLabel = '收';
    }

    final double change = prevClose > 0 ? (basePrice - prevClose) : 0.0;
    final double changePercent =
        prevClose > 0 ? (change / prevClose * 100) : 0.0;
    final isUp = change >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                state.currentSymbolName.isNotEmpty
                    ? state.currentSymbolName
                    : state.currentSymbol,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                state.currentSymbol,
                style: TextStyle(fontSize: 10, color: AppTheme.muted),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPriceSection(
                  basePrice, priceLabel, change, changePercent, isUp),
              const SizedBox(width: 12),
              _buildHighLowSection(currentData, state.phase),
              const SizedBox(width: 12),
              _buildOpenTurnoverSection(currentData, state.phase),
              const SizedBox(width: 12),
              _buildCirculationMarketSection(),
              const SizedBox(width: 12),
              _buildVolumeAmountSection(currentData, state.phase),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(double price, String label, double change,
      double changePercent, bool isUp) {
    final color = isUp ? Colors.red : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              price > 0 ? price.toStringAsFixed(2) : '--',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 10, color: AppTheme.muted)),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              change != double.infinity
                  ? '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}'
                  : '--',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              changePercent != double.infinity
                  ? '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%'
                  : '--',
              style: TextStyle(fontSize: 10, color: color),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHighLowSection(KlineModel? currentData, TrainingPhase phase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem(
          '高',
          phase == TrainingPhase.opening
              ? '--'
              : (currentData?.high.toStringAsFixed(2) ?? '--'),
        ),
        const SizedBox(height: 4),
        _buildInfoItem(
          '低',
          phase == TrainingPhase.opening
              ? '--'
              : (currentData?.low.toStringAsFixed(2) ?? '--'),
        ),
      ],
    );
  }

  Widget _buildOpenTurnoverSection(
      KlineModel? currentData, TrainingPhase phase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem('开', currentData?.open.toStringAsFixed(2) ?? '--'),
        const SizedBox(height: 4),
        _buildInfoItem(
          '换',
          phase == TrainingPhase.opening
              ? '--'
              : '${currentData?.turnoverRate?.toStringAsFixed(2) ?? '--'}%',
        ),
      ],
    );
  }

  Widget _buildCirculationMarketSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem('流通', '7.33亿'),
        const SizedBox(height: 4),
        _buildInfoItem('市值', '--'),
      ],
    );
  }

  Widget _buildVolumeAmountSection(
      KlineModel? currentData, TrainingPhase phase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem(
          '量',
          phase == TrainingPhase.opening
              ? '--'
              : (currentData != null
                  ? _formatVolume(currentData.volume)
                  : '--'),
        ),
        const SizedBox(height: 4),
        _buildInfoItem(
          '额',
          phase == TrainingPhase.opening
              ? '--'
              : (currentData != null
                  ? _formatAmount(currentData.amount ?? 0)
                  : '--'),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: AppTheme.muted)),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 100000000) {
      return '${(volume / 100000000).toStringAsFixed(2)}亿';
    } else if (volume >= 10000) {
      return '${(volume / 10000).toStringAsFixed(2)}万';
    }
    return volume.toStringAsFixed(0);
  }

  String _formatAmount(double amount) {
    if (amount >= 100000000) {
      return '${(amount / 100000000).toStringAsFixed(2)}亿';
    } else if (amount >= 10000) {
      return '${(amount / 10000).toStringAsFixed(2)}万';
    }
    return amount.toStringAsFixed(2);
  }
}
