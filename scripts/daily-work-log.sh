#!/bin/bash

# daily-work-log.sh - 自动生成每日工作记录文档
# 使用方法: ./scripts/daily-work-log.sh [日期]
# 如果不指定日期，默认生成昨天的工作记录

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." &>/dev/null && pwd)

# 获取日期参数，默认昨天
if [ -n "$1" ]; then
    TARGET_DATE="$1"
else
    TARGET_DATE=$(date -v -1d +%Y-%m-%d)
fi

# 格式化日期显示
DISPLAY_DATE=$(date -j -f "%Y-%m-%d" "$TARGET_DATE" +"%Y年%m月%d日")
DAY_OF_WEEK=$(date -j -f "%Y-%m-%d" "$TARGET_DATE" +"%A")

# 输出目录
OUTPUT_DIR="$PROJECT_ROOT/docs/开发记录"
mkdir -p "$OUTPUT_DIR"

# 输出文件名
OUTPUT_FILE="$OUTPUT_DIR/每日工作记录_${TARGET_DATE}.md"

echo "=== 生成每日工作记录 ==="
echo "目标日期: $DISPLAY_DATE ($DAY_OF_WEEK)"
echo "输出文件: $OUTPUT_FILE"

# 获取 Git 提交记录
GIT_LOG=$(cd "$PROJECT_ROOT" && git log --oneline --since="${TARGET_DATE} 00:00:00" --until="${TARGET_DATE} 23:59:59" 2>/dev/null || echo "No commits found")

# 获取文件变更统计
FILE_CHANGES=$(cd "$PROJECT_ROOT" && git diff --stat HEAD~1 HEAD 2>/dev/null | tail -1 | awk '{print $1, $4, $6}' || echo "N/A")

# 获取活跃分支
ACTIVE_BRANCH=$(cd "$PROJECT_ROOT" && git branch --show-current 2>/dev/null || echo "N/A")

# 生成文档内容
cat > "$OUTPUT_FILE" << EOF
# 每日工作记录 - $DISPLAY_DATE ($DAY_OF_WEEK)

## 📅 基本信息

| 项目 | 内容 |
|------|------|
| 日期 | $DISPLAY_DATE |
| 星期 | $DAY_OF_WEEK |
| 项目 | K线训练营 |
| 当前分支 | $ACTIVE_BRANCH |
| 生成时间 | $(date +"%Y-%m-%d %H:%M:%S") |

## 📝 今日完成

### Git 提交记录

$(if [ -n "$GIT_LOG" ] && [ "$GIT_LOG" != "No commits found" ]; then
    echo "\`\`\`"
    echo "$GIT_LOG"
    echo "\`\`\`"
else
    echo "今日无提交记录"
fi)

### 文件变更统计

| 指标 | 数值 |
|------|------|
| 修改文件数 | $(echo "$FILE_CHANGES" | awk '{print $1}') |
| 插入行数 | $(echo "$FILE_CHANGES" | awk '{print $2}') |
| 删除行数 | $(echo "$FILE_CHANGES" | awk '{print $3}') |

## 🔧 代码变更

### 修改的文件

\`\`\`
$(cd "$PROJECT_ROOT" && git diff --name-only HEAD~1 HEAD 2>/dev/null || echo "无法获取文件变更")
\`\`\`

## 🎯 功能进展

### 已完成功能

- [待补充]

### 进行中功能

- [待补充]

### 问题与风险

- [待补充]

## 📋 明日计划

- [待补充]

---

*自动生成于: $(date +"%Y-%m-%d %H:%M:%S")*
EOF

echo ""
echo "✅ 文档生成成功!"
echo "文件位置: $OUTPUT_FILE"

# 更新 README.md 中的文档索引
echo ""
echo "更新文档索引..."
README_FILE="$PROJECT_ROOT/docs/README.md"
LOG_ENTRY="- [每日工作记录_${TARGET_DATE}](开发记录/每日工作记录_${TARGET_DATE}.md)"

if ! grep -q "每日工作记录_${TARGET_DATE}" "$README_FILE"; then
    # 在开发记录部分添加新条目
    sed -i.bak "/## 📁 文档目录结构/i\\
$LOG_ENTRY" "$README_FILE"
    rm -f "${README_FILE}.bak"
    echo "✅ 文档索引已更新"
else
    echo "⚠️  文档索引已存在"
fi
