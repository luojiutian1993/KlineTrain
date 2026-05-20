#!/bin/bash

# cleanup-logs.sh - 定期压缩整理日志和缓存文件
# 使用方法: ./scripts/cleanup-logs.sh [选项]
# 选项:
#   --compress   压缩旧日志文件（默认超过7天）
#   --cleanup    删除过期日志文件（默认超过30天）
#   --all        执行所有操作（压缩+清理）
#   --dry-run    模拟运行，不实际执行操作

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." &>/dev/null && pwd)

# 配置参数
COMPRESS_AGE=7    # 超过多少天的日志进行压缩（天）
CLEANUP_AGE=30    # 超过多少天的日志进行删除（天）
COMPRESS_DIRS=(
    "$PROJECT_ROOT/scripts/logs"
    "$PROJECT_ROOT/docs/开发记录"
)

# 日志文件扩展名
LOG_EXTENSIONS=("*.log" "*.out" "*.err" "*.txt" "*.md")

# 执行模式
DO_COMPRESS=false
DO_CLEANUP=false
DRY_RUN=false

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --compress)
            DO_COMPRESS=true
            ;;
        --cleanup)
            DO_CLEANUP=true
            ;;
        --all)
            DO_COMPRESS=true
            DO_CLEANUP=true
            ;;
        --dry-run)
            DRY_RUN=true
            ;;
        *)
            echo "未知选项: $1"
            exit 1
            ;;
    esac
    shift
done

# 如果没有指定选项，默认执行所有操作
if [ "$DO_COMPRESS" = false ] && [ "$DO_CLEANUP" = false ]; then
    DO_COMPRESS=true
    DO_CLEANUP=true
fi

echo "=== 日志和缓存文件清理脚本 ==="
echo "日期: $(date +"%Y-%m-%d %H:%M:%S")"
echo "压缩阈值: ${COMPRESS_AGE}天"
echo "清理阈值: ${CLEANUP_AGE}天"
if [ "$DRY_RUN" = true ]; then
    echo "模式: 模拟运行（不实际执行）"
fi
echo ""

# 压缩旧日志文件
if [ "$DO_COMPRESS" = true ]; then
    echo "📦 开始压缩旧日志文件..."
    for DIR in "${COMPRESS_DIRS[@]}"; do
        if [ ! -d "$DIR" ]; then
            continue
        fi
        
        echo "处理目录: $DIR"
        for EXT in "${LOG_EXTENSIONS[@]}"; do
            # 查找超过 COMPRESS_AGE 天但未超过 CLEANUP_AGE 天的文件
            find "$DIR" -maxdepth 1 -type f -name "$EXT" -mtime +$COMPRESS_AGE -mtime -$CLEANUP_AGE 2>/dev/null | while read -r FILE; do
                # 跳过已经压缩的文件
                if [[ "$FILE" == *.gz ]]; then
                    continue
                fi
                
                SIZE=$(du -h "$FILE" | awk '{print $1}')
                echo "  压缩: $(basename "$FILE") [$SIZE]"
                
                if [ "$DRY_RUN" = false ]; then
                    gzip -9 "$FILE"
                fi
            done
        done
    done
    echo ""
fi

# 删除过期日志文件
if [ "$DO_CLEANUP" = true ]; then
    echo "🗑️  开始清理过期日志文件..."
    for DIR in "${COMPRESS_DIRS[@]}"; do
        if [ ! -d "$DIR" ]; then
            continue
        fi
        
        echo "处理目录: $DIR"
        for EXT in "${LOG_EXTENSIONS[@]}"; do
            # 查找超过 CLEANUP_AGE 天的文件
            find "$DIR" -maxdepth 1 -type f \( -name "$EXT" -o -name "${EXT}.gz" \) -mtime +$CLEANUP_AGE 2>/dev/null | while read -r FILE; do
                SIZE=$(du -h "$FILE" | awk '{print $1}')
                echo "  删除: $(basename "$FILE") [$SIZE]"
                
                if [ "$DRY_RUN" = false ]; then
                    rm -f "$FILE"
                fi
            done
        done
    done
    echo ""
fi

# 清理空目录
echo "🧹 清理空目录..."
for DIR in "${COMPRESS_DIRS[@]}"; do
    if [ -d "$DIR" ] && [ -z "$(ls -A "$DIR")" ]; then
        echo "  删除空目录: $DIR"
        if [ "$DRY_RUN" = false ]; then
            rmdir "$DIR" 2>/dev/null || true
        fi
    fi
done

echo ""
echo "✅ 清理完成!"

# 显示磁盘使用情况
echo ""
echo "📊 磁盘使用情况:"
df -h "$PROJECT_ROOT" | tail -1