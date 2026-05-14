# 股票历史数据获取工具

用于K线训练营的股票历史数据获取和存储系统。

## 功能特性

- **多市场支持**：A股、美股、港股
- **多周期数据**：日线、周线、月线
- **自动增量更新**：只获取新增数据，避免重复下载
- **SQLite存储**：本地数据库存储，便于查询和分析
- **数据完整性**：自动记录更新日志，支持断点续传

## 目录结构

```
assets/data/
├── stock_data_fetcher.py    # 主程序
├── requirements.txt         # 依赖包
├── README.md               # 说明文档
└── stock_data/             # 数据存储目录
    ├── stock_data.db       # SQLite数据库
    ├── a_share/            # A股数据
    │   ├── daily/          # 日线数据
    │   ├── weekly/         # 周线数据
    │   └── monthly/        # 月线数据
    ├── us_stock/           # 美股数据
    │   ├── daily/
    │   ├── weekly/
    │   └── monthly/
    ├── hk_stock/           # 港股数据
    │   ├── daily/
    │   ├── weekly/
    │   └── monthly/
    └── metadata/           # 元数据
```

## 数据库表结构

### stock_list - 股票列表
| 字段 | 说明 |
|------|------|
| symbol | 股票代码 |
| name | 股票名称 |
| market | 市场类型 (a_share/us_stock/hk_stock) |
| exchange | 交易所 |
| industry | 所属行业 |

### kline_a_share / kline_us_stock / kline_hk_stock - K线数据
| 字段 | 说明 |
|------|------|
| symbol | 股票代码 |
| date | 日期 |
| period | 周期 (daily/weekly/monthly) |
| open | 开盘价 |
| high | 最高价 |
| low | 最低价 |
| close | 收盘价 |
| volume | 成交量 |
| amount | 成交额 |

### data_update_log - 数据更新日志
| 字段 | 说明 |
|------|------|
| symbol | 股票代码 |
| market | 市场类型 |
| period | 周期 |
| last_update_date | 最后更新日期 |
| record_count | 记录数量 |

## 安装依赖

```bash
pip install -r requirements.txt
```

## 使用方法

### 1. 快速开始

```python
from stock_data_fetcher import StockDataFetcher

# 初始化
fetcher = StockDataFetcher()

# 获取A股数据（前50只）
fetcher.batch_fetch_a_share(max_stocks=50)

# 获取美股数据（前30只）
fetcher.batch_fetch_us_stock(max_stocks=30)
```

### 2. 获取全量A股数据

```python
# 获取全部A股（约5000+只）的日线、周线、月线数据
fetcher.batch_fetch_a_share(max_stocks=None)
```

### 3. 查询数据

```python
# 查询某只股票的日线数据
df = fetcher.get_kline_data(
    symbol='000001', 
    market='a_share', 
    period='daily',
    start_date='2024-01-01',
    end_date='2024-12-31'
)

# 获取股票列表
stocks = fetcher.get_stock_list(market='a_share')

# 查看数据统计
stats = fetcher.get_data_stats()
print(stats)
```

### 4. 增量更新

```python
# 再次运行会自动检测已获取的数据，只下载新增部分
fetcher.batch_fetch_a_share(max_stocks=50)
```

## 数据源

| 市场 | 数据源 | 说明 |
|------|--------|------|
| A股 | AKShare | 完全免费，无需注册 |
| 美股 | Yahoo Finance (yfinance) | 免费，无需API Key |
| 港股 | Yahoo Finance (yfinance) | 免费，无需API Key |

## 注意事项

1. **首次获取全量A股数据耗时较长**（约5000+只股票），建议分批获取或只获取需要的股票
2. **请求频率限制**：程序已内置0.5秒延迟，避免请求过快
3. **数据复权**：A股数据默认使用前复权
4. **存储空间**：全量数据约需要几百MB存储空间

## 命令行运行

```bash
# 直接运行获取示例数据
python stock_data_fetcher.py
```

## 扩展功能

如需获取更多美股数据，可以：
1. 修改 `fetch_us_stock_list()` 方法添加更多股票
2. 使用其他数据源如 Alpha Vantage（需要API Key）
