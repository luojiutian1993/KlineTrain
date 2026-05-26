# K线训练营App - API文档

**文档版本**: v1.0  
**最后更新**: 2026-05-13

## 1. 概述

本文档描述 K线训练营App 的后端API接口规范，包括接口地址、请求参数、响应格式等。

**基础URL**: `https://api.kline-trainer.com/v1`

**认证方式**: JWT Token（在请求头中携带 `Authorization: Bearer <token>`）

## 2. 接口列表

### 2.1 用户认证

#### 2.1.1 注册

- **URL**: `/auth/register`
- **方法**: `POST`
- **描述**: 用户注册

**请求体**:
```json
{
  "phone": "string",
  "password": "string",
  "code": "string",
  "nickname": "string"
}
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "token": "string",
    "user": {
      "id": "string",
      "phone": "string",
      "nickname": "string",
      "level": "number",
      "createdAt": "string"
    }
  }
}
```

#### 2.1.2 登录

- **URL**: `/auth/login`
- **方法**: `POST`
- **描述**: 用户登录

**请求体**:
```json
{
  "phone": "string",
  "password": "string"
}
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "token": "string",
    "user": {
      "id": "string",
      "phone": "string",
      "nickname": "string",
      "level": "number",
      "createdAt": "string"
    }
  }
}
```

#### 2.1.3 发送验证码

- **URL**: `/auth/send-code`
- **方法**: `POST`
- **描述**: 发送短信验证码

**请求体**:
```json
{
  "phone": "string",
  "type": "register|login|reset"
}
```

**响应**:
```json
{
  "code": 200,
  "message": "验证码已发送",
  "data": null
}
```

### 2.2 K线数据

#### 2.2.1 获取K线数据

- **URL**: `/kline/{symbol}`
- **方法**: `GET`
- **描述**: 获取指定标的的K线数据

**路径参数**:
| 参数 | 类型 | 说明 |
|------|------|------|
| symbol | string | 股票代码，如 `SH600519` |

**查询参数**:
| 参数 | 类型 | 说明 | 默认值 |
|------|------|------|--------|
| period | string | 周期：`day`/`week`/`month`/`year` | day |
| startDate | string | 开始日期（YYYY-MM-DD） | - |
| endDate | string | 结束日期（YYYY-MM-DD） | - |
| limit | number | 返回数量 | 100 |

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "symbol": "string",
    "name": "string",
    "period": "string",
    "items": [
      {
        "date": "string",
        "open": "number",
        "close": "number",
        "high": "number",
        "low": "number",
        "volume": "number",
        "amount": "number"
      }
    ]
  }
}
```

#### 2.2.2 获取标的列表

- **URL**: `/kline/symbols`
- **方法**: `GET`
- **描述**: 获取可交易标的列表

**查询参数**:
| 参数 | 类型 | 说明 |
|------|------|------|
| market | string | 市场：`a股`/`期货`/`港股`/`美股` |
| keyword | string | 搜索关键词 |

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "symbol": "string",
      "name": "string",
      "market": "string",
      "industry": "string",
      "price": "number",
      "change": "number",
      "changePercent": "number"
    }
  ]
}
```

### 2.3 训练记录

#### 2.3.1 创建训练记录

- **URL**: `/training`
- **方法**: `POST`
- **描述**: 创建训练记录

**请求体**:
```json
{
  "symbol": "string",
  "period": "string",
  "startDate": "string",
  "endDate": "string",
  "initialCapital": "number"
}
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "string",
    "symbol": "string",
    "name": "string",
    "period": "string",
    "startDate": "string",
    "endDate": "string",
    "initialCapital": "number",
    "currentCapital": "number",
    "status": "active|finished",
    "createdAt": "string"
  }
}
```

#### 2.3.2 获取训练记录列表

- **URL**: `/training`
- **方法**: `GET`
- **描述**: 获取用户训练记录列表

**查询参数**:
| 参数 | 类型 | 说明 | 默认值 |
|------|------|------|--------|
| page | number | 页码 | 1 |
| limit | number | 每页数量 | 20 |
| status | string | 状态：`all`/`active`/`finished` | all |

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": "string",
        "symbol": "string",
        "name": "string",
        "period": "string",
        "initialCapital": "number",
        "currentCapital": "number",
        "profit": "number",
        "profitPercent": "number",
        "tradeCount": "number",
        "winCount": "number",
        "status": "string",
        "createdAt": "string"
      }
    ],
    "total": "number",
    "page": "number",
    "limit": "number"
  }
}
```

#### 2.3.3 获取训练记录详情

- **URL**: `/training/{id}`
- **方法**: `GET`
- **描述**: 获取训练记录详情

**路径参数**:
| 参数 | 类型 | 说明 |
|------|------|------|
| id | string | 训练记录ID |

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "string",
    "symbol": "string",
    "name": "string",
    "period": "string",
    "startDate": "string",
    "endDate": "string",
    "initialCapital": "number",
    "currentCapital": "number",
    "profit": "number",
    "profitPercent": "number",
    "tradeCount": "number",
    "winCount": "number",
    "maxDrawdown": "number",
    "status": "string",
    "klineData": [],
    "trades": [],
    "createdAt": "string",
    "updatedAt": "string"
  }
}
```

### 2.4 交易操作

#### 2.4.1 下单交易

- **URL**: `/trade`
- **方法**: `POST`
- **描述**: 执行买卖交易

**请求体**:
```json
{
  "trainingId": "string",
  "type": "buy|sell",
  "price": "number",
  "quantity": "number"
}
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "string",
    "trainingId": "string",
    "type": "string",
    "price": "number",
    "quantity": "number",
    "amount": "number",
    "date": "string",
    "status": "filled"
  }
}
```

#### 2.4.2 设置条件单

- **URL**: `/trade/condition`
- **方法**: `POST`
- **描述**: 设置条件单（止盈止损、网格交易等）

**请求体**:
```json
{
  "trainingId": "string",
  "type": "take_profit|stop_loss|grid",
  "params": {
    "targetPrice": "number",
    "stopPrice": "number",
    "upperPrice": "number",
    "lowerPrice": "number",
    "gridCount": "number"
  }
}
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "string",
    "trainingId": "string",
    "type": "string",
    "params": {},
    "status": "active",
    "createdAt": "string"
  }
}
```

### 2.5 课程管理

#### 2.5.1 获取课程列表

- **URL**: `/courses`
- **方法**: `GET`
- **描述**: 获取课程列表

**查询参数**:
| 参数 | 类型 | 说明 | 默认值 |
|------|------|------|--------|
| page | number | 页码 | 1 |
| limit | number | 每页数量 | 20 |
| category | string | 分类：`basic`/`technical`/`strategy` |

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": "string",
        "title": "string",
        "category": "string",
        "cover": "string",
        "duration": "number",
        "lessons": "number",
        "level": "beginner|intermediate|advanced",
        "price": "number",
        "isFree": "boolean",
        "createdAt": "string"
      }
    ],
    "total": "number"
  }
}
```

#### 2.5.2 获取课程详情

- **URL**: `/courses/{id}`
- **方法**: `GET`
- **描述**: 获取课程详情

**路径参数**:
| 参数 | 类型 | 说明 |
|------|------|------|
| id | string | 课程ID |

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "string",
    "title": "string",
    "category": "string",
    "cover": "string",
    "description": "string",
    "duration": "number",
    "level": "string",
    "price": "number",
    "isFree": "boolean",
    "lessons": [
      {
        "id": "string",
        "title": "string",
        "duration": "number",
        "order": "number"
      }
    ],
    "createdAt": "string"
  }
}
```

## 3. 错误响应格式

```json
{
  "code": "number",
  "message": "string",
  "data": null
}
```

**错误码说明**:
| 错误码 | 说明 |
|--------|------|
| 400 | 请求参数错误 |
| 401 | 未授权，请登录 |
| 403 | 权限不足 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

## 4. WebSocket接口

### 4.1 实时行情

- **URL**: `wss://api.kline-trainer.com/ws/kline`
- **描述**: 订阅实时K线数据

**订阅消息**:
```json
{
  "action": "subscribe",
  "symbol": "SH600519",
  "period": "day"
}
```

**推送消息**:
```json
{
  "symbol": "SH600519",
  "name": "贵州茅台",
  "price": "number",
  "change": "number",
  "changePercent": "number",
  "kline": {
    "date": "string",
    "open": "number",
    "close": "number",
    "high": "number",
    "low": "number",
    "volume": "number"
  },
  "timestamp": "number"
}
```

---

**文档版本**: v1.0  
**生成日期**: 2026-05-13  
**最后更新**: 2026-05-13