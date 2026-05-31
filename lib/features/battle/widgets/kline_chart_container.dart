import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';

class KlineChartContainer extends ConsumerStatefulWidget {
  const KlineChartContainer({super.key});

  @override
  ConsumerState<KlineChartContainer> createState() =>
      _KlineChartContainerState();
}

class _KlineChartContainerState extends ConsumerState<KlineChartContainer> {
  double _lastScale = 1.0;
  DateTime? _lastGestureTime;
  static const _throttleDuration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(battleProvider);
    final notifier = ref.read(battleProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.grey[200]!, width: 0.5)),
      ),
      child: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        onHorizontalDragStart: _onHorizontalDragStart,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        child: KlineChart(
          klineData: notifier.displayKlineData,
          ma5: notifier.ma5Data,
          ma10: notifier.ma10Data,
          ma30: notifier.ma30Data,
          volumes: notifier.displayVolumes,
          macdData: notifier.displayMacdData,
          tradePoints: notifier.visibleTradePoints,
          currentOpenPrice: state.currentKline?.open,
          positionCost: state.hasPosition ? state.positionCost : null,
        ),
      ),
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastScale = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (!_shouldProcessGesture()) return;

    final scaleDelta = details.scale / _lastScale;
    _lastScale = details.scale;

    if (scaleDelta > 1.05) {
      final shouldAlert = ref.read(battleProvider.notifier).zoomOut();
      if (shouldAlert) _showBoundaryAlert('已达到最小缩放级别');
    } else if (scaleDelta < 0.95) {
      final shouldAlert = ref.read(battleProvider.notifier).zoomIn();
      if (shouldAlert) _showBoundaryAlert('已达到最大放大级别');
    }

    _lastGestureTime = DateTime.now();
  }

  void _onHorizontalDragStart(DragStartDetails details) {}

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!_shouldProcessGesture()) return;

    final delta = details.primaryDelta ?? 0;
    final threshold = 20.0;

    if (delta > threshold) {
      final shouldAlert = ref.read(battleProvider.notifier).slideRight();
      if (shouldAlert) _showBoundaryAlert('已到达最右边');
    } else if (delta < -threshold) {
      final shouldAlert = ref.read(battleProvider.notifier).slideLeft();
      if (shouldAlert) _showBoundaryAlert('已到达最左边');
    }

    _lastGestureTime = DateTime.now();
  }

  bool _shouldProcessGesture() {
    if (_lastGestureTime == null) return true;
    final diff = DateTime.now().difference(_lastGestureTime!);
    return diff >= _throttleDuration;
  }

  void _showBoundaryAlert(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
