# K线图表交互优化 — 技术设计文档

## 1. 设计概要

**功能描述**：为实战模块K线图表添加触屏手势支持（滑动和双指缩放），优化按钮缩放逻辑，增加边界防抖提示，确保指标图表同步变化。

**影响范围**：实战模块（BattleProvider、KlineChartContainer、ControlButtons、K线图表组件、指标图表组件

**技术难点**：
1. 手势识别与状态管理的无缝集成
2. 边界防抖机制实现
3. 多组件状态一致性保证

**外部依赖**：Flutter内置手势系统，无需新增第三方库

---

## 2. 架构概览

### 2.1 架构描述

本功能主要涉及三个核心组件交互：
1. **手势层**：通过 GestureDetector 监听用户触屏操作，转换为业务指令
2. **状态层**：BattleProvider 处理业务逻辑，管理可视范围和缩放状态
3. **渲染层**：KLineChartContainer 及指标图表组件响应状态变化

用户触屏操作用户触屏操作 → GestureDetectorBattleProviderKlineChartContainer指标图表手势层状态层渲染层

### 2.2 关键流程

```mermaid
sequenceDiagram
    participant User as 用户
    participant GD as GestureDetector
    participant BP as BattleProvider
    participant KCC as KlineChartContainer
    participant IC as 指标图表

    User->>GD: 触屏手势(滑动/缩放)
    GD->>BP: 调用 slideLeft/Right()
    BP->>BP: 校验边界
    alt 边界检查
    BP->>BP: 更新 visibleStartIndex
    BP->>KCC: notifyListeners()
    KCC->>KCC: rebuild
    KCC->>IC: 同步数据
    IC->>IC: rebuild

    User->>GD: 双指缩放
    GD->>BP: 调用 zoomIn/Out()
    BP->>BP: 计算新 visibleKlineCount
    BP->>KCC: notifyListeners()
```

---

## 3. 状态设计

### 3.1 BattleState 状态扩展

无需新增数据库表，仅扩展现有 [BattleState](file:///Users/lin/dev/KlineTrain/lib/features/battle/models/battle_state.dart) 状态：

| 字段名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `lastLeftBoundaryTime` | `DateTime?` | `null` | 上次到达左边界的时间 |
| `lastRightBoundaryTime` | `DateTime?` | `null` | 上次到达右边界的时间 |
| `lastZoomOutBoundaryTime` | `DateTime?` | `null` | 上次到达缩放边界的时间 |

**理由**：使用内存状态即可，无需持久化存储

### 3.2 BattleConfig 配置扩展

扩展 [BattleConfig](file:///Users/lin/dev/KlineTrain/lib/features/battle/models/battle_config.dart)：

| 字段名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `minVisibleKlineCount` | `int` | `10` | 最小显示K线数量 |
| `maxVisibleKlineCount` | `int` | `700` | 最大显示K线数量 |
| `boundaryDebounceSeconds` | `int` | `3` | 边界提示防抖时间（秒） |
| `slideStepCount` | `int` | `5` | 每次滑动的K线数量 |
| `zoomFactor` | `double` | `1.2` | 缩放因子 |

---

## 4. 核心逻辑设计

### 4.1 手势检测层 → AC-001, AC-002, AC-003, AC-004

**触发条件**：用户在K线图表区域进行触屏操作

**处理流程**：
1. 使用 `GestureDetector` 包裹 `onHorizontalDragUpdate` 监听水平滑动
2. 使用 `onScaleUpdate` 监听双指缩放
3. 根据手势参数判断是滑动还是缩放
4. 调用 BattleProvider 对应的方法

**关键实现**：
- 水平滑动：根据拖动距离计算滑动的K线数量
- 双指缩放：根据缩放比例计算新的显示数量

### 4.2 缩放逻辑 → AC-005, AC-006, AC-013, AC-015

**触发条件**：用户点击+-按钮或双指缩放

**处理流程**：
1. 计算新的 `visibleKlineCount`
2. 限制在 `[10, 700]` 范围内
3. 调整 `visibleStartIndex` 以保持 `currentDayIndex` 在最右侧
4. 更新状态

**伪代码**：
```dart
void zoomIn() {
  newCount = (visibleKlineCount / zoomFactor;
  newCount = newCount.clamp(minVisibleKlineCount, maxVisibleKlineCount);
  visibleStartIndex = max(0, currentDayIndex - newCount + 1);
}

void zoomOut() {
  newCount = (visibleKlineCount * zoomFactor;
  newCount = newCount.clamp(minVisibleKlineCount, maxVisibleKlineCount);
  visibleStartIndex = max(0, currentDayIndex - newCount + 1);
}
```

### 4.3 滑动逻辑 → AC-001, AC-002, AC-014

**触发条件**：用户左右滑动或点击左右按钮

**处理流程**：
1. 计算新的 `visibleStartIndex`
2. 检查边界限制：`[0, currentDayIndex - visibleKlineCount + 1]`
3. 如果到达边界，检查防抖时间
4. 如果需要，显示提示并更新最后边界时间

**伪代码**：
```dart
void slideLeft() {
  newStart = visibleStartIndex - slideStepCount;
  if (newStart <= 0) {
    if (shouldShowBoundaryAlert(lastLeftBoundaryTime)) {
      showAlert('已到达最左边');
      lastLeftBoundaryTime = now();
    }
    newStart = 0;
  }
  visibleStartIndex = newStart;
}

void slideRight() {
  maxStart = currentDayIndex - visibleKlineCount + 1;
  newStart = visibleStartIndex + slideStepCount;
  if (newStart >= maxStart) {
    if (shouldShowBoundaryAlert(lastRightBoundaryTime)) {
      showAlert('已到达最右边');
      lastRightBoundaryTime = now();
    }
    newStart = maxStart;
  }
  visibleStartIndex = newStart;
}
```

### 4.4 边界防抖机制 → AC-008, AC-009, AC-010, AC-011, AC-016

**触发条件**：用户尝试越过边界操作

**处理流程**：
1. 检查上次提示时间是否超过防抖时间
2. 如果超过，显示提示并更新时间
3. 如果未超过，忽略提示

**伪代码**：
```dart
bool shouldShowBoundaryAlert(lastTime) {
  if (lastTime == null) return true;
  return now().difference(lastTime).inSeconds >= boundaryDebounceSeconds;
}
```

### 4.5 指标同步机制 → AC-007

**触发条件**：任何滑动或缩放操作

**处理流程**：
1. 所有指标图表都从 BattleProvider 读取相同的 `visibleStartIndex` 和 `visibleKlineCount`
2. 使用相同的切片逻辑获取显示数据
3. 当 BattleProvider state 状态变化自动触发所有图表 rebuild

---

## 5. 现有代码改动

| 模块 / 文件 | 改动内容 | 原因 | 对应 AC |
|-------------|---------|------|---------|
| [BattleState](file:///Users/lin/dev/KlineTrain/lib/features/battle/models/battle_state.dart) | 添加边界时间字段 | 实现防抖机制 | AC-008, AC-009, AC-016 |
| [BattleConfig](file:///Users/lin/dev/KlineTrain/lib/features/battle/models/battle_config.dart) | 添加缩放和滑动配置 | 统一管理参数 | AC-010, AC-011, AC-015 |
| [BattleProvider](file:///Users/lin/dev/KlineTrain/lib/features/battle/providers/battle_provider.dart) | 实现 zoomIn/Out、slideLeft/Right 方法 | 核心业务逻辑 | AC-001 ~ AC-016 |
| [KlineChartContainer](file:///Users/lin/dev/KlineTrain/lib/features/battle/widgets/kline_chart_container.dart) | 添加 GestureDetector 和手势处理 | 触屏手势支持 | AC-001, AC-002 |
| [ControlButtons](file:///Users/lin/dev/KlineTrain/lib/features/battle/widgets/control_buttons.dart) | 更新按钮回调，连接到 BattleProvider 方法 | 按钮交互优化 | AC-003, AC-004, AC-005, AC-006 |
| [BattleScreen](file:///Users/lin/dev/KlineTrain/lib/features/battle/battle_screen.dart) | 添加边界提示 SnackBar | 用户反馈 | AC-008, AC-009, AC-010, AC-011 |
| 指标图表组件 | 确保从 BattleProvider 获取数据 | 指标同步 | AC-007 |

---

## 6. 技术决策

### 6.1 手势处理位置选择：ChartContainer vs 独立组件

**背景**：手势监听器应该放在哪里

**选项**：
- A: 在 KlineChartContainer 中直接包裹 — 手势与图表在同一组件，逻辑集中
- B: 创建独立手势处理组件 — 分离关注点，但增加复杂度

**结论**：选择 A，手势与图表容器绑定更直观，符合现有架构

### 6.2 边界提示实现：Provider 内部处理 vs 外部回调

**背景**：边界提示是在 Provider 内部直接显示，还是通过回调通知上层

**选项**：
- A: Provider 内部通过 context 显示 — 简单直接，但耦合 UI
- B: Provider 发出事件，上层监听 — 解耦，但增加复杂度

**结论**：选择 B，保持 Provider 纯逻辑层，UI 响应事件

---

## 7. 安全与性能

**性能考量**：
- 手势处理频率限制：使用节流（throttle）避免高频调用
- 数据切片优化：预计算指标数据，避免重复计算
- 渲染优化：使用 const 构造函数和 RepaintBoundary

---

## 8. AC 覆盖总表

| AC 编号 | 验收标准概述 | 实现位置 |
|---------|-------------|---------|
| AC-001 | 触屏左滑查看更早数据 | KlineChartContainer手势 + BattleProvider.slideLeft |
| AC-002 | 触屏右滑查看更近数据 | KlineChartContainer手势 + BattleProvider.slideRight |
| AC-003 | 双指捏合缩小，最多700根 | KlineChartContainer手势 + BattleProvider.zoomOut + 边界检查 |
| AC-004 | 双指张开放大，最少10根 | KlineChartContainer手势 + BattleProvider.zoomIn + 边界检查 |
| AC-005 | 点击+按钮放大 | ControlButtons + BattleProvider.zoomIn |
| AC-006 | 点击-按钮缩小 | ControlButtons + BattleProvider.zoomOut |
| AC-007 | 指标图表同步变化 | 所有指标组件从BattleProvider读取相同状态 |
| AC-008 | 左边界防抖提示，3秒不重复 | BattleProvider边界检查 + BattleScreen提示 |
| AC-009 | 右边界防抖提示，3秒不重复 | BattleProvider边界检查 + BattleScreen提示 |
| AC-010 | 缩放下边界提示 | BattleProvider缩放检查 + BattleScreen提示 |
| AC-011 | 缩放上边界提示 | BattleProvider缩放检查 + BattleScreen提示 |
| AC-012 | 下一步后自动调整 | BattleProvider.nextDay |
| AC-013 | 缩放后当前日期在最右 | BattleProvider缩放计算逻辑 |
| AC-014 | 滑动不超过当前训练日 | BattleProvider滑动边界检查 |
| AC-015 | 缩放数量在10-700之间 | BattleProvider缩放clamp |
| AC-016 | 边界提示防抖3秒 | BattleProvider时间检查逻辑 |

---

## 附录：变更记录

| 日期 | 变更内容 | 原因 |
|------|---------|------|
| 2026-05-31 | 初始版本 | K线图表交互优化技术方案 |
