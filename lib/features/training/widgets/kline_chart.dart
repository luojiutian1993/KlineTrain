import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kline_trainer/data/models/trade_point_model.dart'
    show TradePoint;

class KlineChart extends StatelessWidget {
  final List<KlineData> klineData;
  final List<double>? ma5;
  final List<double>? ma10;
  final List<double>? ma20;
  final List<double>? ma30;
  final List<VolumeData> volumes;
  final List<MacdData> macdData;
  final List<TradePoint>? tradePoints;
  final double? currentOpenPrice;
  final double? positionCost;

  const KlineChart({
    super.key,
    required this.klineData,
    this.ma5,
    this.ma10,
    this.ma20,
    this.ma30,
    required this.volumes,
    required this.macdData,
    this.tradePoints,
    this.currentOpenPrice,
    this.positionCost,
  });

  @override
  Widget build(BuildContext context) {
    if (klineData.isEmpty && volumes.isEmpty && macdData.isEmpty) {
      return const Center(
        child: Text('暂无数据'),
      );
    }

    return _buildPriceChart();
  }

  Widget _buildPriceChart() {
    double minPrice = double.infinity;
    double maxPrice = double.negativeInfinity;

    for (var data in klineData) {
      if (data.low < minPrice) minPrice = data.low;
      if (data.high > maxPrice) maxPrice = data.high;
    }

    if (tradePoints != null) {
      for (var point in tradePoints!) {
        if (point.price < minPrice) minPrice = point.price;
        if (point.price > maxPrice) maxPrice = point.price;
      }
    }

    return ClipRect(
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
              tradePoints: tradePoints,
              currentOpenPrice: currentOpenPrice,
              positionCost: positionCost,
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
          if (ma5 != null && ma5!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'MA5: ${ma5!.last.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 10, color: Colors.yellow),
              ),
            ),
          if (ma10 != null && ma10!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'MA10: ${ma10!.last.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 10, color: Colors.purple),
              ),
            ),
          if (ma20 != null && ma20!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'MA20: ${ma20!.last.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 10, color: Colors.orange),
              ),
            ),
          if (ma30 != null && ma30!.isNotEmpty)
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
    final maxVolume =
        volumes.map((v) => v.volume).reduce((a, b) => a > b ? a : b);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxVolume * 1.2,
              barTouchData: BarTouchData(enabled: false),
              titlesData: const FlTitlesData(
                show: false,
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxVolume / 4,
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
    );
  }

  Widget _buildMacdChart() {
    double maxMacd = macdData
        .map((m) => m.macd)
        .reduce((a, b) => a.abs() > b.abs() ? a : b)
        .abs();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxMacd * 1.2,
              minY: -maxMacd * 1.2,
              barTouchData: BarTouchData(enabled: false),
              titlesData: const FlTitlesData(
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
                          color:
                              entry.value.macd > 0 ? Colors.red : Colors.green,
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
  final List<TradePoint>? tradePoints;
  final double? currentOpenPrice;
  final double? positionCost;

  const CandleStickChart({
    super.key,
    required this.klineData,
    this.ma5,
    this.ma10,
    this.ma20,
    this.ma30,
    required this.minY,
    required this.maxY,
    this.tradePoints,
    this.currentOpenPrice,
    this.positionCost,
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
              tradePoints: tradePoints,
              currentOpenPrice: currentOpenPrice,
              positionCost: positionCost,
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
  final List<TradePoint>? tradePoints;
  final double? currentOpenPrice;
  final double? positionCost;

  const CandleStickChartPainter({
    super.key,
    required this.klineData,
    this.ma5,
    this.ma10,
    this.ma20,
    this.ma30,
    required this.minY,
    required this.maxY,
    this.tradePoints,
    this.currentOpenPrice,
    this.positionCost,
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
        tradePoints: tradePoints,
        currentOpenPrice: currentOpenPrice,
        positionCost: positionCost,
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
  final List<TradePoint>? tradePoints;
  final double? currentOpenPrice;
  final double? positionCost;

  _CandleStickPainter({
    required this.klineData,
    this.ma5,
    this.ma10,
    this.ma20,
    this.ma30,
    required this.minY,
    required this.maxY,
    this.tradePoints,
    this.currentOpenPrice,
    this.positionCost,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (klineData.isEmpty) return;

    final double candleWidth = size.width / klineData.length;
    final double priceRange = maxY - minY;

    for (int i = 0; i < klineData.length; i++) {
      final data = klineData[i];
      final double x = i * candleWidth + candleWidth / 2;
      final double openY =
          size.height - ((data.open - minY) / priceRange) * size.height;
      final double closeY =
          size.height - ((data.close - minY) / priceRange) * size.height;
      final double highY =
          size.height - ((data.high - minY) / priceRange) * size.height;
      final double lowY =
          size.height - ((data.low - minY) / priceRange) * size.height;

      final bool isUp = data.close >= data.open;
      final paint = Paint()
        ..color = isUp ? Colors.red : Colors.green
        ..strokeWidth = 1
        ..isAntiAlias = true;

      canvas.drawLine(Offset(x, highY), Offset(x, lowY), paint);

      final rectPaint = Paint()
        ..color = isUp ? Colors.red : Colors.green
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

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

    if (ma5 != null) _drawSmoothLine(canvas, size, ma5!, Colors.yellow);
    if (ma10 != null) _drawSmoothLine(canvas, size, ma10!, Colors.purple);
    if (ma20 != null) _drawSmoothLine(canvas, size, ma20!, Colors.orange);
    if (ma30 != null) _drawSmoothLine(canvas, size, ma30!, Colors.blue);

    if (currentOpenPrice != null) {
      _drawHorizontalDashedLine(
          canvas, size, currentOpenPrice!, const Color(0xFF3B82F6));
    }

    if (positionCost != null && positionCost! > 0) {
      _drawHorizontalDashedLine(
          canvas, size, positionCost!, const Color(0xFFEF4444));
    }

    if (tradePoints != null && tradePoints!.isNotEmpty) {
      _drawTradePoints(canvas, size);
    }
  }

  void _drawSmoothLine(
      Canvas canvas, Size size, List<double> values, Color color) {
    if (klineData.isEmpty || values.isEmpty) return;

    final double candleWidth = size.width / klineData.length;
    final double priceRange = maxY - minY;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    bool started = false;
    int startIndex = 0;

    for (int i = 0; i < values.length && i < klineData.length; i++) {
      if (values[i] == 0 || values[i].isNaN) continue;

      final x = i * candleWidth + candleWidth / 2;
      final y = size.height - ((values[i] - minY) / priceRange) * size.height;

      if (!started) {
        path.moveTo(x, y);
        started = true;
        startIndex = i;
      } else {
        final prevX = (i - 1) * candleWidth + candleWidth / 2;
        final prevY =
            size.height - ((values[i - 1] - minY) / priceRange) * size.height;
        final cpX = (prevX + x) / 2;
        path.quadraticBezierTo(prevX, prevY, cpX, (prevY + y) / 2);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  void _drawTradePoints(Canvas canvas, Size size) {
    if (klineData.isEmpty || tradePoints == null || tradePoints!.isEmpty)
      return;

    final double candleWidth = size.width / klineData.length;
    final double priceRange = maxY - minY;
    const double fixedDashedLength = 30.0;
    const double dashedDashWidth = 3.0;
    const double dashedDashSpace = 2.0;

    for (var point in tradePoints!) {
      if (point.index >= klineData.length) continue;

      final x = point.index * candleWidth + candleWidth / 2;
      final kline = klineData[point.index];

      double startY;
      if (point.isBuy) {
        startY = size.height - ((kline.high - minY) / priceRange) * size.height;
      } else {
        startY = size.height - ((kline.low - minY) / priceRange) * size.height;
      }

      final dashedPaint = Paint()
        ..color = const Color(0xFF3B82F6)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      double currentY = startY;
      double labelY = startY;
      if (point.isBuy) {
        double drawnLength = 0;
        while (drawnLength < fixedDashedLength && currentY > 0) {
          canvas.drawLine(
            Offset(x, currentY),
            Offset(x, (currentY - dashedDashWidth).clamp(0, size.height)),
            dashedPaint,
          );
          currentY -= dashedDashWidth + dashedDashSpace;
          drawnLength += dashedDashWidth + dashedDashSpace;
        }
        labelY = currentY;
      } else {
        double drawnLength = 0;
        while (drawnLength < fixedDashedLength && currentY < size.height) {
          canvas.drawLine(
            Offset(x, currentY),
            Offset(x, (currentY + dashedDashWidth).clamp(0, size.height)),
            dashedPaint,
          );
          currentY += dashedDashWidth + dashedDashSpace;
          drawnLength += dashedDashWidth + dashedDashSpace;
        }
        labelY = currentY;
      }

      final label = point.isBuy ? 'B' : 'S';
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color:
                point.isBuy ? const Color(0xFFEF4444) : const Color(0xFF34C759),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelBgWidth = textPainter.width + 6;
      final labelBgHeight = textPainter.height + 4;
      final labelBgX = x - labelBgWidth / 2;
      final labelBgY = point.isBuy ? labelY - labelBgHeight : labelY;

      final bgPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      final bgBorderPaint = Paint()
        ..color =
            point.isBuy ? const Color(0xFFEF4444) : const Color(0xFF34C759)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(
        Rect.fromLTWH(labelBgX, labelBgY, labelBgWidth, labelBgHeight),
        bgPaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(labelBgX, labelBgY, labelBgWidth, labelBgHeight),
        bgBorderPaint,
      );

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, labelBgY + 2),
      );
    }
  }

  void _drawHorizontalDashedLine(
      Canvas canvas, Size size, double price, Color color) {
    final priceRange = maxY - minY;
    final y = size.height - ((price - minY) / priceRange) * size.height;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
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
