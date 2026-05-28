import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/database/app_database.dart';

class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({super.key});

  @override
  ConsumerState<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen> {
  List<TrainingSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrainingSessions();
  }

  Future<void> _loadTrainingSessions() async {
    setState(() => _isLoading = true);
    try {
      final dbService = DatabaseService.instance;
      _sessions = await dbService.trainingDao.getUserSessions(1);
    } catch (e) {
      debugPrint('Failed to load training sessions: $e');
    }
    setState(() => _isLoading = false);
  }

  String _getStockName(String symbol) {
    final names = {
      'SH600000': '浦发银行',
      'SH600036': '招商银行',
      'SH600519': '贵州茅台',
      'SH601318': '中国平安',
      'SZ300750': '宁德时代',
      'SZ002594': '比亚迪',
      'SZ000021': '深科技',
      'SH600016': '民生银行',
      'SZ000858': '五粮液',
      'SH601398': '工商银行',
      'SH600585': '海螺水泥',
    };
    return names[symbol] ?? symbol;
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '-';
    return '${start.year}.${start.month.toString().padLeft(2, '0')}.${start.day.toString().padLeft(2, '0')} - ${end.year}.${end.month.toString().padLeft(2, '0')}.${end.day.toString().padLeft(2, '0')}';
  }

  void _handleDetail(int sessionId) {
    context.push('/mine/training-history/$sessionId');
  }

  void _handleReplay(TrainingSession session) {
    final startDateStr = session.startDate?.toIso8601String() ?? '';
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final url = '/main?tab=1&mode=replay&sessionId=${session.id}'
        '&symbol=${session.symbol}&market=${session.marketCode}'
        '&date=$startDateStr&_t=$timestamp';
    print('🔵 [TrainingScreen] 跳转复盘URL: $url');
    context.go(url);
  }

  void _handleRetrain(TrainingSession session) {
    final startDateStr = session.startDate?.toIso8601String() ?? '';
    context.go(
      '/main?tab=1&mode=retrain&sessionId=${session.id}'
      '&symbol=${session.symbol}&market=${session.marketCode}'
      '&date=$startDateStr',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的训练'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildTrainingList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalProfit = _sessions.fold<double>(0, (sum, s) => sum + (s.totalProfit ?? 0));
    final winCount = _sessions.where((s) => (s.profitRate ?? 0) >= 0).length;
    final winRate = _sessions.isNotEmpty ? (winCount / _sessions.length * 100) : 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _SummaryItem(label: '周期', value: '日线'),
            _SummaryItem(label: '训练', value: '${_sessions.length}天'),
            _SummaryItem(label: '胜率', value: '${winRate.toStringAsFixed(1)}%', color: Colors.green),
            _SummaryItem(label: '盈利', value: totalProfit >= 0 ? '+¥${totalProfit.toStringAsFixed(0)}' : '¥${totalProfit.toStringAsFixed(0)}', color: totalProfit >= 0 ? Colors.red : Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_sessions.isEmpty) {
      return const Center(child: Text('暂无训练记录'));
    }
    return Column(
      children: _sessions.map((session) {
        final stockName = _getStockName(session.symbol);
        final profit = session.totalProfit ?? 0;
        final profitPercent = session.profitRate ?? 0;
        String status;
        Color statusColor;
        if (session.status == 'holding') {
          status = '持仓';
          statusColor = Colors.green;
        } else if (session.status == 'stopped_loss') {
          status = '止损';
          statusColor = Colors.red;
        } else if (session.status == 'take_profit') {
          status = '止盈';
          statusColor = AppTheme.accent;
        } else {
          status = '已平仓';
          statusColor = AppTheme.muted;
        }
        return TrainingCard(
          name: stockName,
          code: session.symbol,
          profit: profit >= 0 ? '+¥${profit.toStringAsFixed(0)}' : '¥${profit.toStringAsFixed(0)}',
          profitPercent: profitPercent >= 0 ? '+${profitPercent.toStringAsFixed(1)}%' : '${profitPercent.toStringAsFixed(1)}%',
          period: '日线',
          duration: '${session.endDate?.difference(session.startDate ?? DateTime.now()).inDays ?? 0}天',
          status: status,
          statusColor: statusColor,
          session: session,
          onDetail: () => _handleDetail(session.id),
          onReplay: () => _handleReplay(session),
          onRetrain: () => _handleRetrain(session),
        );
      }).toList(),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
        ],
      ),
    );
  }
}

class TrainingCard extends StatelessWidget {
  final String name;
  final String code;
  final String profit;
  final String profitPercent;
  final String period;
  final String duration;
  final String status;
  final Color statusColor;
  final TrainingSession session;
  final VoidCallback onDetail;
  final VoidCallback onReplay;
  final VoidCallback onRetrain;

  const TrainingCard({
    required this.name,
    required this.code,
    required this.profit,
    required this.profitPercent,
    required this.period,
    required this.duration,
    required this.status,
    required this.statusColor,
    required this.session,
    required this.onDetail,
    required this.onReplay,
    required this.onRetrain,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(code, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton(
                  onPressed: onDetail,
                  child: const Text('详情'),
                ),
                TextButton(
                  onPressed: onReplay,
                  child: const Text('复盘'),
                ),
                TextButton(
                  onPressed: onRetrain,
                  child: const Text('重训'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(profit, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: profit.startsWith('+') ? Colors.red : Colors.green)),
                      const SizedBox(height: 4),
                      Text(profitPercent, style: TextStyle(color: profit.startsWith('+') ? Colors.red : Colors.green)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('训练周期', style: TextStyle(fontSize: 12, color: AppTheme.muted)),
                      const SizedBox(height: 4),
                      Text('$period · $duration', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}