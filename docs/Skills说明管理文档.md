# K线训练营App - Skills 说明管理文档

> **文档版本**: v1.3  
> **最后更新**: 2026-05-19  
> **维护者**: 开发团队  
> **描述**: 本项目所有 skills 能力说明文档，用于快速查询和管理各技能的功能、用途和调用方式。

---

## 目录

1. [Skills 分类概览](#1-skills-分类概览)
2. [核心 Skills 详细说明](#2-核心-skills-详细说明)
3. [技能调用流程](#3-技能调用流程)
4. [文档管理规范](#4-文档管理规范)
5. [添加新 Skills](#5-添加新-skills)
6. [更新记录](#6-更新记录)

---

## 1. Skills 分类概览

| 类别 | Skills | 主要用途 |
|------|--------|---------|
| **项目管理** | project-* | 项目初始化、产品设计、技术选型、架构设计 |
| **功能开发** | feature-* | 需求澄清、技术方案、任务规划、编码实现 |
| **开发工具** | development-essentials, brainstorming, systematic-debugging | 日常开发命令、头脑风暴、系统化调试 |
| **Bug修复** | bugfix-workflow | 问题定位、修复、验证 |
| **文档协作** | doc-coauthoring, writing-plans | 文档写作工作流、实施计划生成 |
| **前端设计** | frontend-design, ui-ux-pro-max | UI界面设计 |
| **Git工作流** | git-workflow, git-commit | Git规范和提交指南 |
| **敏捷管理** | sprint-planner | 敏捷冲刺规划 |
| **数据工程** | explore-data, sql-queries, statistical-analysis | K线数据探索、数据库查询、收益率统计 |
| **工程部署** | deploy-checklist | iOS/Android部署检查 |
| **框架工具** | using-superpowers, find-skills | Superpowers框架核心、Skill发现工具 |
| **编码准则** | karpathy-guidelines | Karpathy编码准则 |
| **自动化测试** | webapp-testing, agent-browser | Web应用测试、浏览器自动化 |
| **治理调试** | pua | 高能动性治理调试 |
| **文档管理** | doc-coauthoring | 文档整理、重命名、索引更新 |
| **其他工具** | pdf, pptx, docx, xlsx 等 | 文档处理、艺术生成等 |

---

## 2. 核心 Skills 详细说明

### 2.1 项目管理类 Skills

#### **project-initialization**
- **名称**: 项目初始化执行者
- **路径**: `skills/project/project-initialization/SKILL.md`
- **功能**: 读取 specs/ 下的定义文档，自动创建目录结构、配置文件和初始化 Git 仓库
- **触发时机**: 项目规划完成后，将文档转化为实际代码骨架
- **前置条件**: 需要 `specs/技术栈.md`、`specs/项目结构.md`、`specs/开发规范.md` 已存在
- **调用方式**: `Use Skill: project-initialization`
- **输出**: 项目目录结构、配置文件、Git 初始化、`docs/开发记录/初始化记录.md`

#### **project-product-overview**
- **名称**: 产品概述生成器
- **路径**: `skills/project/project-product-overview/SKILL.md`
- **功能**: 将需求转化为标准化的产品概述文档
- **触发时机**: 需求澄清后使用，明确愿景、核心价值、板块、用户、场景和验收标准
- **输出**: `specs/产品概述.md`
- **调用方式**: `Use Skill: project-product-overview`

#### **project-tech-stack**
- **名称**: 技术选型器
- **路径**: `skills/project/project-tech-stack/SKILL.md`
- **功能**: 进行项目技术选型，推荐最合适的技术栈
- **触发时机**: 产品概述确定后使用
- **输出**: `specs/技术栈.md`
- **调用方式**: `Use Skill: project-tech-stack`

#### **project-structure**
- **名称**: 项目结构设计器
- **路径**: `skills/project/project-structure/SKILL.md`
- **功能**: 定义项目目录结构，设计高内聚低耦合的架构
- **触发时机**: 技术栈确定后使用
- **输出**: `specs/项目结构.md`
- **调用方式**: `Use Skill: project-structure`

#### **project-dev-standards**
- **名称**: 开发规范制定器
- **路径**: `skills/project/project-dev-standards/SKILL.md`
- **功能**: 制定代码规范和协作流程
- **触发时机**: 技术栈确定后使用，定义代码风格、命名约定、Git提交规范和AI交互协议
- **输出**: `specs/开发规范.md`
- **调用方式**: `Use Skill: project-dev-standards`

#### **project-roadmap-planning**
- **名称**: 项目路线图规划器
- **路径**: `skills/project/project-roadmap-planning/SKILL.md`
- **功能**: 制定项目开发路线图和里程碑规划
- **输出**: 项目路线图文档
- **调用方式**: `Use Skill: project-roadmap-planning`

#### **project-requirements-clarification**
- **名称**: 项目需求澄清器
- **路径**: `skills/project/project-requirements-clarification/SKILL.md`
- **功能**: 通过苏格拉底式提问澄清原始想法，挖掘核心价值、目标用户和关键特性
- **触发时机**: 项目启动阶段使用
- **输出**: 标准化项目描述文档
- **调用方式**: `Use Skill: project-requirements-clarification`

---

### 2.2 功能开发类 Skills

#### **feature-requirements-clarification**
- **名称**: 功能需求澄清器
- **路径**: `skills/feature/feature-requirements-clarification/SKILL.md`
- **功能**: 通过自然对话挖掘需求，产出高质量验收标准（AC）
- **触发时机**: 用户说"我想做一个XX功能"、"帮我想想XX怎么做"等模糊需求描述时
- **输出**: `specs/features/{功能名}.md`
- **调用方式**: `Use Skill: feature-requirements-clarification`

#### **feature-tech-design**
- **名称**: 功能技术方案设计器
- **路径**: `skills/feature/feature-tech-design/SKILL.md`
- **功能**: 设计功能的技术实现方案
- **触发时机**: 需求明确后使用，产出包含 API、数据库、核心逻辑的详细技术方案
- **前置条件**: 需求文档 `specs/features/{功能名}.md` 已存在
- **输出**: `specs/features/{功能名}_技术方案.md`
- **调用方式**: `Use Skill: feature-tech-design`

#### **feature-task-planning**
- **名称**: 功能任务规划器
- **路径**: `skills/feature/feature-task-planning/SKILL.md`
- **功能**: 将功能分解为可执行的任务列表
- **输出**: `specs/features/{功能名}_任务规划.md`
- **调用方式**: `Use Skill: feature-task-planning`

#### **feature-implementation**
- **名称**: 功能编码实现器（TDD驱动）
- **路径**: `skills/feature/feature-implementation/SKILL.md`
- **功能**: 按 RED-GREEN-REFACTOR 循环执行开发任务
- **触发时机**: 用户说"完成XX功能的第N阶段"、"开始写代码"、"实现XX阶段"等时
- **前置条件**: 需求文档、技术方案、任务规划都已就绪
- **调用方式**: `Use Skill: feature-implementation`
- **输出**: 实现的代码、测试用例、阶段完成报告

#### **feature-evolution**
- **名称**: 功能演进管理
- **路径**: `skills/feature/feature-evolution/SKILL.md`
- **功能**: 管理功能的演进和迭代
- **调用方式**: `Use Skill: feature-evolution`

---

### 2.3 Git工作流类

#### **git-workflow**
- **名称**: Git工作流指导
- **路径**: `skills/git-workflow/SKILL.md`
- **功能**: Git规范和工作流指导，使用 Conventional Commits、分支策略和版本控制最佳实践
- **触发时机**: 设计 GitHub 管理及提交方案时
- **核心内容**:
  - Conventional Commits 格式规范
  - 分支策略（feature、bugfix、hotfix 等）
  - 提交信息规范
  - GitHub Actions CI/CD 配置
- **调用方式**: `Use Skill: git-workflow`

#### **git-commit**
- **名称**: Git提交助手
- **路径**: `skills/git-commit/SKILL.md`
- **功能**: 执行 git commit 操作，自动分析提交类型和生成规范的提交信息
- **核心功能**:
  - 自动检测变更类型和作用域
  - 从 diff 生成符合 Conventional Commits 的提交信息
  - 交互式提交，支持类型/作用域/描述覆盖
  - 智能文件暂存，实现逻辑分组
- **触发时机**: 提交代码变更时
- **调用方式**: `Use Skill: git-commit`

---

### 2.4 敏捷管理类

#### **sprint-planner**
- **名称**: 敏捷冲刺规划器
- **路径**: `skills/sprint-planner/SKILL.md`
- **功能**: 敏捷冲刺规划，包含故事估算、容量规划和冲刺目标设定
- **触发时机**: 规划冲刺、估算故事、定义冲刺目标、管理冲刺待办事项时
- **核心功能**:
  - 用户故事估算（Story Points）
  - 团队容量规划
  - 冲刺目标定义
  - 待办事项优先级排序
- **调用方式**: `Use Skill: sprint-planner`

---

### 2.5 数据工程类

#### **explore-data**
- **名称**: K线数据探索分析
- **路径**: `skills/knowledge-work-plugins-main/data/skills/explore-data/SKILL.md`
- **功能**: 提供数据探索的方法和工具，帮助分析K线历史数据
- **核心能力**:
  - K线数据可视化探索
  - 历史数据模式识别
  - 数据质量检查
  - 特征工程辅助
- **调用方式**: `Use Skill: explore-data`

#### **sql-queries**
- **名称**: 数据库查询优化
- **路径**: `skills/knowledge-work-plugins-main/data/skills/sql-queries/SKILL.md`
- **功能**: 优化数据库查询性能，提升数据访问效率
- **核心能力**:
  - SQL查询性能分析
  - 索引优化建议
  - 查询重写优化
  - 执行计划分析
- **调用方式**: `Use Skill: sql-queries`

#### **statistical-analysis**
- **名称**: 收益率统计分析
- **路径**: `skills/knowledge-work-plugins-main/data/skills/statistical-analysis/SKILL.md`
- **功能**: 对交易数据进行统计分析，计算收益率等关键指标
- **核心能力**:
  - 收益率计算与分析
  - 风险指标评估
  - 收益分布统计
  - 绩效评估报告
- **调用方式**: `Use Skill: statistical-analysis`

---

### 2.6 工程部署类

#### **deploy-checklist**
- **名称**: iOS/Android部署检查清单
- **路径**: `skills/knowledge-work-plugins-main/engineering/skills/deploy-checklist/SKILL.md`
- **功能**: 提供部署前的检查项，确保应用部署顺利
- **核心能力**:
  - iOS打包检查
  - Android打包检查
  - 版本号管理
  - 签名配置验证
- **调用方式**: `Use Skill: deploy-checklist`

---

### 2.7 Bug修复类

#### **bugfix-workflow**
- **名称**: BUG修复工作流
- **路径**: `skills/bugfix-workflow/SKILL.md`
- **功能**: 定位问题、修复、确保不再复发
- **触发时机**: 用户报告 bug、错误、异常行为、功能不符合预期时
- **关键判断**: 区分真正的 bug（代码行为与需求不符）和需求变更（用户想要新行为）
- **工作流程**:
  1. 收集信息，复现问题
  2. 定位根因
  3. 修复代码
  4. 测试验证
  5. 生成报告
- **调用方式**: `Use Skill: bugfix-workflow`
- **输出**: 修复后的代码、`docs/BUG修复文档/{时间}_{问题简述}.md`

---

### 2.8 开发工具类

#### **development-essentials**
- **名称**: 开发必备工具集
- **路径**: `skills/development-essentials`
- **功能**: 提供日常开发的子命令

#### **brainstorming**
- **名称**: 头脑风暴工具
- **路径**: `skills/brainstorming/SKILL.md`
- **功能**: 前置设计与需求分析，支持创意思维和方案探索
- **触发时机**: 项目启动前的需求分析、方案讨论阶段
- **核心能力**:
  - 需求澄清与分析
  - 创意方案生成
  - 可行性评估
- **调用方式**: `Use Skill: brainstorming`

#### **systematic-debugging**
- **名称**: 系统化调试工具
- **路径**: `skills/systematic-debugging/SKILL.md`
- **功能**: 系统化的调试方法论和工具
- **触发时机**: 复杂问题定位、性能调试、系统故障排查时
- **核心能力**:
  - 问题复现与分析
  - 调试策略制定
  - 根因追踪
- **调用方式**: `Use Skill: systematic-debugging`

#### **development-essentials 子命令列表**

| 命令 | 功能 | 触发词 | 文档 |
|------|------|--------|------|
| `code` | 编写代码 | "写代码"、"实现"、"编码" | `skills/development-essentials/commands/code.md` |
| `test` | 编写测试 | "写测试"、"测试用例" | `skills/development-essentials/commands/test.md` |
| `debug` | 调试代码 | "调试"、"bug"、"错误" | `skills/development-essentials/commands/debug.md` |
| `review` | 代码审查 | "审查代码"、"review" | `skills/development-essentials/commands/review.md` |
| `refactor` | 重构代码 | "重构"、"优化代码" | `skills/development-essentials/commands/refactor.md` |
| `optimize` | 性能优化 | "优化性能"、"性能问题" | `skills/development-essentials/commands/optimize.md` |
| `docs` | 编写文档 | "写文档"、"文档" | `skills/development-essentials/commands/docs.md` |
| `ask` | 提问解答 | "问一下"、"如何"、"为什么" | `skills/development-essentials/commands/ask.md` |
| `think` | 思考分析 | "分析"、"思考"、"方案" | `skills/development-essentials/commands/think.md` |
| `bugfix` | 修复bug | "修复bug"、"修复问题" | `skills/development-essentials/commands/bugfix.md` |

---

### 2.9 文档协作类

#### **doc-coauthoring**
- **名称**: 文档协作器
- **路径**: `skills/doc-coauthoring/SKILL.md`
- **功能**: 引导用户完成结构化的文档协作工作流
- **工作流程**:
  1. **Context Gathering** - 收集上下文
  2. **Refinement & Structure** - 细化和结构化
  3. **Reader Testing** - 读者测试
- **触发时机**: 用户想写文档、提案、技术规格、决策文档等
- **调用方式**: `Use Skill: doc-coauthoring`

#### **writing-plans**
- **名称**: 实施计划生成器
- **路径**: `skills/writing-plans/SKILL.md`
- **功能**: 根据规格或需求生成多步骤任务的实施计划
- **触发时机**: 在编写代码之前，需要制定详细的实施计划时
- **前置条件**: 需要有 spec 或需求文档
- **调用方式**: `Use Skill: writing-plans`

---

### 2.10 前端设计类

#### **frontend-design**
- **名称**: 前端设计器
- **路径**: `skills/frontend-design/SKILL.md`
- **功能**: 创建独特、生产级的前端界面，避免通用AI美学
- **设计原则**:
  - 排版：选择独特字体
  - 色彩：连贯的美学主题
  - 动效：高影响力的动画和微交互
  - 空间布局：非对称、重叠、对角线流动
- **调用方式**: `Use Skill: frontend-design`

#### **ui-ux-pro-max**
- **名称**: UI/UX设计工具集
- **路径**: `skills/ui-ux-pro-max/SKILL.md`
- **功能**: UI/UX设计工具，包含设计系统、组件库、样式指南等数据
- **包含内容**:
  - 多种技术栈的 UI 组件数据（React、Vue、Flutter 等）
  - 设计系统和样式指南
  - 图标和排版数据
- **调用方式**: `Use Skill: ui-ux-pro-max`

#### **UI-Interface-Design-Review**
- **名称**: UI界面设计评审
- **路径**: `skills/UI-Interface-Design-Review/SKILL.md`
- **功能**: 评审和优化 UI 界面设计
- **调用方式**: `Use Skill: UI-Interface-Design-Review`

---

### 2.11 框架工具类

#### **using-superpowers**
- **名称**: Superpowers框架核心
- **路径**: `skills/using-superpowers/SKILL.md`
- **功能**: Superpowers框架的核心功能，提供技能编排和工作流管理能力
- **核心能力**:
  - 技能组合编排
  - 工作流自动化
  - 上下文管理
- **调用方式**: `Use Skill: using-superpowers`

#### **find-skills**
- **名称**: Skill发现工具
- **路径**: `skills/find-skills/SKILL.md`
- **功能**: 发现和搜索可用的技能，帮助用户找到合适的工具
- **核心能力**:
  - 技能搜索和发现
  - 技能分类浏览
  - 技能推荐
- **调用方式**: `Use Skill: find-skills`

---

### 2.12 编码准则类

#### **karpathy-guidelines**
- **名称**: Karpathy编码准则
- **路径**: `skills/karpathy-guidelines/SKILL.md`
- **功能**: 基于Andrej Karpathy的编码理念，提供代码质量和架构指导
- **核心原则**:
  - 简洁清晰的代码风格
  - 模块化设计
  - 可维护性优先
- **调用方式**: `Use Skill: karpathy-guidelines`

---

### 2.13 自动化测试类

#### **webapp-testing**
- **名称**: Web应用测试
- **路径**: `skills/webapp-testing/SKILL.md`
- **功能**: Web应用的自动化测试工具
- **核心能力**:
  - 端到端测试
  - 功能测试
  - 性能测试
- **调用方式**: `Use Skill: webapp-testing`

#### **agent-browser**
- **名称**: 浏览器自动化
- **路径**: `skills/agent-browser/SKILL.md`
- **功能**: 自动化浏览器操作，支持网页交互和数据采集
- **核心能力**:
  - 页面导航和操作
  - 表单填写和提交
  - 数据抓取和分析
- **调用方式**: `Use Skill: agent-browser`

---

### 2.14 治理调试类

#### **pua**
- **名称**: 高能动性治理调试
- **路径**: `skills/pua/SKILL.md`
- **功能**: 高能动性系统的治理和调试工具
- **核心能力**:
  - 系统状态监控
  - 性能调优
  - 问题诊断
- **调用方式**: `Use Skill: pua`

---

### 2.15 文档管理类

#### **doc-coauthoring**
- **名称**: 文档协作器（增强版）
- **路径**: `skills/doc-coauthoring/SKILL.md`
- **功能**: 文档整理、合并重复文档、统一命名规范、更新文档索引
- **核心能力**:
  - 文档重复性检测
  - 文档合并与整理
  - 文档命名规范化
  - 文档索引更新
- **触发时机**: 文档整理、文档命名规范化、文档索引更新时
- **调用方式**: `Use Skill: doc-coauthoring`

---

### 2.16 其他工具类

#### **skill-creator**
- **名称**: 技能创建器
- **路径**: `skills/skill-creator/SKILL.md`
- **功能**: 创建新的 skills
- **调用方式**: `Use Skill: skill-creator`

#### **product-manager**
- **名称**: 产品经理工具集
- **路径**: `skills/product-manager/SKILL.md`
- **功能**: 产品管理相关工具，包含 PRD 模板、最佳实践等
- **参考文档**:
  - `skills/product-manager/references/PRD-TEMPLATE.md`
  - `skills/product-manager/references/PM-BEST-PRACTICES.md`
  - `skills/product-manager/references/REVIEW-CHECKLIST.md`
- **调用方式**: `Use Skill: product-manager`

#### **theme-factory**
- **名称**: 主题工厂
- **路径**: `skills/theme-factory/SKILL.md`
- **功能**: 创建和管理 UI 主题
- **预设主题**:
  - arctic-frost
  - botanical-garden
  - desert-rose
  - forest-canopy
  - golden-hour
  - midnight-galaxy
  - modern-minimalist
  - ocean-depths
  - sunset-boulevard
  - tech-innovation
- **调用方式**: `Use Skill: theme-factory`

#### **文档处理工具**
- **pdf**: PDF 文档处理
  - 路径: `skills/pdf/SKILL.md`
  - 功能: 表单填写、字段提取、验证等
- **docx**: Word 文档处理
  - 路径: `skills/docx/SKILL.md`
  - 功能: 文档编辑、修改接受等
- **pptx**: PowerPoint 文档处理
  - 路径: `skills/pptx/SKILL.md`
  - 功能: 幻灯片编辑、缩略图生成等
- **xlsx**: Excel 文档处理
  - 路径: `skills/xlsx/SKILL.md`
  - 功能: 电子表格处理

#### **其他创意工具**
- **algorithmic-art**: 算法艺术生成
  - 路径: `skills/algorithmic-art/SKILL.md`
- **canvas-design**: 画布设计
  - 路径: `skills/canvas-design/SKILL.md`
  - 包含大量字体资源
- **slack-gif-creator**: Slack GIF 创建
  - 路径: `skills/slack-gif-creator/SKILL.md`

#### **技术工具**
- **claude-api**: Claude API 使用指南
  - 路径: `skills/claude-api/SKILL.md`
  - 包含多语言示例（Python、TypeScript、Go、Java、PHP、Ruby、C#）
- **mcp-builder**: MCP服务器构建工具
  - 路径: `skills/mcp-builder/SKILL.md`
  - 功能: 创建高质量的 MCP 服务器
- **fullstack-developer**: 全栈开发工具
  - 路径: `skills/fullstack-developer/SKILL.md`
- **brand-guidelines**: 品牌指南工具
  - 路径: `skills/brand-guidelines/SKILL.md`
- **internal-comms**: 内部沟通工具
  - 路径: `skills/internal-comms/SKILL.md`
  - 包含邮件、通讯等模板
- **web-artifacts-builder**: Web构件构建器
  - 路径: `skills/web-artifacts-builder/SKILL.md`

---

## 3. 技能调用流程

### 3.1 项目初始化流程

```mermaid
graph TD
    A[用户提出项目需求] --> B[project-requirements-clarification 需求澄清]
    B --> C[project-product-overview 生成产品概述]
    C --> D[project-tech-stack 技术选型]
    D --> E[project-structure 设计目录结构]
    E --> F[project-dev-standards 制定开发规范]
    F --> G[project-initialization 初始化项目]
```

### 3.2 功能开发流程

```mermaid
graph TD
    A[用户提出功能需求] --> B[feature-requirements-clarification 需求澄清]
    B --> C[feature-tech-design 技术方案设计]
    C --> D[feature-task-planning 任务规划]
    D --> E[feature-implementation TDD编码实现]
```

### 3.3 Bug修复流程

```mermaid
graph TD
    A[用户报告问题] --> B{判断是否为bug}
    B -- 是 --> C[bugfix-workflow 开始修复流程]
    B -- 否 --> D[走功能开发流程]
    C --> E[收集信息复现问题]
    E --> F[定位根因]
    F --> G[修复代码]
    G --> H[测试验证]
    H --> I[生成修复报告]
```

### 3.4 敏捷冲刺规划流程

```mermaid
graph TD
    A[开始冲刺规划] --> B[sprint-planner 定义冲刺目标]
    B --> C[估算用户故事点数]
    C --> D[团队容量规划]
    D --> E[待办事项优先级排序]
    E --> F[生成冲刺计划]
```

### 3.5 文档管理流程

```mermaid
graph TD
    A[用户发起文档整理请求] --> B[分析文档结构和内容]
    B --> C[检查文档重复性和一致性]
    C --> D[整理并更新文档命名]
    D --> E[更新文档索引和目录]
    E --> F[生成整理报告]
```

### 3.6 调用方式说明

所有 skills 都遵循统一的调用格式：

```
Use Skill: <skill-name>
```

例如：
```
Use Skill: git-workflow
Use Skill: feature-requirements-clarification
Use Skill: project-initialization
Use Skill: sprint-planner
Use Skill: explore-data
Use Skill: doc-coauthoring
```

某些 skills 会在特定对话场景自动触发，无需显式调用。

---

## 4. 文档管理规范

### 4.1 文档命名规范

为保证文档管理的规范性，新建文档请遵循以下命名规则：

| 类型 | 命名格式 | 示例 |
|------|----------|------|
| 功能说明 | `XXX功能说明文档.md` | `选股功能说明文档.md` |
| 需求说明 | `XXX需求说明文档.md` | `选股需求说明文档.md` |
| 技术说明 | `XXX技术说明文档.md` | `选股技术说明文档.md` |
| 测试说明 | `XXX测试说明文档.md` | `选股测试说明文档.md` |
| 开发记录 | `XXX开发记录.md` | `XXX功能开发记录.md` |
| 设计文档 | `XXX设计文档.md` | `XXX架构设计文档.md` |
| 实现计划 | `XXX实现计划.md` | `选股条件算法实现计划.md` |

### 4.2 文档目录结构

```
docs/
├── superpowers/                    # 核心功能文档
│   ├── requirements/              # 需求文档
│   ├── designs/                  # 技术设计文档
│   └── plans/                    # 开发计划文档
├── 开发记录/                      # 开发过程记录
├── requirements/                  # 需求说明
├── tech/                         # 技术说明
├── features/                     # 功能说明
├── test/                         # 测试说明
├── README.md                      # 文档首页（综合索引）
├── Skills说明管理文档.md          # AI辅助开发说明
├── 测试账号.md                    # 测试账号信息
└── 数据库命令脚本.sh              # 数据库操作命令
```

### 4.3 文档更新流程

当添加或修改文档时，请按以下步骤操作：

1. **创建/修改文档** - 在对应目录下创建或更新文档
2. **更新索引** - 更新 `docs/README.md` 中的文档索引
3. **检查链接** - 确保所有文档链接有效
4. **更新版本** - 在本文档的更新记录中添加新条目

---

## 5. 添加新 Skills

当添加新 skills 时，请按以下步骤更新本文档：

### 5.1 添加步骤

1. **在 `skills/` 目录下创建新 skill**
   - 确保有 `SKILL.md` 文件
   - 如果有资源文件，放在对应目录

2. **确定 skill 所属分类**
   - 项目管理
   - 功能开发
   - 开发工具
   - Bug修复
   - 文档协作
   - 前端设计
   - Git工作流
   - 敏捷管理
   - 数据工程
   - 工程部署
   - 框架工具
   - 编码准则
   - 自动化测试
   - 治理调试
   - 文档管理
   - 其他工具

3. **在对应分类下添加说明**
   - 填写第 2 章节中的标准字段
   - 添加必要的文档路径

4. **更新更新记录**
   - 在第 6 章节添加新记录

5. **更新版本号**
   - 小更新：v1.0 → v1.1
   - 大更新：v1.0 → v2.0

### 5.2 Skill 说明模板

添加新 skill 时，请使用以下模板：

```markdown
#### **skill-name**
- **名称**: 技能名称
- **路径**: `skills/path/to/skill/SKILL.md`
- **功能**: 简要描述技能功能
- **触发时机**: 何时使用此技能
- **前置条件**: 如有必要，列出前置条件
- **调用方式**: `Use Skill: skill-name`
- **输出**: 输出内容描述（可选）
```

---

## 6. 更新记录

| 版本 | 日期 | 更新内容 | 更新者 |
|------|------|---------|--------|
| v1.0 | 2026-05-13 | 初始版本，整理现有所有 skills | DevOps Engineer |
| v1.1 | 2026-05-13 | 添加 sprint-planner 敏捷冲刺规划技能；添加数据工程类技能（explore-data、sql-queries、statistical-analysis）；添加工程部署类技能（deploy-checklist）；添加 git-commit 技能 | DevOps Engineer |
| v1.2 | 2026-05-14 | 添加10个新技能：brainstorming、ui-ux-pro-max、systematic-debugging、writing-plans、find-skills、using-superpowers、karpathy-guidelines、webapp-testing、agent-browser、pua；新增框架工具、编码准则、自动化测试、治理调试分类 | DevOps Engineer |
| v1.3 | 2026-05-19 | 新增文档管理分类；增强 doc-coauthoring 技能的文档管理能力；添加文档管理规范章节（命名规范、目录结构、更新流程）；更新文档目录结构示例；更新完整 Skills 清单 | DevOps Engineer |

---

## 7. 附录

### 7.1 完整 Skills 清单

| 序号 | Skill 名称 | 分类 | 路径 |
|------|-----------|------|------|
| 1 | project-initialization | 项目管理 | `skills/project/project-initialization/SKILL.md` |
| 2 | project-product-overview | 项目管理 | `skills/project/project-product-overview/SKILL.md` |
| 3 | project-tech-stack | 项目管理 | `skills/project/project-tech-stack/SKILL.md` |
| 4 | project-structure | 项目管理 | `skills/project/project-structure/SKILL.md` |
| 5 | project-dev-standards | 项目管理 | `skills/project/project-dev-standards/SKILL.md` |
| 6 | project-roadmap-planning | 项目管理 | `skills/project/project-roadmap-planning/SKILL.md` |
| 7 | project-requirements-clarification | 项目管理 | `skills/project/project-requirements-clarification/SKILL.md` |
| 8 | feature-requirements-clarification | 功能开发 | `skills/feature/feature-requirements-clarification/SKILL.md` |
| 9 | feature-tech-design | 功能开发 | `skills/feature/feature-tech-design/SKILL.md` |
| 10 | feature-task-planning | 功能开发 | `skills/feature/feature-task-planning/SKILL.md` |
| 11 | feature-implementation | 功能开发 | `skills/feature/feature-implementation/SKILL.md` |
| 12 | feature-evolution | 功能开发 | `skills/feature/feature-evolution/SKILL.md` |
| 13 | git-workflow | Git工作流 | `skills/git-workflow/SKILL.md` |
| 14 | git-commit | Git工作流 | `skills/git-commit/SKILL.md` |
| 15 | sprint-planner | 敏捷管理 | `skills/sprint-planner/SKILL.md` |
| 16 | explore-data | 数据工程 | `skills/knowledge-work-plugins-main/data/skills/explore-data/SKILL.md` |
| 17 | sql-queries | 数据工程 | `skills/knowledge-work-plugins-main/data/skills/sql-queries/SKILL.md` |
| 18 | statistical-analysis | 数据工程 | `skills/knowledge-work-plugins-main/data/skills/statistical-analysis/SKILL.md` |
| 19 | deploy-checklist | 工程部署 | `skills/knowledge-work-plugins-main/engineering/skills/deploy-checklist/SKILL.md` |
| 20 | bugfix-workflow | Bug修复 | `skills/bugfix-workflow/SKILL.md` |
| 21 | development-essentials | 开发工具 | `skills/development-essentials` |
| 22 | brainstorming | 开发工具 | `skills/brainstorming/SKILL.md` |
| 23 | systematic-debugging | 开发工具 | `skills/systematic-debugging/SKILL.md` |
| 24 | doc-coauthoring | 文档协作/文档管理 | `skills/doc-coauthoring/SKILL.md` |
| 25 | writing-plans | 文档协作 | `skills/writing-plans/SKILL.md` |
| 26 | frontend-design | 前端设计 | `skills/frontend-design/SKILL.md` |
| 27 | ui-ux-pro-max | 前端设计 | `skills/ui-ux-pro-max/SKILL.md` |
| 28 | UI-Interface-Design-Review | 前端设计 | `skills/UI-Interface-Design-Review/SKILL.md` |
| 29 | using-superpowers | 框架工具 | `skills/using-superpowers/SKILL.md` |
| 30 | find-skills | 框架工具 | `skills/find-skills/SKILL.md` |
| 31 | karpathy-guidelines | 编码准则 | `skills/karpathy-guidelines/SKILL.md` |
| 32 | webapp-testing | 自动化测试 | `skills/webapp-testing/SKILL.md` |
| 33 | agent-browser | 自动化测试 | `skills/agent-browser/SKILL.md` |
| 34 | pua | 治理调试 | `skills/pua/SKILL.md` |
| 35 | theme-factory | 其他工具 | `skills/theme-factory/SKILL.md` |
| 36 | product-manager | 其他工具 | `skills/product-manager/SKILL.md` |
| 37 | skill-creator | 其他工具 | `skills/skill-creator/SKILL.md` |
| 38 | pdf | 其他工具 | `skills/pdf/SKILL.md` |
| 39 | docx | 其他工具 | `skills/docx/SKILL.md` |
| 40 | pptx | 其他工具 | `skills/pptx/SKILL.md` |
| 41 | xlsx | 其他工具 | `skills/xlsx/SKILL.md` |
| 42 | algorithmic-art | 其他工具 | `skills/algorithmic-art/SKILL.md` |
| 43 | canvas-design | 其他工具 | `skills/canvas-design/SKILL.md` |
| 44 | slack-gif-creator | 其他工具 | `skills/slack-gif-creator/SKILL.md` |
| 45 | claude-api | 其他工具 | `skills/claude-api/SKILL.md` |
| 46 | mcp-builder | 其他工具 | `skills/mcp-builder/SKILL.md` |
| 47 | fullstack-developer | 其他工具 | `skills/fullstack-developer/SKILL.md` |
| 48 | brand-guidelines | 其他工具 | `skills/brand-guidelines/SKILL.md` |
| 49 | internal-comms | 其他工具 | `skills/internal-comms/SKILL.md` |
| 50 | web-artifacts-builder | 其他工具 | `skills/web-artifacts-builder/SKILL.md` |

---

**文档结束**

> 提示：本文档会随着项目的发展不断更新，确保保持与项目实际技能集同步。
