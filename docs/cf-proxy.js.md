# cf-proxy.js

一個基於 Cloudflare Workers 的代理服務，提供 WAF 防護、URL 訪問控制和請求計數功能。

---

## 目錄
- [簡介](#簡介)
- [特性](#特性)
- [安裝](#安裝)
- [使用方法](#使用方法)
- [示例](#示例)
- [配置](#配置)
- [常見問題](#常見問題)
- [貢獻指南](#貢獻指南)
- [許可證](#許可證)

---

## 簡介
cf-proxy.js 是一個運行在 Cloudflare Workers 平台上的代理服務，專為需要安全、高效的代理服務的開發者設計。它提供了 WAF 防護、URL 訪問控制和請求計數等功能，可以有效保護您的應用免受惡意訪問。

## 特性
- 內建 WAF（Web Application Firewall）功能
- 基於國家和 IP 的訪問控制
- 靈活的 URL 訪問控制
- 請求計數和統計
- 支持 API 配置管理
- 高性能緩存機制
- 完整的 CORS 支持

## 安裝

### 環境要求
- Cloudflare 帳戶
- Cloudflare Workers
- Cloudflare D1 數據庫（可選，用於請求計數）
- Cloudflare KV 命名空間

### 安裝步骤
1. 創建 Cloudflare Worker
```bash
# 安裝 Wrangler CLI
npm install -g wrangler

# 登錄到 Cloudflare
wrangler login

# 創建新的 Worker 專案
wrangler init cf-proxy
```

2. 配置環境變量
```bash
# 設置必要的環境變量
wrangler secret put CF_API_TOKEN
wrangler secret put CF_ZONE_ID
wrangler secret put CF_API_URL
```

3. 創建 KV 命名空間
```bash
wrangler kv:namespace create PROXY_CONFIG
```

4. 設置 D1 數據庫（可選）
```bash
wrangler d1 create proxy-db
```

## 使用方法

### 基本使用
1. 部署 Worker
```bash
wrangler deploy
```

2. 訪問代理服務
```
https://your-worker.workers.dev/https://example.com/path
```

### API 使用
更新 WAF 配置：
```bash
curl -X POST 'https://your-worker.workers.dev/api/config' \
-H 'X-Update-Key: your-update-key' \
-H 'Content-Type: application/json' \
-d '{
    "waf": {
        "ENABLED": true,
        "ALLOWED_COUNTRIES": ["TW", "JP"]
    }
}'
```

## 示例

### WAF 配置示例
```javascript
{
    "waf": {
        "ENABLED": true,
        "ALLOWED_COUNTRIES": ["TW", "JP"],
        "BLOCKED_IPS": ["1.2.3.4"]
    }
}
```

### 配置更新響應
```json
{
    "message": "Configuration updated",
    "status": 200
}
```

## 配置

### 全局配置
```javascript
{
    "API_ACCESS": {
        "ENABLE_AUTH": true,
        "UPDATE_KEY": "your-update-key"
    },
    "WAF": {
        "ENABLED": false,
        "ALLOWED_COUNTRIES": [],
        "BLOCKED_COUNTRIES": [],
        "BLOCKED_IPS": []
    },
    "URL_CONTROL": {
        "ALLOWED_DOMAIN_PREFIXES": [
            "https://raw.githubusercontent.com"
        ]
    },
    "PROXY": {
        "TIMEOUT": 30
    },
    "REQUEST_COUNT": {
        "ENABLED": true
    }
}
```

## 常見問題

### Q：如何處理 CORS 錯誤？
A：服務默認已啟用 CORS，響應頭包含 `Access-Control-Allow-Origin: *`。

### Q：為什麼請求計數功能不工作？
A：請確保已正確配置 D1 數據庫並創建了必要的表結構。

### Q：如何更新 WAF 規則？
A：使用 API 端點 `/api/config` 發送 POST 請求，記得包含正確的 `X-Update-Key`。

## 貢獻指南
1. Fork 本專案
2. 創建特性分支
3. 提交更改
4. 發起 Pull Request

歡迎提交 Issue 和 Pull Request！

## 許可證
本專案採用 MIT 許可證。