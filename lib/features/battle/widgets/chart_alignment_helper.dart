import 'package:flutter/material.dart';

class ChartAlignmentHelper {
  static double indexToX(int index, int totalCount, double chartWidth) {
    if (totalCount <= 0) return 0;
    if (index < 0) return 0;
    final candleWidth = chartWidth / totalCount;
    return (index + 0.5) * candleWidth;
  }

  static int xToIndex(double x, int totalCount, double chartWidth) {
    if (chartWidth <= 0 || totalCount <= 0) return 0;
    if (x < 0) return 0;
    final candleWidth = chartWidth / totalCount;
    return (x / candleWidth).floor().clamp(0, totalCount - 1);
  }

  static double calculateBarWidth(int totalCount, double chartWidth, double ratio) {
    if (totalCount <= 0) return 0;
    final candleWidth = chartWidth / totalCount;
    return candleWidth * ratio;
  }

  static double calculateCandleWidth(int totalCount, double chartWidth, {double ratio = 0.7}) {
    return calculateBarWidth(totalCount, chartWidth, ratio);
  }

  static Offset indexToOffset(int index, int totalCount, double chartWidth, double y) {
    return Offset(indexToX(index, totalCount, chartWidth), y);
  }

  static Rect calculateBarRect(int index, int totalCount, double chartWidth, double height, {double ratio = 0.7}) {
    final barWidth = calculateBarWidth(totalCount, chartWidth, ratio);
    final x = indexToX(index, totalCount, chartWidth) - barWidth / 2;
    return Rect.fromLTWH(x, 0, barWidth, height);
  }

  static bool isIndexInRange(int index, int totalCount) {
    return index >= 0 && index < totalCount;
  }

  static int clampIndex(int index, int totalCount) {
    return index.clamp(0, totalCount > 0 ? totalCount - 1 : 0);
  }

  static double calculateInterval(int totalCount, double chartWidth) {
    if (totalCount <= 1) return chartWidth;
    return chartWidth / totalCount;
  }
}