#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
股票历史数据获取工具
支持A股、美股、港股等市场的日线、周线、月线数据获取
数据来源：AKShare（A股）、yfinance（美股/港股）
"""

import os
import json
import sqlite3
import time
from datetime import datetime, timedelta
from pathlib import Path
from typing import List, Dict, Optional, Tuple
import logging

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class StockDataFetcher:
    """股票数据获取器"""
    
    def __init__(self, data_dir: str = None):
        """
        初始化数据获取器
        
        Args:
            data_dir: 数据存储目录，默认为当前目录下的 stock_data
        """
        if data_dir is None:
            self.data_dir = Path(__file__).parent / "stock_data"
        else:
            self.data_dir = Path(data_dir)
        
        # 创建目录结构
        self._create_directory_structure()
        
        # 初始化数据库
        self._init_database()
        
        # 导入数据获取库
        self._import_libs()
    
    def _create_directory_structure(self):
        """创建数据存储目录结构"""
        directories = [
            self.data_dir / "a_share" / "daily",
            self.data_dir / "a_share" / "weekly",
            self.data_dir / "a_share" / "monthly",
            self.data_dir / "us_stock" / "daily",
            self.data_dir / "us_stock" / "weekly",
            self.data_dir / "us_stock" / "monthly",
            self.data_dir / "hk_stock" / "daily",
            self.data_dir / "hk_stock" / "weekly",
            self.data_dir / "hk_stock" / "monthly",
            self.data_dir / "metadata",
        ]
        
        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)
            logger.info(f"创建目录: {directory}")
    
    def _init_database(self):
        """初始化SQLite数据库"""
        self.db_path = self.data_dir / "stock_data.db"
        
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
                list_date TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(symbol, market)
            )
        ''')
        
        # 创建数据更新记录表
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS data_update_log (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                symbol TEXT NOT NULL,
                market TEXT NOT NULL,
                period TEXT NOT NULL,
                last_update_date TEXT,
                record_count INTEGER,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(symbol, market, period)
            )
        ''')
        
        # 创建K线数据表（按市场分表）
        for market in ['a_share', 'us_stock', 'hk_stock']:
            cursor.execute(f'''
                CREATE TABLE IF NOT EXISTS kline_{market} (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    symbol TEXT NOT NULL,
                    date TEXT NOT NULL,
                    period TEXT NOT NULL,
                    open REAL,
                    high REAL,
                    low REAL,
                    close REAL,
                    volume INTEGER,
                    amount REAL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    UNIQUE(symbol, date, period)
                )
            ''')
            
            # 创建索引
            cursor.execute(f'''
                CREATE INDEX IF NOT EXISTS idx_{market}_symbol_date 
                ON kline_{market}(symbol, date)
            ''')
            cursor.execute(f'''
                CREATE INDEX IF NOT EXISTS idx_{market}_symbol_period 
                ON kline_{market}(symbol, period)
            ''')
        
        conn.commit()
        conn.close()
        logger.info(f"数据库初始化完成: {self.db_path}")
    
    def _import_libs(self):
        """导入第三方库"""
        try:
            import akshare as ak
            self.ak = ak
            logger.info("AKShare 导入成功")
        except ImportError:
            logger.warning("AKShare 未安装，A股数据获取功能将不可用")
            self.ak = None
        
        try:
            import yfinance as yf
            self.yf = yf
            logger.info("yfinance 导入成功")
        except ImportError:
            logger.warning("yfinance 未安装，美股/港股数据获取功能将不可用")
            self.yf = None
        
        try:
            import pandas as pd
            self.pd = pd
            logger.info("pandas 导入成功")
        except ImportError:
            logger.error("pandas 未安装，这是必需依赖")
            raise
    
    # ==================== A股数据获取 ====================
    
    def fetch_a_share_stock_list(self) -> List[Dict]:
        """获取A股股票列表"""
        if self.ak is None:
            logger.error("AKShare 未安装，无法获取A股数据")
            return []
        
        logger.info("正在获取A股股票列表...")
        
        try:
            # 获取上海和深圳的股票列表
            df_sh = self.ak.stock_sh_a_spot_em()
            df_sz = self.ak.stock_sz_a_spot_em()
            
            stocks = []
            
            # 处理上海股票
            for _, row in df_sh.iterrows():
                stocks.append({
                    'symbol': row['代码'],
                    'name': row['名称'],
                    'market': 'a_share',
                    'exchange': 'SH',
                    'industry': row.get('所属行业', ''),
                })
            
            # 处理深圳股票
            for _, row in df_sz.iterrows():
                stocks.append({
                    'symbol': row['代码'],
                    'name': row['名称'],
                    'market': 'a_share',
                    'exchange': 'SZ',
                    'industry': row.get('所属行业', ''),
                })
            
            logger.info(f"获取到 {len(stocks)} 只A股股票")
            return stocks
            
        except Exception as e:
            logger.error(f"获取A股股票列表失败: {e}")
            return []
    
    def fetch_a_share_kline(self, symbol: str, period: str = "daily", 
                           start_date: str = None, end_date: str = None) -> Optional:
        """
        获取A股K线数据
        
        Args:
            symbol: 股票代码，如 "000001"
            period: 周期，可选 daily/weekly/monthly
            start_date: 开始日期，格式 YYYYMMDD
            end_date: 结束日期，格式 YYYYMMDD
        
        Returns:
            DataFrame 或 None
        """
        if self.ak is None:
            logger.error("AKShare 未安装")
            return None
        
        # 设置默认日期
        if end_date is None:
            end_date = datetime.now().strftime('%Y%m%d')
        if start_date is None:
            # 默认获取10年数据
            start_date = (datetime.now() - timedelta(days=365*10)).strftime('%Y%m%d')
        
        try:
            logger.info(f"获取A股 {symbol} {period} 数据 ({start_date} ~ {end_date})")
            
            df = self.ak.stock_zh_a_hist(
                symbol=symbol,
                period=period,
                start_date=start_date,
                end_date=end_date,
                adjust="qfq"  # 前复权
            )
            
            if df is not None and not df.empty:
                # 标准化列名
                df = df.rename(columns={
                    '日期': 'date',
                    '开盘': 'open',
                    '收盘': 'close',
                    '最高': 'high',
                    '最低': 'low',
                    '成交量': 'volume',
                    '成交额': 'amount',
                    '振幅': 'amplitude',
                    '涨跌幅': 'pct_change',
                    '涨跌额': 'change',
                    '换手率': 'turnover'
                })
                df['symbol'] = symbol
                df['period'] = period
                
                logger.info(f"获取到 {len(df)} 条数据")
                return df
            
            return None
            
        except Exception as e:
            logger.error(f"获取A股 {symbol} 数据失败: {e}")
            return None
    
    # ==================== 美股数据获取 ====================
    
    def fetch_us_stock_list(self, limit: int = 1000) -> List[Dict]:
        """
        获取美股股票列表
        
        Args:
            limit: 限制数量，默认前1000只
        """
        if self.yf is None:
            logger.error("yfinance 未安装")
            return []
        
        logger.info("正在获取美股股票列表...")
        
        # 使用预设的热门美股列表
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
        ]
        
        stocks = []
        for stock in popular_stocks[:limit]:
            stocks.append({
                'symbol': stock['symbol'],
                'name': stock['name'],
                'market': 'us_stock',
                'exchange': stock['exchange'],
                'industry': ''
            })
        
        logger.info(f"获取到 {len(stocks)} 只美股")
        return stocks
    
    def fetch_us_stock_kline(self, symbol: str, period: str = "daily",
                             start_date: str = None, end_date: str = None) -> Optional:
        """
        获取美股K线数据
        
        Args:
            symbol: 股票代码，如 "AAPL"
            period: 周期，可选 daily/weekly/monthly
            start_date: 开始日期，格式 YYYY-MM-DD
            end_date: 结束日期，格式 YYYY-MM-DD
        """
        if self.yf is None:
            logger.error("yfinance 未安装")
            return None
        
        # 转换周期格式
        interval_map = {
            'daily': '1d',
            'weekly': '1wk',
            'monthly': '1mo'
        }
        interval = interval_map.get(period, '1d')
        
        # 设置默认日期
        if end_date is None:
            end_date = datetime.now().strftime('%Y-%m-%d')
        if start_date is None:
            start_date = (datetime.now() - timedelta(days=365*10)).strftime('%Y-%m-%d')
        
        try:
            logger.info(f"获取美股 {symbol} {period} 数据 ({start_date} ~ {end_date})")
            
            ticker = self.yf.Ticker(symbol)
            df = ticker.history(start=start_date, end=end_date, interval=interval)
            
            if df is not None and not df.empty:
                # 重置索引，将日期变为列
                df = df.reset_index()
                
                # 标准化列名
                df = df.rename(columns={
                    'Date': 'date',
                    'Open': 'open',
                    'High': 'high',
                    'Low': 'low',
                    'Close': 'close',
                    'Volume': 'volume'
                })
                
                # 格式化日期
                df['date'] = df['date'].dt.strftime('%Y-%m-%d')
                df['symbol'] = symbol
                df['period'] = period
                df['amount'] = 0  # yfinance不提供成交额
                
                logger.info(f"获取到 {len(df)} 条数据")
                return df
            
            return None
            
        except Exception as e:
            logger.error(f"获取美股 {symbol} 数据失败: {e}")
            return None
    
    # ==================== 数据存储 ====================
    
    def save_stock_list(self, stocks: List[Dict]):
        """保存股票列表到数据库"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        for stock in stocks:
            cursor.execute('''
                INSERT OR REPLACE INTO stock_list 
                (symbol, name, market, exchange, industry, updated_at)
                VALUES (?, ?, ?, ?, ?, ?)
            ''', (
                stock['symbol'],
                stock['name'],
                stock['market'],
                stock['exchange'],
                stock.get('industry', ''),
                datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            ))
        
        conn.commit()
        conn.close()
        logger.info(f"保存了 {len(stocks)} 只股票信息")
    
    def save_kline_data(self, df, market: str):
        """保存K线数据到数据库"""
        if df is None or df.empty:
            return
        
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        table_name = f"kline_{market}"
        
        for _, row in df.iterrows():
            try:
                cursor.execute(f'''
                    INSERT OR REPLACE INTO {table_name}
                    (symbol, date, period, open, high, low, close, volume, amount)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                ''', (
                    row['symbol'],
                    row['date'],
                    row['period'],
                    float(row['open']) if pd.notna(row['open']) else None,
                    float(row['high']) if pd.notna(row['high']) else None,
                    float(row['low']) if pd.notna(row['low']) else None,
                    float(row['close']) if pd.notna(row['close']) else None,
                    int(row['volume']) if pd.notna(row['volume']) else 0,
                    float(row.get('amount', 0)) if pd.notna(row.get('amount')) else 0
                ))
            except Exception as e:
                logger.warning(f"保存数据失败: {e}")
                continue
        
        conn.commit()
        conn.close()
        logger.info(f"保存了 {len(df)} 条K线数据到 {table_name}")
    
    def update_log(self, symbol: str, market: str, period: str, 
                   last_date: str, count: int):
        """更新数据获取日志"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            INSERT OR REPLACE INTO data_update_log
            (symbol, market, period, last_update_date, record_count, updated_at)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (symbol, market, period, last_date, count, 
              datetime.now().strftime('%Y-%m-%d %H:%M:%S')))
        
        conn.commit()
        conn.close()
    
    # ==================== 批量获取 ====================
    
    def batch_fetch_a_share(self, max_stocks: int = None, 
                           periods: List[str] = None):
        """
        批量获取A股历史数据
        
        Args:
            max_stocks: 最大获取股票数量，None表示全部
            periods: 周期列表，默认 ['daily', 'weekly', 'monthly']
        """
        if periods is None:
            periods = ['daily', 'weekly', 'monthly']
        
        # 获取股票列表
        stocks = self.fetch_a_share_stock_list()
        if max_stocks:
            stocks = stocks[:max_stocks]
        
        # 保存股票列表
        self.save_stock_list(stocks)
        
        # 获取每只股票的数据
        for i, stock in enumerate(stocks):
            symbol = stock['symbol']
            logger.info(f"[{i+1}/{len(stocks)}] 正在获取 {stock['name']} ({symbol})")
            
            for period in periods:
                # 检查是否已更新过
                conn = sqlite3.connect(self.db_path)
                cursor = conn.cursor()
                cursor.execute('''
                    SELECT last_update_date FROM data_update_log
                    WHERE symbol = ? AND market = ? AND period = ?
                ''', (symbol, 'a_share', period))
                result = cursor.fetchone()
                conn.close()
                
                if result:
                    # 已更新过，获取增量数据
                    start_date = (datetime.strptime(result[0], '%Y-%m-%d') + 
                                 timedelta(days=1)).strftime('%Y%m%d')
                    logger.info(f"  增量更新 {period} 数据，从 {start_date} 开始")
                else:
                    start_date = None
                    logger.info(f"  全量获取 {period} 数据")
                
                df = self.fetch_a_share_kline(symbol, period, start_date)
                
                if df is not None and not df.empty:
                    self.save_kline_data(df, 'a_share')
                    last_date = df['date'].max()
                    self.update_log(symbol, 'a_share', period, last_date, len(df))
                
                # 添加延迟，避免请求过快
                time.sleep(0.5)
    
    def batch_fetch_us_stock(self, max_stocks: int = 100,
                            periods: List[str] = None):
        """
        批量获取美股历史数据
        
        Args:
            max_stocks: 最大获取股票数量
            periods: 周期列表
        """
        if periods is None:
            periods = ['daily', 'weekly', 'monthly']
        
        # 获取股票列表
        stocks = self.fetch_us_stock_list(max_stocks)
        
        # 保存股票列表
        self.save_stock_list(stocks)
        
        # 获取每只股票的数据
        for i, stock in enumerate(stocks):
            symbol = stock['symbol']
            logger.info(f"[{i+1}/{len(stocks)}] 正在获取 {stock['name']} ({symbol})")
            
            for period in periods:
                df = self.fetch_us_stock_kline(symbol, period)
                
                if df is not None and not df.empty:
                    self.save_kline_data(df, 'us_stock')
                    last_date = df['date'].max()
                    self.update_log(symbol, 'us_stock', period, last_date, len(df))
                
                time.sleep(0.5)
    
    # ==================== 数据查询 ====================
    
    def get_kline_data(self, symbol: str, market: str, period: str = 'daily',
                       start_date: str = None, end_date: str = None):
        """
        查询K线数据
        
        Args:
            symbol: 股票代码
            market: 市场类型 (a_share/us_stock/hk_stock)
            period: 周期
            start_date: 开始日期
            end_date: 结束日期
        
        Returns:
            DataFrame
        """
        conn = sqlite3.connect(self.db_path)
        
        table_name = f"kline_{market}"
        
        query = f'''
            SELECT * FROM {table_name}
            WHERE symbol = ? AND period = ?
        '''
        params = [symbol, period]
        
        if start_date:
            query += " AND date >= ?"
            params.append(start_date)
        if end_date:
            query += " AND date <= ?"
            params.append(end_date)
        
        query += " ORDER BY date ASC"
        
        df = self.pd.read_sql_query(query, conn, params=params)
        conn.close()
        
        return df
    
    def get_stock_list(self, market: str = None) -> List[Dict]:
        """获取股票列表"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        if market:
            cursor.execute('''
                SELECT symbol, name, market, exchange, industry 
                FROM stock_list WHERE market = ?
            ''', (market,))
        else:
            cursor.execute('''
                SELECT symbol, name, market, exchange, industry FROM stock_list
            ''')
        
        rows = cursor.fetchall()
        conn.close()
        
        return [
            {
                'symbol': row[0],
                'name': row[1],
                'market': row[2],
                'exchange': row[3],
                'industry': row[4]
            }
            for row in rows
        ]
    
    def get_data_stats(self) -> Dict:
        """获取数据统计信息"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        stats = {}
        
        # 各市场股票数量
        for market in ['a_share', 'us_stock', 'hk_stock']:
            cursor.execute('''
                SELECT COUNT(*) FROM stock_list WHERE market = ?
            ''', (market,))
            stats[f'{market}_count'] = cursor.fetchone()[0]
            
            # K线数据条数
            table_name = f"kline_{market}"
            cursor.execute(f'SELECT COUNT(*) FROM {table_name}')
            stats[f'{market}_kline_count'] = cursor.fetchone()[0]
        
        conn.close()
        return stats


def main():
    """主函数"""
    # 初始化数据获取器
    fetcher = StockDataFetcher()
    
    print("=" * 60)
    print("股票历史数据获取工具")
    print("=" * 60)
    print()
    
    # 获取A股数据（示例：前50只）
    print("【1】获取A股数据...")
    fetcher.batch_fetch_a_share(max_stocks=50)
    
    print()
    
    # 获取美股数据（示例：前30只）
    print("【2】获取美股数据...")
    fetcher.batch_fetch_us_stock(max_stocks=30)
    
    print()
    print("=" * 60)
    print("数据统计:")
    stats = fetcher.get_data_stats()
    for key, value in stats.items():
        print(f"  {key}: {value}")
    print("=" * 60)


if __name__ == "__main__":
    main()
