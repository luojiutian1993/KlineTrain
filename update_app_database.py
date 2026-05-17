import sqlite3
import os
from datetime import datetime, timedelta
import random

def update_application_database():
    db_paths = [
        os.path.expanduser('~/Library/Containers/com.example.klineTrainer/Data/Library/Application Support/kline_trainer/kline_trainer.db'),
        os.path.expanduser('~/Library/Application Support/kline_trainer/kline_trainer.db'),
        '/Users/lin/Library/Application Support/kline_trainer/kline_trainer.db',
    ]

    db_path = None
    for path in db_paths:
        if os.path.exists(path):
            db_path = path
            print(f"找到应用数据库: {db_path}")
            break

    if not db_path:
        print("未找到应用数据库，尝试创建目录...")
        db_dir = os.path.dirname(db_paths[0])
        os.makedirs(db_dir, exist_ok=True)
        db_path = db_paths[0]
        print(f"将创建新数据库: {db_path}")

    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()

        cursor.execute('''
            CREATE TABLE IF NOT EXISTS symbols (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                symbol TEXT NOT NULL UNIQUE,
                name TEXT,
                market_code TEXT,
                sector TEXT,
                enabled INTEGER DEFAULT 1,
                last_price REAL,
                change REAL,
                created_at TEXT,
                updated_at TEXT
            )
        ''')

        cursor.execute('DELETE FROM symbols')

        stock_data = [
            ('600519', '贵州茅台', 'SH', None, 1650.0, 2.5),
            ('600036', '招商银行', 'SH', None, 32.5, 1.2),
            ('601318', '中国平安', 'SH', None, 45.8, -0.5),
            ('600000', '浦发银行', 'SH', None, 8.5, 0.3),
            ('000001', '平安银行', 'SZ', None, 12.3, 0.8),
            ('000002', '万科A', 'SZ', None, 8.9, -1.2),
            ('300750', '宁德时代', 'SZ', None, 185.5, 3.5),
            ('002594', '比亚迪', 'SZ', None, 265.3, 2.1),
            ('300059', '东方财富', 'SZ', None, 15.8, 1.5),
            ('688981', '中芯国际', 'SH', None, 45.2, 4.2),
        ]

        for stock in stock_data:
            cursor.execute('''
                INSERT INTO symbols (symbol, name, market_code, sector, enabled, last_price, change, created_at, updated_at)
                VALUES (?, ?, ?, ?, 1, ?, ?, datetime('now'), datetime('now'))
            ''', stock)

        conn.commit()

        cursor.execute('SELECT COUNT(*) FROM symbols')
        count = cursor.fetchone()[0]
        print(f"\n数据库更新成功！共插入 {count} 支股票")

        conn.close()
        return True

    except Exception as e:
        print(f"更新数据库失败: {e}")
        return False

if __name__ == '__main__':
    update_application_database()
