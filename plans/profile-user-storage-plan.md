# "我的"页面用户信息存储实现计划

## 目标
细化"我的"页面，实现用户基本信息（头像、昵称、手机号等）的完整CRUD操作，并存储到后台数据库。

## 任务清单

### Task 1: 数据模型 (1天)
- 创建 `UserProfileModel` - 用户详细资料
- 创建 `UserUpdateRequest` - 更新请求
- 创建 `UploadResultModel` - 上传结果

### Task 2: API层 (1天)
- 创建 `UserProfileApi` - 用户资料API
  - `getUserProfile()` - 获取用户信息
  - `updateProfile()` - 更新用户信息
  - `uploadAvatar()` - 上传头像
- 创建 `UserCacheStorage` - 本地缓存

### Task 3: 仓库层 (0.5天)
- 创建 `UserProfileRepository`
  - 数据获取与缓存策略
  - 头像上传处理

### Task 4: 状态管理 (0.5天)
- 创建 `UserProfileProvider`
  - 加载用户信息
  - 更新用户信息
  - 上传头像

### Task 5: UI组件 (1天)
- 更新 `UserInfoCard` - 展示用户信息
- 创建 `AvatarPicker` - 头像选择器
- 创建 `NicknameEditor` - 昵称编辑器

### Task 6: 页面整合 (0.5天)
- 更新 `ProfilePage`
- 实现编辑交互

### Task 7: 测试 (0.5天)
- 单元测试
- 集成测试

## API接口设计

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 获取用户信息 | GET | /api/v1/user/profile | 获取完整用户资料 |
| 更新用户信息 | PUT | /api/v1/user/profile | 更新昵称等 |
| 上传头像 | POST | /api/v1/user/avatar |  multipart/form-data |

## 数据模型

```dart
class UserProfileModel {
  String userId;
  String phone;
  String nickname;
  String avatarUrl;
  MemberLevel level;
  int levelPoints;
  int trainingCount;
  double totalReturnPercent;
  DateTime createdAt;
}
```

## 执行选项

**1. Subagent-Driven (推荐)** - 派遣独立子代理逐任务执行

**2. Inline Execution** - 当前会话批量执行

选择哪种方式开始开发？
