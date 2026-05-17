#!/bin/bash

DB_PATH="/Users/lin/Library/Developer/CoreSimulator/Devices/0D4B29EB-252F-4858-8704-C5B644EF5EA7/data/Containers/Data/Application/2A615DF0-2578-4B56-9B29-3C16C105D486/Documents/kline_trainer.db"

echo "========================================="
echo "   K线数据可视化查询工具"
echo "========================================="
echo ""
echo "数据库路径: $DB_PATH"
echo ""
echo "选择可视化工具："
echo "  1. DB Browser for SQLite（推荐）"
echo "  2. DBeaver"
echo "  3. TablePlus"
echo "  4. 命令行sqlite3"
echo "  5. 复制路径到剪贴板"
echo ""
read -p "请输入选项 (1-5): " choice

case $choice in
    1)
        if [ -d "/Applications/DB Browser for SQLite.app" ]; then
            open -a "DB Browser for SQLite" "$DB_PATH"
            echo "已在 DB Browser for SQLite 中打开"
        else
            echo "DB Browser for SQLite 未安装，正在打开安装页面..."
            open "https://sqlitebrowser.org/dl/"
        fi
        ;;
    2)
        if [ -d "/Applications/DBeaver.app" ]; then
            open -a DBeaver "$DB_PATH"
            echo "已在 DBeaver 中打开"
        else
            echo "DBeaver 未安装，正在打开安装页面..."
            open "https://dbeaver.io/download/"
        fi
        ;;
    3)
        if [ -d "/Applications/TablePlus.app" ]; then
            open -a TablePlus "$DB_PATH"
            echo "已在 TablePlus 中打开"
        else
            echo "TablePlus 未安装，正在打开安装页面..."
            open "https://tableplus.com/"
        fi
        ;;
    4)
        echo "打开命令行sqlite3..."
        sqlite3 "$DB_PATH"
        ;;
    5)
        echo "$DB_PATH" | pbcopy
        echo "路径已复制到剪贴板！"
        echo "可以在可视化工具中粘贴打开"
        ;;
    *)
        echo "无效选项"
        ;;
esac
