# K线训练营开发文档

> K线训练营是一个用于股票K线分析和实战训练的Flutter移动应用。

## 📚 文档导航

### 快速入口
- [功能索引文档](功能索引文档.md) - 所有功能模块的文档索引

### 核心功能文档

| 功能模块 | 需求文档 | 技术设计 | 开发记录 |
|----------|-----------|-----------|-----------|
| 选股条件 | [需求](superpowers/requirements/2026-05-16-stock-selection-functional-requirements.md) | [设计](superpowers/designs/2026-05-16-stock-selection-technical-design.md) | [记录](开发记录/时间范围筛选功能开发记录.md) |

### 开发指南

| 文档 | 说明 |
|------|------|
| [Skills说明管理文档](Skills说明管理文档.md) | AI辅助开发指南 |
| [测试指南](test_guide.md) | 应用测试指南 |
| [数据库命令](db_commands.sh) | 数据库操作命令 |

## 🎯 功能特性

### 已实现功能

- ✅ **首页选股条件筛选** - 18种选股条件算法
- ✅ **市场板块选择** - A股、港股、美股、期货
- ✅ **时间范围筛选** - 近1年、近3年、近5年、自定义
- ✅ **K线数据展示** - 股票历史K线查看
- ✅ **实战训练页面** - K线技术分析训练

### 选股条件列表（18种）

**趋势向上（9种）**
1. 历史新高
2. 一年新高
3. 200日新高
4. 30日涨幅前50%
5. 15日涨幅前50%
6. 涨停
7. 连板
8. 量价齐升
9. 上升趋势

**趋势向下（9种）**
10. 历史新低
11. 一年新低
12. 200日新低
13. 30日跌幅前50%
14. 15日跌幅前50%
15. 下降趋势
16. 跌停
17. 连续跌停
18. 随机

## 🛠️ 开发环境

### 技术栈

| 层级 | 技术 |
|------|------|
| 框架 | Flutter 3.19+ |
| 状态管理 | Riverpod 2.3+ |
| 数据库 | Drift (SQLite) 2.18+ |
| 路由 | GoRouter 12.0+ |
| 序列化 | json_serializable |

### 常用命令

```bash
# 安装依赖
flutter pub get

# 代码生成
flutter pub run build_runner build --delete-conflicting-outputs

# 运行分析
flutter analyze

# 运行应用
flutter run -d <device_id>

# 构建iOS
flutter build ios
```

## 📁 项目结构

```
lib/
├── core/                    # 核心定义
│   ├── enums/              # 枚举定义
│   └── constants/         # 常量定义
├── data/                   # 数据层
│   ├── database/          # 数据库相关
│   ├── models/           # 数据模型
│   └── repositories/      # 数据仓库
├── features/               # 功能模块
│   └── home/             # 首页功能
├── providers/             # 状态管理
└── theme/                # 主题样式
```

## 📖 文档更新说明

> **重要**: 当您提出新的开发需求时，我会自动按以下规则更新文档：

1. **需求文档** - 更新 `superpowers/requirements/` 目录下的功能需求文档
2. **技术设计** - 更新 `superpowers/designs/` 目录下的技术设计文档
3. **开发记录** - 在 `开发记录/` 目录下新增开发记录文档
4. **功能索引** - 更新 `功能索引文档.md` 以包含新功能

---

*最后更新: 2026-05-16*
