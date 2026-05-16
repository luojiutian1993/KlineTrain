#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
简化版股票数据获取工具 - 使用requests直接获取数据
无需复杂依赖，直接导出Excel
"""

import json
import time
import sqlite3
from datetime import datetime, timedelta
from pathlib import Path
from urllib import request
from urllib.error import URLError
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

try:
    import pandas as pd
except ImportError:
    import subprocess
    import sys
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pandas", "--break-system-packages"])
    import pandas as pd

try:
    import openpyxl
except ImportError:
    import subprocess
    import sys
    subprocess.check_call([sys.executable, "-m", "pip", "install", "openpyxl", "--break-system-packages"])


class SimpleStockFetcher:
    """简化版股票数据获取器"""
    
    def __init__(self, output_dir: str = None):
        if output_dir is None:
            self.output_dir = Path(__file__).parent / "stock_data"
        else:
            self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        self.db_path = self.output_dir / "stock_data.db"
        self._init_db()
        logger.info(f"数据保存到: {self.output_dir}")
    
    def _init_db(self):
        """初始化数据库"""
        conn = sqlite3.connect(self.db_path)
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
        
        conn.commit()
        conn.close()
    
    def _save_to_db(self, df: pd.DataFrame, period: str):
        """保存到数据库"""
        if df.empty:
            return
        
        conn = sqlite3.connect(self.db_path)
        
        for _, row in df.iterrows():
            try:
                conn.execute('''
                    INSERT OR REPLACE INTO kline_data
                    (symbol, name, date, period, open, high, low, close, volume, pct_change)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ''', (
                    row.get('symbol', ''), row.get('name', ''), row.get('date', ''), period,
                    float(row.get('open', 0)) if pd.notna(row.get('open')) else 0,
                    float(row.get('high', 0)) if pd.notna(row.get('high')) else 0,
                    float(row.get('low', 0)) if pd.notna(row.get('low')) else 0,
                    float(row.get('close', 0)) if pd.notna(row.get('close')) else 0,
                    int(row.get('volume', 0)) if pd.notna(row.get('volume')) else 0,
                    float(row.get('pct_change', 0)) if pd.notna(row.get('pct_change')) else 0
                ))
            except Exception as e:
                logger.warning(f"保存失败: {e}")
        
        conn.commit()
        conn.close()
    
    def _export_to_excel(self, all_data: dict, filename_prefix: str):
        """导出到Excel，每个股票一个sheet"""
        for period, df_list in all_data.items():
            if not df_list:
                continue
            
            combined = pd.concat(df_list, ignore_index=True)
            if combined.empty:
                continue
            
            excel_path = self.output_dir / f"{filename_prefix}_{period}.xlsx"
            
            with pd.ExcelWriter(excel_path, engine='openpyxl') as writer:
                # 汇总sheet
                summary = []
                for symbol in combined['symbol'].unique():
                    stock_df = combined[combined['symbol'] == symbol]
                    summary.append({
                        '股票代码': symbol,
                        '股票名称': stock_df['name'].iloc[0] if 'name' in stock_df.columns else '',
                        '数据条数': len(stock_df),
                        '开始日期': stock_df['date'].min(),
                        '结束日期': stock_df['date'].max(),
                    })
                
                pd.DataFrame(summary).to_excel(writer, sheet_name='汇总', index=False)
                
                # 每个股票一个sheet
                for symbol in combined['symbol'].unique():
                    stock_df = combined[combined['symbol'] == symbol].copy()
                    sheet_name = str(symbol)[:31]
                    stock_df.to_excel(writer, sheet_name=sheet_name, index=False)
            
            logger.info(f"导出: {excel_path} ({len(combined['symbol'].unique())} 只股票)")
    
    def fetch_us_stocks(self):
        """获取美股数据 - 使用预设列表"""
        stocks = [
            ('AAPL', 'Apple Inc.'), ('MSFT', 'Microsoft'), ('GOOGL', 'Alphabet'),
            ('AMZN', 'Amazon'), ('TSLA', 'Tesla'), ('META', 'Meta'),
            ('NVDA', 'NVIDIA'), ('JPM', 'JPMorgan'), ('JNJ', 'Johnson & Johnson'),
            ('V', 'Visa'), ('WMT', 'Walmart'), ('PG', 'Procter & Gamble'),
            ('MA', 'Mastercard'), ('UNH', 'UnitedHealth'), ('HD', 'Home Depot'),
            ('BAC', 'Bank of America'), ('XOM', 'Exxon Mobil'), ('PFE', 'Pfizer'),
            ('KO', 'Coca-Cola'), ('DIS', 'Walt Disney'), ('NFLX', 'Netflix'),
            ('ADBE', 'Adobe'), ('CRM', 'Salesforce'), ('NKE', 'Nike'),
            ('INTC', 'Intel'), ('AMD', 'AMD'), ('PYPL', 'PayPal'),
            ('UBER', 'Uber'), ('ABNB', 'Airbnb'), ('SQ', 'Block'),
            ('BABA', 'Alibaba'), ('JD', 'JD.com'), ('PDD', 'PDD Holdings'),
            ('NIO', 'NIO'), ('XPEV', 'XPeng'), ('LI', 'Li Auto'),
            ('BIDU', 'Baidu'), ('NTES', 'NetEase'), ('ZM', 'Zoom'),
            ('SHOP', 'Shopify'), ('SPOT', 'Spotify'), ('SNOW', 'Snowflake'),
            ('PLTR', 'Palantir'), ('COIN', 'Coinbase'), ('ROKU', 'Roku'),
            ('CRWD', 'CrowdStrike'), ('NET', 'Cloudflare'), ('MELI', 'MercadoLibre'),
            ('SE', 'Sea Limited'), ('DASH', 'DoorDash'), ('HOOD', 'Robinhood'),
            ('RIVN', 'Rivian'), ('LCID', 'Lucid'), ('F', 'Ford'),
            ('GM', 'General Motors'), ('TM', 'Toyota'), ('COST', 'Costco'),
            ('MCD', "McDonald's"), ('SBUX', 'Starbucks'), ('LULU', 'Lululemon'),
            ('GS', 'Goldman Sachs'), ('MS', 'Morgan Stanley'), ('BLK', 'BlackRock'),
            ('C', 'Citigroup'), ('WFC', 'Wells Fargo'), ('BRK-B', 'Berkshire Hathaway'),
            ('LLY', 'Eli Lilly'), ('ABBV', 'AbbVie'), ('MRK', 'Merck'),
            ('BMY', 'Bristol Myers'), ('AMGN', 'Amgen'), ('GILD', 'Gilead'),
            ('CVX', 'Chevron'), ('COP', 'ConocoPhillips'), ('OXY', 'Occidental'),
            ('GE', 'General Electric'), ('HON', 'Honeywell'), ('CAT', 'Caterpillar'),
            ('BA', 'Boeing'), ('LMT', 'Lockheed Martin'), ('RTX', 'RTX Corporation'),
            ('UPS', 'UPS'), ('FDX', 'FedEx'), ('CSX', 'CSX'),
        ]
        
        logger.info(f"准备下载 {len(stocks)} 只美股数据")
        
        all_data = {'daily': [], 'weekly': [], 'monthly': []}
        
        for idx, (symbol, name) in enumerate(stocks, 1):
            logger.info(f"[{idx}/{len(stocks)}] 获取 {name} ({symbol})")
            
            for period, interval in [('daily', '1d'), ('weekly', '1wk'), ('monthly', '1mo')]:
                df = self._fetch_yahoo_data(symbol, name, interval)
                if not df.empty:
                    df['period'] = period
                    all_data[period].append(df)
                    self._save_to_db(df, period)
                time.sleep(0.2)
        
        # 导出Excel
        self._export_to_excel(all_data, "us_stock")
        
        # 导出股票列表
        stock_df = pd.DataFrame(stocks, columns=['symbol', 'name'])
        stock_df['market'] = 'us_stock'
        stock_df.to_excel(self.output_dir / "us_stock_list.xlsx", index=False)
        
        return all_data
    
    def _fetch_yahoo_data(self, symbol: str, name: str, interval: str = "1d") -> pd.DataFrame:
        """从Yahoo获取数据"""
        try:
            # 构建Yahoo Finance API URL
            period1 = int((datetime.now() - timedelta(days=365*20)).timestamp())
            period2 = int(datetime.now().timestamp())
            
            url = f"https://query1.finance.yahoo.com/v8/finance/chart/{symbol}?period1={period1}&period2={period2}&interval={interval}&events=history"
            
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            }
            
            req = request.Request(url, headers=headers)
            with request.urlopen(req, timeout=30) as response:
                data = json.loads(response.read().decode())
            
            result = data.get('chart', {}).get('result', [{}])[0]
            timestamps = result.get('timestamp', [])
            quote = result.get('indicators', {}).get('quote', [{}])[0]
            
            if not timestamps:
                return pd.DataFrame()
            
            df = pd.DataFrame({
                'date': [datetime.fromtimestamp(t).strftime('%Y-%m-%d') for t in timestamps],
                'open': quote.get('open', []),
                'high': quote.get('high', []),
                'low': quote.get('low', []),
                'close': quote.get('close', []),
                'volume': quote.get('volume', []),
            })
            
            df['symbol'] = symbol
            df['name'] = name
            df['pct_change'] = df['close'].pct_change() * 100
            
            return df.dropna()
            
        except Exception as e:
            logger.error(f"获取 {symbol} 失败: {e}")
            return pd.DataFrame()
    
    def get_stats(self):
        """获取统计信息"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute("SELECT COUNT(DISTINCT symbol) FROM kline_data")
        stock_count = cursor.fetchone()[0]
        
        cursor.execute("SELECT COUNT(*) FROM kline_data")
        total_records = cursor.fetchone()[0]
        
        stats = {'股票数量': stock_count, '总记录数': total_records}
        
        for period in ['daily', 'weekly', 'monthly']:
            cursor.execute("SELECT COUNT(*) FROM kline_data WHERE period=?", (period,))
            stats[f'{period}_records'] = cursor.fetchone()[0]
        
        conn.close()
        return stats


def main():
    print("=" * 60)
    print("股票历史数据下载工具")
    print("=" * 60)
    print()
    
    fetcher = SimpleStockFetcher()
    
    print("开始下载美股数据（约100只热门股票）...")
    print("包含日线、周线、月线数据")
    print()
    
    fetcher.fetch_us_stocks()
    
    print()
    print("=" * 60)
    print("数据统计:")
    stats = fetcher.get_stats()
    for k, v in stats.items():
        print(f"  {k}: {v}")
    print("=" * 60)
    print()
    print(f"Excel文件已保存到: {fetcher.output_dir}")
    print()
    print("生成的文件:")
    for f in sorted(fetcher.output_dir.glob("*.xlsx")):
        size = f.stat().st_size / 1024
        print(f"  - {f.name} ({size:.1f} KB)")


if __name__ == "__main__":
    main()
