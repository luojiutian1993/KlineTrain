import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/features/home/widgets/market_selector.dart';
import 'package:kline_trainer/features/home/widgets/stock_condition_selector.dart';
import 'package:kline_trainer/features/home/widgets/training_date_display.dart';
import 'package:kline_trainer/providers/asset_summary_provider.dart';
import 'package:kline_trainer/providers/recent_trades_provider.dart';
import 'package:kline_trainer/providers/stock_trade_summary_provider.dart';
import 'package:kline_trainer/providers/stock_filter_provider.dart';
import 'package:kline_trainer/providers/selection_provider.dart';
import 'package:kline_trainer/data/services/time_range_service.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/models/asset_summary_model.dart';
import 'package:kline_trainer/data/models/recent_trade_model.dart';
import 'package:kline_trainer/data/models/stock_trade_summary_model.dart';
import 'package:kline_trainer/shared/utils/logger.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedCondition = '随机';
  DateTime? _trainingStartDate;
  bool _isGeneratingDate = false;

  final List<String> _conditions = [
    '随机',
    '历史新高',
    '一年新高',
    '200日新高',
    '30日涨幅前50%',
    '15日涨幅前50%',
    '涨停',
    '连板',
    '量价齐升',
    '上升趋势',
    '历史新低',
    '一年新低',
    '200日新低',
    '30日跌幅前50%',
    '15日跌幅前50%',
    '下降趋势',
    '跌停',
    '连续跌停'
  ];

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    List<String> weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    return '${weekdays[now.weekday - 1]} · ${now.month}月${now.day}日';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/battle');
        break;
      case 2:
        context.go('/records');
        break;
      case 3:
        context.go('/mine');
        break;
    }
  }

  String _formatCurrency(double value) {
    return '¥${value.toStringAsFixed(2)}';
  }

  String _formatPercent(double value) {
    final prefix = value >= 0 ? '+' : '';
    return '$prefix${value.toStringAsFixed(1)}%';
  }

  Future<void> _generateTrainingDate() async {
    appLogger.i('开始生成训练日期...');
    setState(() {
      _isGeneratingDate = true;
    });

    try {
      final service = TimeRangeService(DatabaseService.instance.stockFilterDao);
      final date = await service.generateRandomTrainingStartDate();
      appLogger.i('成功生成训练日期: $date');
      setState(() {
        _trainingStartDate = date;
      });
      ref.read(selectionProvider.notifier).setTrainingStartDate(date);
    } catch (e, stackTrace) {
      appLogger.e('生成训练日期失败', error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('生成时间失败: ${e.toString()}')),
        );
      }
    } finally {
      setState(() {
        _isGeneratingDate = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _generateTrainingDate();
  }

  @override
  Widget build(BuildContext context) {
    final assetSummaryAsync = ref.watch(assetSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getCurrentDate(),
                style: TextStyle(fontSize: 12, color: AppTheme.muted)),
            const Text('训练',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('筛选'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAssetStatsCard(),
            const SizedBox(height: 20),
            _buildProfitCurve(),
            const SizedBox(height: 20),
            _buildBattleStats(),
            const SizedBox(height: 20),
            _buildStockSelection(),
            const SizedBox(height: 20),
            _buildRecentTrades(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '实战',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '记录',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.accent,
        unselectedItemColor: AppTheme.muted,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildAssetStatsCard() {
    final assetSummaryAsync = ref.watch(assetSummaryProvider);

    return assetSummaryAsync.when(
      data: (summary) => _buildAssetCardContent(summary),
      loading: () => _buildAssetCardLoading(),
      error: (_, __) => _buildAssetCardContent(AssetSummaryModel.defaultValue),
    );
  }

  Widget _buildAssetCardLoading() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              color: AppTheme.accent,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetCardContent(AssetSummaryModel summary) {
    final profitColor = summary.totalProfit >= 0 ? Colors.red : Colors.green;
    final profitPrefix = summary.totalProfit >= 0 ? '+' : '';
    final winColor = summary.winRate >= 50 ? Colors.green : Colors.red;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: '初始资产',
                    value: _formatCurrency(summary.initialCapital),
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: '现有资产',
                    value: _formatCurrency(summary.currentCapital),
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: '总盈亏',
                    value:
                        '$profitPrefix${_formatCurrency(summary.totalProfit)}',
                    color: profitColor,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: '收益率',
                    value: _formatPercent(summary.profitRate),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                      label: '操作次数', value: '${summary.totalTradeCount}'),
                ),
                Expanded(
                  child: _StatItem(
                      label: '操作天数', value: '${summary.totalTradeDays}'),
                ),
                Expanded(
                  child: _StatItem(
                    label: '盈利次数',
                    value: '${summary.winCount}',
                    color: winColor,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: '成功率',
                    value: '${summary.winRate.toStringAsFixed(1)}%',
                    color: winColor,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: '最大盈利',
                    value: '+${_formatCurrency(summary.maxProfit)}',
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: '最大亏损',
                    value: '-${_formatCurrency(summary.maxLoss)}',
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: '最大回撤',
                    value: '-${summary.maxDrawdown.toStringAsFixed(1)}%',
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: '年化收益',
                    value: _formatPercent(summary.annualizedReturn),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitCurve() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('收益率曲线',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 120,
              child: const Center(child: Text('[收益率曲线图表]')),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBattleStats() {
    final assetSummaryAsync = ref.watch(assetSummaryProvider);

    return assetSummaryAsync.when(
      data: (summary) => _buildBattleStatsContent(summary),
      loading: () => _buildBattleStatsLoading(),
      error: (_, __) =>
          _buildBattleStatsContent(AssetSummaryModel.defaultValue),
    );
  }

  Widget _buildBattleStatsLoading() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 180,
          child: Center(
            child: CircularProgressIndicator(
              color: AppTheme.accent,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBattleStatsContent(AssetSummaryModel summary) {
    final profitColor = summary.profitRate >= 0 ? Colors.red : Colors.green;
    final rating = _calculateRating(summary.profitRate);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('实战',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                StatBadge(label: '操盘评级', value: rating),
                StatBadge(
                    label: '总收益率',
                    value: _formatPercent(summary.profitRate),
                    color: profitColor),
                StatBadge(label: '交易次数', value: '${summary.totalTradeCount}'),
              ],
            ),
            const SizedBox(height: 12),
            const Text('年化收益率',
                style: TextStyle(fontSize: 14, color: AppTheme.muted)),
            const SizedBox(height: 4),
            Text(
              _formatPercent(summary.annualizedReturn),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _ProgressBar(
              label: '近30日收益率',
              progress: (summary.profitRate / 100).clamp(0.0, 1.0),
              value: _formatPercent(summary.profitRate),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                StatBadge(
                  label: '本月收益',
                  value: _formatCurrency(summary.totalProfit),
                  color: profitColor,
                ),
                StatBadge(
                  label: '最大回撤',
                  value: '-${summary.maxDrawdown.toStringAsFixed(1)}%',
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                StatBadge(
                    label: '夏普比率',
                    value: summary.sharpeRatio.toStringAsFixed(2)),
                StatBadge(
                    label: '盈亏比',
                    value: '${summary.profitLossRatio.toStringAsFixed(1)}:1'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _calculateRating(double profitRate) {
    if (profitRate >= 50) return 'A+';
    if (profitRate >= 30) return 'A';
    if (profitRate >= 20) return 'B+';
    if (profitRate >= 10) return 'B';
    if (profitRate >= 0) return 'C+';
    return 'C';
  }

  Widget _buildStockSelection() {
    final selectionState = ref.watch(selectionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
                child: Text('选股条件',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            TextButton(onPressed: () {}, child: const Text('编辑')),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                MarketSelector(
                  selectedMarket: selectionState.selectedMarket,
                  selectedSubMarkets: selectionState.selectedSubMarkets,
                  onMarketChanged: (market) {
                    ref.read(selectionProvider.notifier).setMarket(market);
                  },
                  onSubMarketsChanged: (subMarkets) {
                    ref
                        .read(selectionProvider.notifier)
                        .setSubMarkets(subMarkets);
                  },
                ),
                const SizedBox(height: 16),
                _buildIndustrySectorSelector(),
                const SizedBox(height: 16),
                TrainingDateDisplay(
                  startDate: _trainingStartDate,
                  trainingDays: 150,
                  onRegenerate: _generateTrainingDate,
                ),
                const SizedBox(height: 16),
                StockConditionSelector(
                  selectedCondition: _selectedCondition,
                  onChanged: (value) {
                    setState(() {
                      _selectedCondition = value;
                    });
                    ref.read(selectionProvider.notifier).setCondition(value);
                  },
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, child) {
                    final filterState = ref.watch(stockFilterProvider);
                    final hasSelectedStock = filterState.hasSelectedStock;
                    final isLoading =
                        filterState.isLoading || _isGeneratingDate;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (!hasSelectedStock) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('请先选择一只股票'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }

                                final stock = filterState.selectedStock;
                                if (stock != null &&
                                    _trainingStartDate != null) {
                                  final dateStr = _trainingStartDate!
                                      .toIso8601String()
                                      .split('T')[0];
                                  appLogger.d('🔵🔵🔵 [1.首页跳转] 准备跳转实战页面');
                                  appLogger.d('🔵🔵🔵 [1.首页跳转] 参数详情:');
                                  appLogger.d(
                                      '🔵🔵🔵   - stock.symbol: ${stock.symbol}');
                                  appLogger.d(
                                      '🔵🔵🔵   - stock.symbolName: ${stock.symbolName}');
                                  appLogger.d(
                                      '🔵🔵🔵   - stock.marketCode: ${stock.marketCode}');
                                  appLogger.d(
                                      '🔵🔵🔵   - _trainingStartDate: $dateStr');
                                  appLogger.d(
                                      '🔵🔵🔵 [1.首页跳转] 跳转URL: /battle?symbol=${stock.symbol}&name=${Uri.encodeComponent(stock.symbolName)}&market=${stock.marketCode}&date=$dateStr');
                                  context.go(
                                    '/battle?symbol=${stock.symbol}&name=${Uri.encodeComponent(stock.symbolName)}&market=${stock.marketCode}&date=$dateStr',
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          disabledBackgroundColor:
                              AppTheme.accent.withOpacity(0.5),
                        ),
                        child: isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('加载中...',
                                      style: TextStyle(fontSize: 16)),
                                ],
                              )
                            : const Text('确认', style: TextStyle(fontSize: 16)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndustrySectorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '行业板块',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: null,
              isExpanded: true,
              hint: const Text('行业板块（后续实现）'),
              items: const [
                DropdownMenuItem(
                  value: null,
                  enabled: false,
                  child: Text('行业板块（后续实现）'),
                ),
              ],
              onChanged: null,
              disabledHint: const Text('行业板块（后续实现）'),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(),
      ],
    );
  }

  Widget _buildRecentTrades() {
    final stockSummaryAsync = ref.watch(stockTradeSummaryProvider);

    return stockSummaryAsync.when(
      data: (summaries) => _buildStockTradeSummaryContent(summaries),
      loading: () => _buildRecentTradesLoading(),
      error: (_, __) => _buildRecentTradesEmpty(),
    );
  }

  Widget _buildRecentTradesLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
                child: Text('最近交易',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            TextButton(onPressed: () {}, child: const Text('查看全部')),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.accent,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTradesEmpty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
                child: Text('最近交易',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            TextButton(onPressed: () {}, child: const Text('查看全部')),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: SizedBox(
            height: 100,
            child: Center(
              child: Text(
                '暂无交易记录',
                style: TextStyle(color: AppTheme.muted),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStockTradeSummaryContent(
      List<StockTradeSummaryModel> summaries) {
    if (summaries.isEmpty) {
      return _buildRecentTradesEmpty();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
                child: Text('最近交易',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            TextButton(onPressed: () {}, child: const Text('查看全部')),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Column(
            children: summaries.take(5).map((summary) {
              final profitColor = summary.isWin ? Colors.green : Colors.red;
              return InkWell(
                onTap: () {
                  context.push(
                    '/trade-detail?symbol=${summary.symbol}&name=${Uri.encodeComponent(summary.symbolName)}&market=${summary.marketCode}',
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppTheme.border, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              summary.symbolName.isNotEmpty
                                  ? summary.symbolName
                                  : summary.symbol,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              summary.displayCode,
                              style: TextStyle(
                                  fontSize: 12, color: AppTheme.muted),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              summary.displayProfitRate,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: profitColor),
                            ),
                            Text(
                              summary.displayProfit,
                              style:
                                  TextStyle(fontSize: 12, color: profitColor),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              summary.displayTradeCount,
                              style: TextStyle(
                                  fontSize: 12, color: AppTheme.muted),
                            ),
                            Text(
                              '胜率 ${summary.displayWinRate}',
                              style: TextStyle(
                                  fontSize: 12, color: AppTheme.muted),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: AppTheme.muted, size: 20),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final bool bgHighlight;
  final Color? color;

  const _StatItem({
    required this.label,
    required this.value,
    this.highlight = false,
    this.bgHighlight = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
        const SizedBox(height: 4),
        Container(
          padding: bgHighlight
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
              : EdgeInsets.zero,
          decoration: bgHighlight
              ? BoxDecoration(
                  color: AppTheme.accentSoft,
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: Text(
            value,
            style: TextStyle(
              fontSize: highlight ? 16 : 14,
              fontWeight: highlight || bgHighlight
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: color ?? (bgHighlight ? AppTheme.accent : AppTheme.fg),
            ),
          ),
        ),
      ],
    );
  }
}

class StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool expanded;

  const StatBadge(
      {required this.label,
      required this.value,
      this.color,
      this.expanded = true});

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color ?? AppTheme.fg)),
      ],
    );
    return expanded ? Expanded(child: content) : content;
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final double progress;
  final String value;

  const _ProgressBar(
      {required this.label, required this.progress, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(label, style: TextStyle(color: AppTheme.muted))),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppTheme.border,
          color: AppTheme.accent,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class TradeItem extends StatelessWidget {
  final String name;
  final String code;
  final String type;
  final String quantity;
  final String profit;
  final String status;
  final Color statusColor;

  const TradeItem({
    required this.name,
    required this.code,
    required this.type,
    required this.quantity,
    required this.profit,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(code,
                    style: TextStyle(fontSize: 12, color: AppTheme.muted)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$type $quantity',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(profit,
                        style: TextStyle(
                            color: profit.startsWith('+')
                                ? Colors.red
                                : Colors.green)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(status,
                          style: TextStyle(fontSize: 12, color: statusColor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
