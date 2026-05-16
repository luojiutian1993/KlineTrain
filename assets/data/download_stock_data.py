#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
股票全量历史数据下载工具 - Excel导出版
使用 yfinance 获取美股数据（更稳定）
支持日线、周线、月线数据获取并导出为Excel
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
        for market in ['us_stock', 'cn_stock']:
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
    
    def _export_to_excel(self, df: pd.DataFrame, filename: str):
        """导出数据到Excel"""
        if df.empty:
            logger.warning(f"{filename} 数据为空，跳过导出")
            return
        
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
                        '最新涨跌幅(%)': stock_df['pct_change'].iloc[-1] if not stock_df.empty else None,
                    })
                
                # 写入汇总sheet
                summary_df = pd.DataFrame(summary_data)
                summary_df.to_excel(writer, sheet_name='汇总', index=False)
            
            logger.info(f"导出Excel: {excel_path}，共 {len(df['symbol'].unique())} 只股票")
            
        except Exception as e:
            logger.error(f"导出Excel失败 {filename}: {e}")
    
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
            {'symbol': 'MELI', 'name': 'MercadoLibre Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'SE', 'name': 'Sea Limited', 'exchange': 'NYSE'},
            {'symbol': 'DASH', 'name': 'DoorDash Inc.', 'exchange': 'NYSE'},
            {'symbol': 'HOOD', 'name': 'Robinhood Markets', 'exchange': 'NASDAQ'},
            {'symbol': 'SOFI', 'name': 'SoFi Technologies', 'exchange': 'NASDAQ'},
            {'symbol': 'RIVN', 'name': 'Rivian Automotive', 'exchange': 'NASDAQ'},
            {'symbol': 'LCID', 'name': 'Lucid Group', 'exchange': 'NASDAQ'},
            {'symbol': 'F', 'name': 'Ford Motor', 'exchange': 'NYSE'},
            {'symbol': 'GM', 'name': 'General Motors', 'exchange': 'NYSE'},
            {'symbol': 'TM', 'name': 'Toyota Motor', 'exchange': 'NYSE'},
            {'symbol': 'HMC', 'name': 'Honda Motor', 'exchange': 'NYSE'},
            {'symbol': 'TMUS', 'name': 'T-Mobile US', 'exchange': 'NASDAQ'},
            {'symbol': 'VZ', 'name': 'Verizon Communications', 'exchange': 'NYSE'},
            {'symbol': 'T', 'name': 'AT&T Inc.', 'exchange': 'NYSE'},
            {'symbol': 'CMCSA', 'name': 'Comcast Corporation', 'exchange': 'NASDAQ'},
            {'symbol': 'CHTR', 'name': 'Charter Communications', 'exchange': 'NASDAQ'},
            {'symbol': 'SIRI', 'name': 'Sirius XM Holdings', 'exchange': 'NASDAQ'},
            {'symbol': 'SIRI', 'name': 'Sirius XM Holdings', 'exchange': 'NASDAQ'},
            {'symbol': 'LULU', 'name': 'Lululemon Athletica', 'exchange': 'NASDAQ'},
            {'symbol': 'ULTA', 'name': 'Ulta Beauty', 'exchange': 'NASDAQ'},
            {'symbol': 'COST', 'name': 'Costco Wholesale', 'exchange': 'NASDAQ'},
            {'symbol': 'TGT', 'name': 'Target Corporation', 'exchange': 'NYSE'},
            {'symbol': 'MCD', 'name': "McDonald's Corporation", 'exchange': 'NYSE'},
            {'symbol': 'SBUX', 'name': 'Starbucks Corporation', 'exchange': 'NASDAQ'},
            {'symbol': 'YUM', 'name': 'Yum! Brands', 'exchange': 'NYSE'},
            {'symbol': 'DPZ', 'name': "Domino's Pizza", 'exchange': 'NYSE'},
            {'symbol': 'CMG', 'name': 'Chipotle Mexican Grill', 'exchange': 'NYSE'},
            {'symbol': 'DRI', 'name': 'Darden Restaurants', 'exchange': 'NYSE'},
            {'symbol': 'MAR', 'name': 'Marriott International', 'exchange': 'NASDAQ'},
            {'symbol': 'HLT', 'name': 'Hilton Worldwide', 'exchange': 'NYSE'},
            {'symbol': 'CCL', 'name': 'Carnival Corporation', 'exchange': 'NYSE'},
            {'symbol': 'RCL', 'name': 'Royal Caribbean Cruises', 'exchange': 'NYSE'},
            {'symbol': 'NCLH', 'name': 'Norwegian Cruise Line', 'exchange': 'NYSE'},
            {'symbol': 'DAL', 'name': 'Delta Air Lines', 'exchange': 'NYSE'},
            {'symbol': 'UAL', 'name': 'United Airlines', 'exchange': 'NASDAQ'},
            {'symbol': 'AAL', 'name': 'American Airlines', 'exchange': 'NASDAQ'},
            {'symbol': 'LUV', 'name': 'Southwest Airlines', 'exchange': 'NYSE'},
            {'symbol': 'ALK', 'name': 'Alaska Air Group', 'exchange': 'NYSE'},
            {'symbol': 'JBLU', 'name': 'JetBlue Airways', 'exchange': 'NASDAQ'},
            {'symbol': 'SPGI', 'name': 'S&P Global', 'exchange': 'NYSE'},
            {'symbol': 'MCO', 'name': "Moody's Corporation", 'exchange': 'NYSE'},
            {'symbol': 'ICE', 'name': 'Intercontinental Exchange', 'exchange': 'NYSE'},
            {'symbol': 'NDAQ', 'name': 'Nasdaq Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'CME', 'name': 'CME Group', 'exchange': 'NASDAQ'},
            {'symbol': 'GS', 'name': 'Goldman Sachs', 'exchange': 'NYSE'},
            {'symbol': 'MS', 'name': 'Morgan Stanley', 'exchange': 'NYSE'},
            {'symbol': 'SCHW', 'name': 'Charles Schwab', 'exchange': 'NYSE'},
            {'symbol': 'BLK', 'name': 'BlackRock Inc.', 'exchange': 'NYSE'},
            {'symbol': 'AXP', 'name': 'American Express', 'exchange': 'NYSE'},
            {'symbol': 'COF', 'name': 'Capital One Financial', 'exchange': 'NYSE'},
            {'symbol': 'DFS', 'name': 'Discover Financial', 'exchange': 'NYSE'},
            {'symbol': 'SYF', 'name': 'Synchrony Financial', 'exchange': 'NYSE'},
            {'symbol': 'ALLY', 'name': 'Ally Financial', 'exchange': 'NYSE'},
            {'symbol': 'USB', 'name': 'U.S. Bancorp', 'exchange': 'NYSE'},
            {'symbol': 'PNC', 'name': 'PNC Financial Services', 'exchange': 'NYSE'},
            {'symbol': 'TFC', 'name': 'Truist Financial', 'exchange': 'NYSE'},
            {'symbol': 'RF', 'name': 'Regions Financial', 'exchange': 'NYSE'},
            {'symbol': 'KEY', 'name': 'KeyCorp', 'exchange': 'NYSE'},
            {'symbol': 'CFG', 'name': 'Citizens Financial', 'exchange': 'NYSE'},
            {'symbol': 'FITB', 'name': 'Fifth Third Bancorp', 'exchange': 'NASDAQ'},
            {'symbol': 'HBAN', 'name': 'Huntington Bancshares', 'exchange': 'NASDAQ'},
            {'symbol': 'C', 'name': 'Citigroup Inc.', 'exchange': 'NYSE'},
            {'symbol': 'WFC', 'name': 'Wells Fargo', 'exchange': 'NYSE'},
            {'symbol': 'BRK-B', 'name': 'Berkshire Hathaway', 'exchange': 'NYSE'},
            {'symbol': 'CB', 'name': 'Chubb Limited', 'exchange': 'NYSE'},
            {'symbol': 'PGR', 'name': 'Progressive Corporation', 'exchange': 'NYSE'},
            {'symbol': 'TRV', 'name': 'Travelers Companies', 'exchange': 'NYSE'},
            {'symbol': 'AIG', 'name': 'American International Group', 'exchange': 'NYSE'},
            {'symbol': 'MET', 'name': 'MetLife Inc.', 'exchange': 'NYSE'},
            {'symbol': 'PRU', 'name': 'Prudential Financial', 'exchange': 'NYSE'},
            {'symbol': 'AFL', 'name': 'Aflac Inc.', 'exchange': 'NYSE'},
            {'symbol': 'ALL', 'name': 'Allstate Corporation', 'exchange': 'NYSE'},
            {'symbol': 'CNC', 'name': 'Centene Corporation', 'exchange': 'NYSE'},
            {'symbol': 'CI', 'name': 'Cigna Corporation', 'exchange': 'NYSE'},
            {'symbol': 'HUM', 'name': 'Humana Inc.', 'exchange': 'NYSE'},
            {'symbol': 'CVS', 'name': 'CVS Health Corporation', 'exchange': 'NYSE'},
            {'symbol': 'WBA', 'name': 'Walgreens Boots Alliance', 'exchange': 'NASDAQ'},
            {'symbol': 'MRK', 'name': 'Merck & Co.', 'exchange': 'NYSE'},
            {'symbol': 'LLY', 'name': 'Eli Lilly and Company', 'exchange': 'NYSE'},
            {'symbol': 'ABBV', 'name': 'AbbVie Inc.', 'exchange': 'NYSE'},
            {'symbol': 'BMY', 'name': 'Bristol Myers Squibb', 'exchange': 'NYSE'},
            {'symbol': 'AMGN', 'name': 'Amgen Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'GILD', 'name': 'Gilead Sciences', 'exchange': 'NASDAQ'},
            {'symbol': 'VRTX', 'name': 'Vertex Pharmaceuticals', 'exchange': 'NASDAQ'},
            {'symbol': 'REGN', 'name': 'Regeneron Pharmaceuticals', 'exchange': 'NASDAQ'},
            {'symbol': 'BIIB', 'name': 'Biogen Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'ISRG', 'name': 'Intuitive Surgical', 'exchange': 'NASDAQ'},
            {'symbol': 'ZTS', 'name': 'Zoetis Inc.', 'exchange': 'NYSE'},
            {'symbol': 'CVX', 'name': 'Chevron Corporation', 'exchange': 'NYSE'},
            {'symbol': 'COP', 'name': 'ConocoPhillips', 'exchange': 'NYSE'},
            {'symbol': 'EOG', 'name': 'EOG Resources', 'exchange': 'NYSE'},
            {'symbol': 'MPC', 'name': 'Marathon Petroleum', 'exchange': 'NYSE'},
            {'symbol': 'VLO', 'name': 'Valero Energy', 'exchange': 'NYSE'},
            {'symbol': 'PSX', 'name': 'Phillips 66', 'exchange': 'NYSE'},
            {'symbol': 'OXY', 'name': 'Occidental Petroleum', 'exchange': 'NYSE'},
            {'symbol': 'DVN', 'name': 'Devon Energy', 'exchange': 'NYSE'},
            {'symbol': 'FANG', 'name': 'Diamondback Energy', 'exchange': 'NASDAQ'},
            {'symbol': 'MRO', 'name': 'Marathon Oil', 'exchange': 'NYSE'},
            {'symbol': 'HAL', 'name': 'Halliburton', 'exchange': 'NYSE'},
            {'symbol': 'SLB', 'name': 'Schlumberger', 'exchange': 'NYSE'},
            {'symbol': 'BKR', 'name': 'Baker Hughes', 'exchange': 'NASDAQ'},
            {'symbol': 'NOV', 'name': 'NOV Inc.', 'exchange': 'NYSE'},
            {'symbol': 'GE', 'name': 'General Electric', 'exchange': 'NYSE'},
            {'symbol': 'HON', 'name': 'Honeywell International', 'exchange': 'NASDAQ'},
            {'symbol': 'MMM', 'name': '3M Company', 'exchange': 'NYSE'},
            {'symbol': 'CAT', 'name': 'Caterpillar Inc.', 'exchange': 'NYSE'},
            {'symbol': 'DE', 'name': 'Deere & Company', 'exchange': 'NYSE'},
            {'symbol': 'ITW', 'name': 'Illinois Tool Works', 'exchange': 'NYSE'},
            {'symbol': 'EMR', 'name': 'Emerson Electric', 'exchange': 'NYSE'},
            {'symbol': 'ETN', 'name': 'Eaton Corporation', 'exchange': 'NYSE'},
            {'symbol': 'ROK', 'name': 'Rockwell Automation', 'exchange': 'NYSE'},
            {'symbol': 'PH', 'name': 'Parker-Hannifin', 'exchange': 'NYSE'},
            {'symbol': 'SWK', 'name': 'Stanley Black & Decker', 'exchange': 'NYSE'},
            {'symbol': 'CMI', 'name': 'Cummins Inc.', 'exchange': 'NYSE'},
            {'symbol': 'PCAR', 'name': 'PACCAR Inc', 'exchange': 'NASDAQ'},
            {'symbol': 'CSX', 'name': 'CSX Corporation', 'exchange': 'NASDAQ'},
            {'symbol': 'UNP', 'name': 'Union Pacific', 'exchange': 'NYSE'},
            {'symbol': 'NSC', 'name': 'Norfolk Southern', 'exchange': 'NYSE'},
            {'symbol': 'UPS', 'name': 'United Parcel Service', 'exchange': 'NYSE'},
            {'symbol': 'FDX', 'name': 'FedEx Corporation', 'exchange': 'NYSE'},
            {'symbol': 'LMT', 'name': 'Lockheed Martin', 'exchange': 'NYSE'},
            {'symbol': 'NOC', 'name': 'Northrop Grumman', 'exchange': 'NYSE'},
            {'symbol': 'RTX', 'name': 'RTX Corporation', 'exchange': 'NYSE'},
            {'symbol': 'GD', 'name': 'General Dynamics', 'exchange': 'NYSE'},
            {'symbol': 'BA', 'name': 'Boeing Company', 'exchange': 'NYSE'},
            {'symbol': 'TDG', 'name': 'TransDigm Group', 'exchange': 'NYSE'},
            {'symbol': 'AXON', 'name': 'Axon Enterprise', 'exchange': 'NASDAQ'},
            {'symbol': 'MSCI', 'name': 'MSCI Inc.', 'exchange': 'NYSE'},
            {'symbol': 'FICO', 'name': 'Fair Isaac Corporation', 'exchange': 'NYSE'},
            {'symbol': 'ADP', 'name': 'Automatic Data Processing', 'exchange': 'NASDAQ'},
            {'symbol': 'PAYX', 'name': 'Paychex Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'INTU', 'name': 'Intuit Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'WDAY', 'name': 'Workday Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'TEAM', 'name': 'Atlassian Corporation', 'exchange': 'NASDAQ'},
            {'symbol': 'ASAN', 'name': 'Asana Inc.', 'exchange': 'NYSE'},
            {'symbol': 'MDB', 'name': 'MongoDB Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'ESTC', 'name': 'Elastic N.V.', 'exchange': 'NYSE'},
            {'symbol': 'SPLK', 'name': 'Splunk Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'NOW', 'name': 'ServiceNow Inc.', 'exchange': 'NYSE'},
            {'symbol': 'VEEV', 'name': 'Veeva Systems', 'exchange': 'NYSE'},
            {'symbol': 'DOCU', 'name': 'DocuSign Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'ZI', 'name': 'ZoomInfo Technologies', 'exchange': 'NASDAQ'},
            {'symbol': 'HUBS', 'name': 'HubSpot Inc.', 'exchange': 'NYSE'},
            {'symbol': 'TWOU', 'name': '2U Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'CHWY', 'name': 'Chewy Inc.', 'exchange': 'NYSE'},
            {'symbol': 'ETSY', 'name': 'Etsy Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'FTCH', 'name': 'Farfetch Limited', 'exchange': 'NYSE'},
            {'symbol': 'REAL', 'name': 'The RealReal', 'exchange': 'NASDAQ'},
            {'symbol': 'CVNA', 'name': 'Carvana Co.', 'exchange': 'NYSE'},
            {'symbol': 'VRM', 'name': 'Vroom Inc.', 'exchange': 'NASDAQ'},
            {'symbol': 'LAZR', 'name': 'Luminar Technologies', 'exchange': 'NASDAQ'},
            {'symbol': 'QS', 'name': 'QuantumScape', 'exchange': 'NYSE'},
        ]
        
        df = pd.DataFrame(popular_stocks)
        df['market'] = 'us_stock'
        df['industry'] = ''
        
        self._save_stock_list(df)
        
        logger.info(f"获取到 {len(df)} 只美股")
        return df
    
    def fetch_stock_kline(self, symbol: str, name: str, period: str = "daily",
                         start_date: str = None, end_date: str = None) -> pd.DataFrame:
        """获取股票K线数据"""
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
            logger.error(f"获取 {symbol} 数据失败: {e}")
            return pd.DataFrame()
    
    def download_all(self, periods: list = None):
        """下载所有股票数据"""
        if periods is None:
            periods = ['daily', 'weekly', 'monthly']
        
        stocks_df = self.get_us_stock_list()
        if stocks_df.empty:
            logger.error("获取股票列表失败")
            return
        
        total = len(stocks_df)
        logger.info(f"开始下载数据，共 {total} 只股票，周期: {periods}")
        
        all_data = {period: [] for period in periods}
        
        for idx, (_, stock) in enumerate(stocks_df.iterrows(), 1):
            symbol = stock['symbol']
            name = stock['name']
            
            logger.info(f"[{idx}/{total}] 下载 {name} ({symbol})")
            
            for period in periods:
                df = self.fetch_stock_kline(symbol, name, period)
                if not df.empty:
                    all_data[period].append(df)
                    self._save_kline_to_db(df, 'us_stock')
                
                time.sleep(0.3)
        
        # 导出Excel
        for period in periods:
            if all_data[period]:
                combined_df = pd.concat(all_data[period], ignore_index=True)
                self._export_to_excel(combined_df, f"us_stock_{period}")
        
        logger.info("数据下载完成")
    
    def export_stock_list_excel(self):
        """导出股票列表到Excel"""
        conn = sqlite3.connect(self.db_path)
        
        df = pd.read_sql_query("SELECT * FROM stock_list WHERE market='us_stock'", conn)
        if not df.empty:
            df.to_excel(self.output_dir / "us_stock_list.xlsx", index=False)
            logger.info(f"导出股票列表: {len(df)} 只")
        
        conn.close()
    
    def get_stats(self) -> dict:
        """获取数据统计信息"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        stats = {}
        
        # 股票数量
        cursor.execute("SELECT COUNT(*) FROM stock_list WHERE market='us_stock'")
        stats['stock_count'] = cursor.fetchone()[0]
        
        # K线数据条数
        cursor.execute("SELECT COUNT(*) FROM kline_us_stock")
        stats['kline_count'] = cursor.fetchone()[0]
        
        # 各周期数据条数
        for period in ['daily', 'weekly', 'monthly']:
            cursor.execute("SELECT COUNT(*) FROM kline_us_stock WHERE period=?", (period,))
            stats[f'{period}_count'] = cursor.fetchone()[0]
        
        conn.close()
        return stats


def main():
    """主函数"""
    print("=" * 70)
    print("股票全量历史数据下载工具")
    print("=" * 70)
    print()
    
    downloader = StockDataDownloader()
    
    print("【1】开始下载美股全量数据...")
    print("    包含约300只热门美股的日线、周线、月线数据")
    print()
    
    downloader.download_all(periods=['daily', 'weekly', 'monthly'])
    
    print()
    print("【2】导出股票列表...")
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
        size_mb = f.stat().st_size / (1024 * 1024)
        print(f"  - {f.name} ({size_mb:.2f} MB)")


if __name__ == "__main__":
    main()
