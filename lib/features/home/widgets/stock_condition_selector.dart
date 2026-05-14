import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StockConditionSelector extends StatefulWidget {
  final String selectedCondition;
  final ValueChanged<String> onChanged;

  const StockConditionSelector({
    super.key,
    required this.selectedCondition,
    required this.onChanged,
  });

  @override
  State<StockConditionSelector> createState() => _StockConditionSelectorState();
}

class _StockConditionSelectorState extends State<StockConditionSelector> {
  final List<String> _conditions = [
    '随机', '历史新高', '1年新高', '200日新高',
    '30日涨幅前50', '15日涨幅前50', '涨停', '连板',
    '量升价涨', '上升趋势', '历史新低', '1年新低',
    '200日新低', '30日跌幅前50', '15日跌幅前50',
    '下降趋势', '跌停', '连续跌停'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _conditions.length,
          itemBuilder: (context, index) {
            final condition = _conditions[index];
            final isSelected = widget.selectedCondition == condition;

            return _ConditionRadioTile(
              condition: condition,
              isSelected: isSelected,
              onTap: () {
                widget.onChanged(condition);
              },
            );
          },
        ),
        const SizedBox(height: 12),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            '当前满足条件: 12 支股票',
            style: TextStyle(color: AppTheme.muted, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _ConditionRadioTile extends StatelessWidget {
  final String condition;
  final bool isSelected;
  final VoidCallback onTap;

  const _ConditionRadioTile({
    required this.condition,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : AppTheme.muted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                condition,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : AppTheme.fg,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}