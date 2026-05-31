import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/models/battle_config.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';
import 'package:kline_trainer/features/battle/models/battle_state.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';
import 'package:fl_chart/fl_chart.dart';

class IndicatorPanel extends ConsumerWidget {
  const IndicatorPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(battleProvider);
    final notifier = ref.read(battleProvider.notifier);

    return SizedBox(
      height: 120,
      child: Column(
        children: [
          Expanded(
            child: _buildIndicatorSection(
              context,
              ref,
              state.selectedTopIndicator,
              (value) => notifier.updateTopIndicator(value),
            ),
          ),
          Expanded(
            child: _buildIndicatorSection(
              context,
              ref,
              state.selectedBottomIndicator,
              (value) => notifier.updateBottomIndicator(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorSection(
    BuildContext context,
    WidgetRef ref,
    String selectedIndicator,
    Function(String) onChanged,
  ) {
    final notifier = ref.read(battleProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.grey[200]!, width: 0.5)),
      ),
      child: Column(
        children: [
          _buildIndicatorHeader(selectedIndicator, onChanged),
          _buildIndicatorContent(context, ref, selectedIndicator),
        ],
      ),
    );
  }

  Widget _buildIndicatorHeader(
    String selectedIndicator,
    Function(String) onChanged,
  ) {
    return Row(
      children: [
        Container(
          width: 70,
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<String>(
            value: selectedIndicator,
            isExpanded: true,
            underline: const SizedBox(),
            style: const TextStyle(fontSize: 10, color: Colors.black),
            items: BattleConfig.indicators.map((indicator) {
              return DropdownMenuItem(
                value: indicator,
                child: Text(indicator, style: const TextStyle(fontSize: 10)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final notifier = ref.read(battleProvider.notifier);
              return _buildIndicatorInfo(context, ref, selectedIndicator);
            },
          ),
        ),
        const Icon(Icons.expand_more, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildIndicatorInfo(
      BuildContext context, WidgetRef ref, String indicatorType) {
    final notifier = ref.read(battleProvider.notifier);
    final info = _getIndicatorInfo(indicatorType, notifier);
    return Row(
      children: info.map((item) {
        return Row(
          children: [
            Text(item.label, style: TextStyle(fontSize: 9, color: item.color)),
            Text(item.value, style: TextStyle(fontSize: 9, color: item.color)),
          ],
        );
      }).toList(),
    );
  }

  List<_IndicatorInfoItem> _getIndicatorInfo(
      String indicatorType, Battle notifier) {
    switch (indicatorType) {
      case '成交量':
        final volumes = notifier.displayVolumes;
        final lastVolume =
            volumes.isNotEmpty ? volumes.last.volume.toStringAsFixed(0) : '--';
        return [
          _IndicatorInfoItem(
              label: '量:', value: lastVolume, color: Colors.black),
        ];
      case 'MACD':
        final macdData = notifier.displayMacdData;
        final lastMacd = macdData.isNotEmpty
            ? _IndicatorInfoItem(
                label: 'MACD:',
                value: macdData.last.macd.toStringAsFixed(2),
                color: Colors.blue)
            : _IndicatorInfoItem(
                label: 'MACD:', value: '--', color: Colors.blue);
        final lastDiff = macdData.isNotEmpty
            ? _IndicatorInfoItem(
                label: ' DIFF:',
                value: macdData.last.diff.toStringAsFixed(2),
                color: Colors.red)
            : _IndicatorInfoItem(
                label: ' DIFF:', value: '--', color: Colors.red);
        final lastDea = macdData.isNotEmpty
            ? _IndicatorInfoItem(
                label: ' DEA:',
                value: macdData.last.dea.toStringAsFixed(2),
                color: Colors.green)
            : _IndicatorInfoItem(
                label: ' DEA:', value: '--', color: Colors.green);
        return [
          _IndicatorInfoItem(label: '(12,26,9) ', color: Colors.black),
          lastMacd,
          lastDiff,
          lastDea,
        ];
      case 'KDJ':
        final kdjData = notifier.displayKdjData;
        final lastK = kdjData.isNotEmpty
            ? _IndicatorInfoItem(
                label: 'K:',
                value: kdjData.last.k.toStringAsFixed(1),
                color: Colors.blue)
            : _IndicatorInfoItem(label: 'K:', value: '--', color: Colors.blue);
        final lastD = kdjData.isNotEmpty
            ? _IndicatorInfoItem(
                label: ' D:',
                value: kdjData.last.d.toStringAsFixed(1),
                color: Colors.red)
            : _IndicatorInfoItem(label: ' D:', value: '--', color: Colors.red);
        final lastJ = kdjData.isNotEmpty
            ? _IndicatorInfoItem(
                label: ' J:',
                value: kdjData.last.j.toStringAsFixed(1),
                color: Colors.green)
            : _IndicatorInfoItem(
                label: ' J:', value: '--', color: Colors.green);
        return [
          _IndicatorInfoItem(label: '(9,3,3) ', color: Colors.black),
          lastK,
          lastD,
          lastJ,
        ];
      case 'RSI':
        final rsiData = notifier.displayRsiData;
        final lastRsi = rsiData.isNotEmpty
            ? _IndicatorInfoItem(
                label: 'RSI:',
                value: rsiData.last.toStringAsFixed(1),
                color: Colors.blue)
            : _IndicatorInfoItem(
                label: 'RSI:', value: '--', color: Colors.blue);
        return [
          _IndicatorInfoItem(label: '(14) ', color: Colors.black),
          lastRsi,
        ];
      case 'BOLL':
        final bollData = notifier.displayBollData;
        final lastUp = bollData.isNotEmpty
            ? _IndicatorInfoItem(
                label: '上:',
                value: bollData.last.up.toStringAsFixed(2),
                color: Colors.red)
            : _IndicatorInfoItem(label: '上:', value: '--', color: Colors.red);
        final lastMb = bollData.isNotEmpty
            ? _IndicatorInfoItem(
                label: '中:',
                value: bollData.last.mb.toStringAsFixed(2),
                color: Colors.blue)
            : _IndicatorInfoItem(label: '中:', value: '--', color: Colors.blue);
        final lastDn = bollData.isNotEmpty
            ? _IndicatorInfoItem(
                label: '下:',
                value: bollData.last.dn.toStringAsFixed(2),
                color: Colors.green)
            : _IndicatorInfoItem(label: '下:', value: '--', color: Colors.green);
        return [
          _IndicatorInfoItem(label: '(20) ', color: Colors.black),
          lastUp,
          lastMb,
          lastDn,
        ];
      case 'DMI':
        final dmiData = notifier.displayDmiData;
        final lastPlusDi = dmiData.isNotEmpty
            ? _IndicatorInfoItem(
                label: '+DI:',
                value: dmiData.last.plusDi.toStringAsFixed(1),
                color: Colors.blue)
            : _IndicatorInfoItem(
                label: '+DI:', value: '--', color: Colors.blue);
        final lastMinusDi = dmiData.isNotEmpty
            ? _IndicatorInfoItem(
                label: ' -DI:',
                value: dmiData.last.minusDi.toStringAsFixed(1),
                color: Colors.red)
            : _IndicatorInfoItem(
                label: ' -DI:', value: '--', color: Colors.red);
        final lastAdx = dmiData.isNotEmpty
            ? _IndicatorInfoItem(
                label: ' ADX:',
                value: dmiData.last.adx.toStringAsFixed(1),
                color: Colors.green)
            : _IndicatorInfoItem(
                label: ' ADX:', value: '--', color: Colors.green);
        return [
          _IndicatorInfoItem(label: '(14) ', color: Colors.black),
          lastPlusDi,
          lastMinusDi,
          lastAdx,
        ];
      case 'CCI':
        final cciData = notifier.displayCciData;
        final lastCci = cciData.isNotEmpty
            ? _IndicatorInfoItem(
                label: 'CCI:',
                value: cciData.last.toStringAsFixed(1),
                color: Colors.blue)
            : _IndicatorInfoItem(
                label: 'CCI:', value: '--', color: Colors.blue);
        return [
          _IndicatorInfoItem(label: '(14) ', color: Colors.black),
          lastCci,
        ];
      case 'WR':
        final wrData = notifier.displayWrData;
        final lastWr = wrData.isNotEmpty
            ? _IndicatorInfoItem(
                label: 'WR:',
                value: wrData.last.toStringAsFixed(1),
                color: Colors.blue)
            : _IndicatorInfoItem(label: 'WR:', value: '--', color: Colors.blue);
        return [
          _IndicatorInfoItem(label: '(14) ', color: Colors.black),
          lastWr,
        ];
      case 'OBV':
        final obvData = notifier.displayObvData;
        final lastObv = obvData.isNotEmpty
            ? _IndicatorInfoItem(
                label: 'OBV:',
                value: obvData.last.toStringAsFixed(0),
                color: Colors.blue)
            : _IndicatorInfoItem(
                label: 'OBV:', value: '--', color: Colors.blue);
        return [
          _IndicatorInfoItem(label: '', color: Colors.black),
          lastObv,
        ];
      case 'DMA':
        final dmaData = notifier.displayDmaData;
        final lastDma = dmaData.isNotEmpty
            ? _IndicatorInfoItem(
                label: 'DMA:',
                value: dmaData.last.dma.toStringAsFixed(2),
                color: Colors.blue)
            : _IndicatorInfoItem(
                label: 'DMA:', value: '--', color: Colors.blue);
        final lastAma = dmaData.isNotEmpty
            ? _IndicatorInfoItem(
                label: ' AMA:',
                value: dmaData.last.ama.toStringAsFixed(2),
                color: Colors.red)
            : _IndicatorInfoItem(
                label: ' AMA:', value: '--', color: Colors.red);
        return [
          _IndicatorInfoItem(label: '(10,50,10) ', color: Colors.black),
          lastDma,
          lastAma,
        ];
      case 'BBI':
        final bbiData = notifier.displayBbiData;
        final lastBbi = bbiData.isNotEmpty
            ? _IndicatorInfoItem(
                label: 'BBI:',
                value: bbiData.last.toStringAsFixed(2),
                color: Colors.blue)
            : _IndicatorInfoItem(
                label: 'BBI:', value: '--', color: Colors.blue);
        return [
          _IndicatorInfoItem(label: '', color: Colors.black),
          lastBbi,
        ];
      default:
        return [
          _IndicatorInfoItem(label: '', value: '--', color: Colors.black)
        ];
    }
  }

  Widget _buildIndicatorContent(
      BuildContext context, WidgetRef ref, String indicatorType) {
    final notifier = ref.read(battleProvider.notifier);
    if (indicatorType == '成交量') {
      return _buildVolumeChart(notifier.displayVolumes);
    } else if (indicatorType == 'MACD') {
      return _buildMacdChart(notifier.displayMacdData);
    } else if (indicatorType == 'KDJ') {
      return _buildKdjChart(notifier.displayKdjData);
    } else if (indicatorType == 'RSI') {
      return _buildRsiChart(notifier.displayRsiData);
    } else if (indicatorType == 'BOLL') {
      return _buildBollChart(notifier.displayBollData);
    } else if (indicatorType == 'DMI') {
      return _buildDmiChart(notifier.displayDmiData);
    } else if (indicatorType == 'CCI') {
      return _buildCciChart(notifier.displayCciData);
    } else if (indicatorType == 'WR') {
      return _buildWrChart(notifier.displayWrData);
    } else if (indicatorType == 'OBV') {
      return _buildObvChart(notifier.displayObvData);
    } else if (indicatorType == 'DMA') {
      return _buildDmaChart(notifier.displayDmaData);
    } else if (indicatorType == 'BBI') {
      return _buildBbiChart(notifier.displayBbiData);
    } else {
      return _buildGenericChart(indicatorType);
    }
  }

  Widget _buildVolumeChart(List<VolumeData> volumes) {
    if (volumes.isEmpty) {
      return const Center(child: Text('暂无数据', style: TextStyle(fontSize: 10)));
    }

    final maxVolume =
        volumes.map((v) => v.volume).reduce((a, b) => a > b ? a : b);
    final minVolume = 0.0;

    return Expanded(
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          barGroups: volumes.asMap().entries.map((entry) {
            final index = entry.key;
            final volume = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: volume.volume,
                  color: volume.isUp ? Colors.red : Colors.green,
                  width: 4,
                  borderRadius: const BorderRadius.all(Radius.circular(1)),
                ),
              ],
            );
          }).toList(),
          minY: minVolume,
          maxY: maxVolume * 1.1,
          alignment: BarChartAlignment.center,
        ),
      ),
    );
  }

  Widget _buildMacdChart(List<MacdData> macdData) {
    if (macdData.isEmpty) {
      return const Center(child: Text('暂无数据', style: TextStyle(fontSize: 10)));
    }

    final maxValue =
        macdData.fold(0.0, (max, m) => max = max > m.diff ? max : m.diff);
    final minValue =
        macdData.fold(0.0, (min, m) => min = min < m.diff ? min : m.diff);
    final range = (maxValue - minValue).abs();
    final padding = range * 0.2;

    return Expanded(
      child: Stack(
        children: [
          BarChart(
            BarChartData(
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(show: false),
              barGroups: macdData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data.macd.abs(),
                      color: data.macd >= 0 ? Colors.red : Colors.green,
                      width: 3,
                      borderRadius: const BorderRadius.all(Radius.circular(1)),
                    ),
                  ],
                );
              }).toList(),
              minY: 0,
              maxY: (macdData.fold(
                      0.0,
                      (max, m) =>
                          max = max > m.macd.abs() ? max : m.macd.abs())) *
                  1.1,
              alignment: BarChartAlignment.center,
            ),
          ),
          LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: macdData
                      .asMap()
                      .entries
                      .map((entry) =>
                          FlSpot(entry.key.toDouble(), entry.value.diff))
                      .toList(),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: Colors.blue,
                  barWidth: 1.5,
                  dotData: const FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: macdData
                      .asMap()
                      .entries
                      .map((entry) =>
                          FlSpot(entry.key.toDouble(), entry.value.dea))
                      .toList(),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: Colors.red,
                  barWidth: 1.5,
                  dotData: const FlDotData(show: false),
                ),
              ],
              minY: minValue - padding,
              maxY: maxValue + padding,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKdjChart(List<KdjData> kdjData) {
    if (kdjData.isEmpty) {
      return const Center(child: Text('暂无数据', style: TextStyle(fontSize: 10)));
    }

    final maxValue = kdjData.fold(0.0, (max, k) => max = max > k.k ? max : k.k);
    final minValue =
        kdjData.fold(100.0, (min, k) => min = min < k.k ? min : k.k);

    return Expanded(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: kdjData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value.k))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.blue,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: kdjData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value.d))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.red,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: kdjData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value.j))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.green,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
          ],
          minY: 0,
          maxY: 100,
        ),
      ),
    );
  }

  Widget _buildRsiChart(List<double> rsiData) {
    if (rsiData.isEmpty) {
      return const Center(child: Text('暂无数据', style: TextStyle(fontSize: 10)));
    }

    return Expanded(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: rsiData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.blue,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
          ],
          minY: 0,
          maxY: 100,
        ),
      ),
    );
  }

  Widget _buildBollChart(List<BollData> bollData) {
    if (bollData.isEmpty) {
      return const Center(child: Text('暂无数据', style: TextStyle(fontSize: 10)));
    }

    final maxValue =
        bollData.fold(0.0, (max, b) => max = max > b.up ? max : b.up);
    final minValue =
        bollData.fold(1000000.0, (min, b) => min = min < b.dn ? min : b.dn);
    final range = maxValue - minValue;
    final padding = range * 0.1;

    return Expanded(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: bollData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value.up))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.red,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: bollData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value.mb))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.blue,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: bollData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value.dn))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.green,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
          ],
          minY: minValue - padding,
          maxY: maxValue + padding,
        ),
      ),
    );
  }

  Widget _buildDmiChart(List<DmiData> dmiData) {
    if (dmiData.isEmpty) {
      return const Center(child: Text('暂无数据', style: TextStyle(fontSize: 10)));
    }

    final maxValue =
        dmiData.fold(0.0, (max, d) => max = max > d.plusDi ? max : d.plusDi);
    final minValue = 0.0;

    return Expanded(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: dmiData
                  .asMap()
                  .entries
                  .map((entry) =>
                      FlSpot(entry.key.toDouble(), entry.value.plusDi))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.blue,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: dmiData
                  .asMap()
                  .entries
                  .map((entry) =>
                      FlSpot(entry.key.toDouble(), entry.value.minusDi))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.red,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: dmiData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value.adx))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.green,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
          ],
          minY: minValue,
          maxY: 100,
        ),
      ),
    );
  }

  Widget _buildCciChart(List<double> cciData) {
    if (cciData.isEmpty) {
      return const Center(child: Text('暂无数据', style: TextStyle(fontSize: 10)));
    }

    final maxValue =
        cciData.fold(0.0, (max, c) => max = max > c.abs() ? max : c.abs());
    final padding = maxValue * 0.1;

    return Expanded(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: cciData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.blue,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
          ],
          minY: -maxValue - padding,
          maxY: maxValue + padding,
        ),
      ),
    );
  }

  Widget _buildWrChart(List<double> wrData) {
    if (wrData.isEmpty) {
      return const Center(child: Text('暂无数据', style: TextStyle(fontSize: 10)));
    }

    return Expanded(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: wrData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.blue,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
          ],
          minY: -100,
          maxY: 0,
        ),
      ),
    );
  }

  Widget _buildObvChart(List<double> obvData) {
    if (obvData.isEmpty) {
      return const Center(child: Text('暂无数据', style: TextStyle(fontSize: 10)));
    }

    final maxValue = obvData.fold(0.0, (max, o) => max = max > o ? max : o);
    final minValue =
        obvData.fold(1000000.0, (min, o) => min = min < o ? min : o);
    final range = maxValue - minValue;
    final padding = range * 0.1;

    return Expanded(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: obvData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.blue,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
          ],
          minY: minValue - padding,
          maxY: maxValue + padding,
        ),
      ),
    );
  }

  Widget _buildDmaChart(List<DmaData> dmaData) {
    if (dmaData.isEmpty) {
      return const Center(child: Text('暂无数据', style: TextStyle(fontSize: 10)));
    }

    final maxValue =
        dmaData.fold(0.0, (max, d) => max = max > d.dma ? max : d.dma);
    final minValue =
        dmaData.fold(1000000.0, (min, d) => min = min < d.dma ? min : d.dma);
    final range = maxValue - minValue;
    final padding = range * 0.1;

    return Expanded(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: dmaData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value.dma))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.blue,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: dmaData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value.ama))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.red,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
          ],
          minY: minValue - padding,
          maxY: maxValue + padding,
        ),
      ),
    );
  }

  Widget _buildBbiChart(List<double> bbiData) {
    if (bbiData.isEmpty) {
      return const Center(child: Text('暂无数据', style: TextStyle(fontSize: 10)));
    }

    final maxValue = bbiData.fold(0.0, (max, b) => max = max > b ? max : b);
    final minValue =
        bbiData.fold(1000000.0, (min, b) => min = min < b ? min : b);
    final range = maxValue - minValue;
    final padding = range * 0.1;

    return Expanded(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: bbiData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.blue,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
          ],
          minY: minValue - padding,
          maxY: maxValue + padding,
        ),
      ),
    );
  }

  Widget _buildGenericChart(String indicatorType) {
    return Expanded(
      child: Center(
        child: Text(
          '$indicatorType 指标',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ),
    );
  }
}

class _IndicatorInfoItem {
  final String label;
  final String value;
  final Color color;

  _IndicatorInfoItem({
    required this.label,
    this.value = '',
    this.color = Colors.black,
  });
}
