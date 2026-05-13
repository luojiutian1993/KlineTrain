import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class KlineChart extends StatelessWidget {
  final List<KlineData> klineData;
  final List<double>? ma5;
  final List<double>? ma10;
  final List<double>? ma20;
  final List<double>? ma30;
  final List<VolumeData> volumes;
  final List<MacdData> macdData;

  const KlineChart({
    super.key,
    required this.klineData,
    this.ma5,
    this.ma10,
    this.ma20,
    this.ma30,
    required this.volumes,
    required this.macdData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPriceChart(),
        const SizedBox(height: 8),
        _buildVolumeChart(),
        const SizedBox(height: 8),
        _buildMacdChart(),
      ],
    );
  }

  Widget _buildPriceChart() {
    double minPrice = double.infinity;
    double maxPrice = double.negativeInfinity;

    for (var data in klineData) {
      if (data.low < minPrice) minPrice = data.low;
      if (data.high > maxPrice) maxPrice = data.high;
    }

    return SizedBox(
      height: 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CandleStickChart(
              klineData: klineData,
              ma5: ma5,
              ma10: ma10,
              ma20: ma20,
              ma30: ma30,
              minY: minPrice * 0.98,
              maxY: maxPrice * 1.02,
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: _buildPriceLegend(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ma5 != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'MA5: ${ma5!.last.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 10, color: Colors.yellow),
              ),
            ),
          if (ma10 != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'MA10: ${ma10!.last.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 10, color: Colors.purple),
              ),
            ),
          if (ma20 != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'MA20: ${ma20!.last.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 10, color: Colors.orange),
              ),
            ),
          if (ma30 != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'MA30: ${ma30!.last.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 10, color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVolumeChart() {
    return SizedBox(
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: volumes.map((v) => v.volume).reduce((a, b) => a > b ? a : b) * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: false,
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (volumes.map((v) => v.volume).reduce((a, b) => a > b ? a : b)) / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                barGroups: volumes
                    .asMap()
                    .entries
                    .map(
                      (entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.volume,
                            color: entry.value.isUp ? Colors.red : Colors.green,
                            width: 4,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                '成交量',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacdChart() {
    double maxMacd = macdData.map((m) => m.macd).reduce((a, b) => a.abs() > b.abs() ? a : b).abs();

    return SizedBox(
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxMacd * 1.2,
                minY: -maxMacd * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: false,
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxMacd / 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                barGroups: macdData
                    .asMap()
                    .entries
                    .map(
                      (entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.macd,
                            color: entry.value.macd > 0 ? Colors.red : Colors.green,
                            width: 3,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'MACD',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CandleStickChart extends StatelessWidget {
  final List<KlineData> klineData;
  final List<double>? ma5;
  final List<double>? ma10;
  final List<double>? ma20;
  final List<double>? ma30;
  final double minY;
  final double maxY;

  const CandleStickChart({
    super.key,
    required this.klineData,
    this.ma5,
    this.ma10,
    this.ma20,
    this.ma30,
    required this.minY,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: 280,
        child: Stack(
          children: [
            CandleStickChartPainter(
              klineData: klineData,
              ma5: ma5,
              ma10: ma10,
              ma20: ma20,
              ma30: ma30,
              minY: minY,
              maxY: maxY,
            ),
          ],
        ),
      ),
    );
  }
}

class CandleStickChartPainter extends StatelessWidget {
  final List<KlineData> klineData;
  final List<double>? ma5;
  final List<double>? ma10;
  final List<double>? ma20;
  final List<double>? ma30;
  final double minY;
  final double maxY;

  const CandleStickChartPainter({
    super.key,
    required this.klineData,
    this.ma5,
    this.ma10,
    this.ma20,
    this.ma30,
    required this.minY,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _CandleStickPainter(
        klineData: klineData,
        ma5: ma5,
        ma10: ma10,
        ma20: ma20,
        ma30: ma30,
        minY: minY,
        maxY: maxY,
      ),
    );
  }
}

class _CandleStickPainter extends CustomPainter {
  final List<KlineData> klineData;
  final List<double>? ma5;
  final List<double>? ma10;
  final List<double>? ma20;
  final List<double>? ma30;
  final double minY;
  final double maxY;

  _CandleStickPainter({
    required this.klineData,
    this.ma5,
    this.ma10,
    this.ma20,
    this.ma30,
    required this.minY,
    required this.maxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double candleWidth = size.width / klineData.length;
    final double priceRange = maxY - minY;

    for (int i = 0; i < klineData.length; i++) {
      final data = klineData[i];
      final double x = i * candleWidth + candleWidth / 2;
      final double openY = size.height - ((data.open - minY) / priceRange) * size.height;
      final double closeY = size.height - ((data.close - minY) / priceRange) * size.height;
      final double highY = size.height - ((data.high - minY) / priceRange) * size.height;
      final double lowY = size.height - ((data.low - minY) / priceRange) * size.height;

      final bool isUp = data.close >= data.open;
      final paint = Paint()
        ..color = isUp ? Colors.red : Colors.green
        ..strokeWidth = 1;

      canvas.drawLine(Offset(x, highY), Offset(x, lowY), paint);

      final rectPaint = Paint()
        ..color = isUp ? Colors.red : Colors.green
        ..style = PaintingStyle.fill;

      final rectHeight = (closeY - openY).abs();
      final rectTop = isUp ? openY : closeY;
      final rectWidth = candleWidth * 0.6;

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, rectTop + rectHeight / 2),
          width: rectWidth,
          height: rectHeight > 1 ? rectHeight : 1,
        ),
        rectPaint,
      );
    }

    if (ma5 != null) _drawLine(canvas, size, ma5!, Colors.yellow);
    if (ma10 != null) _drawLine(canvas, size, ma10!, Colors.purple);
    if (ma20 != null) _drawLine(canvas, size, ma20!, Colors.orange);
    if (ma30 != null) _drawLine(canvas, size, ma30!, Colors.blue);
  }

  void _drawLine(Canvas canvas, Size size, List<double> values, Color color) {
    final double candleWidth = size.width / klineData.length;
    final double priceRange = maxY - minY;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool started = false;

    for (int i = 0; i < values.length && i < klineData.length; i++) {
      final x = i * candleWidth + candleWidth / 2;
      final y = size.height - ((values[i] - minY) / priceRange) * size.height;

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
  bool shouldRepaint(covariant _CandleStickPainter oldDelegate) => true;
}

class KlineData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  KlineData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}

class VolumeData {
  final double volume;
  final bool isUp;

  VolumeData({
    required this.volume,
    required this.isUp,
  });
}

class MacdData {
  final double macd;
  final double diff;
  final double dea;

  MacdData({
    required this.macd,
    required this.diff,
    required this.dea,
  });
}
