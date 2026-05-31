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

在 `BattleProvider` 中，`displayKlineData` 和各指标数据（`displayMacdData`、`displayVolumes` 等）虽然都使用 `visibleStartIndex` 和 `visibleKlineCount` 计算，但存在边界条件处理差异。

#### 1.1.2 fl_chart 坐标系对齐问题

fl_chart 的 BarChart/LineChart 默认使用 `BarChartAlignment.spaceAround`，导致柱状图/线条之间存在间距，无法与 K 线精确对齐。

#### 1.1.3 K 线与指标数据偏移不同步

K 线使用自定义 CustomPainter 绘制，指标使用 fl_chart 组件，两者的 x 轴映射算法不同。

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
  final int startIndex;
  final int dataLength;
  final double candleWidth;
}

ChartDisplayRange getDisplayRange() {
  final endIndex = (state.currentDayIndex + 1).clamp(0, state.allKlineData.length);
  final maxStart = (endIndex - state.visibleKlineCount).clamp(0, endIndex);
  final startIndex = state.visibleStartIndex.clamp(0, maxStart);
  final length = min(state.visibleKlineCount, endIndex - startIndex);
  return ChartDisplayRange(startIndex: startIndex, dataLength: length, candleWidth: 0);
}
```

### 3.2 统一 x 轴映射算法

所有图表使用统一的 x 轴映射：

```dart
double getXPosition(int index, int totalCount, double chartWidth) {
  final candleWidth = chartWidth / totalCount;
  return (index + 0.5) * candleWidth;
}
```

### 3.3 修改 K 线主图

修改 `kline_chart.dart` 中的 `_CandleStickPainter`：

```dart
final double candleWidth = size.width / klineData.length;
// 改为 center 对齐
alignment: BarChartAlignment.center;
```

### 3.4 修改副图指标

修改 `indicator_panel.dart` 中的所有图表：

```dart
alignment: BarChartAlignment.center,
groupsCount: displayData.length,
```

### 3.5 统一坐标转换工具类

创建 `ChartAlignmentHelper` 工具类：

```dart
class ChartAlignmentHelper {
  static double indexToX(int index, int totalCount, double chartWidth) {
    if (totalCount <= 0) return 0;
    final candleWidth = chartWidth / totalCount;
    return (index + 0.5) * candleWidth;
  }

  static int xToIndex(double x, int totalCount, double chartWidth) {
    if (chartWidth <= 0) return 0;
    final candleWidth = chartWidth / totalCount;
    return (x / candleWidth).floor().clamp(0, totalCount - 1);
  }

  static double calculateBarWidth(int totalCount, double chartWidth, double ratio) {
    if (totalCount <= 0) return 0;
    final candleWidth = chartWidth / totalCount;
    return candleWidth * ratio;
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

### 4.2 新增文件

| 文件路径 | 说明 |
|----------|------|
| `lib/features/battle/widgets/chart_alignment_helper.dart` | 坐标转换工具类 |

---

## 5. 验收标准

### 5.1 功能验收

| 验收项 | 验收条件 |
|--------|----------|
| 初始状态对齐 | K 线与指标精确对齐，无明显偏移 |
| 缩放对齐 | 放大/缩小后，K 线与指标保持对齐 |
| 滑动对齐 | 左右滑动后，K 线与指标保持对齐 |
| 多周期对齐 | 日/周/月周期均保持对齐 |
| 复盘页面对齐 | 复盘页面同样对齐 |

---

## 6. 文档关联

| 文档类型 | 文档路径 |
|----------|----------|
| 需求文档 | `specs/features/kline_indicator_alignment.md` |
| 任务规划 | `specs/features/kline_indicator_alignment_任务规划.md` |

---

*文档版本: v1.0.0*
*创建日期: 2026-05-31*