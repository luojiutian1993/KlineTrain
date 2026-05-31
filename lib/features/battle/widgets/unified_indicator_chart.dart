import 'package:flutter/material.dart';
import 'package:kline_trainer/data/models/kline_model.dart';

class VolumeIndicatorChart extends StatelessWidget {
  final List<VolumeData> volumes;
  final double? minY;
  final double? maxY;

  const VolumeIndicatorChart({
    super.key,
    required this.volumes,
    this.minY,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _VolumeIndicatorPainter(
            volumes: volumes,
            chartWidth: constraints.maxWidth,
            chartHeight: constraints.maxHeight,
          ),
        );
      },
    );
  }
}

class _VolumeIndicatorPainter extends CustomPainter {
  final List<VolumeData> volumes;
  final double chartWidth;
  final double chartHeight;

  _VolumeIndicatorPainter({
    required this.volumes,
    required this.chartWidth,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (volumes.isEmpty) return;

    final int dataCount = volumes.length;
    final double candleWidth = chartWidth / dataCount;
    final double centerXOffset = candleWidth / 2;
    final double barWidth = candleWidth * 0.6;

    double maxVolume = 0;
    for (final v in volumes) {
      if (v.volume > maxVolume) maxVolume = v.volume;
    }
    maxVolume = maxVolume > 0 ? maxVolume : 1;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final gridPaint = Paint()
      ..color = Colors.grey.withAlpha(51)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 3; i++) {
      final y = chartHeight * i / 3;
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    final halfBarWidth = barWidth / 2;

    for (int i = 0; i < volumes.length; i++) {
      final volume = volumes[i];
      final x = i * candleWidth + centerXOffset;

      paint.color = volume.isUp ? Colors.red : Colors.green;

      final barHeight = (volume.volume / maxVolume) * chartHeight * 0.9;
      final barTop = chartHeight - barHeight;

      canvas.drawRect(
        Rect.fromLTWH(x - halfBarWidth, barTop, barWidth, barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VolumeIndicatorPainter oldDelegate) {
    return volumes != oldDelegate.volumes;
  }
}

class MacdIndicatorChart extends StatelessWidget {
  final List<MacdData> macdData;

  const MacdIndicatorChart({
    super.key,
    required this.macdData,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _MacdIndicatorPainter(
            macdData: macdData,
            chartWidth: constraints.maxWidth,
            chartHeight: constraints.maxHeight,
          ),
        );
      },
    );
  }
}

class _MacdIndicatorPainter extends CustomPainter {
  final List<MacdData> macdData;
  final double chartWidth;
  final double chartHeight;

  _MacdIndicatorPainter({
    required this.macdData,
    required this.chartWidth,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (macdData.isEmpty) return;

    final int dataCount = macdData.length;
    final double candleWidth = chartWidth / dataCount;
    final double centerXOffset = candleWidth / 2;
    final double barWidth = candleWidth * 0.5;

    double maxMacd = 0;
    double maxDiff = 0;
    double maxDea = 0;
    for (final m in macdData) {
      if (m.macd.abs() > maxMacd) maxMacd = m.macd.abs();
      if (m.diff.abs() > maxDiff) maxDiff = m.diff.abs();
      if (m.dea.abs() > maxDea) maxDea = m.dea.abs();
    }
    final maxValue = [maxMacd, maxDiff, maxDea].reduce((a, b) => a > b ? a : b);
    final effectiveMax = maxValue > 0 ? maxValue : 1.0;

    final gridPaint = Paint()
      ..color = Colors.grey.withAlpha(51)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 3; i++) {
      final y = chartHeight * i / 3;
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    final zeroY = chartHeight / 2;
    canvas.drawLine(Offset(0, zeroY), Offset(chartWidth, zeroY), gridPaint);

    final barPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final halfBarWidth = barWidth / 2;

    for (int i = 0; i < macdData.length; i++) {
      final m = macdData[i];
      final x = i * candleWidth + centerXOffset;

      barPaint.color = m.macd >= 0 ? Colors.red : Colors.green;

      final barHeight = (m.macd.abs() / effectiveMax) * chartHeight * 0.45;
      final barTop = zeroY - (m.macd >= 0 ? barHeight : 0);

      canvas.drawRect(
        Rect.fromLTWH(x - halfBarWidth, barTop, barWidth, barHeight),
        barPaint,
      );
    }

    _drawSmoothLine(canvas, macdData.map((m) => m.diff).toList(), Colors.blue, effectiveMax, candleWidth, centerXOffset);
    _drawSmoothLine(canvas, macdData.map((m) => m.dea).toList(), Colors.orange, effectiveMax, candleWidth, centerXOffset);
  }

  void _drawSmoothLine(Canvas canvas, List<double> values, Color color, double maxValue, double candleWidth, double centerXOffset) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    bool started = false;

    final zeroY = chartHeight / 2;

    for (int i = 0; i < values.length; i++) {
      final value = values[i];
      if (value.isNaN || value.isInfinite) continue;

      final x = i * candleWidth + centerXOffset;
      final y = zeroY - (value / maxValue) * chartHeight * 0.45;

      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _MacdIndicatorPainter oldDelegate) {
    return macdData != oldDelegate.macdData;
  }
}

class KdjIndicatorChart extends StatelessWidget {
  final List<KdjData> kdjData;

  const KdjIndicatorChart({
    super.key,
    required this.kdjData,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _KdjIndicatorPainter(
            kdjData: kdjData,
            chartWidth: constraints.maxWidth,
            chartHeight: constraints.maxHeight,
          ),
        );
      },
    );
  }
}

class _KdjIndicatorPainter extends CustomPainter {
  final List<KdjData> kdjData;
  final double chartWidth;
  final double chartHeight;

  _KdjIndicatorPainter({
    required this.kdjData,
    required this.chartWidth,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (kdjData.isEmpty) return;

    final int dataCount = kdjData.length;
    final double candleWidth = chartWidth / dataCount;
    final double centerXOffset = candleWidth / 2;

    final gridPaint = Paint()
      ..color = Colors.grey.withAlpha(51)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 3; i++) {
      final y = chartHeight * i / 3;
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    _drawSmoothLine(canvas, kdjData.map((k) => k.k).toList(), Colors.blue, candleWidth, centerXOffset);
    _drawSmoothLine(canvas, kdjData.map((k) => k.d).toList(), Colors.orange, candleWidth, centerXOffset);
    _drawSmoothLine(canvas, kdjData.map((k) => k.j).toList(), Colors.purple, candleWidth, centerXOffset);
  }

  void _drawSmoothLine(Canvas canvas, List<double> values, Color color, double candleWidth, double centerXOffset) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    bool started = false;

    for (int i = 0; i < values.length; i++) {
      final value = values[i];
      if (value.isNaN || value.isInfinite) continue;

      final x = i * candleWidth + centerXOffset;
      final y = chartHeight - (value / 100) * chartHeight;

      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _KdjIndicatorPainter oldDelegate) {
    return kdjData != oldDelegate.kdjData;
  }
}

class RsiIndicatorChart extends StatelessWidget {
  final List<double> rsiData;

  const RsiIndicatorChart({
    super.key,
    required this.rsiData,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _RsiIndicatorPainter(
            rsiData: rsiData,
            chartWidth: constraints.maxWidth,
            chartHeight: constraints.maxHeight,
          ),
        );
      },
    );
  }
}

class _RsiIndicatorPainter extends CustomPainter {
  final List<double> rsiData;
  final double chartWidth;
  final double chartHeight;

  _RsiIndicatorPainter({
    required this.rsiData,
    required this.chartWidth,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (rsiData.isEmpty) return;

    final int dataCount = rsiData.length;
    final double candleWidth = chartWidth / dataCount;
    final double centerXOffset = candleWidth / 2;

    final gridPaint = Paint()
      ..color = Colors.grey.withAlpha(51)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 3; i++) {
      final y = chartHeight * i / 3;
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    bool started = false;

    for (int i = 0; i < rsiData.length; i++) {
      final value = rsiData[i];
      if (value.isNaN || value.isInfinite) continue;

      final x = i * candleWidth + centerXOffset;
      final y = chartHeight - (value / 100) * chartHeight;

      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _RsiIndicatorPainter oldDelegate) {
    return rsiData != oldDelegate.rsiData;
  }
}

class BollIndicatorChart extends StatelessWidget {
  final List<BollData> bollData;

  const BollIndicatorChart({
    super.key,
    required this.bollData,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _BollIndicatorPainter(
            bollData: bollData,
            chartWidth: constraints.maxWidth,
            chartHeight: constraints.maxHeight,
          ),
        );
      },
    );
  }
}

class _BollIndicatorPainter extends CustomPainter {
  final List<BollData> bollData;
  final double chartWidth;
  final double chartHeight;

  _BollIndicatorPainter({
    required this.bollData,
    required this.chartWidth,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (bollData.isEmpty) return;

    final int dataCount = bollData.length;
    final double candleWidth = chartWidth / dataCount;
    final double centerXOffset = candleWidth / 2;

    double maxVal = 0;
    double minVal = double.infinity;
    for (final b in bollData) {
      if (b.up > maxVal) maxVal = b.up;
      if (b.mb > maxVal) maxVal = b.mb;
      if (b.up > maxVal) maxVal = b.up;
      if (b.dn < minVal) minVal = b.dn;
      if (b.mb < minVal) minVal = b.mb;
      if (b.dn < minVal) minVal = b.dn;
    }

    if (minVal == double.infinity) minVal = 0;
    final range = maxVal - minVal;
    final effectiveRange = range > 0 ? range : 1.0;
    final padding = effectiveRange * 0.1;

    _drawSmoothLine(canvas, bollData.map((b) => b.up).toList(), Colors.red, minVal, effectiveRange, padding, candleWidth, centerXOffset);
    _drawSmoothLine(canvas, bollData.map((b) => b.mb).toList(), Colors.blue, minVal, effectiveRange, padding, candleWidth, centerXOffset);
    _drawSmoothLine(canvas, bollData.map((b) => b.dn).toList(), Colors.green, minVal, effectiveRange, padding, candleWidth, centerXOffset);
  }

  void _drawSmoothLine(Canvas canvas, List<double> values, Color color, double minVal, double effectiveRange, double padding, double candleWidth, double centerXOffset) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    bool started = false;

    for (int i = 0; i < values.length; i++) {
      final value = values[i];
      if (value.isNaN || value.isInfinite) continue;

      final x = i * candleWidth + centerXOffset;
      final y = chartHeight - ((value - minVal + padding) / (effectiveRange + 2 * padding)) * chartHeight;

      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _BollIndicatorPainter oldDelegate) {
    return bollData != oldDelegate.bollData;
  }
}

class LineIndicatorChart extends StatelessWidget {
  final List<List<double>> lineDataList;
  final List<Color> colors;
  final double? minY;
  final double? maxY;

  const LineIndicatorChart({
    super.key,
    required this.lineDataList,
    this.colors = const [Colors.blue, Colors.red, Colors.green],
    this.minY,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _LineIndicatorPainter(
            lineDataList: lineDataList,
            colors: colors,
            minY: minY,
            maxY: maxY,
            chartWidth: constraints.maxWidth,
            chartHeight: constraints.maxHeight,
          ),
        );
      },
    );
  }
}

class _LineIndicatorPainter extends CustomPainter {
  final List<List<double>> lineDataList;
  final List<Color> colors;
  final double? minY;
  final double? maxY;
  final double chartWidth;
  final double chartHeight;

  _LineIndicatorPainter({
    required this.lineDataList,
    required this.colors,
    this.minY,
    this.maxY,
    required this.chartWidth,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (lineDataList.isEmpty || lineDataList[0].isEmpty) return;

    final int dataCount = lineDataList[0].length;
    final double candleWidth = chartWidth / dataCount;
    final double centerXOffset = candleWidth / 2;

    double maxVal = maxY ?? 0.0;
    double minVal = minY ?? 0.0;

    if (maxY == null || minY == null) {
      for (final lineData in lineDataList) {
        for (final v in lineData) {
          if (v > maxVal) maxVal = v;
          if (v < minVal) minVal = v;
        }
      }
    }

    final range = maxVal - minVal;
    final effectiveRange = range > 0 ? range : 1.0;
    final padding = effectiveRange * 0.1;

    final gridPaint = Paint()
      ..color = Colors.grey.withAlpha(51)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 3; i++) {
      final y = chartHeight * i / 3;
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    for (int lineIndex = 0; lineIndex < lineDataList.length; lineIndex++) {
      final lineData = lineDataList[lineIndex];
      final color = colors[lineIndex % colors.length];

      _drawSmoothLine(canvas, lineData, color, minVal, effectiveRange, padding, candleWidth, centerXOffset);
    }
  }

  void _drawSmoothLine(Canvas canvas, List<double> values, Color color, double minVal, double effectiveRange, double padding, double candleWidth, double centerXOffset) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    bool started = false;

    for (int i = 0; i < values.length; i++) {
      final value = values[i];
      if (value.isNaN || value.isInfinite) continue;

      final x = i * candleWidth + centerXOffset;
      final y = chartHeight - ((value - minVal + padding) / (effectiveRange + 2 * padding)) * chartHeight;

      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineIndicatorPainter oldDelegate) {
    return lineDataList != oldDelegate.lineDataList ||
        colors != oldDelegate.colors ||
        minY != oldDelegate.minY ||
        maxY != oldDelegate.maxY;
  }
}