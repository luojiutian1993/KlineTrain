#!/usr/bin/env osascript

set dbPath to "/Users/lin/Library/Developer/CoreSimulator/Devices/0D4B29EB-252F-4858-8704-C5B644EF5EA7/data/Containers/Data/Application/2A615DF0-2578-4B56-9B29-3C16C105D486/Documents/kline_trainer.db"

-- 尝试使用 DB Browser for SQLite
try
    tell application "DB Browser for SQLite"
        open file dbPath
        activate
    end tell
on error
    -- 如果未安装，尝试使用 DBeaver
    try
        tell application "DBeaver"
            open file dbPath
            activate
        end tell
    on error
        -- 如果都未安装，显示提示
        display dialog "请安装可视化数据库工具：\n\n1. DB Browser for SQLite: https://sqlitebrowser.org/dl/\n2. DBeaver: https://dbeaver.io/download/" buttons {"确定"} default button 1
    end try
end try
