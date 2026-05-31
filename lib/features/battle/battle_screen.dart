import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';
import 'package:kline_trainer/features/battle/models/battle_state.dart';
import 'package:kline_trainer/features/battle/widgets/stock_info_bar.dart';
import 'package:kline_trainer/features/battle/widgets/control_buttons.dart';
import 'package:kline_trainer/features/battle/widgets/asset_panel.dart';
import 'package:kline_trainer/features/battle/widgets/indicator_panel.dart';
import 'package:kline_trainer/features/battle/widgets/kline_chart_container.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class BattleScreen extends ConsumerStatefulWidget {
  final String? initialSymbol;
  final String? initialName;
  final String? initialMarketCode;
  final DateTime? initialTrainingStartDate;
  final bool isReplayMode;
  final int? replaySessionId;

  const BattleScreen({
    super.key,
    this.initialSymbol,
    this.initialName,
    this.initialMarketCode,
    this.initialTrainingStartDate,
    this.isReplayMode = false,
    this.replaySessionId,
  });

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  bool _hasShownTrainingCompleteDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void _initialize() {
    final notifier = ref.read(battleProvider.notifier);

    if (widget.replaySessionId != null) {
      notifier.loadReplayMode(widget.replaySessionId!);
    } else if (widget.initialSymbol != null &&
        widget.initialSymbol!.isNotEmpty) {
      notifier.initializeWithSymbol(
        symbol: widget.initialSymbol!,
        name: widget.initialName,
        marketCode: widget.initialMarketCode,
        startDate: widget.initialTrainingStartDate,
      );
    } else if (widget.isReplayMode) {
      notifier.loadReplayMode(0);
    } else {
      notifier.initializeRandom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(battleProvider);

    if (state.isLoading) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text('加载中...', style: TextStyle(color: AppTheme.muted)),
              ],
            ),
          ),
        ),
      );
    }

    if (!state.hasAvailableData) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(state.errorMessage ?? '暂无可训练股票',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(battleProvider.notifier).initializeRandom(),
                  child: const Text('重新加载'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (state.isTrainingComplete &&
        !_hasShownTrainingCompleteDialog &&
        !state.isReplayMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _hasShownTrainingCompleteDialog = true;
        _showTrainingCompleteDialog();
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const StockInfoBar(),
            _buildPeriodSelector(state),
            Expanded(flex: 3, child: KlineChartContainer()),
            const ControlButtons(),
            const IndicatorPanel(),
            _buildTradeButtons(),
            const AssetPanel(),
          ],
        ),
      ),
    );
  }

  void _showTrainingCompleteDialog() {
    final state = ref.read(battleProvider);
    final finalCapital = state.accountBalance + state.positionValue;
    final profitRate =
        (finalCapital - state.initialBalance) / state.initialBalance * 100;
    final winCount = _calculateWinCount(state);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber),
            SizedBox(width: 8),
            Text('训练结束'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('恭喜完成 ${state.trainingDays} 天训练！'),
            const SizedBox(height: 16),
            _buildStatRow('最终收益',
                '${state.totalProfitLoss >= 0 ? '+' : ''}${state.totalProfitLoss.toStringAsFixed(2)}'),
            _buildStatRow('收益率',
                '${profitRate >= 0 ? '+' : ''}${profitRate.toStringAsFixed(2)}%'),
            _buildStatRow('交易次数', '${state.tradePoints.length}'),
            if (state.tradePoints.isNotEmpty)
              _buildStatRow('胜率',
                  '${(winCount / state.tradePoints.length * 100).toStringAsFixed(1)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(battleProvider.notifier).initializeRandom();
            },
            child: const Text('重新开始'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(battleProvider.notifier)
                  .saveTrainingRecordAndEnterReplay();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
            ),
            child: const Text('查看复盘'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  int _calculateWinCount(BattleState state) {
    final buyPoints = state.tradePoints.where((p) => p.isBuy).toList();
    final sellPoints = state.tradePoints.where((p) => !p.isBuy).toList();

    if (sellPoints.isEmpty) return 0;

    int winCount = 0;
    int buyIndex = 0;

    for (final sell in sellPoints) {
      if (buyIndex < buyPoints.length) {
        final buy = buyPoints[buyIndex];
        if (sell.price > buy.price) {
          winCount++;
        }
        buyIndex++;
      }
    }

    return winCount;
  }

  Widget _buildPeriodSelector(BattleState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppTheme.border, width: 0.5))),
      child: Row(
        children: [
          DropdownButton<String>(
            value: state.selectedPeriod,
            items: ['日K', '周K', '月K', '季K', '年K']
                .map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p, style: const TextStyle(fontSize: 11))))
                .toList(),
            onChanged: (v) {
              if (v != null) ref.read(battleProvider.notifier).updatePeriod(v);
            },
            underline: const SizedBox(),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.accent),
          ),
          const Spacer(),
          _buildMaDisplays(state),
        ],
      ),
    );
  }

  Widget _buildMaDisplays(BattleState state) {
    final notifier = ref.read(battleProvider.notifier);
    final ma5 = notifier.ma5Data;
    final ma10 = notifier.ma10Data;
    final ma30 = notifier.ma30Data;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (ma5.isNotEmpty) _buildMaItem('MA5', ma5.last, Colors.yellow),
        if (ma10.isNotEmpty) _buildMaItem('MA10', ma10.last, Colors.purple),
        if (ma30.isNotEmpty) _buildMaItem('MA30', ma30.last, Colors.blue),
      ],
    );
  }

  Widget _buildMaItem(String label, double value, Color color) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text('$label:${value > 0 ? value.toStringAsFixed(2) : '--'}',
            style: TextStyle(fontSize: 10, color: color)));
  }

  Widget _buildKlineChart(BattleState state) {
    final notifier = ref.read(battleProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppTheme.border, width: 0.5))),
      child: KlineChart(
        klineData: notifier.displayKlineData,
        ma5: notifier.ma5Data,
        ma10: notifier.ma10Data,
        ma30: notifier.ma30Data,
        volumes: notifier.displayVolumes,
        macdData: notifier.displayMacdData,
        tradePoints: notifier.visibleTradePoints,
        currentOpenPrice: state.currentKline?.open,
        positionCost: state.hasPosition ? state.positionCost : null,
      ),
    );
  }

  Widget _buildTradeButtons() {
    final state = ref.watch(battleProvider);
    final isComplete = state.isTrainingComplete;
    final isReplay = state.isReplayMode;
    final shouldDisableActions = isComplete || isReplay;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border, width: 0.5))),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: _buildButton('换股', () {
                _hasShownTrainingCompleteDialog = false;
                ref.read(battleProvider.notifier).initializeRandom();
              }, AppTheme.surface, AppTheme.muted)),
          const SizedBox(width: 4),
          Expanded(
              flex: 2,
              child: _buildButton(
                  '条件单',
                  shouldDisableActions ? () {} : _showConditionalOrderDialog,
                  shouldDisableActions ? Colors.grey[300]! : AppTheme.surface,
                  shouldDisableActions ? Colors.grey : AppTheme.muted)),
          const SizedBox(width: 4),
          Expanded(
              flex: 2,
              child: _buildButton(
                  '买入',
                  shouldDisableActions ? () {} : _showBuyDialog,
                  shouldDisableActions ? Colors.grey[300]! : Colors.red,
                  shouldDisableActions ? Colors.grey : Colors.white)),
          const SizedBox(width: 4),
          Expanded(
              flex: 2,
              child: _buildButton(
                  '卖出',
                  shouldDisableActions ? () {} : _showSellDialog,
                  shouldDisableActions ? Colors.grey[300]! : Colors.green,
                  shouldDisableActions ? Colors.grey : Colors.white)),
          const SizedBox(width: 4),
          _buildProgressDisplay(),
          const SizedBox(width: 4),
          Expanded(
              flex: 2,
              child: _buildButton(
                  isComplete || isReplay ? '已完成' : '下一步',
                  shouldDisableActions
                      ? () {}
                      : () {
                          _hasShownTrainingCompleteDialog = false;
                          ref.read(battleProvider.notifier).handleNextStep();
                        },
                  shouldDisableActions ? Colors.grey : AppTheme.accent,
                  Colors.white)),
        ],
      ),
    );
  }

  Widget _buildButton(
      String label, VoidCallback onPressed, Color bgColor, Color textColor) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          side: BorderSide(color: AppTheme.border),
          padding: const EdgeInsets.symmetric(vertical: 6)),
      child: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }

  Widget _buildProgressDisplay() {
    final state = ref.watch(battleProvider);
    final isComplete = state.isTrainingComplete;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green.withOpacity(0.1) : AppTheme.bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${state.currentTrainingDay}/${state.trainingDays}',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: isComplete ? Colors.green : AppTheme.accent,
        ),
      ),
    );
  }

  void _showConditionalOrderDialog() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('条件单设置',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    const Text('功能开发中...'),
                    const SizedBox(height: 16),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('关闭'))),
                  ]),
            ));
  }

  void _showBuyDialog() {
    final price = ref.read(battleProvider).currentPrice;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) => _TradeAmountSheet(
            title: '买入',
            currentPrice: price,
            onConfirm: (price, quantity) {
              Navigator.pop(context);
              ref.read(battleProvider.notifier).buy(price, quantity);
            }));
  }

  void _showSellDialog() {
    final state = ref.read(battleProvider);
    if (!state.hasPosition) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('没有持仓')));
      return;
    }
    final price = state.currentPrice;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) => _TradeAmountSheet(
            title: '卖出',
            currentPrice: price,
            maxQuantity: state.positionQuantity,
            onConfirm: (price, quantity) {
              Navigator.pop(context);
              ref.read(battleProvider.notifier).sell(price, quantity);
            }));
  }
}

class _TradeAmountSheet extends ConsumerStatefulWidget {
  final String title;
  final double currentPrice;
  final double? maxQuantity;
  final Function(double, double) onConfirm;

  const _TradeAmountSheet(
      {required this.title,
      required this.currentPrice,
      this.maxQuantity,
      required this.onConfirm});

  @override
  ConsumerState<_TradeAmountSheet> createState() => _TradeAmountSheetState();
}

class _TradeAmountSheetState extends ConsumerState<_TradeAmountSheet> {
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  double _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _priceController =
        TextEditingController(text: widget.currentPrice.toStringAsFixed(2));
    final maxQty = widget.maxQuantity ??
        (100000 / widget.currentPrice / 100).floor() * 100;
    _quantityController = TextEditingController(text: maxQty.toString());
    _updateTotalAmount();
  }

  void _updateTotalAmount() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    setState(() {
      _totalAmount = price * quantity;
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _setQuantityPercent(double percent) {
    final state = ref.read(battleProvider);
    double maxQty;

    if (widget.title == '买入') {
      final maxBuyQty = (state.accountBalance /
                  (double.tryParse(_priceController.text) ??
                      widget.currentPrice) /
                  100)
              .floor() *
          100;
      maxQty = maxBuyQty * percent;
    } else {
      maxQty = (state.positionQuantity * percent / 100).floor() * 100;
    }

    _quantityController.text = maxQty.toString();
    _updateTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(battleProvider);
    final isBuy = widget.title == '买入';

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 资产信息
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('账户余额', style: TextStyle(fontSize: 12)),
                      Text('${state.accountBalance.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  if (isBuy) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('可买数量', style: TextStyle(fontSize: 12)),
                        _buildBuyableQuantity(state.accountBalance),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('持仓数量', style: TextStyle(fontSize: 12)),
                        Text('${state.positionQuantity}股',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('持仓成本', style: TextStyle(fontSize: 12)),
                        Text('${state.positionCost.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 价格输入
            TextField(
              controller: _priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: '价格',
                border: const OutlineInputBorder(),
                suffixText: '当前: ${widget.currentPrice.toStringAsFixed(2)}',
              ),
              onChanged: (_) => _updateTotalAmount(),
            ),
            const SizedBox(height: 12),

            // 数量输入
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '数量(股)',
                border: OutlineInputBorder(),
                helperText: '1手=100股',
              ),
              onChanged: (_) => _updateTotalAmount(),
            ),
            const SizedBox(height: 12),

            // 快捷选择按钮
            Row(
              children: [
                Expanded(
                    child: _buildQuickButton(
                        '1/3', () => _setQuantityPercent(1 / 3))),
                const SizedBox(width: 8),
                Expanded(
                    child: _buildQuickButton(
                        '1/2', () => _setQuantityPercent(1 / 2))),
                const SizedBox(width: 8),
                Expanded(
                    child:
                        _buildQuickButton('全仓', () => _setQuantityPercent(1))),
              ],
            ),
            const SizedBox(height: 16),

            // 交易金额
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('交易金额', style: TextStyle(fontSize: 14)),
                Text('${_totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),

            // 确认按钮
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final price = double.tryParse(_priceController.text) ??
                        widget.currentPrice;
                    final quantity =
                        double.tryParse(_quantityController.text) ?? 0;
                    if (quantity > 0) {
                      widget.onConfirm(price, quantity);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.title == '买入' ? Colors.red : Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text(widget.title),
                )),
          ]),
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildBuyableQuantity(double accountBalance) {
    final price = double.tryParse(_priceController.text) ?? widget.currentPrice;
    final buyableQty = (accountBalance / price / 100).floor() * 100;
    return Text('${buyableQty}股',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
  }
}
