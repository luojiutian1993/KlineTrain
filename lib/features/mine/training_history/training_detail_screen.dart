import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/providers/training_review_provider.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart'
    as kline_chart;
import 'package:kline_trainer/data/database/app_database.dart';
import 'package:kline_trainer/data/models/training_review_data.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/models/trade_point_model.dart';
import 'package:kline_trainer/data/utils/indicator_calculator.dart';

class TrainingDetailScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const TrainingDetailScreen({super.key, required this.sessionId});

  @override
  ConsumerState<TrainingDetailScreen> createState() =>
      _TrainingDetailScreenState();
}

class _TrainingDetailScreenState extends ConsumerState<TrainingDetailScreen> {
  int _visibleStartIndex = 0;
  int _visibleKlineCount = 20;
  double _zoomScale = 1.0;
  String _selectedIndicator = 'MACD';

  final List<String> _indicators = ['成交量', 'MACD', 'KDJ', 'RSI', 'BOLL'];

  String _getStockName(String symbol) {
    final names = {
      'SH600000': '浦发银行',
      'SH600036': '招商银行',
      'SH600519': '贵州茅台',
      'SH601318': '中国平安',
      'SZ300750': '宁德时代',
      'SZ002594': '比亚迪',
      'SH600016': '民生银行',
      'SZ000858': '五粮液',
      'SH601398': '工商银行',
      'SH600585': '海螺水泥',
      'SZ000021': '深科技',
    };
    return names[symbol] ?? symbol;
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '-';
    return '${start.year}.${start.month.toString().padLeft(2, '0')}.${start.day.toString().padLeft(2, '0')} - ${end.year}.${end.month.toString().padLeft(2, '0')}.${end.day.toString().padLeft(2, '0')}';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  void _zoomIn() {
    setState(() {
      _zoomScale = (_zoomScale * 1.2).clamp(0.0286, 3.0);
      _updateVisibleRange();
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomScale = (_zoomScale / 1.2).clamp(0.0286, 3.0);
      _updateVisibleRange();
    });
  }

  void _updateVisibleRange() {
    final baseCount = 20;
    _visibleKlineCount = (baseCount / _zoomScale).round().clamp(10, 700);
  }

  int _getMaxStartIndex(List<kline_chart.KlineData> klineData) {
    if (klineData.isEmpty) return 0;
    return (klineData.length - _visibleKlineCount).clamp(0, klineData.length);
  }

  void _slideLeft() {
    setState(() {
      _visibleStartIndex =
          (_visibleStartIndex - 5).clamp(0, _visibleStartIndex);
    });
  }

  void _slideRight(List<kline_chart.KlineData> klineData) {
    setState(() {
      _visibleStartIndex =
          (_visibleStartIndex + 5).clamp(0, _getMaxStartIndex(klineData));
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewData = ref.watch(trainingReviewProvider(widget.sessionId));
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('训练复盘'),
        backgroundColor: AppTheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: reviewData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('训练记录不存在'));
          }
          return _buildContent(data);
        },
      ),
    );
  }

  Widget _buildContent(TrainingReviewData data) {
    if (data.klineData.isEmpty) {
      return _buildEmptyKlineContent(data);
    }

    final klineDataList = data.klineData
        .map((k) => kline_chart.KlineData(
              date: k.dateTime,
              open: k.open,
              high: k.high,
              low: k.low,
              close: k.close,
              volume: k.volume,
            ))
        .toList();

    final displayKlineData = _getDisplayKlineData(klineDataList);
    final displayTradePoints =
        _getDisplayTradePoints(data.tradePoints, klineDataList);
    final indicators = _calculateIndicators(data.klineData);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSessionInfo(data.session),
          _buildPeriodSelector(),
          _buildKlineChart(displayKlineData, indicators, displayTradePoints),
          _buildControlButtons(klineDataList),
          _buildIndicatorSelector(),
          _buildVolumeChart(indicators),
          _buildIndicatorChart(_selectedIndicator, data.klineData),
          _buildTradesList(data.trades),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildEmptyKlineContent(TrainingReviewData data) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSessionInfo(data.session),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const Icon(Icons.bar_chart, size: 48, color: AppTheme.muted),
                const SizedBox(height: 16),
                const Text(
                  '暂无K线数据',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '无法找到训练期间的K线数据，请检查数据导入情况',
                  style: TextStyle(color: AppTheme.muted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ).copyWith(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: const Text('返回列表'),
                ),
              ],
            ),
          ),
          _buildTradesList(data.trades),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  List<kline_chart.KlineData> _getDisplayKlineData(
      List<kline_chart.KlineData> allData) {
    if (allData.isEmpty) return [];
    final startIndex = _visibleStartIndex.clamp(0, _getMaxStartIndex(allData));
    final endIndex = (startIndex + _visibleKlineCount).clamp(0, allData.length);
    return allData.sublist(startIndex, endIndex);
  }

  List<kline_chart.TradePoint> _getDisplayTradePoints(
      List<TradePoint> allPoints, List<kline_chart.KlineData> allKlineData) {
    if (allPoints.isEmpty || allKlineData.isEmpty) return [];

    final startIndex =
        _visibleStartIndex.clamp(0, _getMaxStartIndex(allKlineData));

    return allPoints
        .where((point) =>
            point.index >= startIndex &&
            point.index < startIndex + _visibleKlineCount)
        .map((point) => kline_chart.TradePoint(
              index: point.index - startIndex,
              price: point.price,
              isBuy: point.isBuy,
              label: point.label,
              date: point.date,
            ))
        .toList();
  }

  Map<String, dynamic> _calculateIndicators(List<KlineModel> data) {
    final closes = data.map((d) => d.close).toList();
    final ma5 = IndicatorCalculator.calculateSMA(closes, 5);
    final ma10 = IndicatorCalculator.calculateSMA(closes, 10);

    final volumes = data
        .map((d) => kline_chart.VolumeData(
              volume: d.volume,
              isUp: d.close >= d.open,
            ))
        .toList();

    final macdResult = IndicatorCalculator.calculateMACD(data);
    final macdData = <kline_chart.MacdData>[];
    final macdOffset = data.length - macdResult.macd.length;
    for (int i = 0; i < data.length; i++) {
      final macdIndex = i - macdOffset;
      if (macdIndex >= 0 && macdIndex < macdResult.macd.length) {
        macdData.add(kline_chart.MacdData(
          macd: macdResult.macd[macdIndex],
          diff: macdResult.dif[macdIndex],
          dea: macdResult.dea[macdIndex],
        ));
      } else {
        macdData.add(kline_chart.MacdData(macd: 0, diff: 0, dea: 0));
      }
    }

    return {
      'ma5': ma5,
      'ma10': ma10,
      'volumes': volumes,
      'macd': macdData,
    };
  }

  Widget _buildSessionInfo(TrainingSession session) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_getStockName(session.symbol),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(session.symbol,
                        style: TextStyle(fontSize: 14, color: AppTheme.muted)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: (session.profitRate ?? 0) >= 0
                      ? AppTheme.red.withOpacity(0.1)
                      : AppTheme.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(session.profitRate ?? 0) >= 0 ? '+' : ''}${(session.profitRate ?? 0).toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: (session.profitRate ?? 0) >= 0
                        ? AppTheme.red
                        : AppTheme.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                    label: '训练周期',
                    value:
                        _formatDateRange(session.startDate, session.endDate)),
              ),
              Expanded(
                child: _InfoItem(
                    label: '初始资金',
                    value:
                        '¥${(session.initialCapital ?? 0).toStringAsFixed(2)}'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                    label: '最终资金',
                    value:
                        '¥${(session.currentCapital ?? 0).toStringAsFixed(2)}'),
              ),
              Expanded(
                child: _InfoItem(
                    label: '总收益',
                    value: '¥${(session.totalProfit ?? 0).toStringAsFixed(2)}'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                    label: '交易次数', value: '${session.tradeCount ?? 0}次'),
              ),
              Expanded(
                child: _InfoItem(
                    label: '胜率',
                    value: '${(session.winRate ?? 0).toStringAsFixed(1)}%'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: ['日K', '周K', '月K'].map((period) {
          return Expanded(
            child: Center(
              child: Text(
                period,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      period == '日K' ? FontWeight.bold : FontWeight.normal,
                  color: period == '日K' ? AppTheme.accent : AppTheme.muted,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKlineChart(
      List<kline_chart.KlineData> klineData,
      Map<String, dynamic> indicators,
      List<kline_chart.TradePoint> tradePoints) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('K线走势',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (klineData.isEmpty)
            const SizedBox(height: 280, child: Center(child: Text('暂无K线数据')))
          else
            kline_chart.KlineChart(
              klineData: klineData,
              ma5: indicators['ma5'],
              ma10: indicators['ma10'],
              volumes: [],
              macdData: [],
              tradePoints: tradePoints,
            ),
          _buildChartLegend(),
        ],
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: AppTheme.red, label: '买入'),
        const SizedBox(width: 16),
        _LegendItem(color: AppTheme.green, label: '卖出'),
        const SizedBox(width: 16),
        _LegendItem(color: Colors.yellow, label: 'MA5'),
        const SizedBox(width: 16),
        _LegendItem(color: Colors.purple, label: 'MA10'),
      ],
    );
  }

  Widget _buildControlButtons(List<kline_chart.KlineData> klineData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 20),
            onPressed: _zoomOut,
            color: AppTheme.accent,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.arrow_left, size: 20),
            onPressed: _slideLeft,
            color: AppTheme.accent,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.arrow_right, size: 20),
            onPressed: () => _slideRight(klineData),
            color: AppTheme.accent,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            onPressed: _zoomIn,
            color: AppTheme.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _indicators.map((indicator) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndicator = indicator),
                child: Text(
                  indicator,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: _selectedIndicator == indicator
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: _selectedIndicator == indicator
                        ? AppTheme.accent
                        : AppTheme.muted,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildVolumeChart(Map<String, dynamic> indicators) {
    final volumes = indicators['volumes'] as List<kline_chart.VolumeData>;
    if (volumes.isEmpty) {
      return const SizedBox(height: 100, child: Center(child: Text('暂无成交量数据')));
    }

    final displayStartIndex = _visibleStartIndex.clamp(0, volumes.length);
    final displayEndIndex =
        (displayStartIndex + _visibleKlineCount).clamp(0, volumes.length);
    final displayVolumes = volumes.sublist(displayStartIndex, displayEndIndex);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('成交量',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: kline_chart.KlineChart(
              klineData: [],
              volumes: displayVolumes,
              macdData: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorChart(String indicator, List<KlineModel> klineData) {
    if (klineData.isEmpty) {
      return const SizedBox(height: 120, child: Center(child: Text('暂无指标数据')));
    }

    switch (indicator) {
      case 'MACD':
        return _buildMacdChart(klineData);
      case 'KDJ':
        return _buildKdjChart(klineData);
      case 'RSI':
        return _buildRsiChart(klineData);
      case 'BOLL':
        return const SizedBox(
            height: 120, child: Center(child: Text('BOLL指标')));
      default:
        return const SizedBox(height: 120, child: Center(child: Text('指标')));
    }
  }

  Widget _buildMacdChart(List<KlineModel> klineData) {
    final macdResult = IndicatorCalculator.calculateMACD(klineData);

    final displayStartIndex = _visibleStartIndex.clamp(0, klineData.length);
    final displayEndIndex =
        (displayStartIndex + _visibleKlineCount).clamp(0, klineData.length);

    final macdOffset = klineData.length - macdResult.macd.length;
    final displayMacd = <kline_chart.MacdData>[];

    for (int i = displayStartIndex; i < displayEndIndex; i++) {
      final macdIndex = i - macdOffset;
      if (macdIndex >= 0 && macdIndex < macdResult.macd.length) {
        displayMacd.add(kline_chart.MacdData(
          macd: macdResult.macd[macdIndex],
          diff: macdResult.dif[macdIndex],
          dea: macdResult.dea[macdIndex],
        ));
      } else {
        displayMacd.add(kline_chart.MacdData(macd: 0, diff: 0, dea: 0));
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('MACD(12,26,9)',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: kline_chart.KlineChart(
              klineData: [],
              volumes: [],
              macdData: displayMacd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKdjChart(List<KlineModel> klineData) {
    final kdjResult = IndicatorCalculator.calculateKDJ(klineData);

    if (kdjResult.k.isEmpty) {
      return const SizedBox(height: 120, child: Center(child: Text('暂无KDJ数据')));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('KDJ(9,3,3)',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: Center(
              child: Text('KDJ指标图表'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRsiChart(List<KlineModel> klineData) {
    final rsiResult = IndicatorCalculator.calculateRSI(klineData);

    if (rsiResult.values.isEmpty) {
      return const SizedBox(height: 120, child: Center(child: Text('暂无RSI数据')));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RSI(14)',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: Center(
              child: Text('RSI指标图表'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradesList(List<Trade> trades) {
    if (trades.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('暂无交易记录')),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('交易记录',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trades.length,
            itemBuilder: (context, index) {
              final trade = trades[index];
              return _TradeItem(trade: trade);
            },
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 2, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _TradeItem extends StatelessWidget {
  final Trade trade;

  const _TradeItem({required this.trade});

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.type == 'buy';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isBuy
                      ? AppTheme.red.withOpacity(0.1)
                      : AppTheme.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isBuy ? '买入' : '卖出',
                  style: TextStyle(
                    color: isBuy ? AppTheme.red : AppTheme.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(_formatDate(trade.tradeDate),
                  style: TextStyle(color: AppTheme.muted)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TradeInfo(
                  label: '价格',
                  value: '¥${trade.price?.toStringAsFixed(2) ?? '0'}'),
              _TradeInfo(label: '数量', value: '${trade.quantity ?? 0}股'),
              _TradeInfo(
                  label: '金额',
                  value: '¥${trade.amount?.toStringAsFixed(2) ?? '0'}'),
            ],
          ),
          if (trade.profit != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '盈亏: ',
                    style: TextStyle(fontSize: 14, color: AppTheme.muted),
                  ),
                  Text(
                    '${trade.profit! >= 0 ? '+' : ''}¥${trade.profit?.toStringAsFixed(2) ?? '0'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: trade.profit! >= 0 ? AppTheme.red : AppTheme.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${trade.profitRate! >= 0 ? '+' : ''}${trade.profitRate?.toStringAsFixed(2) ?? '0'}%)',
                    style: TextStyle(
                      fontSize: 14,
                      color: trade.profitRate! >= 0
                          ? AppTheme.red
                          : AppTheme.green,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TradeInfo extends StatelessWidget {
  final String label;
  final String value;

  const _TradeInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
      ],
    );
  }
}
