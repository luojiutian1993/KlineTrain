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
          context: context,
          icon: Icons.chevron_left,
          label: '左滑',
          onPressed: () {
            final shouldAlert = ref.read(battleProvider.notifier).slideLeft();
            if (shouldAlert) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已到达最左边'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
        const SizedBox(width: 4),
        _buildControlButton(
          context: context,
          icon: Icons.chevron_right,
          label: '右滑',
          onPressed: () {
            final shouldAlert = ref.read(battleProvider.notifier).slideRight();
            if (shouldAlert) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已到达最右边'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
        const SizedBox(width: 4),
        _buildControlButton(
          context: context,
          icon: Icons.zoom_in,
          label: '放大',
          onPressed: () {
            final shouldAlert = ref.read(battleProvider.notifier).zoomIn();
            if (shouldAlert) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已达到最大放大级别'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
        const SizedBox(width: 4),
        _buildControlButton(
          context: context,
          icon: Icons.zoom_out,
          label: '缩小',
          onPressed: () {
            final shouldAlert = ref.read(battleProvider.notifier).zoomOut();
            if (shouldAlert) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已达到最小缩放级别'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
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
