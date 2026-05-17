#!/bin/bash

# K线数据查询脚本
DB_PATH="/Users/lin/Library/Developer/CoreSimulator/Devices/0D4B29EB-252F-4858-8704-C5B644EF5EA7/data/Containers/Data/Application/2A615DF0-2578-4B56-9B29-3C16C105D486/Documents/kline_trainer.db"

echo "========================================="
echo "     K线数据表查询工具"
echo "========================================="
echo ""
echo "数据库路径: $DB_PATH"
echo ""

sqlite3 -header -column "$DB_PATH" "
SELECT 
    symbol AS '股票代码',
    market_code AS '市场',
    datetime(trade_date, 'unixepoch') AS '交易日期',
    printf('%.2f', open) AS '开盘价',
    printf('%.2f', close) AS '收盘价',
    printf('%.2f', high) AS '最高价',
    printf('%.2f', low) AS '最低价',
    printf('%.0f', volume) AS '成交量'
FROM kline_data 
ORDER BY symbol, trade_date DESC 
LIMIT 30;
"

echo ""
echo "========================================="
echo "按股票代码筛选示例:"
echo "  WHERE symbol='000001'"
echo "  WHERE market_code='SH'"
echo "  WHERE trade_date > strftime('%s', '2024-01-01')"
echo "========================================="
