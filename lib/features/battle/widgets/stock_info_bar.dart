import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/models/battle_state.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';

class StockInfoBar extends ConsumerWidget {
  const StockInfoBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(battleProvider);
    final currentKline = state.currentKline;
    final prevClose = state.previousClose;
    final phase = state.phase;

    final isUp = currentKline != null && currentKline.close > prevClose;
    final priceColor = isUp ? Colors.red : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          _buildStockName(state.currentSymbol, state.currentSymbolName),
          const SizedBox(width: 12),
          _buildPriceInfo(currentKline, prevClose, phase, priceColor),
          const SizedBox(width: 12),
          _buildHighLowInfo(currentKline, phase),
          const SizedBox(width: 12),
          _buildOpenTurnover(currentKline, phase),
          const SizedBox(width: 12),
          _buildVolumeAmount(currentKline, phase),
        ],
      ),
    );
  }

  Widget _buildStockName(String symbol, String name) {
    final displayName = name.isNotEmpty ? name : symbol;
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            symbol,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(
    dynamic currentKline,
    double prevClose,
    TrainingPhase phase,
    Color priceColor,
  ) {
    if (phase == TrainingPhase.opening || currentKline == null) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('--', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          SizedBox(height: 2),
          Text('--', style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      );
    }

    final currentPrice = currentKline.close;
    final change = currentPrice - prevClose;
    final changePercent = prevClose > 0 ? (change / prevClose * 100) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          currentPrice.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: priceColor,
          ),
        ),
        Text(
          '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)} (${changePercent.toStringAsFixed(2)}%)',
          style: TextStyle(
            fontSize: 10,
            color: priceColor,
          ),
        ),
      ],
    );
  }

  Widget _buildHighLowInfo(dynamic currentKline, TrainingPhase phase) {
    if (phase == TrainingPhase.opening || currentKline == null) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('高 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('--', style: TextStyle(fontSize: 11)),
            ],
          ),
          Row(
            children: [
              Text('低 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('--', style: TextStyle(fontSize: 11)),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Text('高 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text(
              currentKline.high.toStringAsFixed(2),
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
        Row(
          children: [
            const Text('低 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text(
              currentKline.low.toStringAsFixed(2),
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOpenTurnover(dynamic currentKline, TrainingPhase phase) {
    if (phase == TrainingPhase.opening || currentKline == null) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('开 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('--', style: TextStyle(fontSize: 11)),
            ],
          ),
          Row(
            children: [
              Text('换 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('--', style: TextStyle(fontSize: 11)),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Text('开 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text(
              currentKline.open.toStringAsFixed(2),
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
        Row(
          children: [
            const Text('换 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text(
              '${currentKline.turnoverRate?.toStringAsFixed(2) ?? '--'}%',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVolumeAmount(dynamic currentKline, TrainingPhase phase) {
    if (phase == TrainingPhase.opening || currentKline == null) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('量 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('--', style: TextStyle(fontSize: 11)),
            ],
          ),
          Row(
            children: [
              Text('额 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('--', style: TextStyle(fontSize: 11)),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Text('量 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Flexible(
              child: Text(
                _formatVolume(currentKline.volume ?? 0),
                style: const TextStyle(fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('额 ', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Flexible(
              child: Text(
                _formatAmount(currentKline.amount ?? 0),
                style: const TextStyle(fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 100000000) {
      return '${(volume / 100000000).toStringAsFixed(2)}亿';
    } else if (volume >= 10000) {
      return '${(volume / 10000).toStringAsFixed(2)}万';
    } else {
      return volume.toStringAsFixed(0);
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 100000000) {
      return '${(amount / 100000000).toStringAsFixed(2)}亿';
    } else if (amount >= 10000) {
      return '${(amount / 10000).toStringAsFixed(2)}万';
    } else {
      return amount.toStringAsFixed(2);
    }
  }
}
