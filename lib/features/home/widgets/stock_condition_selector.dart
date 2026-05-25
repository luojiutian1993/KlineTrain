import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/stock_filter_condition.dart';
import '../../../data/models/stock_filter_result_model.dart';
import '../../../providers/stock_filter_provider.dart';
import '../../../providers/selection_provider.dart';
import '../../../theme/app_theme.dart';

class StockConditionSelector extends ConsumerStatefulWidget {
  final String selectedCondition;
  final ValueChanged<String> onChanged;

  const StockConditionSelector({
    super.key,
    required this.selectedCondition,
    required this.onChanged,
  });

  @override
  ConsumerState<StockConditionSelector> createState() =>
      _StockConditionSelectorState();
}

class _StockConditionSelectorState
    extends ConsumerState<StockConditionSelector> {
  bool _isExpanded = false;
  static const int _maxVisibleCount = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final condition =
          StockFilterCondition.fromString(widget.selectedCondition);
      ref.read(stockFilterProvider.notifier).selectCondition(condition);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(stockFilterProvider);
    final filterCount = filterState.filterCount;
    final isLoading = filterState.isLoading;
    final filterResult = filterState.filterResult;

    final upTrendConditions = StockFilterCondition.upTrendConditions;
    final downTrendConditions = StockFilterCondition.downTrendConditions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildConditionGroup(
          title: '趋势向上',
          conditions: upTrendConditions,
          selectedLabel: widget.selectedCondition,
          accentColor: Colors.red,
          onSelect: _onConditionSelected,
        ),
        const SizedBox(height: 16),
        _buildConditionGroup(
          title: '趋势向下',
          conditions: downTrendConditions,
          selectedLabel: widget.selectedCondition,
          accentColor: Colors.green,
          onSelect: _onConditionSelected,
        ),
        const SizedBox(height: 12),
        _buildResultIndicator(filterCount, isLoading),
        const SizedBox(height: 16),
        _buildStockList(filterResult, isLoading),
      ],
    );
  }

  Widget _buildConditionGroup({
    required String title,
    required List<StockFilterCondition> conditions,
    required String selectedLabel,
    required Color accentColor,
    required ValueChanged<StockFilterCondition> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.fg,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: conditions.length,
          itemBuilder: (context, index) {
            final condition = conditions[index];
            final isSelected = selectedLabel == condition.label;

            return _ConditionRadioTile(
              condition: condition.label,
              isSelected: isSelected,
              accentColor: accentColor,
              onTap: () => onSelect(condition),
            );
          },
        ),
      ],
    );
  }

  Widget _buildResultIndicator(int? count, bool isLoading) {
    if (isLoading) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '正在计算...',
              style: TextStyle(color: AppTheme.muted, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        count != null ? '当前满足条件: $count 支股票' : '请选择条件查看结果',
        style: const TextStyle(color: AppTheme.muted, fontSize: 12),
      ),
    );
  }

  void _onConditionSelected(StockFilterCondition condition) {
    widget.onChanged(condition.label);

    // 获取 selectionProvider 中的市场选择
    final selectionState = ref.read(selectionProvider);
    final selectedSubMarkets = selectionState.selectedSubMarkets;

    // 同步市场选择到 stockFilterProvider
    if (selectedSubMarkets.isNotEmpty) {
      selectedSubMarkets.forEach((marketCode) {
        ref.read(stockFilterProvider.notifier).toggleMarket(marketCode);
      });
    }

    ref.read(stockFilterProvider.notifier).selectCondition(condition);
  }

  Widget _buildStockList(StockFilterResultResponse? result, bool isLoading) {
    if (isLoading) {
      return const SizedBox.shrink();
    }

    if (result == null || result.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalCount = result.items.length;
    final visibleItems = _isExpanded
        ? result.items
        : result.items.take(_maxVisibleCount).toList();
    final hasMore = totalCount > _maxVisibleCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '选股结果 ($totalCount)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.fg,
              ),
            ),
            if (hasMore) ...[
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? '收起' : '更多',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.accent,
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppTheme.accent,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children:
                visibleItems.map((stock) => _buildStockItem(stock)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStockItem(StockFilterResultModel stock) {
    final isUp = stock.changePercent >= 0;
    final changeColor = isUp ? Colors.red : Colors.green;
    final filterState = ref.watch(stockFilterProvider);
    final isSelected = filterState.selectedStockCode == stock.symbol;

    return GestureDetector(
      onTap: () {
        ref.read(stockFilterProvider.notifier).selectStock(stock);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.border)),
          color:
              isSelected ? AppTheme.accent.withAlpha(15) : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.accent : AppTheme.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: AppTheme.accent,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.symbolName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppTheme.accent : AppTheme.fg,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stock.marketCode}${stock.symbol}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  stock.closePrice.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: changeColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${isUp ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: changeColor,
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

class _ConditionRadioTile extends StatelessWidget {
  final String condition;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _ConditionRadioTile({
    required this.condition,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withAlpha(25) : Colors.white,
          border: Border.all(
            color: isSelected ? accentColor : AppTheme.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? accentColor : AppTheme.muted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: accentColor,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                condition,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? accentColor : AppTheme.fg,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
