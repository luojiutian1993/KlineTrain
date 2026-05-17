import sqlite3
import os
import csv
from datetime import datetime

def import_stock_data():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    db_path = os.path.join(base_dir, 'assets', 'data', 'stock_data', 'stock_data.db')
    csv_path = os.path.join(base_dir, 'assets', 'data', 'stock_data', '1000_stocks_post_fq_history.csv')

    if not os.path.exists(csv_path):
        print(f"CSV文件不存在: {csv_path}")
        return False

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

    stock_symbols = set()
    kline_count = 0

    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            try:
                symbol = row.get('code', '').strip()
                name = row.get('name', '').strip()
                market = row.get('market', 'US').strip()

                if symbol and symbol not in stock_symbols:
                    cursor.execute(
                        'INSERT OR IGNORE INTO stock_list (symbol, name, market, exchange) VALUES (?, ?, ?, ?)',
                        (symbol, name, market, 'NASDAQ')
                    )
                    stock_symbols.add(symbol)

                date_str = row.get('date', '')
                if date_str:
                    try:
                        date = datetime.strptime(date_str, '%Y-%m-%d').strftime('%Y-%m-%d')
                    except:
                        date = date_str

                    open_price = float(row.get('open', 0) or 0)
                    high_price = float(row.get('high', 0) or 0)
                    low_price = float(row.get('low', 0) or 0)
                    close_price = float(row.get('close', 0) or 0)
                    volume = int(row.get('volume', 0) or 0)
                    pct_change = float(row.get('pct_chg', 0) or 0)

                    cursor.execute('''
                        INSERT OR REPLACE INTO kline_data 
                        (symbol, name, date, period, open, high, low, close, volume, pct_change)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    ''', (symbol, name, date, 'day', open_price, high_price, low_price, close_price, volume, pct_change))
                    kline_count += 1

                if kline_count % 10000 == 0:
                    print(f"已导入 {kline_count} 条K线数据...")

            except Exception as e:
                print(f"导入数据出错: {e}")
                continue

    conn.commit()

    cursor.execute('SELECT COUNT(*) FROM stock_list')
    stock_count = cursor.fetchone()[0]

    print(f"\n数据导入完成！")
    print(f"- 股票列表: {stock_count} 支")
    print(f"- K线数据: {kline_count} 条")

    conn.close()
    return True

if __name__ == '__main__':
    import_stock_data()
