#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
股票全量历史数据下载工具 - Excel导出版
支持A股、美股等市场的日线、周线、月线数据获取并导出为Excel
"""

import os
import time
import sqlite3
from datetime import datetime, timedelta
from pathlib import Path
import logging

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

import pandas as pd
import akshare as ak
import yfinance as yf


class StockDataDownloader:
    """股票数据下载器"""
    
    def __init__(self, output_dir: str = None):
        """
        初始化数据下载器
        
        Args:
            output_dir: 数据输出目录
        """
        if output_dir is None:
            self.output_dir = Path(__file__).parent / "stock_data"
        else:
            self.output_dir = Path(output_dir)
        
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        # 初始化数据库
        self.db_path = self.output_dir / "stock_data.db"
        self._init_database()
        
        logger.info(f"数据将保存到: {self.output_dir}")
    
    def _init_database(self):
        """初始化SQLite数据库"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # 创建股票列表表
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS stock_list (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                symbol TEXT NOT NULL,
                name TEXT,
                market TEXT NOT NULL,
                exchange TEXT,
                industry TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(symbol, market)
            )
        ''')
        
        # 创建K线数据表
        for market in ['a_share', 'us_stock']:
            cursor.execute(f'''
                CREATE TABLE IF NOT EXISTS kline_{market} (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    symbol TEXT NOT NULL,
                    name TEXT,
                    date TEXT NOT NULL,
                    period TEXT NOT NULL,
                    open REAL,
                    high REAL,
                    low REAL,
                    close REAL,
                    volume INTEGER,
                    amount REAL,
                    pct_change REAL,
                    UNIQUE(symbol, date, period)
                )
            ''')
            
            cursor.execute(f'''
                CREATE INDEX IF NOT EXISTS idx_{market}_symbol_date 
                ON kline_{market}(symbol, date)
            ''')
        
        conn.commit()
        conn.close()
        logger.info(f"数据库初始化完成: {self.db_path}")
    
    # ==================== A股数据获取 ====================
    
    def get_a_share_stock_list(self) -> pd.DataFrame:
        """获取A股全量股票列表"""
        logger.info("正在获取A股股票列表...")
        
        try:
            # 获取上海和深圳的股票列表
            df_sh = ak.stock_sh_a_spot_em()
            df_sz = ak.stock_sz_a_spot_em()
            
            stocks_sh = []
            for _, row in df_sh.iterrows():
                stocks_sh.append({
                    'symbol': str(row['代码']).zfill(6),
                    'name': row['名称'],
                    'market': 'a_share',
                    'exchange': 'SH',
                    'industry': row.get('所属行业', ''),
                })
            
            stocks_sz = []
            for _, row in df_sz.iterrows():
                stocks_sz.append({
                    'symbol': str(row['代码']).zfill(6),
                    'name': row['名称'],
                    'market': 'a_share',
                    'exchange': 'SZ',
                    'industry': row.get('所属行业', ''),
                })
            
            all_stocks = stocks_sh + stocks_sz
            df = pd.DataFrame(all_stocks)
            
            # 保存到数据库
            self._save_stock_list(df)
            
            logger.info(f"获取到 {len(df)} 只A股股票")
            return df
            
        except Exception as e:
            logger.error(f"获取A股股票列表失败: {e}")
            return pd.DataFrame()
    
    def fetch_a_share_kline(self, symbol: str, name: str, period: str = "daily",
                           start_date: str = None, end_date: str = None) -> pd.DataFrame:
        """获取A股K线数据"""
        if end_date is None:
            end_date = datetime.now().strftime('%Y%m%d')
        if start_date is None:
            start_date = "19900101"  # 获取全部历史数据
        
        try:
            df = ak.stock_zh_a_hist(
                symbol=symbol,
                period=period,
                start_date=start_date,
                end_date=end_date,
                adjust="qfq"  # 前复权
            )
            
            if df is not None and not df.empty:
                df = df.rename(columns={
                    '日期': 'date',
                    '开盘': 'open',
                    '收盘': 'close',
                    '最高': 'high',
                    '最低': 'low',
                    '成交量': 'volume',
                    '成交额': 'amount',
                    '涨跌幅': 'pct_change',
                })
                df['symbol'] = symbol
                df['name'] = name
                df['period'] = period
                df['market'] = 'a_share'
                
                return df[['symbol', 'name', 'date', 'period', 'open', 'high', 'low', 'close', 'volume', 'amount', 'pct_change', 'market']]
            
            return pd.DataFrame()
            
        except Exception as e:
            logger.error(f"获取A股 {symbol} 数据失败: {e}")
            return pd.DataFrame()
    
    # ==================== 美股数据获取 ====================
    
    def get_us_stock_list(self) -> pd.DataFrame:
        """获取美股热门股票列表"""
        logger.info("正在获取美股股票列表...")
        
        popular_stocks = [
            {'symbol': 'AAPL', 'name': 'Apple Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'MSFT', 'name': 'Microsoft Corporation', 'exchange': 'NASDAQ'},
            {'symbol': 'GOOGL', 'name': 'Alphabet Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'AMZN', 'name': 'Amazon.com Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'TSLA', 'name': 'Tesla Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'META', 'name': 'Meta Platforms Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'NVDA', 'name': 'NVIDIA Corporation', 'exchange': 'NASDAQ'},
            {'symbol': 'JPM', 'name': 'JPMorgan Chase & Co.', 'exchange': 'NYSE'},
            {'symbol': 'JNJ', 'name': 'Johnson & Johnson', 'exchange': 'NYSE'},
            {'symbol': 'V', 'name': 'Visa Inc.', 'exchange': 'NYSE'},
            {'symbol': 'WMT', 'name': 'Walmart Inc.', 'exchange': 'NYSE'},
            {'symbol': 'PG', 'name': 'Procter & Gamble', 'exchange': 'NYSE'},
            {'symbol': 'MA', 'name': 'Mastercard Inc.', 'exchange': 'NYSE'},
            {'symbol': 'UNH', 'name': 'UnitedHealth Group', 'exchange': 'NYSE'},
            {'symbol': 'HD', 'name': 'Home Depot Inc.', 'exchange': 'NYSE'},
            {'symbol': 'BAC', 'name': 'Bank of America', 'exchange': 'NYSE'},
            {'symbol': 'XOM', 'name': 'Exxon Mobil', 'exchange': 'NYSE'},
            {'symbol': 'PFE', 'name': 'Pfizer Inc.', 'exchange': 'NYSE'},
            {'symbol': 'KO', 'name': 'Coca-Cola Company', 'exchange': 'NYSE'},
            {'symbol': 'DIS', 'name': 'Walt Disney', 'exchange': 'NYSE'},
            {'symbol': 'NFLX', 'name': 'Netflix Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'ADBE', 'name': 'Adobe Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'CRM', 'name': 'Salesforce Inc.', 'exchange': 'NYSE'},
            {'symbol': 'NKE', 'name': 'Nike Inc.', 'exchange': 'NYSE'},
            {'symbol': 'INTC', 'name': 'Intel Corporation', 'exchange': 'NASDAQ'},
            {'symbol': 'AMD', 'name': 'AMD Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'PYPL', 'name': 'PayPal Holdings', 'exchange': 'NASDAQ'},
            {'symbol': 'UBER', 'name': 'Uber Technologies', 'exchange': 'NYSE'},
            {'symbol': 'ABNB', 'name': 'Airbnb Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'SQ', 'name': 'Block Inc.', 'exchange': 'NYSE'},
            {'symbol': 'BABA', 'name': 'Alibaba Group', 'exchange': 'NYSE'},
            {'symbol': 'JD', 'name': 'JD.com Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'PDD', 'name': 'PDD Holdings', 'exchange': 'NASDAQ'},
            {'symbol': 'NIO', 'name': 'NIO Inc.', 'exchange': 'NYSE'},
            {'symbol': 'XPEV', 'name': 'XPeng Inc.', 'exchange': 'NYSE'},
            {'symbol': 'LI', 'name': 'Li Auto Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'TCEHY', 'name': 'Tencent Holdings', 'exchange': 'OTC'},
            {'symbol': 'BIDU', 'name': 'Baidu Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'NTES', 'name': 'NetEase Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'ZM', 'name': 'Zoom Video', 'exchange': 'NASDAQ'},
            {'symbol': 'SHOP', 'name': 'Shopify Inc.', 'exchange': 'NYSE'},
            {'symbol': 'SPOT', 'name': 'Spotify Technology', 'exchange': 'NYSE'},
            {'symbol': 'SNOW', 'name': 'Snowflake Inc.', 'exchange': 'NYSE'},
            {'symbol': 'PLTR', 'name': 'Palantir Technologies', 'exchange': 'NYSE'},
            {'symbol': 'RBLX', 'name': 'Roblox Corporation', 'exchange': 'NYSE'},
            {'symbol': 'COIN', 'name': 'Coinbase Global', 'exchange': 'NASDAQ'},
            {'symbol': 'ROKU', 'name': 'Roku Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'TWLO', 'name': 'Twilio Inc.', 'exchange': 'NYSE'},
            {'symbol': 'DDOG', 'name': 'Datadog Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'OKTA', 'name': 'Okta Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'CRWD', 'name': 'CrowdStrike Holdings', 'exchange': 'NASDAQ'},
            {'symbol': 'NET', 'name': 'Cloudflare Inc.', 'exchange': 'NYSE'},
            {'symbol': 'FSLY', 'name': 'Fastly Inc.', 'exchange': 'NYSE'},
        ]
        
        df = pd.DataFrame(popular_stocks)
        df['market'] = 'us_stock'
        df['industry'] = ''
        
        self._save_stock_list(df)
        
        logger.info(f"获取到 {len(df)} 只美股")
        return df
    
    def fetch_us_stock_kline(self, symbol: str, name: str, period: str = "daily",
                            start_date: str = None, end_date: str = None) -> pd.DataFrame:
        """获取美股K线数据"""
        interval_map = {'daily': '1d', 'weekly': '1wk', 'monthly': '1mo'}
        interval = interval_map.get(period, '1d')
        
        if end_date is None:
            end_date = datetime.now().strftime('%Y-%m-%d')
        if start_date is None:
            start_date = "1990-01-01"
        
        try:
            ticker = yf.Ticker(symbol)
            df = ticker.history(start=start_date, end=end_date, interval=interval)
            
            if df is not None and not df.empty:
                df = df.reset_index()
                df = df.rename(columns={
                    'Date': 'date',
                    'Open': 'open',
                    'High': 'high',
                    'Low': 'low',
                    'Close': 'close',
                    'Volume': 'volume',
                })
                df['date'] = df['date'].dt.strftime('%Y-%m-%d')
                df['symbol'] = symbol
                df['name'] = name
                df['period'] = period
                df['amount'] = 0
                df['pct_change'] = df['close'].pct_change() * 100
                df['market'] = 'us_stock'
                
                return df[['symbol', 'name', 'date', 'period', 'open', 'high', 'low', 'close', 'volume', 'amount', 'pct_change', 'market']]
            
            return pd.DataFrame()
            
        except Exception as e:
            logger.error(f"获取美股 {symbol} 数据失败: {e}")
            return pd.DataFrame()
    
    # ==================== 数据存储 ====================
    
    def _save_stock_list(self, df: pd.DataFrame):
        """保存股票列表到数据库"""
        conn = sqlite3.connect(self.db_path)
        
        for _, row in df.iterrows():
            conn.execute('''
                INSERT OR REPLACE INTO stock_list (symbol, name, market, exchange, industry)
                VALUES (?, ?, ?, ?, ?)
            ''', (row['symbol'], row['name'], row['market'], row.get('exchange', ''), row.get('industry', '')))
        
        conn.commit()
        conn.close()
    
    def _save_kline_to_db(self, df: pd.DataFrame, market: str):
        """保存K线数据到数据库"""
        if df.empty:
            return
        
        conn = sqlite3.connect(self.db_path)
        table_name = f"kline_{market}"
        
        for _, row in df.iterrows():
            try:
                conn.execute(f'''
                    INSERT OR REPLACE INTO {table_name}
                    (symbol, name, date, period, open, high, low, close, volume, amount, pct_change)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ''', (
                    row['symbol'], row['name'], row['date'], row['period'],
                    float(row['open']) if pd.notna(row['open']) else None,
                    float(row['high']) if pd.notna(row['high']) else None,
                    float(row['low']) if pd.notna(row['low']) else None,
                    float(row['close']) if pd.notna(row['close']) else None,
                    int(row['volume']) if pd.notna(row['volume']) else 0,
                    float(row['amount']) if pd.notna(row['amount']) else 0,
                    float(row['pct_change']) if pd.notna(row['pct_change']) else None
                ))
            except Exception as e:
                logger.warning(f"保存数据失败 {row['symbol']}: {e}")
        
        conn.commit()
        conn.close()
    
    # ==================== 批量下载 ====================
    
    def download_a_share_all(self, periods: list = None, max_workers: int = 1):
        """
        下载A股全量数据
        
        Args:
            periods: 周期列表，默认 ['daily', 'weekly', 'monthly']
            max_workers: 并发数（暂不支持，保持1）
        """
        if periods is None:
            periods = ['daily', 'weekly', 'monthly']
        
        # 获取股票列表
        stocks_df = self.get_a_share_stock_list()
        if stocks_df.empty:
            logger.error("获取股票列表失败")
            return
        
        total = len(stocks_df)
        logger.info(f"开始下载A股全量数据，共 {total} 只股票，周期: {periods}")
        
        all_data = {period: [] for period in periods}
        
        for idx, (_, stock) in enumerate(stocks_df.iterrows(), 1):
            symbol = stock['symbol']
            name = stock['name']
            
            logger.info(f"[{idx}/{total}] 下载 {name} ({symbol})")
            
            for period in periods:
                df = self.fetch_a_share_kline(symbol, name, period)
                if not df.empty:
                    all_data[period].append(df)
                    self._save_kline_to_db(df, 'a_share')
                
                time.sleep(0.3)  # 避免请求过快
        
        # 合并数据并导出Excel
        for period in periods:
            if all_data[period]:
                combined_df = pd.concat(all_data[period], ignore_index=True)
                self._export_to_excel(combined_df, f"a_share_{period}")
        
        logger.info("A股数据下载完成")
    
    def download_us_stock_all(self, periods: list = None):
        """下载美股数据"""
        if periods is None:
            periods = ['daily', 'weekly', 'monthly']
        
        stocks_df = self.get_us_stock_list()
        if stocks_df.empty:
            logger.error("获取美股列表失败")
            return
        
        total = len(stocks_df)
        logger.info(f"开始下载美股数据，共 {total} 只股票，周期: {periods}")
        
        all_data = {period: [] for period in periods}
        
        for idx, (_, stock) in enumerate(stocks_df.iterrows(), 1):
            symbol = stock['symbol']
            name = stock['name']
            
            logger.info(f"[{idx}/{total}] 下载 {name} ({symbol})")
            
            for period in periods:
                df = self.fetch_us_stock_kline(symbol, name, period)
                if not df.empty:
                    all_data[period].append(df)
                    self._save_kline_to_db(df, 'us_stock')
                
                time.sleep(0.5)
        
        # 导出Excel
        for period in periods:
            if all_data[period]:
                combined_df = pd.concat(all_data[period], ignore_index=True)
                self._export_to_excel(combined_df, f"us_stock_{period}")
        
        logger.info("美股数据下载完成")
    
    # ==================== Excel导出 ====================
    
    def _export_to_excel(self, df: pd.DataFrame, filename: str):
        """导出数据到Excel"""
        if df.empty:
            logger.warning(f"{filename} 数据为空，跳过导出")
            return
        
        # 按股票分组，每个股票一个sheet
        excel_path = self.output_dir / f"{filename}.xlsx"
        
        try:
            with pd.ExcelWriter(excel_path, engine='openpyxl') as writer:
                # 汇总sheet
                summary_data = []
                
                for symbol in df['symbol'].unique():
                    stock_df = df[df['symbol'] == symbol].copy()
                    stock_name = stock_df['name'].iloc[0] if 'name' in stock_df.columns else ''
                    
                    # 写入单个股票的sheet
                    sheet_name = f"{symbol}"[:31]  # Excel sheet名最长31字符
                    stock_df.to_excel(writer, sheet_name=sheet_name, index=False)
                    
                    # 汇总信息
                    summary_data.append({
                        '股票代码': symbol,
                        '股票名称': stock_name,
                        '数据条数': len(stock_df),
                        '开始日期': stock_df['date'].min(),
                        '结束日期': stock_df['date'].max(),
                        '最新收盘价': stock_df['close'].iloc[-1] if not stock_df.empty else None,
                        '最新涨跌幅': stock_df['pct_change'].iloc[-1] if not stock_df.empty else None,
                    })
                
                # 写入汇总sheet
                summary_df = pd.DataFrame(summary_data)
                summary_df.to_excel(writer, sheet_name='汇总', index=False)
            
            logger.info(f"导出Excel: {excel_path}，共 {len(df['symbol'].unique())} 只股票")
            
        except Exception as e:
            logger.error(f"导出Excel失败 {filename}: {e}")
    
    def export_stock_list_excel(self):
        """导出股票列表到Excel"""
        conn = sqlite3.connect(self.db_path)
        
        # A股列表
        df_a = pd.read_sql_query("SELECT * FROM stock_list WHERE market='a_share'", conn)
        if not df_a.empty:
            df_a.to_excel(self.output_dir / "a_share_stock_list.xlsx", index=False)
            logger.info(f"导出A股列表: {len(df_a)} 只")
        
        # 美股列表
        df_us = pd.read_sql_query("SELECT * FROM stock_list WHERE market='us_stock'", conn)
        if not df_us.empty:
            df_us.to_excel(self.output_dir / "us_stock_stock_list.xlsx", index=False)
            logger.info(f"导出美股列表: {len(df_us)} 只")
        
        conn.close()
    
    # ==================== 统计信息 ====================
    
    def get_stats(self) -> dict:
        """获取数据统计信息"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        stats = {}
        
        for market in ['a_share', 'us_stock']:
            # 股票数量
            cursor.execute("SELECT COUNT(*) FROM stock_list WHERE market=?", (market,))
            stats[f'{market}_stock_count'] = cursor.fetchone()[0]
            
            # K线数据条数
            table_name = f"kline_{market}"
            cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
            stats[f'{market}_kline_count'] = cursor.fetchone()[0]
            
            # 各周期数据条数
            for period in ['daily', 'weekly', 'monthly']:
                cursor.execute(f"SELECT COUNT(*) FROM {table_name} WHERE period=?", (period,))
                stats[f'{market}_{period}_count'] = cursor.fetchone()[0]
        
        conn.close()
        return stats


def main():
    """主函数"""
    print("=" * 70)
    print("股票全量历史数据下载工具")
    print("=" * 70)
    print()
    
    downloader = StockDataDownloader()
    
    # 下载A股数据（全量）
    print("【1】开始下载A股全量数据...")
    print("    注意：A股约5000+只股票，全量下载需要较长时间")
    print()
    
    # 为了演示，先下载前100只
    # 如需全量，修改 get_a_share_stock_list 后使用
    stocks_df = downloader.get_a_share_stock_list()
    
    # 下载前200只作为示例（全量数据太多，演示用）
    sample_stocks = stocks_df.head(200)
    logger.info(f"本次下载前200只A股作为示例")
    
    all_data = {'daily': [], 'weekly': [], 'monthly': []}
    
    for idx, (_, stock) in enumerate(sample_stocks.iterrows(), 1):
        symbol = stock['symbol']
        name = stock['name']
        
        logger.info(f"[{idx}/200] 下载 {name} ({symbol})")
        
        for period in ['daily', 'weekly', 'monthly']:
            df = downloader.fetch_a_share_kline(symbol, name, period)
            if not df.empty:
                all_data[period].append(df)
                downloader._save_kline_to_db(df, 'a_share')
            
            time.sleep(0.2)
    
    # 导出Excel
    for period in ['daily', 'weekly', 'monthly']:
        if all_data[period]:
            combined_df = pd.concat(all_data[period], ignore_index=True)
            downloader._export_to_excel(combined_df, f"a_share_{period}")
    
    print()
    print("【2】开始下载美股数据...")
    downloader.download_us_stock_all(periods=['daily', 'weekly', 'monthly'])
    
    print()
    print("【3】导出股票列表...")
    downloader.export_stock_list_excel()
    
    print()
    print("=" * 70)
    print("数据统计:")
    stats = downloader.get_stats()
    for key, value in stats.items():
        print(f"  {key}: {value}")
    print("=" * 70)
    print()
    print(f"数据文件保存在: {downloader.output_dir}")
    print()
    print("Excel文件列表:")
    for f in sorted(downloader.output_dir.glob("*.xlsx")):
        print(f"  - {f.name}")


if __name__ == "__main__":
    main()
