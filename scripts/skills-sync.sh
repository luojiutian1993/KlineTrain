#!/bin/bash

# skills-sync.sh - 同步 skills/ 和 .agents/skills/ 目录
# 使用方法: ./scripts/skills-sync.sh

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." &>/dev/null && pwd)

SKILLS_SRC="$PROJECT_ROOT/skills"
SKILLS_DST="$PROJECT_ROOT/.agents/skills"

echo "=== Skills 目录同步脚本 ==="
echo "源目录: $SKILLS_SRC"
echo "目标目录: $SKILLS_DST"
echo ""

# 确保目标目录存在
mkdir -p "$SKILLS_DST"

# 复制所有技能目录（排除 .DS_Store 和隐藏文件）
echo "正在同步技能目录..."
rsync -av --delete --exclude='*.DS_Store' --exclude='.*' "$SKILLS_SRC/" "$SKILLS_DST/"

echo ""
echo "同步完成！"
echo ""

# 显示统计信息
echo "=== 同步统计 ==="
echo "源目录技能数量: $(find "$SKILLS_SRC" -type d -mindepth 1 -maxdepth 1 | wc -l)"
echo "目标目录技能数量: $(find "$SKILLS_DST" -type d -mindepth 1 -maxdepth 1 | wc -l)"
echo ""

# 检查关键技能是否存在
echo "=== 关键技能检查 ==="
CHECK_SKILLS=(
    "feature/feature-requirements-clarification"
    "feature/feature-tech-design" 
    "feature/feature-implementation"
    "project/project-initialization"
    "bugfix-workflow"
    "git-workflow"
)

for skill in "${CHECK_SKILLS[@]}"; do
    if [ -d "$SKILLS_DST/$skill" ]; then
        echo "✅ $skill"
    else
        echo "❌ $skill - 缺失"
    fi
done

echo ""
echo "提示: 可以将此脚本添加到 git pre-commit hook 中自动同步"
