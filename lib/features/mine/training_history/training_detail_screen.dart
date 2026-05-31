import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/providers/training_review_provider.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';
import 'package:kline_trainer/data/database/app_database.dart';
import 'package:kline_trainer/data/models/training_review_data.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/models/trade_point_model.dart';
import 'package:kline_trainer/data/utils/indicator_calculator.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

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

  void _updateVisibleRange() {
    final baseCount = 20;
    _visibleKlineCount = (baseCount / _zoomScale).round().clamp(10, 700);
  }

  int _getMaxStartIndex(List<KlineData> klineData) {
    if (klineData.isEmpty) return 0;
    return (klineData.length - _visibleKlineCount).clamp(0, klineData.length);
  }

  void _slideLeft() {
    setState(() {
      _visibleStartIndex =
          (_visibleStartIndex - 5).clamp(0, _visibleStartIndex);
    });
  }

  void _slideRight(List<KlineData> klineData) {
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
        .map((k) => KlineData(
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

  List<KlineData> _getDisplayKlineData(
      List<KlineData> allData) {
    if (allData.isEmpty) return [];
    final startIndex = _visibleStartIndex.clamp(0, _getMaxStartIndex(allData));
    final endIndex = (startIndex + _visibleKlineCount).clamp(0, allData.length);
    return allData.sublist(startIndex, endIndex);
  }

  List<TradePoint> _getDisplayTradePoints(
      List<TradePoint> allPoints, List<KlineData> allKlineData) {
    if (allPoints.isEmpty || allKlineData.isEmpty) return [];

    final startIndex =
        _visibleStartIndex.clamp(0, _getMaxStartIndex(allKlineData));

    return allPoints
        .where((point) =>
            point.index >= startIndex &&
            point.index < startIndex + _visibleKlineCount)
        .map((point) => TradePoint(
              index: point.index - startIndex,
              price: point.price,
              isBuy: point.isBuy,
              label: point.label,
              date: point.date,
              tradeId: point.tradeId,
              quantity: point.quantity,
            ))
        .toList();
  }

  Map<String, dynamic> _calculateIndicators(List<KlineModel> data) {
    final closes = data.map((d) => d.close).toList();
    final ma5 = IndicatorCalculator.calculateSMA(closes, 5);
    final ma10 = IndicatorCalculator.calculateSMA(closes, 10);

    final volumes = data
        .map((d) => VolumeData(
              volume: d.volume,
              isUp: d.close >= d.open,
            ))
        .toList();

    final macdResult = IndicatorCalculator.calculateMACD(data);
    final macdData = <MacdData>[];
    final macdOffset = data.length - macdResult.macd.length;
    for (int i = 0; i < data.length; i++) {
      final macdIndex = i - macdOffset;
      if (macdIndex >= 0 && macdIndex < macdResult.macd.length) {
        macdData.add(MacdData(
          macd: macdResult.macd[macdIndex],
          diff: macdResult.dif[macdIndex],
          dea: macdResult.dea[macdIndex],
        ));
      } else {
        macdData.add(MacdData(macd: 0, diff: 0, dea: 0));
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
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getStockName(session.symbol),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                session.symbol,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                  '资金', '¥${session.initialCapital.toStringAsFixed(0)}'),
              _buildStatItem(
                  '盈亏', '¥${session.totalProfit?.toStringAsFixed(0) ?? '0'}',
                  color: (session.totalProfit ?? 0) >= 0
                      ? AppTheme.green
                      : AppTheme.red),
              _buildStatItem(
                  '收益率',
                  '${((session.totalProfit ?? 0) / session.initialCapital * 100).toStringAsFixed(2)}%',
                  color: (session.totalProfit ?? 0) >= 0
                      ? AppTheme.green
                      : AppTheme.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppTheme.muted),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('训练周期', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            '${_getSessionDuration(widget.sessionId)}天',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getSessionDuration(int sessionId) {
    return '30';
  }

  Widget _buildKlineChart(List<KlineData> klineData,
      Map<String, dynamic> indicators, List<TradePoint> tradePoints) {
    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: KlineChart(
          klineData: klineData,
          ma5: (indicators['ma5'] as List<double>?)?.take(klineData.length).toList(),
          ma10: (indicators['ma10'] as List<double>?)?.take(klineData.length).toList(),
          volumes: (indicators['volumes'] as List<VolumeData>?)?.take(klineData.length).toList() ?? [],
          macdData: (indicators['macd'] as List<MacdData>?)?.take(klineData.length).toList() ?? [],
          tradePoints: tradePoints,
        ),
      ),
    );
  }

  Widget _buildControlButtons(List<KlineData> klineData) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(Icons.zoom_out, '缩小', () {
            setState(() {
              _zoomScale = (_zoomScale / 1.2).clamp(0.5, 2.0);
              _updateVisibleRange();
            });
          }),
          _buildControlButton(Icons.arrow_back_ios, '左移', () {
            _slideLeft();
          }),
          _buildControlButton(Icons.arrow_forward_ios, '右移', () {
            _slideRight(klineData);
          }),
          _buildControlButton(Icons.zoom_in, '放大', () {
            setState(() {
              _zoomScale = (_zoomScale * 1.2).clamp(0.5, 2.0);
              _updateVisibleRange();
            });
          }),
        ],
      ),
    );
  }

  Widget _buildControlButton(
      IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Text('指标: ', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _indicators.map((indicator) {
                  final isSelected = _selectedIndicator == indicator;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(indicator),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedIndicator = indicator;
                          });
                        }
                      },
                      selectedColor: AppTheme.accent,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.fg,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeChart(Map<String, dynamic> indicators) {
    final volumes = indicators['volumes'] as List<VolumeData>;
    if (volumes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 80,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: Text('成交量图表', style: TextStyle(color: AppTheme.muted)),
      ),
    );
  }

  Widget _buildIndicatorChart(String indicatorType, List<KlineModel> data) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: _buildIndicatorChartContent(indicatorType, data),
      ),
    );
  }

  Widget _buildIndicatorChartContent(String indicatorType, List<KlineModel> data) {
    final closes = data.map((d) => d.close).toList();
    final maxClose = closes.reduce((a, b) => a > b ? a : b);
    final minClose = closes.reduce((a, b) => a < b ? a : b);

    if (indicatorType == 'MACD') {
      final macdResult = IndicatorCalculator.calculateMACD(data);
      final displayMacd = <MacdData>[];
      for (int i = 0; i < macdResult.macd.length; i++) {
        displayMacd.add(MacdData(
          macd: macdResult.macd[i],
          diff: macdResult.dif[i],
          dea: macdResult.dea[i],
        ));
      }

      return Container(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text('MACD: ${displayMacd.isNotEmpty ? displayMacd.last.macd.toStringAsFixed(2) : "--"}',
              style: const TextStyle(fontSize: 12)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text('$indicatorType: --', style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildTradesList(List<Trade> trades) {
    if (trades.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '交易记录',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trades.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final trade = trades[index];
              return ListTile(
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: trade.type == 'buy'
                        ? AppTheme.green.withOpacity(0.1)
                        : AppTheme.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      trade.type == 'buy' ? 'B' : 'S',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: trade.type == 'buy'
                            ? AppTheme.green
                            : AppTheme.red,
                      ),
                    ),
                  ),
                ),
                title: Text('¥${trade.price?.toStringAsFixed(2) ?? "--"}'),
                subtitle: Text(
                  trade.tradeDate ?? '',
                  style: TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
                trailing: Text(
                  '${trade.quantity ?? 0}股',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
