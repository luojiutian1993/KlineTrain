# K线训练营数据库查询命令

## 数据库路径
DB_PATH="/Users/lin/Library/Developer/CoreSimulator/Devices/0D4B29EB-252F-4858-8704-C5B644EF5EA7/data/Containers/Data/Application/032D41A8-0CD2-4FE4-B8A6-085C63998340/Documents/kline_trainer.db"

## 查询所有用户
sqlite3 -header -column "$DB_PATH" "SELECT * FROM users;"

## 按手机号查询用户
sqlite3 "$DB_PATH" "SELECT * FROM users WHERE phone='13071103531';"

## 查看数据库表结构
sqlite3 "$DB_PATH" ".schema users"

## 查看所有表
sqlite3 "$DB_PATH" ".tables"

## 退出
# .exit
