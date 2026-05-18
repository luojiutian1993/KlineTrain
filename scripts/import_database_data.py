#!/usr/bin/env python3
"""
数据库导入脚本 v2.0
功能：将"数据库导入数据"文件夹下的CSV历史数据导入到stock_data.db
支持UPSERT：以最新数据为准
纯Python实现，无需pandas依赖
"""

import os
import sys
import sqlite3
import glob
from datetime import datetime
from pathlib import Path
import time
import csv

# 数据库路径
DB_PATH = 'lib/data/database/kline_trainer.db'
DATA_DIR = '数据库导入数据'

# 批量插入大小
BATCH_SIZE = 10000

def init_database(conn):
    """初始化数据库表结构"""
    cursor = conn.cursor()
    
    # 创建markets表
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS markets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT NOT NULL UNIQUE,
            name TEXT NOT NULL,
            currency TEXT DEFAULT 'CNY',
            enabled INTEGER DEFAULT 1,
            sort_order INTEGER DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # 创建symbols表
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS symbols (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            symbol TEXT NOT NULL UNIQUE,
            name TEXT,
            market_code TEXT NOT NULL,
            enabled INTEGER DEFAULT 1,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # 创建kline_data表
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS kline_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            symbol TEXT NOT NULL,
            market_code TEXT NOT NULL,
            period TEXT NOT NULL DEFAULT 'day',
            trade_date TIMESTAMP NOT NULL,
            open REAL,
            close REAL,
            high REAL,
            low REAL,
            volume REAL,
            amount REAL,
            turnover_rate REAL,
            pe REAL,
            pb REAL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(symbol, period, trade_date)
        )
    ''')
    
    # 创建索引
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_symbols_market ON symbols(market_code)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_kline_symbol ON kline_data(symbol)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_kline_date ON kline_data(trade_date)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_kline_symbol_date ON kline_data(symbol, trade_date)')
    
    # 初始化市场数据
    markets = [
        ('XSHG', '上海证券交易所'),
        ('XSHE', '深圳证券交易所'),
    ]
    cursor.executemany('''
        INSERT OR IGNORE INTO markets (code, name) VALUES (?, ?)
    ''', markets)
    
    conn.commit()
    print(f"✅ 数据库初始化完成")

def get_market_code(code):
    """从股票代码提取市场代码"""
    if '.XSHE' in code or code.endswith('.SZ'):
        return 'XSHE'
    elif '.XSHG' in code or code.endswith('.SH'):
        return 'XSHG'
    return 'XSHE'

def parse_date(date_str):
    """解析日期字符串"""
    formats = ['%Y-%m-%d', '%Y/%m/%d', '%Y%m%d']
    for fmt in formats:
        try:
            return datetime.strptime(date_str, fmt).strftime('%Y-%m-%d')
        except:
            continue
    return None

def process_csv_file(filepath):
    """处理单个CSV文件"""
    filename = os.path.basename(filepath)
    print(f"📖 读取文件: {filename}")
    
    try:
        records = []
        symbols_set = set()
        
        # 读取文件内容并跳过BOM
        with open(filepath, 'r', encoding='utf-8-sig') as f:
            reader = csv.DictReader(f)
            
            # 检查必要的列
            if reader.fieldnames:
                required_cols = ['date', 'code', 'open', 'close', 'high', 'low', 'volume']
                missing = [col for col in required_cols if col not in reader.fieldnames]
                if missing:
                    print(f"   ⚠️ 缺少列 {missing}，跳过此文件")
                    return [], set()
            
            for row in reader:
                try:
                    # 过滤无效数据
                    date = parse_date(row.get('date', ''))
                    if not date:
                        continue
                    
                    open_val = row.get('open', '')
                    close_val = row.get('close', '')
                    volume_val = row.get('volume', '')
                    
                    if not open_val or not close_val or not volume_val:
                        continue
                    
                    symbol = row.get('code', '').strip()
                    if not symbol:
                        continue
                    
                    market_code = get_market_code(symbol)
                    
                    # 记录股票
                    symbols_set.add((symbol, market_code, row.get('name', '')))
                    
                    # 计算成交额（估算）
                    try:
                        vol = float(volume_val)
                        open_p = float(open_val)
                        close_p = float(close_val)
                        amount = vol * (open_p + close_p) / 2
                    except:
                        amount = 0
                    
                    record = (
                        symbol,
                        market_code,
                        'day',
                        date,
                        float(open_val) if open_val else 0,
                        float(close_val) if close_val else 0,
                        float(row.get('high', 0)) if row.get('high') else 0,
                        float(row.get('low', 0)) if row.get('low') else 0,
                        vol,
                        amount
                    )
                    records.append(record)
                    
                except Exception as e:
                    continue
        
        print(f"   ✅ 读取成功: {len(records)} 条记录, {len(symbols_set)} 只股票")
        return records, symbols_set
        
    except Exception as e:
        print(f"   ❌ 读取错误: {e}")
        return [], set()

def upsert_kline_data(conn, records):
    """使用UPSERT方式插入数据，以最新数据为准"""
    cursor = conn.cursor()
    
    # SQLite UPSERT语法 (INSERT OR REPLACE)
    insert_sql = '''
        INSERT OR REPLACE INTO kline_data 
        (symbol, market_code, period, trade_date, open, close, high, low, volume, amount, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now'))
    '''
    
    total = len(records)
    for i in range(0, total, BATCH_SIZE):
        batch = records[i:i+BATCH_SIZE]
        cursor.executemany(insert_sql, batch)
        conn.commit()
        
        progress = min(i + BATCH_SIZE, total)
        if i % (BATCH_SIZE * 5) == 0 or progress == total:
            print(f"   📊 进度: {progress:,}/{total:,} ({progress*100//total}%)")
    
    return total

def upsert_symbols(conn, symbols_set):
    """更新symbols表"""
    cursor = conn.cursor()
    
    # 获取已存在的股票
    cursor.execute("SELECT symbol FROM symbols")
    existing = {row[0] for row in cursor.fetchall()}
    
    # 找出需要新增的股票
    new_symbols = []
    for symbol, market_code, name in symbols_set:
        if symbol not in existing:
            new_symbols.append((symbol, market_code, name))
    
    if new_symbols:
        cursor.executemany('''
            INSERT OR IGNORE INTO symbols (symbol, market_code, name) VALUES (?, ?, ?)
        ''', new_symbols)
        conn.commit()
        print(f"   ✅ 新增股票: {len(new_symbols)} 只")
    
    return len(new_symbols)

def main():
    print("=" * 60)
    print("📦 数据库导入工具 v2.0 (纯Python版)")
    print("=" * 60)
    
    start_time = time.time()
    
    # 检查数据目录
    if not os.path.exists(DATA_DIR):
        print(f"❌ 数据目录不存在: {DATA_DIR}")
        sys.exit(1)
    
    # 获取所有CSV文件
    csv_files = sorted(glob.glob(os.path.join(DATA_DIR, '*.csv')))
    if not csv_files:
        print(f"❌ 未找到CSV文件: {DATA_DIR}/*.csv")
        sys.exit(1)
    
    print(f"📂 找到 {len(csv_files)} 个CSV文件\n")
    
    # 连接数据库
    print(f"🔌 连接数据库: {DB_PATH}")
    conn = sqlite3.connect(DB_PATH)
    
    # 初始化数据库
    init_database(conn)
    
    # 统计
    total_records = 0
    total_files = 0
    all_symbols = set()
    all_records = []
    
    # 处理每个CSV文件
    for csv_file in csv_files:
        records, symbols_set = process_csv_file(csv_file)
        if records:
            all_records.extend(records)
            all_symbols.update(symbols_set)
            total_files += 1
    
    # 更新symbols表
    print(f"\n📝 更新股票列表...")
    upsert_symbols(conn, all_symbols)
    
    # 插入kline_data（UPSERT）
    print(f"\n📝 导入K线数据...")
    if all_records:
        inserted = upsert_kline_data(conn, all_records)
        total_records = inserted
        print(f"   ✅ 导入成功: {inserted:,} 条记录")
    
    # 关闭数据库
    conn.close()
    
    # 统计结果
    elapsed = time.time() - start_time
    
    print("\n" + "=" * 60)
    print("📊 导入完成统计")
    print("=" * 60)
    print(f"   处理文件数: {total_files}/{len(csv_files)}")
    print(f"   总记录数: {total_records:,}")
    print(f"   总股票数: {len(all_symbols)}")
    print(f"   耗时: {elapsed:.2f} 秒")
    if elapsed > 0:
        print(f"   速度: {total_records/elapsed:.0f} 条/秒")
    
    # 验证数据库
    print("\n🔍 验证数据库...")
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    cursor.execute("SELECT COUNT(*) FROM markets")
    markets_count = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM symbols")
    symbols_count = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM kline_data")
    kline_count = cursor.fetchone()[0]
    
    cursor.execute("SELECT MIN(trade_date), MAX(trade_date) FROM kline_data")
    date_range = cursor.fetchone()
    
    conn.close()
    
    print(f"   markets表: {markets_count} 条")
    print(f"   symbols表: {symbols_count} 条")
    print(f"   kline_data表: {kline_count:,} 条")
    print(f"   日期范围: {date_range[0]} ~ {date_range[1]}")
    
    print("\n✅ 全部完成!")

if __name__ == '__main__':
    main()
