import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/battle/providers/battle_provider.dart';
import 'package:kline_trainer/features/battle/models/position_config.dart';
import 'package:kline_trainer/features/battle/widgets/position_setting_dialog.dart';

class TradeAmountSheet extends ConsumerStatefulWidget {
  final String title;
  final double currentPrice;
  final double? maxQuantity;
  final Function(double, double) onConfirm;

  const TradeAmountSheet({
    super.key,
    required this.title,
    required this.currentPrice,
    this.maxQuantity,
    required this.onConfirm,
  });

  @override
  ConsumerState<TradeAmountSheet> createState() => _TradeAmountSheetState();
}

class _TradeAmountSheetState extends ConsumerState<TradeAmountSheet> {
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  double _totalAmount = 0;
  List<PositionItem> _positions = [];

  @override
  void initState() {
    super.initState();
    _priceController =
        TextEditingController(text: widget.currentPrice.toStringAsFixed(2));
    _positions = widget.title == '买入'
        ? List.from(PositionConfig.buyPositions)
        : List.from(PositionConfig.sellPositions);
    final defaultQty = _calculateDefaultQuantity();
    _quantityController = TextEditingController(text: defaultQty.toString());
    _updateTotalAmount();
  }

  double _calculateDefaultQuantity() {
    final state = ref.read(battleProvider);
    final price = double.tryParse(_priceController.text) ?? widget.currentPrice;

    if (widget.title == '买入') {
      final maxBuyQty = PositionCalculator.calculateMaxBuyQuantity(state.accountBalance, price);
      if (_positions.isNotEmpty) {
        return PositionCalculator.calculateQuantity(maxBuyQty, _positions.first.ratio);
      }
      return maxBuyQty;
    } else {
      final maxSellQty = state.positionQuantity;
      if (_positions.isNotEmpty) {
        return PositionCalculator.calculateQuantity(maxSellQty, _positions.first.ratio);
      }
      return maxSellQty;
    }
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

  void _setPositionRatio(double ratio) {
    final state = ref.read(battleProvider);
    double maxQty;
    final price = double.tryParse(_priceController.text) ?? widget.currentPrice;

    if (widget.title == '买入') {
      maxQty = PositionCalculator.calculateMaxBuyQuantity(state.accountBalance, price);
    } else {
      maxQty = state.positionQuantity;
    }

    final quantity = PositionCalculator.calculateQuantity(maxQty, ratio);
    _quantityController.text = quantity.toString();
    _updateTotalAmount();
  }

  void _showPositionSettingDialog() {
    showDialog(
      context: context,
      builder: (context) => PositionSettingDialog(
        isBuy: widget.title == '买入',
      ),
    ).then((_) {
      setState(() {
        _positions = widget.title == '买入'
            ? List.from(PositionConfig.buyPositions)
            : List.from(PositionConfig.sellPositions);
      });
    });
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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

          // 仓位选择行
          Row(
            children: [
              const Text('仓位:', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              ..._positions.map((position) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _buildPositionButton(position),
                    ),
                  )),
              const SizedBox(width: 4),
              _buildEditButton(),
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
                    backgroundColor: isBuy ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(widget.title),
              )),
        ],
      ),
    );
  }

  Widget _buildPositionButton(PositionItem position) {
    return TextButton(
      onPressed: () => _setPositionRatio(position.ratio),
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 6),
      ),
      child: Text(position.label, style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _buildEditButton() {
    return SizedBox(
      width: 40,
      child: TextButton(
        onPressed: _showPositionSettingDialog,
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue[100],
          padding: const EdgeInsets.symmetric(vertical: 6),
        ),
        child: const Text('编辑', style: TextStyle(fontSize: 10, color: Colors.blue)),
      ),
    );
  }

  Widget _buildBuyableQuantity(double accountBalance) {
    final price = double.tryParse(_priceController.text) ?? widget.currentPrice;
    final buyableQty = PositionCalculator.calculateMaxBuyQuantity(accountBalance, price);
    return Text('${buyableQty}股',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
  }
}
