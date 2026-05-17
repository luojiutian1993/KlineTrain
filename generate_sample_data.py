import sqlite3
import os
from datetime import datetime, timedelta
import random

def generate_sample_data():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    db_path = os.path.join(base_dir, 'assets', 'data', 'stock_data', 'stock_data.db')

    if not os.path.exists(db_path):
        print(f"数据库文件不存在: {db_path}")
        return False

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS stock_list (
            symbol TEXT PRIMARY KEY,
            name TEXT,
            market TEXT,
            exchange TEXT
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS kline_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            symbol TEXT,
            name TEXT,
            date TEXT,
            period TEXT,
            open REAL,
            high REAL,
            low REAL,
            close REAL,
            volume INTEGER,
            pct_change REAL,
            UNIQUE(symbol, date, period)
        )
    ''')

    cursor.execute('DELETE FROM stock_list')
    cursor.execute('DELETE FROM kline_data')

    stock_data = [
        ('600519', '贵州茅台', 'SH', 'SSE'),
        ('600036', '招商银行', 'SH', 'SSE'),
        ('601318', '中国平安', 'SH', 'SSE'),
        ('600000', '浦发银行', 'SH', 'SSE'),
        ('000001', '平安银行', 'SZ', 'SZSE'),
        ('000002', '万科A', 'SZ', 'SZSE'),
        ('300750', '宁德时代', 'SZ', 'SZSE'),
        ('002594', '比亚迪', 'SZ', 'SZSE'),
        ('300059', '东方财富', 'SZ', 'SZSE'),
        ('688981', '中芯国际', 'SH', 'SSE'),
    ]

    for stock in stock_data:
        cursor.execute(
            'INSERT INTO stock_list (symbol, name, market, exchange) VALUES (?, ?, ?, ?)',
            stock
        )

    print(f"已插入 {len(stock_data)} 支股票")

    kline_count = 0
    start_date = datetime.now() - timedelta(days=365 * 5)

    for stock in stock_data:
        symbol, name, market, exchange = stock
        base_price = random.uniform(10, 500)
        current_price = base_price

        for i in range(1825):
            date = start_date + timedelta(days=i)

            if date.weekday() >= 5:
                continue

            change_pct = random.uniform(-0.1, 0.1)
            open_price = current_price * (1 + random.uniform(-0.02, 0.02))
            close_price = open_price * (1 + change_pct)
            high_price = max(open_price, close_price) * (1 + random.uniform(0, 0.03))
            low_price = min(open_price, close_price) * (1 - random.uniform(0, 0.03))
            volume = random.randint(1000000, 50000000)

            try:
                cursor.execute('''
                    INSERT OR REPLACE INTO kline_data
                    (symbol, name, date, period, open, high, low, close, volume, pct_change)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ''', (
                    symbol,
                    name,
                    date.strftime('%Y-%m-%d'),
                    'day',
                    round(open_price, 2),
                    round(high_price, 2),
                    round(low_price, 2),
                    round(close_price, 2),
                    volume,
                    round(change_pct * 100, 2)
                ))
                kline_count += 1
                current_price = close_price

            except Exception as e:
                print(f"插入K线数据失败: {e}")
                continue

    conn.commit()

    cursor.execute('SELECT COUNT(*) FROM stock_list')
    stock_count = cursor.fetchone()[0]

    print(f"\n测试数据生成完成！")
    print(f"- 股票列表: {stock_count} 支")
    print(f"- K线数据: {kline_count} 条")
    print(f"- 时间范围: 最近5年")

    conn.close()
    return True

if __name__ == '__main__':
    generate_sample_data()
