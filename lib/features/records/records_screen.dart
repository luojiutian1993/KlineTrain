import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/database/app_database.dart';

class RecordsScreen extends ConsumerStatefulWidget {
  const RecordsScreen({super.key});

  @override
  ConsumerState<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends ConsumerState<RecordsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
    print('🔵 [_handleDetail] 跳转到详情: sessionId=$sessionId');
    context.pushReplacement('/records/$sessionId/detail');
  }

  void _handleReplay(TrainingSession session) {
    final startDateStr = session.startDate?.toIso8601String() ?? '';
    final url = '/main?tab=1&mode=replay&sessionId=${session.id}'
        '&symbol=${session.symbol}&market=${session.marketCode}'
        '&date=$startDateStr';
    print('🔵 [_handleReplay] 跳转URL: $url');
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
    super.build(context);
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('记录'),
        backgroundColor: AppTheme.surface,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
              ? const Center(child: Text('暂无训练记录'))
              : ListView.builder(
                  itemCount: _sessions.length,
                  itemBuilder: (context, index) {
                    final session = _sessions[index];
                    return _RecordCard(
                      session: session,
                      stockName: _getStockName(session.symbol),
                      onDetail: () => _handleDetail(session.id),
                      onReplay: () => _handleReplay(session),
                      onRetrain: () => _handleRetrain(session),
                    );
                  },
                ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final TrainingSession session;
  final String stockName;
  final VoidCallback onDetail;
  final VoidCallback onReplay;
  final VoidCallback onRetrain;

  const _RecordCard({
    required this.session,
    required this.stockName,
    required this.onDetail,
    required this.onReplay,
    required this.onRetrain,
  });

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '-';
    return '${start.year}.${start.month.toString().padLeft(2, '0')}.${start.day.toString().padLeft(2, '0')} - ${end.year}.${end.month.toString().padLeft(2, '0')}.${end.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    Text(stockName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(session.symbol,
                        style: TextStyle(fontSize: 12, color: AppTheme.muted)),
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
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: (session.profitRate ?? 0) >= 0
                        ? AppTheme.red
                        : AppTheme.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(_formatDateRange(session.startDate, session.endDate),
              style: TextStyle(color: AppTheme.muted, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatChip(
                label: '交易次数',
                value: '${session.tradeCount ?? 0}次',
              ),
              _StatChip(
                  label: '胜率',
                  value: '${session.winRate?.toStringAsFixed(1) ?? '0'}%'),
              _StatChip(
                  label: '收益',
                  value: '¥${(session.totalProfit ?? 0).toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _ActionButton(
                  label: '详情',
                  color: AppTheme.accent,
                  onTap: onDetail,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: '复盘',
                  color: AppTheme.green,
                  onTap: onReplay,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: '重训',
                  color: AppTheme.red,
                  onTap: onRetrain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatChip({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color ?? AppTheme.fg)),
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }
}
