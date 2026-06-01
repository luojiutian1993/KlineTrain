import 'package:flutter/material.dart';
import 'package:kline_trainer/features/battle/models/position_config.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class PositionSettingDialog extends StatefulWidget {
  final bool isBuy;

  const PositionSettingDialog({
    super.key,
    required this.isBuy,
  });

  @override
  State<PositionSettingDialog> createState() => _PositionSettingDialogState();
}

class _PositionSettingDialogState extends State<PositionSettingDialog> {
  late List<PositionItem> _positions;
  bool _skipBuyConfirm = false;
  PositionItem? _draggedItem;
  int? _dragTargetIndex;

  @override
  void initState() {
    super.initState();
    _positions = widget.isBuy
        ? List.from(PositionConfig.buyPositions)
        : List.from(PositionConfig.sellPositions);
    _skipBuyConfirm = PositionConfig.skipBuyConfirm;
  }

  void _removePosition(int index) {
    if (_positions.length > 1) {
      setState(() {
        _positions.removeAt(index);
      });
    }
  }

  void _addPosition() {
    if (_positions.length < 12) {
      final nextN = _positions.length + 1;
      setState(() {
        _positions.add(PositionItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          label: '1/$nextN仓',
          ratio: 1 / nextN,
        ));
      });
    }
  }

  void _resetToDefault() {
    setState(() {
      _positions = widget.isBuy
          ? List.from(defaultBuyPositions)
          : List.from(defaultSellPositions);
    });
  }

  void _savePositions() {
    if (widget.isBuy) {
      PositionConfig.saveBuyPositions(_positions);
      PositionConfig.skipBuyConfirm = _skipBuyConfirm;
    } else {
      PositionConfig.saveSellPositions(_positions);
    }
    Navigator.pop(context);
  }

  void _onDragStarted(PositionItem item) {
    _draggedItem = item;
  }

  void _onDragEnded() {
    _draggedItem = null;
    _dragTargetIndex = null;
  }

  void _onDrop(int targetIndex) {
    if (_draggedItem != null) {
      setState(() {
        final currentIndex = _positions.indexOf(_draggedItem!);
        if (currentIndex != -1 && currentIndex != targetIndex) {
          _positions.removeAt(currentIndex);
          _positions.insert(targetIndex, _draggedItem!);
        }
        _dragTargetIndex = null;
        _draggedItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('仓位设置', style: TextStyle(fontSize: 16)),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTabButton('买入仓位', true),
                _buildTabButton('卖出仓位', false),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '拖动按钮可以排序，最多可拥有12个仓位，默认按第1个仓位买入',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _buildPositionButtons(),
            ),
            const SizedBox(height: 16),
            if (widget.isBuy)
              Row(
                children: [
                  Checkbox(
                    value: _skipBuyConfirm,
                    onChanged: (value) {
                      setState(() {
                        _skipBuyConfirm = value ?? false;
                      });
                    },
                  ),
                  const Text('买入时不弹确认框', style: TextStyle(fontSize: 12)),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _resetToDefault,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('默认值'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _savePositions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                    ),
                    child: Text(widget.isBuy ? '保存买入仓位' : '保存卖出仓位'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, bool isSelected) {
    return Expanded(
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? AppTheme.accent : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  List<Widget> _buildPositionButtons() {
    final buttons = <Widget>[];
    for (int i = 0; i < _positions.length; i++) {
      buttons.add(
        DragTarget<PositionItem>(
          onWillAccept: (data) => true,
          onAccept: (data) => _onDrop(i),
          builder: (context, candidateData, rejectedData) {
            return Container(
              decoration: _dragTargetIndex == i
                  ? BoxDecoration(
                      border: Border.all(color: AppTheme.accent, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    )
                  : null,
              child: Draggable<PositionItem>(
                data: _positions[i],
                onDragStarted: () => _onDragStarted(_positions[i]),
                onDragEnd: (_) => _onDragEnded(),
                feedback: Material(
                  child: _buildPositionChip(_positions[i], true),
                ),
                childWhenDragging: _buildPositionChip(_positions[i], false),
                child: _buildPositionChip(_positions[i], true),
              ),
            );
          },
        ),
      );
    }
    if (_positions.length < 12) {
      buttons.add(
        InkWell(
          onTap: _addPosition,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('+', style: TextStyle(fontSize: 18)),
          ),
        ),
      );
    }
    return buttons;
  }

  Widget _buildPositionChip(PositionItem item, bool visible) {
    if (!visible) {
      return const SizedBox(width: 60, height: 32);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item.label, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          if (_positions.length > 1)
            InkWell(
              onTap: () => _removePosition(_positions.indexOf(item)),
              child: const Icon(Icons.close, size: 14, color: Colors.red),
            ),
        ],
      ),
    );
  }
}
