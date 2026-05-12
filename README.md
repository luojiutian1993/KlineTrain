# K线训练营 App

一款帮助用户学习和练习股票K线分析的跨平台教育类应用。

## 📱 功能特点

- 📈 **K线图表展示** - 实时/历史K线展示、时间周期切换、数据刷新
- 🎓 **学习课程** - K线基础知识、技术分析教程、实战案例
- 🎮 **模拟交易** - 虚拟资金练习、交易记录、收益统计
- 👤 **用户中心** - 用户注册登录、学习进度、收藏管理
- 📊 **数据统计** - 学习时长、正确率、成就徽章
- 🌓 **主题切换** - 支持明暗主题

## 🎯 支持平台

- ✅ iOS
- ✅ Android
- ✅ macOS
- ✅ Windows

## 🛠️ 技术栈

| 分类 | 技术 | 版本 |
|------|------|------|
| 框架 | Flutter | 3.41.9 |
| 语言 | Dart | 3.2+ |
| 状态管理 | Riverpod | 2.3+ |
| 路由 | GoRouter | 12.0+ |
| 图表 | fl_chart | 0.65.0 |
| 网络 | Dio | 5.4+ |
| 数据库 | Drift + SQLite | 2.11+ |

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.41.0
- Dart SDK >= 3.2.0
- Android Studio / VS Code
- Xcode >= 15.0 (macOS/iOS开发)
- CocoaPods >= 1.16.0 (macOS/iOS)

### 安装依赖

```bash
flutter pub get
dart run build_runner build
```

### 运行项目

```bash
# 运行在所有平台
flutter run

# 指定平台
flutter run -d ios
flutter run -d android
flutter run -d macos
flutter run -d windows
```

### macOS运行注意事项

由于GPU着色器编译问题，macOS需要特殊环境变量：

```bash
FLUTTER_DISABLE_GPU_SHADERS=true flutter run -d macos --release
```

### 构建发布版本

```bash
# Android
flutter build apk

# iOS
flutter build ios

# macOS
FLUTTER_DISABLE_GPU_SHADERS=true flutter build macos --release

# Windows
flutter build windows
```

## 📁 项目结构

```
kline_trainer/
├── lib/
│   ├── main.dart              # 应用入口
│   ├── app.dart               # 应用主组件
│   ├── routes/                # 路由配置
│   ├── providers/             # Riverpod状态管理
│   ├── data/                  # 数据层
│   │   ├── api/               # API接口
│   │   ├── models/            # 数据模型
│   │   └── repositories/      # 数据仓库
│   ├── features/              # 功能模块
│   │   ├── kline_chart/       # K线图表
│   │   ├── course/            # 课程管理
│   │   ├── trading/           # 模拟交易
│   │   └── user/              # 用户中心
│   ├── shared/                # 共享组件和工具
│   └── theme/                 # 主题配置
├── assets/                    # 静态资源
├── test/                      # 测试代码
├── macos/                     # macOS平台代码
├── pubspec.yaml               # 依赖配置
└── .env                       # 环境变量
```

## 🏗️ 架构设计

### 分层架构

```
UI Layer (Features)      →  Provider Layer (Riverpod)
                              ↓
                         Repository Layer
                              ↓
                           API Layer
                              ↓
                      Data Source Layer (SQLite/API/WebSocket)
```

### 核心模块

| 模块 | 职责 |
|------|------|
| `routes/` | 路由定义和导航管理 |
| `providers/` | 状态管理，业务逻辑 |
| `data/api/` | 网络请求封装 |
| `data/models/` | 数据模型定义 |
| `data/repositories/` | 数据访问抽象 |
| `features/` | UI组件和页面 |

## 📋 开发规范

请参考 `specs/开发规范.md` 文件了解代码风格、Git工作流等规范。

## 📝 技术文档

- `specs/技术栈.md` - 技术栈选型和依赖说明
- `specs/项目结构.md` - 项目结构和架构设计
- `specs/开发规范.md` - 开发规范和编码标准

## 📜 许可证

MIT License

## 📊 项目状态

| 模块 | 状态 |
|------|------|
| 基础架构 | ✅ 已完成 |
| K线图表 | ✅ 基础完成 |
| 课程管理 | ✅ 基础完成 |
| 模拟交易 | ✅ 基础完成 |
| 用户中心 | ✅ 基础完成 |
| macOS构建 | ✅ 已验证 |
| Android构建 | 📋 待生成 |
| iOS构建 | 📋 待生成 |
| Windows构建 | 📋 待生成 |
