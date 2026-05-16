#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
生成示例股票数据Excel文件
用于K线训练营演示
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
from pathlib import Path


def generate_stock_data(symbol: str, name: str, start_date: str, end_date: str, 
                        base_price: float, volatility: float = 0.02) -> pd.DataFrame:
    """
    生成模拟股票数据
    
    Args:
        symbol: 股票代码
        name: 股票名称
        start_date: 开始日期 'YYYY-MM-DD'
        end_date: 结束日期 'YYYY-MM-DD'
        base_price: 基础价格
        volatility: 波动率
    """
    dates = pd.date_range(start=start_date, end=end_date, freq='D')
    # 只保留工作日
    dates = dates[dates.dayofweek < 5]
    
    n = len(dates)
    
    # 生成随机价格走势
    returns = np.random.normal(0.0005, volatility, n)  # 轻微上涨趋势
    prices = base_price * np.exp(np.cumsum(returns))
    
    # 生成OHLC数据
    df = pd.DataFrame({
        'date': dates.strftime('%Y-%m-%d'),
        'open': prices * (1 + np.random.normal(0, 0.005, n)),
        'high': prices * (1 + np.abs(np.random.normal(0, 0.01, n))),
        'low': prices * (1 - np.abs(np.random.normal(0, 0.01, n))),
        'close': prices,
        'volume': np.random.randint(1000000, 50000000, n),
    })
    
    # 确保 high >= max(open, close) 且 low <= min(open, close)
    df['high'] = df[['open', 'close', 'high']].max(axis=1)
    df['low'] = df[['open', 'close', 'low']].min(axis=1)
    
    df['symbol'] = symbol
    df['name'] = name
    df['pct_change'] = df['close'].pct_change() * 100
    
    return df.round(2)


def resample_to_weekly(df: pd.DataFrame) -> pd.DataFrame:
    """日线转周线"""
    df['date'] = pd.to_datetime(df['date'])
    df = df.set_index('date')
    
    weekly = df.resample('W').agg({
        'symbol': 'first',
        'name': 'first',
        'open': 'first',
        'high': 'max',
        'low': 'min',
        'close': 'last',
        'volume': 'sum',
    }).dropna()
    
    weekly['pct_change'] = weekly['close'].pct_change() * 100
    weekly = weekly.reset_index()
    weekly['date'] = weekly['date'].dt.strftime('%Y-%m-%d')
    
    return weekly.round(2)


def resample_to_monthly(df: pd.DataFrame) -> pd.DataFrame:
    """日线转月线"""
    df['date'] = pd.to_datetime(df['date'])
    df = df.set_index('date')
    
    monthly = df.resample('ME').agg({
        'symbol': 'first',
        'name': 'first',
        'open': 'first',
        'high': 'max',
        'low': 'min',
        'close': 'last',
        'volume': 'sum',
    }).dropna()
    
    monthly['pct_change'] = monthly['close'].pct_change() * 100
    monthly = monthly.reset_index()
    monthly['date'] = monthly['date'].dt.strftime('%Y-%m-%d')
    
    return monthly.round(2)


def export_to_excel(all_data: dict, filename: str, output_dir: Path):
    """导出到Excel，每个股票一个sheet"""
    excel_path = output_dir / filename
    
    with pd.ExcelWriter(excel_path, engine='openpyxl') as writer:
        # 汇总sheet
        summary = []
        for symbol in all_data['symbol'].unique():
            stock_df = all_data[all_data['symbol'] == symbol]
            summary.append({
                '股票代码': symbol,
                '股票名称': stock_df['name'].iloc[0],
                '数据条数': len(stock_df),
                '开始日期': stock_df['date'].min(),
                '结束日期': stock_df['date'].max(),
                '最新收盘价': stock_df['close'].iloc[-1],
                '最新涨跌幅(%)': stock_df['pct_change'].iloc[-1],
            })
        
        pd.DataFrame(summary).to_excel(writer, sheet_name='汇总', index=False)
        
        # 每个股票一个sheet
        for symbol in all_data['symbol'].unique():
            stock_df = all_data[all_data['symbol'] == symbol].copy()
            sheet_name = str(symbol)[:31]
            stock_df.to_excel(writer, sheet_name=sheet_name, index=False)
    
    print(f"  导出: {filename} ({len(all_data['symbol'].unique())} 只股票, {len(all_data)} 条记录)")


def main():
    output_dir = Path(__file__).parent / "stock_data"
    output_dir.mkdir(exist_ok=True)
    
    print("=" * 60)
    print("生成示例股票数据")
    print("=" * 60)
    print()
    
    # 定义股票列表和参数
    stocks = [
        ('AAPL', 'Apple Inc.', 150, 0.018),
        ('MSFT', 'Microsoft Corporation', 300, 0.016),
        ('GOOGL', 'Alphabet Inc.', 120, 0.020),
        ('AMZN', 'Amazon.com Inc.', 130, 0.022),
        ('TSLA', 'Tesla Inc.', 200, 0.035),
        ('META', 'Meta Platforms Inc.', 300, 0.025),
        ('NVDA', 'NVIDIA Corporation', 400, 0.030),
        ('JPM', 'JPMorgan Chase & Co.', 150, 0.015),
        ('JNJ', 'Johnson & Johnson', 160, 0.012),
        ('V', 'Visa Inc.', 220, 0.014),
        ('WMT', 'Walmart Inc.', 140, 0.013),
        ('PG', 'Procter & Gamble', 145, 0.011),
        ('MA', 'Mastercard Inc.', 380, 0.016),
        ('UNH', 'UnitedHealth Group', 480, 0.015),
        ('HD', 'Home Depot Inc.', 300, 0.017),
        ('BAC', 'Bank of America', 35, 0.020),
        ('XOM', 'Exxon Mobil', 110, 0.018),
        ('PFE', 'Pfizer Inc.', 35, 0.015),
        ('KO', 'Coca-Cola Company', 60, 0.012),
        ('DIS', 'Walt Disney', 90, 0.022),
        ('NFLX', 'Netflix Inc.', 450, 0.028),
        ('ADBE', 'Adobe Inc.', 520, 0.024),
        ('CRM', 'Salesforce Inc.', 220, 0.026),
        ('NKE', 'Nike Inc.', 95, 0.019),
        ('INTC', 'Intel Corporation', 35, 0.025),
        ('AMD', 'AMD Inc.', 140, 0.032),
        ('PYPL', 'PayPal Holdings', 65, 0.028),
        ('UBER', 'Uber Technologies', 45, 0.030),
        ('ABNB', 'Airbnb Inc.', 130, 0.027),
        ('SQ', 'Block Inc.', 75, 0.035),
        ('BABA', 'Alibaba Group', 75, 0.028),
        ('JD', 'JD.com Inc.', 35, 0.026),
        ('PDD', 'PDD Holdings', 120, 0.032),
        ('NIO', 'NIO Inc.', 5, 0.040),
        ('XPEV', 'XPeng Inc.', 10, 0.038),
        ('LI', 'Li Auto Inc.', 25, 0.035),
        ('BIDU', 'Baidu Inc.', 100, 0.025),
        ('NTES', 'NetEase Inc.', 90, 0.022),
        ('ZM', 'Zoom Video', 65, 0.030),
        ('SHOP', 'Shopify Inc.', 65, 0.032),
        ('SPOT', 'Spotify Technology', 280, 0.026),
        ('SNOW', 'Snowflake Inc.', 150, 0.035),
        ('PLTR', 'Palantir Technologies', 16, 0.038),
        ('COIN', 'Coinbase Global', 180, 0.045),
        ('ROKU', 'Roku Inc.', 60, 0.040),
        ('CRWD', 'CrowdStrike Holdings', 280, 0.032),
        ('NET', 'Cloudflare Inc.', 75, 0.035),
        ('MELI', 'MercadoLibre Inc.', 1850, 0.030),
        ('SE', 'Sea Limited', 65, 0.038),
        ('DASH', 'DoorDash Inc.', 125, 0.032),
    ]
    
    end_date = datetime.now().strftime('%Y-%m-%d')
    start_date = (datetime.now() - timedelta(days=5*365)).strftime('%Y-%m-%d')
    
    print(f"生成 {len(stocks)} 只股票的 {start_date} 到 {end_date} 数据")
    print()
    
    # 生成日线数据
    print("【1】生成日线数据...")
    all_daily = []
    for symbol, name, base_price, vol in stocks:
        df = generate_stock_data(symbol, name, start_date, end_date, base_price, vol)
        all_daily.append(df)
    
    daily_df = pd.concat(all_daily, ignore_index=True)
    export_to_excel(daily_df, 'us_stock_daily.xlsx', output_dir)
    
    # 生成周线数据
    print("【2】生成周线数据...")
    all_weekly = []
    for symbol, name, base_price, vol in stocks:
        df = generate_stock_data(symbol, name, start_date, end_date, base_price, vol)
        weekly = resample_to_weekly(df)
        all_weekly.append(weekly)
    
    weekly_df = pd.concat(all_weekly, ignore_index=True)
    export_to_excel(weekly_df, 'us_stock_weekly.xlsx', output_dir)
    
    # 生成月线数据
    print("【3】生成月线数据...")
    all_monthly = []
    for symbol, name, base_price, vol in stocks:
        df = generate_stock_data(symbol, name, start_date, end_date, base_price, vol)
        monthly = resample_to_monthly(df)
        all_monthly.append(monthly)
    
    monthly_df = pd.concat(all_monthly, ignore_index=True)
    export_to_excel(monthly_df, 'us_stock_monthly.xlsx', output_dir)
    
    # 导出股票列表
    print("【4】导出股票列表...")
    stock_list = pd.DataFrame(stocks, columns=['symbol', 'name', 'base_price', 'volatility'])
    stock_list['market'] = 'us_stock'
    stock_list.to_excel(output_dir / 'us_stock_list.xlsx', index=False)
    print(f"  导出: us_stock_list.xlsx ({len(stock_list)} 只股票)")
    
    print()
    print("=" * 60)
    print("数据统计:")
    print(f"  日线记录数: {len(daily_df)}")
    print(f"  周线记录数: {len(weekly_df)}")
    print(f"  月线记录数: {len(monthly_df)}")
    print(f"  股票数量: {len(stocks)}")
    print("=" * 60)
    print()
    print(f"Excel文件已保存到: {output_dir}")
    print()
    print("生成的文件:")
    for f in sorted(output_dir.glob("*.xlsx")):
        size = f.stat().st_size / 1024
        print(f"  - {f.name} ({size:.1f} KB)")
    
    print()
    print("说明:")
    print("  - 数据为模拟生成的示例数据，用于K线训练营演示")
    print("  - 日线数据: 约5年历史数据")
    print("  - 周线数据: 日线聚合")
    print("  - 月线数据: 日线聚合")
    print("  - 每个Excel文件包含'汇总'sheet和每个股票的独立sheet")


if __name__ == "__main__":
    main()
