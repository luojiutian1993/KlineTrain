import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';

class ControlButtons extends ConsumerWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildControlButton(
          icon: Icons.chevron_left,
          label: '左滑',
          onPressed: () {
            ref.read(battleProvider.notifier).previousDay();
          },
        ),
        const SizedBox(width: 4),
        _buildControlButton(
          icon: Icons.chevron_right,
          label: '右滑',
          onPressed: () {
            ref.read(battleProvider.notifier).nextDay();
          },
        ),
        const SizedBox(width: 4),
        _buildControlButton(
          icon: Icons.zoom_in,
          label: '放大',
          onPressed: () {},
        ),
        const SizedBox(width: 4),
        _buildControlButton(
          icon: Icons.zoom_out,
          label: '缩小',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 44,
      height: 28,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14),
            Text(
              label,
              style: const TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }
}
