#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
上证股票历史基础数据导入工具 - CSV版本
将 1000_stocks_post_fq_history.csv 数据导入到 drift 数据库
"""

import os
import sqlite3
import time
import logging
from datetime import datetime
from pathlib import Path

import pandas as pd

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

SCRIPT_DIR = Path(__file__).parent
PROJECT_DIR = SCRIPT_DIR.parent
CSV_FILE = PROJECT_DIR / "1000_stocks_post_fq_history.csv"
DB_FILE = SCRIPT_DIR.parent / "lib" / "data" / "database" / "kline_trainer.db"


def create_tables(conn: sqlite3.Connection):
    """创建与 drift 一致的数据库表"""
    cursor = conn.cursor()
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS markets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT NOT NULL UNIQUE,
            name TEXT NOT NULL,
            enabled INTEGER DEFAULT 1,
            sort_order INTEGER DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS symbols (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            symbol TEXT NOT NULL UNIQUE,
            name TEXT,
            market_code TEXT NOT NULL,
            enabled INTEGER DEFAULT 1,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (market_code) REFERENCES markets(code)
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS kline_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            symbol TEXT NOT NULL,
            market_code TEXT NOT NULL,
            period TEXT NOT NULL,
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
            UNIQUE(symbol, period, trade_date)
        )
    ''')
    
    cursor.execute('''
        CREATE INDEX IF NOT EXISTS idx_kline_symbol_period_date 
        ON kline_data(symbol, period, trade_date)
    ''')
    
    cursor.execute('''
        CREATE INDEX IF NOT EXISTS idx_symbols_market 
        ON symbols(market_code)
    ''')
    
    conn.commit()
    logger.info("数据库表创建完成")


def init_markets(conn: sqlite3.Connection):
    """初始化市场数据"""
    cursor = conn.cursor()
    
    cursor.execute("SELECT COUNT(*) FROM markets")
    count = cursor.fetchone()[0]
    
    if count == 0:
        cursor.executemany(
            "INSERT INTO markets (code, name, sort_order) VALUES (?, ?, ?)",
            [
                ("XSHG", "上海证券交易所", 1),
                ("XSHE", "深圳证券交易所", 2),
            ]
        )
        conn.commit()
        logger.info("市场数据初始化完成")


def import_stock_data(csv_path: str, db_path: str, batch_size: int = 5000):
    """
    导入股票数据
    
    Args:
        csv_path: CSV文件路径
        db_path: SQLite数据库路径
        batch_size: 批量插入大小
    """
    logger.info(f"开始导入数据: {csv_path}")
    logger.info(f"目标数据库: {db_path}")
    
    start_time = time.time()
    
    conn = sqlite3.connect(db_path)
    create_tables(conn)
    init_markets(conn)
    
    logger.info("正在读取CSV文件...")
    df = pd.read_csv(csv_path)
    total_rows = len(df)
    logger.info(f"CSV数据总行数: {total_rows}")
    
    df.columns = df.columns.str.lower().str.strip()
    
    if 'code' not in df.columns:
        logger.error("CSV文件缺少 'code' 列")
        return False
    
    df_valid = df[df['open'].notna() & df['close'].notna()].copy()
    valid_rows = len(df_valid)
    logger.info(f"有效数据行数: {valid_rows} (过滤了 {total_rows - valid_rows} 行空数据)")
    
    unique_symbols = df_valid['code'].unique()
    logger.info(f"股票数量: {len(unique_symbols)}")
    
    existing_symbols = set()
    cursor = conn.cursor()
    cursor.execute("SELECT symbol FROM symbols")
    for row in cursor.fetchall():
        existing_symbols.add(row[0])
    
    new_symbols = [s for s in unique_symbols if s not in existing_symbols]
    
    if new_symbols:
        logger.info(f"新增 {len(new_symbols)} 只股票到 symbols 表")
        
        symbol_data = []
        for code in new_symbols:
            if '.XSHG' in code:
                market_code = "XSHG"
            elif '.XSHE' in code:
                market_code = "XSHE"
            else:
                market_code = "XSHG"
            
            symbol_data.append((code, "", market_code))
        
        cursor.executemany(
            "INSERT OR IGNORE INTO symbols (symbol, name, market_code) VALUES (?, ?, ?)",
            symbol_data
        )
        conn.commit()
    
    cursor.execute("SELECT symbol, market_code FROM symbols")
    symbol_market_map = {row[0]: row[1] for row in cursor.fetchall()}
    
    logger.info("开始导入K线数据...")
    
    inserted_count = 0
    skipped_count = 0
    
    records = []
    for idx, row in df_valid.iterrows():
        code = row['code']
        market_code = symbol_market_map.get(code, "XSHG")
        
        trade_date = row['date']
        if isinstance(trade_date, str):
            try:
                trade_date = datetime.strptime(trade_date, '%Y-%m-%d')
            except:
                try:
                    trade_date = datetime.strptime(trade_date, '%Y/%m/%d')
                except:
                    trade_date = datetime.now()
        elif not isinstance(trade_date, datetime):
            trade_date = datetime.now()
        
        trade_date_str = trade_date.strftime('%Y-%m-%d %H:%M:%S')
        
        records.append((
            code,
            market_code,
            'day',
            trade_date_str,
            float(row['open']) if pd.notna(row['open']) else 0,
            float(row['close']) if pd.notna(row['close']) else 0,
            float(row['high']) if pd.notna(row['high']) else 0,
            float(row['low']) if pd.notna(row['low']) else 0,
            float(row['volume']) if pd.notna(row['volume']) else 0,
            0,
            None,
            None,
            None,
        ))
        
        if len(records) >= batch_size:
            try:
                cursor.executemany('''
                    INSERT OR REPLACE INTO kline_data 
                    (symbol, market_code, period, trade_date, open, close, high, low, volume, amount, turnover_rate, pe, pb)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ''', records)
                conn.commit()
                inserted_count += len(records)
                progress = inserted_count / valid_rows * 100
                elapsed = time.time() - start_time
                speed = inserted_count / elapsed if elapsed > 0 else 0
                logger.info(f"进度: {inserted_count}/{valid_rows} ({progress:.1f}%) - 速度: {speed:.0f} 条/秒")
            except Exception as e:
                logger.error(f"插入数据时出错: {e}")
                skipped_count += len(records)
            records = []
    
    if records:
        try:
            cursor.executemany('''
                INSERT OR REPLACE INTO kline_data 
                (symbol, market_code, period, trade_date, open, close, high, low, volume, amount, turnover_rate, pe, pb)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ''', records)
            conn.commit()
            inserted_count += len(records)
        except Exception as e:
            logger.error(f"插入最后一批数据时出错: {e}")
            skipped_count += len(records)
    
    conn.close()
    
    elapsed = time.time() - start_time
    logger.info("=" * 50)
    logger.info(f"导入完成! 总耗时: {elapsed:.1f} 秒")
    logger.info(f"总记录数: {valid_rows}")
    logger.info(f"成功导入: {inserted_count}")
    logger.info(f"跳过/错误: {skipped_count}")
    logger.info("=" * 50)
    
    return True


def verify_data(db_path: str):
    """验证导入的数据"""
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    logger.info("\n数据验证:")
    
    cursor.execute("SELECT COUNT(*) FROM markets")
    market_count = cursor.fetchone()[0]
    logger.info(f"  市场数量: {market_count}")
    
    cursor.execute("SELECT COUNT(*) FROM symbols")
    symbol_count = cursor.fetchone()[0]
    logger.info(f"  股票数量: {symbol_count}")
    
    cursor.execute("SELECT COUNT(*) FROM kline_data")
    kline_count = cursor.fetchone()[0]
    logger.info(f"  K线数据条数: {kline_count}")
    
    cursor.execute("SELECT symbol, COUNT(*) as cnt FROM kline_data GROUP BY symbol ORDER BY cnt DESC LIMIT 5")
    top_stocks = cursor.fetchall()
    logger.info("  数据量前5的股票:")
    for symbol, cnt in top_stocks:
        logger.info(f"    {symbol}: {cnt} 条")
    
    cursor.execute("SELECT MIN(trade_date), MAX(trade_date) FROM kline_data")
    date_range = cursor.fetchone()
    logger.info(f"  数据日期范围: {date_range[0]} ~ {date_range[1]}")
    
    conn.close()


def main():
    """主函数"""
    print("=" * 60)
    print("上证股票历史基础数据导入工具 - CSV版本")
    print("=" * 60)
    
    if not CSV_FILE.exists():
        logger.error(f"CSV文件不存在: {CSV_FILE}")
        return
    
    if not DB_FILE.parent.exists():
        DB_FILE.parent.mkdir(parents=True, exist_ok=True)
        logger.info(f"创建目录: {DB_FILE.parent}")
    
    success = import_stock_data(str(CSV_FILE), str(DB_FILE), batch_size=5000)
    
    if success:
        verify_data(str(DB_FILE))
    
    print("\n" + "=" * 60)
    print(f"数据库文件位置: {DB_FILE}")
    print("=" * 60)


if __name__ == "__main__":
    main()