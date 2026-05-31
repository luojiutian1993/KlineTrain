# K线图表与技术指标对齐修复 - 技术方案

> 本文档记录 K线图表与技术指标垂直对齐修复功能的技术实现方案。

**文档版本**：v1.0.0
**创建日期**：2026-05-31
**需求追溯**：REQ-018 - K线图表与技术指标对齐修复

---

## 1. 问题分析

### 1.1 问题根因

当前实现中存在的问题：

#### 1.1.1 数据范围计算逻辑不一致

在 `BattleProvider` 中，`displayKlineData` 和各指标数据（`displayMacdData`、`displayVolumes` 等）虽然都使用 `visibleStartIndex` 和 `visibleKlineCount` 计算，但存在边界条件处理差异：

```dart
// displayKlineData 计算
List<KlineData> get displayKlineData {
  final endIndex = (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
  final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
  final startIndex = state.visibleStartIndex.clamp(0, maxStart);
  // ... 后续逻辑
}

// displayMacdData 计算
List<MacdData> get displayMacdData {
  final endIndex = (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
  final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
  final startIndex = state.visibleStartIndex.clamp(0, maxStart);
  // ... 后续逻辑
}
```

虽然计算逻辑相同，但 `skip` 和 `take` 操作后的数据长度可能不一致。

#### 1.1.2 fl_chart 坐标系对齐问题

fl_chart 的 BarChart/LineChart 默认使用 `BarChartAlignment.spaceAround`，导致：
- 柱状图/线条之间存在间距
- 无法与 K 线精确对齐
- 当数据量变化时，间距比例会改变

```dart
// 当前 IndicatorPanel 中的问题代码
BarChart(
  BarChartData(
    alignment: BarChartAlignment.spaceAround,  // 问题：导致间距不一致
    // ...
  ),
)
```

#### 1.1.3 K 线与指标数据偏移不同步

当 `visibleStartIndex` 变化时（缩放/滑动），K 线使用自定义 CustomPainter 绘制，指标使用 fl_chart 组件，两者的 x 轴映射算法不同：

```dart
// _CandleStickPainter 中
final double candleWidth = size.width / klineData.length;  // 按数据长度平均分

// IndicatorPanel 中的 BarChart
alignment: BarChartAlignment.spaceAround  // 使用间距对齐
```

---

## 2. 技术方案

### 2.1 统一图表组件方案

采用**统一坐标映射**策略，确保 K 线主图与所有副图指标使用相同的 x 轴映射算法。

### 2.2 核心修改点

| 序号 | 修改点 | 文件 | 说明 |
|------|--------|------|------|
| 1 | 创建统一坐标计算 | BattleProvider | 新增 `getDisplayRange()` 方法统一计算数据范围 |
| 2 | 修改 K 线渲染 | kline_chart.dart | 改用 `center` 对齐，与 fl_chart 保持一致 |
| 3 | 修改副图指标 | indicator_panel.dart | 将 `spaceAround` 改为 `center`，添加 `barGroups` 精确控制 |
| 4 | 统一复盘页面 | training_detail_screen.dart | 采用相同对齐策略 |

---

## 3. 详细设计

### 3.1 统一数据范围计算

在 `BattleProvider` 中新增统一方法：

```dart
class ChartDisplayRange {
  final int startIndex;      // 起始索引
  final int dataLength;      // 数据长度
  final double candleWidth;  // 每根K线宽度
}

ChartDisplayRange getDisplayRange() {
  final endIndex = (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
  final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
  final startIndex = state.visibleStartIndex.clamp(0, maxStart);
  final length = min(state.visibleKlineCount, endIndex - startIndex);

  return ChartDisplayRange(
    startIndex: startIndex,
    dataLength: length,
    candleWidth: _calculateCandleWidth(length),
  );
}
```

### 3.2 统一 x 轴映射算法

所有图表使用统一的 x 轴映射：

```dart
double getXPosition(int index, int totalCount, double chartWidth) {
  // 中心对齐方式：确保数据点精确对应 K 线
  final candleWidth = chartWidth / totalCount;
  return (index + 0.5) * candleWidth;  // 每个数据点居中
}
```

### 3.3 修改 K 线主图

修改 `kline_chart.dart` 中的 `_CandleStickPainter`：

```dart
// 将按数据长度平均分改为按实际可见数量平均分
final double candleWidth = size.width / klineData.length;
// 改为中心对齐
final double candleWidth = size.width / totalVisibleCount;
```

### 3.4 修改副图指标

修改 `indicator_panel.dart` 中的所有图表：

```dart
// 将 spaceAround 改为 center
alignment: BarChartAlignment.center,

// 添加 groupsCount 确保对齐
groupsCount: displayData.length,

// 移除 interval 让 fl_chart 不自动计算
getTitlesWidget: (value, meta) => SizedBox.shrink(),
```

### 3.5 统一坐标转换工具类

创建 `ChartAlignmentHelper` 工具类：

```dart
class ChartAlignmentHelper {
  /// 根据索引计算 x 坐标（中心对齐）
  static double indexToX(int index, int totalCount, double chartWidth) {
    if (totalCount <= 0) return 0;
    final candleWidth = chartWidth / totalCount;
    return (index + 0.5) * candleWidth;
  }

  /// 根据 x 坐标计算索引
  static int xToIndex(double x, int totalCount, double chartWidth) {
    if (chartWidth <= 0) return 0;
    final candleWidth = chartWidth / totalCount;
    return (x / candleWidth).floor().clamp(0, totalCount - 1);
  }

  /// 计算等宽柱状图/线宽
  static double calculateBarWidth(int totalCount, double chartWidth, double ratio) {
    if (totalCount <= 0) return 0;
    final candleWidth = chartWidth / totalCount;
    return candleWidth * ratio;  // ratio 通常为 0.6~0.8
  }
}
```

---

## 4. 修改文件清单

### 4.1 核心文件

| 文件路径 | 修改类型 | 修改内容 |
|----------|----------|----------|
| `lib/features/battle/providers/battle_provider.dart` | 修改 | 新增统一数据范围计算方法 |
| `lib/features/training/widgets/kline_chart.dart` | 修改 | 统一 x 轴映射算法 |
| `lib/features/battle/widgets/indicator_panel.dart` | 修改 | 统一图表对齐方式 |
| `lib/features/mine/training_history/training_detail_screen.dart` | 修改 | 复盘页面采用相同策略 |

### 4.2 可能需要新增的文件

| 文件路径 | 说明 |
|----------|------|
| `lib/features/battle/widgets/chart_alignment_helper.dart` | 坐标转换工具类 |

---

## 5. 实施步骤

### 阶段 1：创建工具类（预估 1 小时）

1. 创建 `ChartAlignmentHelper` 工具类
2. 实现 `indexToX`、`xToIndex`、`calculateBarWidth` 方法
3. 添加单元测试验证

### 阶段 2：修改 BattleProvider（预估 1 小时）

1. 新增 `ChartDisplayRange` 类
2. 新增 `getDisplayRange()` 方法
3. 统一所有 `display*Data` getter 的计算逻辑
4. 添加日志输出便于调试

### 阶段 3：修改 K 线主图（预估 2 小时）

1. 修改 `_CandleStickPainter` 使用统一 x 轴映射
2. 确保 K 线宽度与副图一致
3. 验证渲染效果

### 阶段 4：修改副图指标（预估 3 小时）

1. 修改 `IndicatorPanel` 中的所有图表
2. 将 `spaceAround` 改为 `center`
3. 添加 `groupsCount` 和 `barGroups` 精确控制
4. 验证每个指标的对齐效果

### 阶段 5：修改复盘页面（预估 1 小时）

1. 修改 `TrainingDetailScreen` 中的图表
2. 采用与实战页面相同的对齐策略
3. 验证对齐效果

### 阶段 6：测试验证（预估 1 小时）

1. 测试不同缩放级别下的对齐效果
2. 测试滑动操作
3. 测试不同周期（日/周/月）
4. 测试复盘页面

---

## 6. 风险与应对

| 风险 | 影响 | 应对措施 |
|------|------|----------|
| fl_chart 对齐限制 | 部分对齐效果可能不完美 | 考虑使用自定义 ChartRenderer |
| 性能影响 | 频繁计算可能影响性能 | 添加缓存，避免重复计算 |
| 多周期兼容 | 周K/月K数据量少，对齐难度大 | 针对不同周期使用不同参数 |

---

## 7. 验收标准

### 7.1 功能验收

| 验收项 | 验收条件 |
|--------|----------|
| 初始状态对齐 | K 线与指标精确对齐，无明显偏移 |
| 缩放对齐 | 放大/缩小后，K 线与指标保持对齐 |
| 滑动对齐 | 左右滑动后，K 线与指标保持对齐 |
| 多周期对齐 | 日/周/月周期均保持对齐 |
| 复盘页面对齐 | 复盘页面同样对齐 |

### 7.2 性能验收

| 验收项 | 验收条件 |
|--------|----------|
| 渲染性能 | 图表操作流畅（60fps） |
| 内存占用 | 不因对齐修复增加额外内存 |

---

## 8. 文档关联

| 文档类型 | 文档路径 |
|----------|----------|
| 需求文档 | `docs/features/实战模块/K线与指标对齐修复需求.md` |
| 任务规划 | `docs/features/实战模块/K线与指标对齐修复_任务规划.md` |

---

*文档版本: v1.0.0*
*创建日期: 2026-05-31*