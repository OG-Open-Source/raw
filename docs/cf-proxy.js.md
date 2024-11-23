# cf-proxy.js
基於 Cloudflare Workers 的高性能代理服務，提供 WAF 防護與訪問控制功能。

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
cf-proxy.js 是一個運行在 Cloudflare Workers 平台上的代理服務，為開發者提供安全可靠的代理功能。透過內建的 WAF 防護、訪問控制和請求統計功能，有效保護應用程式免受惡意訪問。

## 特性
- 內建 WAF 防護機制
- 支援國家和 IP 級別的訪問控制
- 靈活的 URL 過濾規則
- 請求計數與統計功能
- API 配置管理介面
- 高效能緩存系統
- 完整的 CORS 支援

## 安裝

### 環境要求
- Cloudflare 帳戶
- Node.js 14.0 或更高版本
- npm 6.0 或更高版本
- Wrangler CLI 工具
- Cloudflare Workers（免費版或付費版）
- Cloudflare D1 數據庫（可選，用於請求計數）
- Cloudflare KV 命名空間（用於配置存儲）

{:.important}
> 使用前請確保您擁有 Cloudflare 帳戶並已啟用 Workers 服務。

```bash
# 安裝 Wrangler CLI
npm install -g wrangler

# 登錄到 Cloudflare
wrangler login

# 創建專案
wrangler init cf-proxy

# 設置必要的環境變量
wrangler secret put CF_API_TOKEN
wrangler secret put CF_ZONE_ID
wrangler secret put CF_API_URL

# 創建 KV 命名空間
wrangler kv:namespace create PROXY_CONFIG

# 創建 D1 數據庫（可選）
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

### API 配置
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

{:.note}
> 配置更新後會立即生效，無需重新部署。

## 配置

### 全局配置選項
```javascript
{
    API_ACCESS: {
        ENABLE_AUTH: true,
        UPDATE_KEY: 'your-update-key'
    },

    WAF: {
        ENABLED: false,
        ALLOWED_COUNTRIES: [],
        BLOCKED_COUNTRIES: [],
        BLOCKED_IPS: []
    },

    URL_CONTROL: {
        ALLOW_ALL_DOMAINS: false,
        ALLOWED_DOMAIN_PREFIXES: [
            'https://raw.githubusercontent.com/OG-Open-Source',
            'https://raw.githubusercontent.com'
        ],
        ALLOWED_GENERAL_PATTERN: ''
    },

    PROXY: {
        TIMEOUT: 30
    },

    REQUEST_COUNT: {
        ENABLED: true,
    }
}
```

{:.tip}
> 建議在正式環境中啟用 API 認證功能。

## 常見問題

**Q：如何解決 CORS 問題？**<br>
A：服務默認已啟用 CORS 支援，響應頭包含 `Access-Control-Allow-Origin: *`。如需特定域名限制，可通過配置修改。

**Q：請求計數功能無法使用？**<br>
A：請確認：
- D1 數據庫已正確配置
- 數據表結構完整
- Worker 有足夠的權限

**Q：如何更新 WAF 規則？**<br>
A：通過 `/api/config` API 端點發送 POST 請求，記得包含 `X-Update-Key` 認證頭。

## 貢獻指南
1. Fork 專案
2. 創建功能分支
3. 提交更改
4. 發起 Pull Request

## 許可證
本專案採用 MIT 許可證。