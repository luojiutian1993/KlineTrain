#!/bin/bash

# install-cron.sh - 安装每日工作记录定时任务
# 使用方法: ./scripts/install-cron.sh

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." &>/dev/null && pwd)

echo "=== 安装每日工作记录定时任务 ==="
echo ""

# 创建日志目录
mkdir -p "$PROJECT_ROOT/scripts/logs"

# 方法1: 使用 launchd（推荐）
echo "方法1: 使用 launchd（推荐）"
echo "=========================="
echo "请手动执行以下命令:"
echo ""
echo "# 复制 plist 文件到用户 LaunchAgents 目录"
echo "cp $PROJECT_ROOT/scripts/com.kline-trainer.daily-work-log.plist ~/Library/LaunchAgents/"
echo ""
echo "# 加载定时任务"
echo "launchctl load ~/Library/LaunchAgents/com.kline-trainer.daily-work-log.plist"
echo ""
echo "# 验证任务是否加载成功"
echo "launchctl list | grep com.kline-trainer.daily-work-log"
echo ""
echo "卸载命令:"
echo "launchctl unload ~/Library/LaunchAgents/com.kline-trainer.daily-work-log.plist"
echo "rm ~/Library/LaunchAgents/com.kline-trainer.daily-work-log.plist"
echo ""

# 方法2: 使用 crontab
echo "方法2: 使用 crontab"
echo "=================="
echo "请手动执行以下命令:"
echo ""
echo "# 编辑 crontab"
echo "crontab -e"
echo ""
echo "# 在编辑器中添加以下内容:"
echo "0 8 * * * $PROJECT_ROOT/scripts/daily-work-log.sh"
echo ""
echo "# 验证定时任务"
echo "crontab -l"
echo ""

echo "=== 定时任务说明 ==="
echo ""
echo "任务时间: 每天早上 8:00"
echo "任务内容: 自动生成前一天的工作记录文档"
echo "输出位置: docs/开发记录/每日工作记录_YYYY-MM-DD.md"
echo "日志位置: scripts/logs/daily-work-log.out"
echo ""
echo "手动测试命令:"
echo "$PROJECT_ROOT/scripts/daily-work-log.sh"
echo "$PROJECT_ROOT/scripts/daily-work-log.sh 2026-05-20"
