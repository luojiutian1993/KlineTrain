# "我的"页面技术文档

## 1. 技术架构

### 1.1. 架构概述

"我的"页面采用 Flutter + Riverpod + SQLite (Drift) 的技术栈，遵循 MVVM 架构模式。

```
┌─────────────────────────────────────────────────────────────┐
│                      UI 层 (Views)                         │
│  MineScreen / LoginScreen / RegisterScreen / SubPages       │
└──────────────────────────┬──────────────────────────────────┘
                           │ Consumer
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    状态管理层 (Providers)                    │
│  UserNotifier / AuthState / NotificationsNotifier          │
└──────────────────────────┬──────────────────────────────────┘
                           │ Repository
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                      仓库层 (Repository)                     │
│  UserRepository (数据获取、缓存、业务逻辑)                  │
└──────────────────────────┬──────────────────────────────────┘
                           │ DAO
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                   数据访问层 (DAO)                         │
│  UserDao / DatabaseService                                │
└──────────────────────────┬──────────────────────────────────┘
                           │ SQLite
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                      数据库层 (SQLite)                      │
│  kline_trainer.db                                          │
└─────────────────────────────────────────────────────────────┘
```

### 1.2. 核心技术栈

| 层级 | 技术 | 版本 | 说明 |
|------|------|------|------|
| 框架 | Flutter | 3.19+ | 移动端UI框架 |
| 状态管理 | Riverpod | 2.3+ | 响应式状态管理 |
| 路由 | GoRouter | 13.0+ | 声明式路由管理 |
| 数据库 | Drift | 2.18+ | SQLite ORM |
| JSON序列化 | json_serializable | 6.7+ | JSON处理 |

---

## 2. 目录结构

```
lib/
├── features/
│   ├── mine/
│   │   ├── mine_screen.dart          # 我的页面主入口
│   │   ├── settings/                 # 设置页面
│   │   ├── favorites/                # 自选管理页面
│   │   ├── training_history/         # 训练记录页面
│   │   ├── learning_progress/        # 学习进度页面
│   │   ├── notifications/            # 消息通知页面
│   │   ├── feedback/                 # 意见反馈页面
│   │   └── help_center/              # 帮助中心页面
│   └── user/
│       ├── login_screen.dart         # 登录页面
│       └── register_screen.dart      # 注册页面
├── providers/
│   ├── user_provider.dart            # 用户状态管理
│   └── auth_provider.dart            # 认证状态管理
├── data/
│   ├── models/
│   │   ├── user_model.dart           # 用户数据模型
│   │   └── notice_model.dart         # 通知数据模型
│   ├── repositories/
│   │   └── user_repository.dart      # 用户数据仓库
│   └── database/                     # 数据库相关
│       ├── app_database.dart         # 数据库配置
│       ├── database_service.dart     # 数据库服务
│       ├── daos/                     # DAO层
│       └── tables/                   # 数据表定义
├── routes/
│   └── app_routes.dart               # 路由配置
└── shared/
    └── utils/
        ├── screen_utils.dart         # 屏幕适配工具
        └── logger.dart               # 日志工具
```

---

## 3. 关键类与方法

### 3.1. UserRepository

| 方法名 | 功能说明 | 参数 | 返回值 |
|--------|----------|------|--------|
| `getCurrentUser()` | 获取当前用户 | 无 | `Future<UserModel?>` |
| `fetchUserProfile()` | 获取用户资料（自动创建测试用户） | 无 | `Future<UserModel>` |
| `saveUserToDatabase()` | 保存用户到数据库 | `UserModel user` | `Future<void>` |
| `updateProfile()` | 更新用户资料 | `String? nickname, String? avatarUrl` | `Future<void>` |
| `getUserByPhone()` | 通过手机号查找用户 | `String phone` | `Future<UserModel?>` |

### 3.2. UserNotifier

| 方法名 | 功能说明 | 参数 |
|--------|----------|------|
| `_loadUser()` | 加载用户信息 | 无 |
| `refreshProfile()` | 刷新用户资料 | 无 |
| `updateProfile()` | 更新用户资料 | `String? nickname, String? avatarUrl` |

### 3.3. AuthState

| 方法名 | 功能说明 | 参数 | 返回值 |
|--------|----------|------|--------|
| `login()` | 用户登录 | `String phone, String password` | `Future<void>` |
| `logout()` | 用户退出 | 无 | `Future<void>` |
| `register()` | 用户注册 | `String phone, String password, String email` | `Future<bool>` |

---

## 4. 数据库设计

### 4.1. users 表结构

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | 用户ID |
| phone | TEXT | UNIQUE, NOT NULL | 手机号 |
| password | TEXT | NOT NULL | 加密密码 |
| nickname | TEXT | NULLABLE | 用户昵称 |
| avatar | TEXT | NULLABLE | 头像URL |
| member_level | INTEGER | DEFAULT 1 | 会员等级(1-5) |
| experience | INTEGER | DEFAULT 0 | 经验值 |
| total_profit | REAL | DEFAULT 0.0 | 累计盈亏 |
| status | TEXT | DEFAULT 'active' | 用户状态 |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | 更新时间 |

---

## 5. 状态管理设计

### 5.1. UserState

```dart
class UserState {
  final UserModel? user;      // 用户信息
  final bool isLoading;       // 加载状态
  final String? error;        // 错误信息
}
```

### 5.2. NotificationsState

```dart
class NotificationsState {
  final List<NoticeModel> notices;  // 通知列表
  final bool isLoading;             // 加载状态
  final String? error;              // 错误信息
}
```

---

## 6. 路由配置

| 路由路径 | 页面 | 说明 |
|----------|------|------|
| /mine | MineScreen | 我的页面 |
| /mine/settings | SettingsScreen | 设置页面 |
| /mine/favorites | FavoritesScreen | 自选管理 |
| /mine/training-history | TrainingHistoryScreen | 训练记录 |
| /mine/learning-progress | LearningProgressScreen | 学习进度 |
| /mine/notifications | NotificationsScreen | 消息通知 |
| /mine/feedback | FeedbackScreen | 意见反馈 |
| /mine/help-center | HelpCenterScreen | 帮助中心 |
| /login | LoginScreen | 登录页面 |
| /register | RegisterScreen | 注册页面 |

---

**文档版本**: v1.0  
**创建日期**: 2026-05-14  
**最后更新**: 2026-05-14