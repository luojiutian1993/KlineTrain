# Flutter移动端架构规范

> **文档版本**: v1.0
> **创建日期**: 2026-05-28
> **最后更新**: 2026-05-28
> **适用范围**: K线训练营App所有页面（首页、实战、我的、记录等）
> **状态**: 草稿，待评审

---

## 1. 背景与目的

### 1.1 为什么需要架构规范

**现状问题**：
- 不同页面代码风格不一致，维护困难
- 状态管理分散在各个Screen文件中，难以追踪
- 业务逻辑与UI代码混杂，单元测试困难
- 数据格式处理不统一，容易出错

**规范目标**：
- 统一代码组织方式，降低学习成本
- 明确职责划分，提升代码可维护性
- 建立可复用的开发模式，提高开发效率
- 提升代码质量，便于团队协作

### 1.2 架构演进历程

| 阶段 | 架构模式 | 代表页面 | 问题 |
|------|---------|---------|------|
| 初期 | StatefulWidget内聚 | 首页、老版实战页面 | 文件过大（4500+行），状态分散 |
| 当前 | 实战页面重构 | v7.0实战页面 | 最佳实践已验证 |
| 未来 | 统一规范 | 所有页面 | 需要推广最佳实践 |

### 1.3 规范的适用范围

**必须遵循的页面**：
- ✅ 首页模块（HomeScreen）
- ✅ 实战模块（BattleScreen）— 已完成重构
- ✅ 我的模块（MineScreen）
- ✅ 记录页面（RecordScreen）
- ✅ 复盘页面（ReplayScreen）
- ✅ 任何新增页面

**本次不重构但需遵循规范**：
- 首页、我的、记录等现有页面保持现状
- 新功能开发时必须遵循本规范
- 后续迭代时逐步规范化现有页面

---

## 2. 分层架构

### 2.1 整体架构图

```
┌─────────────────────────────────────────────────────────────────────┐
│                         UI Layer (视图层)                            │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐          │
│  │ Screen 文件    │  │ Widget 文件   │  │ Dialog 文件   │          │
│  │ (主视图容器)    │  │ (可复用组件)  │  │ (弹窗组件)    │          │
│  └────────────────┘  └────────────────┘  └────────────────┘          │
├─────────────────────────────────────────────────────────────────────┤
│                      Provider Layer (状态管理层)                      │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐          │
│  │ StateNotifiers │  │ AsyncNotifiers│  │ Providers      │          │
│  │ (同步状态)      │  │ (异步状态)     │  │ (依赖注入)     │          │
│  └────────────────┘  └────────────────┘  └────────────────┘          │
├─────────────────────────────────────────────────────────────────────┤
│                       Service Layer (业务逻辑层)                       │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐          │
│  │ *Service       │  │ *Manager      │  │ *Calculator    │          │
│  │ (业务服务)      │  │ (流程管理)     │  │ (计算工具)     │          │
│  └────────────────┘  └────────────────┘  └────────────────┘          │
├─────────────────────────────────────────────────────────────────────┤
│                        Data Layer (数据层)                          │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐          │
│  │ Repository     │  │ DAO           │  │ API Client     │          │
│  │ (数据仓库)      │  │ (数据库访问)   │  │ (网络请求)     │          │
│  └────────────────┘  └────────────────┘  └────────────────┘          │
├─────────────────────────────────────────────────────────────────────┤
│                       Model Layer (数据模型层)                        │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐          │
│  │ *State        │  │ *Config        │  │ *Request/*Response │
│  │ (状态模型)      │  │ (配置模型)     │  │ (DTO模型)     │          │
│  └────────────────┘  └────────────────┘  └────────────────┘          │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 各层职责定义

| 层级 | 职责 | 包含内容 | 不应该包含 |
|------|------|---------|-----------|
| **UI Layer** | 视图渲染、用户交互 | Widget构建、布局、动画 | 业务逻辑、状态管理 |
| **Provider Layer** | 状态管理、事件分发 | State定义、Notifier实现、状态更新 | 直接的数据访问 |
| **Service Layer** | 业务逻辑、数据转换 | 业务规则、数据组装 | UI渲染、状态管理 |
| **Data Layer** | 数据访问、持久化 | CRUD操作、网络请求 | 业务规则 |
| **Model Layer** | 数据结构定义 | 数据类、转换方法 | 业务逻辑 |

### 2.3 依赖方向

```
UI Layer → Provider Layer → Service Layer → Data Layer
     ↓           ↓             ↓
  Widget文件   状态对象      数据模型
```

**规则**：
- 上层可以依赖下层，下层不能依赖上层
- 跨层依赖通过依赖注入（Provider）实现
- 同层之间禁止直接依赖

---

## 3. 文件组织规范

### 3.1 Feature模块结构

每个功能模块应遵循以下目录结构：

```
lib/features/
└── [模块名]/
    ├── screens/
    │   └── [feature_name]_screen.dart          # 主视图文件 (~300行)
    │
    ├── providers/
    │   ├── [feature_name]_provider.dart        # 状态管理 (~200行)
    │   └── [feature_name]_provider.g.dart       # Riverpod生成
    │
    ├── services/
    │   ├── [feature_name]_service.dart          # 业务逻辑 (~200行)
    │   └── [sub_feature]_service.dart           # 子业务逻辑
    │
    ├── models/
    │   ├── [feature_name]_state.dart           # 状态模型 (~150行)
    │   └── [feature_name]_config.dart          # 配置模型 (~50行)
    │
    ├── widgets/
    │   ├── [component]_widget.dart             # 组件文件 (~100行)
    │   └── [component]_widget.dart
    │
    ├── utils/
    │   ├── [feature_name]_converter.dart       # 格式转换工具
    │   └── [feature_name]_validator.dart       # 验证工具
    │
    ├── exceptions/
    │   └── [feature_name]_exception.dart       # 异常定义
    │
    └── [feature_name].dart                    # 模块导出文件
```

### 3.2 文件命名规范

| 文件类型 | 命名格式 | 示例 |
|---------|---------|------|
| Screen文件 | `*_screen.dart` | `home_screen.dart` |
| Provider文件 | `*_provider.dart` | `battle_provider.dart` |
| Service文件 | `*_service.dart` | `stock_service.dart` |
| State文件 | `*_state.dart` | `battle_state.dart` |
| Widget文件 | `*_widget.dart` | `stock_info_bar.dart` |
| 配置文件 | `*_config.dart` | `battle_config.dart` |
| 工具类 | `*_util.dart` | `date_converter.dart` |
| 异常类 | `*_exception.dart` | `battle_exception.dart` |

### 3.3 文件行数限制

| 文件类型 | 最大行数 | 说明 |
|---------|---------|------|
| Screen文件 | 400行 | 包含build()和简单回调 |
| Provider文件 | 300行 | 包含Notifier实现 |
| Service文件 | 300行 | 业务逻辑 |
| State文件 | 200行 | 不可变状态类 |
| Widget文件 | 150行 | 单一职责组件 |
| Config文件 | 100行 | 常量定义 |

**超限处理**：
1. 检查是否违反单一职责原则
2. 拆分过大的Widget或Service
3. 抽取可复用的工具方法

---

## 4. 状态管理规范

### 4.1 状态管理模式

**选择 Riverpod 的理由**：
- 与项目现有架构一致（实战页面已验证）
- 状态集中管理，便于调试
- 支持依赖注入
- 编译时安全性（riverpod_annotation）

### 4.2 状态模型设计

```dart
// models/[feature]_state.dart

class [Feature]State {
  // 配置数据（初始化后不变）
  final String configValue;
  final int maxRetries;

  // 业务数据（会变化）
  final List<Item> items;
  final int currentIndex;

  // UI状态
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  // 计算属性
  bool get hasData => items.isNotEmpty;
  Item? get currentItem => hasData ? items[currentIndex] : null;

  const [Feature]State({
    this.configValue = 'default',
    this.maxRetries = 3,
    this.items = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  // 不可变更新：使用copyWith
  [Feature]State copyWith({
    String? configValue,
    int? maxRetries,
    List<Item>? items,
    int? currentIndex,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return [Feature]State(
      configValue: configValue ?? this.configValue,
      maxRetries: maxRetries ?? this.maxRetries,
      items: items ?? this.items,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
```

### 4.3 Provider实现模式

```dart
// providers/[feature]_provider.dart

part '[feature]_provider.g.dart';

@riverpod
class [Feature] extends _$<[Feature]> {
  @override
  [Feature]State build() {
    return const [Feature]State();
  }

  // 异步初始化
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final data = await _fetchData();
      state = state.copyWith(
        items: data,
        isLoading: false,
        isSuccess: true,
      );
    } catch (e, stackTrace) {
      _handleError(e, stackTrace);
    }
  }

  // 同步操作
  void updateItem(int index, Item newItem) {
    final newItems = List<Item>.from(state.items);
    newItems[index] = newItem;
    state = state.copyWith(items: newItems);
  }

  // 错误处理
  void _handleError(dynamic error, StackTrace stackTrace) {
    print('[$runtimeType] Error: $error');
    print('StackTrace: $stackTrace');

    state = state.copyWith(
      isLoading: false,
      errorMessage: _getErrorMessage(error),
    );
  }

  String _getErrorMessage(dynamic error) {
    if (error is NetworkException) return '网络连接失败';
    if (error is ServerException) return '服务器错误';
    return '操作失败，请重试';
  }
}
```

### 4.4 状态更新的黄金法则

**✅ 正确做法**：
```dart
// 使用copyWith进行不可变更新
state = state.copyWith(
  items: newItems,
  currentIndex: newIndex,
);
```

**❌ 错误做法**：
```dart
// 直接修改状态（禁止）
state.items.add(newItem);
state.currentIndex = newIndex;
```

### 4.5 状态持久化策略

| 状态类型 | 存储方式 | 生命周期 | 示例 |
|---------|---------|---------|------|
| 会话状态 | Provider内存 | 当前会话 | 当前选中的Tab |
| 应用状态 | Provider + SharedPreferences | 跨会话 | 用户偏好设置 |
| 重要数据 | Provider + 数据库 | 永久 | 训练记录、用户信息 |
| 临时缓存 | Provider内存 | 页面生命周期 | 表单输入 |

---

## 5. Widget组件规范

### 5.1 Widget分类

| 类型 | 特征 | 示例 |
|------|------|------|
| **页面级Widget** | Screen的子组件，复杂度高 | StockInfoBar, TradingPanel |
| **复用级Widget** | 可跨页面使用 | AppButton, LoadingIndicator |
| **原子级Widget** | 最小UI单元 | PriceText, TrendArrow |

### 5.2 Widget通信模式

```
Screen (ConsumerWidget)
  │
  ├── Listens to: Provider.state
  │
  ├── Consumer<Provider> (stateless wrappers)
  │   │
  │   ├── WidgetA
  │   │   └── Listens to: state.propertyA
  │   │
  │   ├── WidgetB
  │   │   └── Listens to: state.propertyB
  │   │
  │   └── WidgetC
  │       ├── onTap: notifier.action()
  │       └── Listens to: state.propertyC
  │
  └── Callback handlers (delegates to notifier)
```

### 5.3 Widget实现模板

```dart
// widgets/[component]_widget.dart

class [Component]Widget extends ConsumerWidget {
  const [Component]Widget({
    super.key,
    // 必要参数
    required this.data,
    // 可选参数
    this.onAction,
  });

  final DataType data;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 读取状态（如果需要）
    // final globalState = ref.watch(someProvider);

    // 读取Provider（如果需要修改全局状态）
    // final notifier = ref.read(someProvider.notifier);

    return Container(
      child: Column(
        children: [
          // 构建UI
          _buildHeader(),
          _buildContent(),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(data.title);
  }

  Widget _buildContent() {
    return Text(data.content);
  }

  Widget _buildActions() {
    return ElevatedButton(
      onPressed: onAction,
      child: const Text('Action'),
    );
  }
}
```

### 5.4 溢出处理规范

| 场景 | 处理方案 | 代码示例 |
|------|---------|---------|
| 文字过长 | `Flexible` + `ellipsis` | `Flexible(child: Text(name, overflow: TextOverflow.ellipsis))` |
| 价格数字 | 固定宽度 + 缩放 | `FittedBox(fit: BoxFit.scaleDown, child: Text(price))` |
| 按钮文字 | `Flexible` + `FittedBox` | `Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(text))))` |
| 列表项 | `Expanded` | `Expanded(child: Text(content))` |

---

## 6. Service层规范

### 6.1 Service职责

- 封装业务逻辑
- 数据格式转换
- 调用DAO/Repository
- 异常处理和日志记录

### 6.2 Service实现模板

```dart
// services/[feature]_service.dart

class [Feature]Service {
  // 依赖注入
  final DatabaseService _db;
  final [Other]Service _otherService;

  [Feature]Service({
    DatabaseService? db,
    [Other]Service? otherService,
  })  : _db = db ?? DatabaseService.instance,
        _otherService = otherService ?? [Other]Service();

  /// 业务方法1
  Future<Result> doSomething(param) async {
    try {
      // 1. 参数验证
      _validate(param);

      // 2. 数据准备
      final preparedData = _prepareData(param);

      // 3. 调用数据层
      final result = await _db.dao.doSomething(preparedData);

      // 4. 数据转换
      return _convertToResult(result);
    } on SpecificException catch (e) {
      // 特定异常处理
      throw [Feature]SpecificException(e.message);
    } catch (e, stackTrace) {
      // 通用异常处理
      Logger.e('[$runtimeType] doSomething failed', e, stackTrace);
      throw [Feature]ServiceException('操作失败');
    }
  }

  void _validate(Param param) {
    if (param.value == null) {
      throw ValidationException('参数不能为空');
    }
  }

  PreparedData _prepareData(Param param) {
    // 数据转换逻辑
    return PreparedData(...);
  }

  Result _convertToResult(Data data) {
    // 转换为业务结果
    return Result(...);
  }
}
```

### 6.3 日志记录规范

| 日志级别 | 使用场景 | 示例 |
|---------|---------|------|
| `d()` (Debug) | 开发调试信息 | 方法入口、变量值 |
| `i()` (Info) | 重要业务流程节点 | 初始化完成、数据加载成功 |
| `w()` (Warning) | 可恢复的异常 | 网络超时重试、数据格式异常 |
| `e()` (Error) | 需要关注的错误 | 操作失败、异常捕获 |

```dart
import 'package:logger/logger.dart';

final Logger _logger = Logger();

_logger.d('[Service] method started: param=$param');
_logger.i('[Service] data loaded: count=${data.length}');
_logger.w('[Service] retry attempt: $attempt/$maxRetries');
_logger.e('[Service] operation failed: $error', error, stackTrace);
```

---

## 7. 数据格式规范

### 7.1 格式统一原则

**核心原则**：以数据库存储格式为准，前端和后端需要做好格式转换

```
数据库（数据源） → Repository/DAO → Provider/Service → UI
                     ↑ 转换        ↑ 转换
                   数据库格式    数据库格式
```

### 7.2 股票代码格式

```dart
// utils/symbol_converter.dart

class SymbolConverter {
  /// 数据库格式 → 前端显示格式
  static String toDisplay(String dbSymbol, String marketCode) {
    if (dbSymbol.startsWith('SH') || dbSymbol.startsWith('SZ')) {
      return dbSymbol;  // 已经是显示格式
    }
    final prefix = marketCode == 'XSHE' ? 'SZ' : 'SH';
    return '$prefix$dbSymbol';
  }

  /// 前端输入 → 数据库查询格式
  static String toDbQuery(String displaySymbol) {
    String normalized = displaySymbol;

    // 移除市场前缀 (SH, SZ)
    if (normalized.startsWith('SH') && normalized.length > 2) {
      normalized = normalized.substring(2);
    } else if (normalized.startsWith('SZ') && normalized.length > 2) {
      normalized = normalized.substring(2);
    }

    // 移除后缀 (.XSHE, .XSHG)
    if (normalized.contains('.')) {
      normalized = normalized.split('.')[0];
    }

    return normalized;
  }

  /// 市场代码转换
  static String toExchangeCode(String marketPrefix) {
    switch (marketPrefix) {
      case 'SH': return 'XSHG';
      case 'SZ': return 'XSHE';
      default: return marketPrefix;
    }
  }
}
```

### 7.3 日期时间格式

```dart
// utils/date_converter.dart

class DateConverter {
  /// 存储格式：ISO8601 (用于数据库和路由)
  static const String storageFormat = "yyyy-MM-dd'T'HH:mm:ss";

  /// 显示格式：中文年月日
  static const String displayFormat = 'yyyy-MM-dd';

  /// 短显示格式：月日
  static const String shortDisplayFormat = 'MM-dd';

  /// DateTime → 存储格式
  static String toStorage(DateTime date) {
    return date.toIso8601String();
  }

  /// 存储格式 → DateTime
  static DateTime fromStorage(String storage) {
    return DateTime.parse(storage);
  }

  /// DateTime → 显示格式
  static String toDisplay(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 显示格式 → DateTime
  static DateTime fromDisplay(String display) {
    final parts = display.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
```

### 7.4 货币格式

```dart
// utils/currency_formatter.dart

class CurrencyFormatter {
  /// 金额显示：保留2位小数
  static String format(double amount) {
    return amount.toStringAsFixed(2);
  }

  /// 金额显示：带货币符号
  static String formatWithSymbol(double amount, {String symbol = '¥'}) {
    return '$symbol${format(amount)}';
  }

  /// 盈亏显示：带正负号
  static String formatProfitLoss(double profitLoss) {
    final formatted = format(profitLoss.abs());
    return profitLoss >= 0 ? '+$formatted' : '-$formatted';
  }

  /// 百分比显示
  static String formatPercentage(double percentage, {int decimals = 2}) {
    return '${percentage.toStringAsFixed(decimals)}%';
  }
}
```

---

## 8. 错误处理规范

### 8.1 异常分类

| 异常类型 | 异常类 | 父类 | 使用场景 |
|---------|-------|------|---------|
| 验证异常 | `ValidationException` | `Exception` | 参数校验失败 |
| 网络异常 | `NetworkException` | `Exception` | 网络请求失败 |
| 服务器异常 | `ServerException` | `Exception` | 服务器返回错误 |
| 业务异常 | `*[Feature]Exception` | `Exception` | 业务规则违反 |
| 系统异常 | `SystemException` | `Exception` | 系统级错误 |

### 8.2 异常定义模板

```dart
// exceptions/[feature]_exception.dart

sealed class [Feature]Exception implements Exception {
  final String userMessage;
  final String code;
  final dynamic originalError;

  const [Feature]Exception({
    required this.userMessage,
    required this.code,
    this.originalError,
  });

  @override
  String toString() => '[Feature]Exception: $code - $userMessage';
}

class DataLoadException extends [Feature]Exception {
  const DataLoadException({super.originalError})
      : super(
          userMessage: '数据加载失败，请检查网络后重试',
          code: 'DATA_LOAD_ERROR',
        );
}

class InsufficientBalanceException extends [Feature]Exception {
  const InsufficientBalanceException()
      : super(
          userMessage: '可用余额不足',
          code: 'INSUFFICIENT_BALANCE',
        );
}
```

### 8.3 错误处理层级

```
UI 层（Widget）
    ↓ 捕获用户交互异常
Provider 层（Notifier）
    ↓ 捕获业务逻辑异常
Service 层
    ↓ 捕获数据访问异常
Repository / DAO 层
    ↓ 捕获基础设施异常
```

### 8.4 错误展示规范

| 错误类型 | 展示方式 | 持续时间 | 用户操作 |
|---------|---------|---------|---------|
| 网络错误 | Toast提示 | 3秒 | 自动消失 |
| 表单验证 | 输入框下方红色文字 | 直到修正 | 实时显示 |
| 操作失败 | Dialog弹窗 | 确认关闭 | 用户确认 |
| 严重错误 | 全屏错误页 | 直到重试 | 可重试 |

---

## 9. UI规范

### 9.1 字体大小层级

| 层级 | 字号 | 字重 | 用途 |
|------|------|------|------|
| 大标题 | 20px | Bold | 页面标题 |
| 标题 | 18px | Bold | 区块标题 |
| 副标题 | 16px | - | 卡片标题 |
| 正文 | 14px | - | 主要内容 |
| 辅助 | 12px | - | 辅助信息 |
| 小字 | 10-11px | - | 图例、标签 |

### 9.2 间距规范

```dart
// 区块间距
const EdgeInsets.symmetric(horizontal: 16, vertical: 8)

// 元素间距
const SizedBox(width: 4)    // 标签与数值
const SizedBox(width: 8)     // 信息项之间
const SizedBox(width: 12)   // 信息列之间
const SizedBox(height: 4)   // 行内垂直间距
const SizedBox(height: 8)   // 块内垂直间距
const SizedBox(height: 16)  // 区块间距
```

### 9.3 颜色使用规范

| 场景 | 颜色 | 代码 |
|------|------|------|
| 上涨/盈利 | 红色 | `Colors.red` |
| 下跌/亏损 | 绿色 | `Colors.green` |
| 主色调 | 蓝色 | `Theme.of(context).primaryColor` |
| 背景色 | 浅灰 | `Colors.grey[100]` |
| 文字色 | 深灰 | `Colors.grey[800]` |
| 辅助文字 | 中灰 | `Colors.grey[600]` |

**重要**：股票涨跌颜色固定为红涨绿跌，不可随主题变化。

### 9.4 加载状态规范

| 状态 | UI展示 | 交互 |
|------|--------|------|
| 初始加载 | 全屏Loading + 骨架屏 | 禁止操作 |
| 局部加载 | 按钮Loading + 禁用 | 允许其他操作 |
| 刷新加载 | 下拉刷新 + Loading指示器 | 等待完成 |
| 错误状态 | 错误提示 + 重试按钮 | 可重试 |

---

## 10. 代码审查清单

### 10.1 架构检查项

- [ ] 是否遵循分层架构（UI → Provider → Service → Data）
- [ ] 文件命名是否符合规范
- [ ] 文件行数是否超过限制
- [ ] 是否存在跨层依赖

### 10.2 状态管理检查项

- [ ] State是否为不可变对象
- [ ] 是否使用copyWith进行状态更新
- [ ] Provider是否正确监听状态变化
- [ ] 异步操作是否正确处理Loading/Error状态

### 10.3 代码质量检查项

- [ ] 是否存在魔法值（应使用常量）
- [ ] 是否有适当的注释
- [ ] 方法长度是否适中（<50行）
- [ ] 是否处理了异常情况

### 10.4 UI规范检查项

- [ ] 文本是否处理溢出
- [ ] 间距是否统一
- [ ] 颜色使用是否正确
- [ ] 是否有加载状态提示

---

## 11. 新功能开发流程

### 11.1 开发前准备

1. **需求分析**：明确功能需求和验收标准
2. **架构设计**：确定模块划分和文件组织
3. **技术方案**：选择技术方案和依赖库

### 11.2 开发步骤

```
1. 创建目录结构
   lib/features/[模块名]/
   ├── screens/
   ├── providers/
   ├── services/
   ├── models/
   ├── widgets/
   └── utils/

2. 实现数据模型
   models/*_state.dart
   models/*_config.dart

3. 实现Provider
   providers/*_provider.dart

4. 实现Service
   services/*_service.dart

5. 实现Widget组件
   widgets/*_widget.dart

6. 实现Screen
   screens/*_screen.dart

7. 单元测试
   测试Provider、Service逻辑

8. 集成测试
   端到端功能测试
```

### 11.3 文档输出

每个新功能应输出以下文档：
- **需求文档**：`docs/features/[模块]/[模块]需求.md`
- **技术方案**：`docs/features/[模块]/[模块]技术方案.md`
- **开发记录**：`docs/开发记录/[模块]开发记录.md`

---

## 12. 现有页面规范化计划

### 12.1 优先级排序

| 优先级 | 页面 | 原因 | 计划时间 |
|--------|------|------|---------|
| P0 | 实战页面 | 已完成重构，可作为标杆 | ✅ 已完成 |
| P1 | 首页 | 核心入口，逻辑较简单 | 待定 |
| P1 | 我的页面 | 用户中心，逻辑较简单 | 待定 |
| P2 | 记录页面 | 功能独立，便于拆分 | 待定 |
| P2 | 选股模块 | 涉及多个页面 | 待定 |

### 12.2 规范化策略

**原则**：
- 不破坏现有功能
- 逐步演进，而非一次性重构
- 每次迭代只做一件事

**策略**：
1. 新代码必须遵循本规范
2. 修改现有代码时顺手规范化
3. 定期进行代码审查和优化

---

## 附录：最佳实践示例

### A.1 实战页面（已完成重构）

```
lib/features/battle/
├── battle_screen.dart                    # ~400行
├── models/
│   ├── battle_state.dart                # ~180行
│   └── battle_config.dart               # ~50行
├── providers/
│   ├── battle_provider.dart             # ~300行
│   └── battle_provider.g.dart          # 自动生成
├── services/
│   ├── training_service.dart            # ~200行
│   └── stock_service.dart              # ~150行
└── widgets/
    ├── stock_info_bar.dart             # ~100行
    ├── trading_panel.dart              # ~100行
    └── ...
```

### A.2 路由配置（GoRouter）

```dart
GoRoute(
  path: '/[feature]',
  name: '[feature]',
  builder: (context, state) {
    // 解析路由参数
    final id = state.uri.queryParameters['id'];
    return [Feature]Screen(featureId: id);
  },
)
```

### A.3 依赖注入示例

```dart
// 在需要的地方注入
final service = ref.read(serviceProvider);

// 或在Service中注入其他Service
class [Feature]Service {
  final OtherService _otherService;

  [Feature]Service(this._otherService);
}
```

---

## 文档变更记录

| 日期 | 版本 | 变更内容 | 作者 |
|------|------|---------|------|
| 2026-05-28 | v1.0 | 初始版本，基于实战页面重构最佳实践 | AI助手 |

---

**文档版本**: v1.0
**创建日期**: 2026-05-28
**最后更新**: 2026-05-28
