import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/stock_filter_condition.dart';
import '../../../providers/stock_filter_provider.dart';
import '../../../theme/app_theme.dart';

class StockConditionSelector extends ConsumerStatefulWidget {
  final String selectedCondition;
  final ValueChanged<String> onChanged;
  final StockTimeRange? selectedTimeRange;
  final ValueChanged<StockTimeRange>? onTimeRangeChanged;

  const StockConditionSelector({
    super.key,
    required this.selectedCondition,
    required this.onChanged,
    this.selectedTimeRange,
    this.onTimeRangeChanged,
  });

  @override
  ConsumerState<StockConditionSelector> createState() =>
      _StockConditionSelectorState();
}

class _StockConditionSelectorState
    extends ConsumerState<StockConditionSelector> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final condition = StockFilterCondition.fromString(widget.selectedCondition);
      ref.read(stockFilterProvider.notifier).selectCondition(condition);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(stockFilterProvider);
    final filterCount = filterState.filterCount;
    final isLoading = filterState.isLoading;

    final upTrendConditions = StockFilterCondition.upTrendConditions;
    final downTrendConditions = StockFilterCondition.downTrendConditions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimeRangeSelector(),
        const SizedBox(height: 16),
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
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
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
            const Text(
              '时间范围',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.fg,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TimeRangeType.values.map((type) {
            final isSelected = widget.selectedTimeRange?.type == type ||
                (widget.selectedTimeRange == null && type == TimeRangeType.recent1Year);
            return _TimeRangeChip(
              type: type,
              isSelected: isSelected,
              onTap: () => _onTimeRangeSelected(type),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _onTimeRangeSelected(TimeRangeType type) {
    StockTimeRange? timeRange;
    switch (type) {
      case TimeRangeType.recent1Year:
        timeRange = StockTimeRange.recent1Year();
      case TimeRangeType.recent3Years:
        timeRange = StockTimeRange.recent3Years();
      case TimeRangeType.recent5Years:
        timeRange = StockTimeRange.recent5Years();
      case TimeRangeType.custom:
        timeRange = widget.selectedTimeRange ?? StockTimeRange.recent1Year();
        _showCustomDatePicker(type);
        return;
    }
    if (timeRange != null) {
      widget.onTimeRangeChanged?.call(timeRange);
    }
  }

  Future<void> _showCustomDatePicker(TimeRangeType type) async {
    final now = DateTime.now();
    final initialStartDate = widget.selectedTimeRange?.startDate ?? DateTime(now.year - 1, now.month, now.day);
    final initialEndDate = widget.selectedTimeRange?.endDate ?? now;

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1990, 1, 1),
      lastDate: now,
      initialDateRange: DateTimeRange(start: initialStartDate, end: initialEndDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.accent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.fg,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final timeRange = StockTimeRange.custom(picked.start, picked.end);
      widget.onTimeRangeChanged?.call(timeRange);
    }
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
    ref.read(stockFilterProvider.notifier).selectCondition(condition);
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

class _TimeRangeChip extends StatelessWidget {
  final TimeRangeType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeRangeChip({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withAlpha(25) : Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (type == TimeRangeType.custom)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.date_range,
                  size: 14,
                  color: isSelected ? AppTheme.accent : AppTheme.muted,
                ),
              ),
            Text(
              type.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppTheme.accent : AppTheme.fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
