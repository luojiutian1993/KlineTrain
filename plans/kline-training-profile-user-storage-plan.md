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
│   │   ├── user_profile_model.dart
│   │   ├── user_update_request.dart
│   │   └── upload_result_model.dart
│   ├── repositories/
│   │   └── user_profile_repository.dart
│   └── datasources/
│       ├── api/
│       │   └── user_profile_api.dart
│       └── local/
│           └── user_cache_storage.dart
├── presentation/
│   ├── pages/
│   │   └── profile/
│   │       ├── profile_page.dart
│   │       └── widgets/
│   │           ├── user_info_card.dart
│   │           ├── avatar_picker.dart
│   │           └── nickname_editor.dart
│   └── providers/
│       └── user_profile_provider.dart
└── core/
    └── utils/
        └── image_compressor.dart
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

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String userId,
    required String phone,
    @Default('') String nickname,
    @Default('') String avatarUrl,
    required MemberLevel level,
    @Default(0) int levelPoints,
    @Default(0) int nextLevelPoints,
    @Default(0) int trainingCount,
    @Default(0) double totalReturnPercent,
    @Default(0) int winCount,
    @Default(0) int totalTrades,
    @Default(false) bool hasPassword,
    @Default(true) bool notificationEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastLoginAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

enum MemberLevel {
  @JsonValue('bronze') bronze('青铜', 1, 0, 100),
  @JsonValue('silver') silver('白银', 2, 100, 500),
  @JsonValue('gold') gold('黄金', 3, 500, 2000),
  @JsonValue('platinum') platinum('铂金', 4, 2000, 5000),
  @JsonValue('diamond') diamond('钻石', 5, 5000, 10000);

  const MemberLevel(this.label, this.value, this.minPoints, this.maxPoints);
  final String label;
  final int value;
  final int minPoints;
  final int maxPoints;

  MemberLevel? get nextLevel {
    final levels = MemberLevel.values;
    final index = levels.indexOf(this);
    if (index < levels.length - 1) return levels[index + 1];
    return null;
  }
}

extension UserProfileModelExtension on UserProfileModel {
  String get maskedPhone => phone.length >= 11 
      ? '${phone.substring(0, 3)}****${phone.substring(7)}' 
      : phone;
  
  String get displayName => nickname.isEmpty ? '用户${phone.substring(7)}' : nickname;
  
  double get levelProgress {
    if (nextLevelPoints == 0) return 1.0;
    return ((levelPoints - level.minPoints) / (nextLevelPoints - level.minPoints)).clamp(0.0, 1.0);
  }
}
```

- [ ] **Step 2: 创建用户更新请求模型**

```dart
// lib/data/models/user_update_request.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_request.freezed.dart';
part 'user_update_request.g.dart';

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

@freezed
class UploadResultModel with _$UploadResultModel {
  const factory UploadResultModel({
    required String url,
    required String fileName,
  }) = _UploadResultModel;

  factory UploadResultModel.fromJson(Map<String, dynamic> json) =>
      _$UploadResultModelFromJson(json);
}
```

- [ ] **Step 3: 运行代码生成**

Run: `flutter pub run build_runner build --delete-conflicting-outputs`
Expected: All freezed files generated

- [ ] **Step 4: 提交代码**

```bash
git add lib/data/models/
git commit -m "feat(user): add user profile and update request models"
```

---

## Task 2: API层实现

**Files:**
- Create: `lib/data/datasources/api/user_profile_api.dart`
- Create: `lib/data/datasources/local/user_cache_storage.dart`
- Create: `lib/data/repositories/user_profile_repository.dart`

- [ ] **Step 1: 创建用户资料API**

```dart
// lib/data/datasources/api/user_profile_api.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../models/user_profile_model.dart';
import '../../models/user_update_request.dart';
import '../../models/upload_result_model.dart';

class UserProfileApi {
  final ApiClient _client;

  UserProfileApi(this._client);

  Future<UserProfileModel> getUserProfile() async {
    final response = await _client.get('/api/v1/user/profile');
    return UserProfileModel.fromJson(response.data);
  }

  Future<UserProfileModel> updateProfile(UserUpdateRequest request) async {
    final response = await _client.put(
      '/api/v1/user/profile',
      data: request.toJson(),
    );
    return UserProfileModel.fromJson(response.data);
  }

  Future<UploadResultModel> uploadAvatar(File imageFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'avatar.jpg',
      ),
    });
    
    final response = await _client.post(
      '/api/v1/user/avatar',
      data: formData,
    );
    return UploadResultModel.fromJson(response.data);
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await