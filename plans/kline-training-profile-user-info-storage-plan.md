# "我的"页面用户信息存储 - Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use subagent-driven-development (recommended) or executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 细化"我的"页面用户信息功能，实现用户基本信息（头像、昵称、手机号等）的完整CRUD操作，并存储到后台数据库

**Architecture:** 扩展用户数据模型，完善API接口，实现用户信息编辑和头像上传功能

**Tech Stack:** Flutter + Riverpod + Dio + image_picker

---

## 需求理解

### 1.1 任务重述

在现有"我的"页面基础上，实现以下用户信息管理功能：

| 功能模块 | 说明 |
|----------|------|
| 用户信息展示 | 头像、昵称、手机号、会员等级、注册时间等 |
| 用户信息编辑 | 修改昵称、修改头像 |
| 数据持久化 | 用户信息存储到后台数据库 |
| 头像上传 | 支持相册选择和拍照上传 |

### 1.2 预期输出

- 完整的用户数据模型
- 用户信息API接口（获取、更新、上传头像）
- 用户信息仓库层
- 用户信息编辑UI组件
- 头像上传功能

### 1.3 成功标准

- 用户信息正确显示
- 编辑后数据同步到后台数据库
- 头像上传成功并更新显示
- 数据变更后本地缓存同步更新

---

## 文件结构变更

```
lib/
├── data/
│   ├── models/
│   │   ├── user_profile_model.dart        # 用户详细资料模型
│   │   ├── user_update_request.dart       # 用户更新请求模型
│   │   └── upload_result_model.dart       # 上传结果模型
│   ├── repositories/
│   │   └── user_profile_repository.dart   # 用户资料仓库
│   └── datasources/
│       ├── api/
│       │   └── user_profile_api.dart      # 用户资料API
│       └── local/
│           └── user_cache_storage.dart    # 用户缓存存储
│
├── presentation/
│   ├── pages/
│   │   └── profile/
│   │       ├── profile_page.dart          # 更新：我的主页
│   │       └── widgets/
│   │           ├── user_info_card.dart    # 更新：用户信息卡片
│   │           ├── avatar_picker.dart     # 新增：头像选择器
│   │           └── nickname_editor.dart   # 新增：昵称编辑器
│   └── providers/
│       └── user_profile_provider.dart     # 新增：用户资料状态管理
│
└── core/
    └── utils/
        └── image_compressor.dart          # 图片压缩工具
```

---

## Task 1: 数据模型扩展

**Files:**
- Create: `lib/data/models/user_profile_model.dart`
- Create: `lib/data/models/user_update_request.dart`
- Create: `lib/data/models/upload_result_model.dart`

- [ ] **Step 1: 创建用户详细资料模型**

```dart
// lib/data/models/user_profile_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// 用户详细资料模型
@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    // 基础信息
    required String userId,
    required String phone,
    @Default('') String nickname,
    @Default('') String avatarUrl,
    
    // 会员信息
    required MemberLevel level,
    @Default(0) int levelPoints,           // 等级积分
    @Default(0) int nextLevelPoints,       // 升级所需积分
    
    // 训练统计
    @Default(0) int trainingCount,
    @Default(0) int completedTrainings,
    @Default(0) double totalReturnPercent,
    @Default(0) int winCount,
    @Default(0) int totalTrades,
    @Default(0.0) double winRate,
    
    // 账户设置
    @Default(false) bool hasPassword,
    @Default(false) bool hasSetPin,
    @Default(true) bool notificationEnabled,
    
    // 时间戳
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastLoginAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

enum MemberLevel {
  @JsonValue('bronze')
  bronze('青铜', 1, 0, 100),
  @JsonValue('silver')
  silver('白银', 2, 100, 500),
  @JsonValue('gold')
  gold('黄金', 3, 500, 2000),
  @JsonValue('platinum')
  platinum('铂金', 4, 2000, 5000),
  @JsonValue('diamond')
  diamond('钻石', 5, 5000, 10000);

  const MemberLevel(
    this.label,
    this.value,
    this.minPoints,
    this.maxPoints,
  );
  
  final String label;
  final int value;
  final int minPoints;
  final int maxPoints;

  /// 获取下一等级
  MemberLevel? get nextLevel {
    final levels = MemberLevel.values;
    final index = levels.indexOf(this);
    if (index < levels.length - 1) {
      return levels[index + 1];
    }
    return null;
  }

  /// 获取等级颜色
  String get colorHex {
    switch (this) {
      case MemberLevel.bronze:
        return '#CD7F32';
      case MemberLevel.silver:
        return '#C0C0C0';
      case MemberLevel.gold:
        return '#FFD700';
      case MemberLevel.platinum:
        return '#E5E4E2';
      case MemberLevel.diamond:
        return '#B9F2FF';
    }
  }
}

/// 扩展方法
extension UserProfileModelExtension on UserProfileModel {
  /// 脱敏手机号
  String get maskedPhone {
    if (phone.length < 11) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(7)}';
  }

  /// 显示昵称（如果没有设置则显示默认）
  String get displayName => nickname.isEmpty ? '用户${phone.substring(7)}' : nickname;

  /// 等级进度百分比
  double get levelProgress {
    if (nextLevelPoints == 0) return 1.0;
    final range = nextLevelPoints - level.minPoints;
    final current = levelPoints - level.minPoints;
    return (current / range).clamp(0.0, 1.0);
  }

  /// 格式化注册时间
  String get formattedJoinDate {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}加入';
  }
}
```

- [ ] **Step 2: 创建用户更新请求模型**

```dart
// lib/data/models/user_update_request.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_request.freezed.dart';
part 'user_update_request.g.dart';

/// 用户资料更新请求
@freezed
class UserUpdateRequest with _$UserUpdateRequest {
  const factory UserUpdateRequest({
    String? nickname,
    String? avatarUrl,
    bool? notificationEnabled,
  }) = _UserUpdateRequest;

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateRequestFromJson(json);
}

/// 修改密码请求
@freezed
class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    required String oldPassword,
    required String newPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}

/// 绑定手机号请求
@freezed
class BindPhoneRequest with _$BindPhoneRequest {
  const factory BindPhoneRequest({
    required String phone,
    required String verifyCode,
  }) = _BindPhoneRequest;

  factory BindPhoneRequest.from