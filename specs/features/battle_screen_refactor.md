# BattleScreen完全重构需求文档

## 1. 需求概述

将BattleScreen（约4500行）完全重构为轻量级主入口组件，将所有业务逻辑迁移到BattleProvider中。

## 2. 验收标准

### 2.1 功能完整性
- AC-001: Given 用户进入实战页面，When 页面加载，Then 所有状态由BattleProvider管理，UI组件通过Provider获取数据
- AC-002: Given 用户点击"下一步"，When 训练推进，Then BattleProvider更新currentDayIndex和phase
- AC-003: Given 用户点击"买入/卖出"，When 执行交易，Then BattleProvider更新账户和持仓数据
- AC-004: Given 用户点击"换股"，When 随机选股，Then BattleProvider重新初始化数据

### 2.2 数据管理
- AC-005: Given K线数据加载，When 数据返回，Then BattleProvider存储并计算指标数据
- AC-006: Given 指标计算，When 显示K线图，Then BattleProvider提供MA5/MA10/MA30等指标数据
- AC-007: Given 训练进度，When 用户推进训练，Then BattleProvider维护visibleStartIndex和visibleKlineCount

### 2.3 界面展示
- AC-008: Given 股票信息，When 页面显示，Then StockInfoBar从Provider获取并显示完整信息
- AC-009: Given K线图表，When 页面显示，Then KlineChartWidget从Provider获取K线数据和交易点
- AC-010: Given 指标面板，When 页面显示，Then 显示成交量和MACD等指标（上下布局）
- AC-011: Given 交易面板，When 页面显示，Then TradingPanel显示换股、条件单、买入、卖出、训练周期、下一步按钮
- AC-012: Given 资产面板，When 页面显示，Then AssetPanel显示市值、盈亏、持仓、总资产等

### 2.4 性能要求
- AC-013: Given BattleScreen主入口，When 完成重构，Then 代码行数 ≤ 200行
- AC-014: Given 组件拆分，When 完成重构，Then 业务逻辑全部在Provider中，UI组件无状态

## 3. 范围界定

### 本次做
- 将BattleScreen中的所有业务逻辑迁移到BattleProvider
- 创建新的轻量级主入口BattleScreen（约200行）
- 更新路由配置
- 验证所有功能正常

### 本次不做
- 修改已拆分的UI组件内部实现
- 修改数据库和Repository层
- 修改指标计算逻辑

## 4. 技术方案

### 4.1 状态迁移
需要迁移到BattleProvider的状态：
- `currentSymbol`, `currentSymbolName`, `currentMarketCode`
- `allKlineData`, `currentDayIndex`, `visibleStartIndex`, `visibleKlineCount`
- `accountBalance`, `positionQuantity`, `positionCost`, `totalProfitLoss`
- `tradePoints`, `selectedPeriod`, `selectedTopIndicator`, `selectedBottomIndicator`
- `phase` (TrainingPhase)
- `isReplayMode`, `isLoading`, `hasAvailableData`, `errorMessage`

### 4.2 方法迁移
需要迁移到BattleProvider的方法：
- 初始化方法（initializeWithSymbol, initializeRandom）
- 导航方法（nextDay, previousDay, setPhase）
- 缩放/滑动方法（zoomIn, zoomOut, slideLeft, slideRight）
- 交易方法（buy, sell）
- 指标更新方法（updateTopIndicator, updateBottomIndicator, updatePeriod）

### 4.3 新主入口职责
BattleScreen新主入口只负责：
- 接收路由参数
- 调用Provider初始化
- 组合UI组件
- 处理对话框显示（需要BuildContext）

## 5. 文件变更

### 新增
- `lib/features/battle/battle_screen_new.dart` - 新轻量级主入口

### 修改
- `lib/features/battle/providers/battle_provider.dart` - 扩展状态和方法
- `lib/features/battle/models/battle_state.dart` - 扩展状态模型
- `lib/routes/app_routes.dart` - 更新路由引用

### 删除（重构后）
- `lib/features/battle/battle_screen.dart` - 原4500行文件

## 6. 实施步骤

1. 扩展BattleState模型，添加所有缺失状态
2. 扩展BattleProvider，添加所有缺失方法
3. 创建新的BattleScreen主入口（约200行）
4. 更新路由配置
5. 验证功能完整性
6. 删除原BattleScreen（可选）