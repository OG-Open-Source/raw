# Cloudflare Worker Proxy by OG-Open-Source

## 1. 功能概述
- WAF（Web Application Firewall）防火牆
- URL 訪問控制
- 請求計數
- API 配置管理

## 2. 環境設置
### 2.1 Cloudflare Workers 環境變量
- `CF_API_TOKEN`：Cloudflare API Token（需要 Firewall Services 編輯權限）
- `CF_ZONE_ID`：Cloudflare Zone ID
- `CF_API_URL`：Cloudflare API URL

### 2.2 D1 數據庫設置
數據庫會自動創建以下表：
```sql
CREATE TABLE IF NOT EXISTS ip_visits (
    date TEXT,
    ip TEXT,
    count INTEGER DEFAULT 1,
    PRIMARY KEY (date, ip)
);
```

### 2.3 KV 命名空間
- 名稱：`PROXY_CONFIG`
- 用途：存儲 WAF 配置

## 3. 配置說明
### 3.1 全局配置（GLOBAL_CONFIG）
```javascript
{
    // API 訪問控制配置
    API_ACCESS: {
        ENABLE_AUTH: true,        // 是否啟用 API 認證
        UPDATE_KEY: 'your-update-key'  // API 更新密鑰，用於驗證配置更新請求
    },

    // WAF 防火牆配置
    WAF: {
        ENABLED: false,           // 是否啟用 WAF 功能
        ALLOWED_COUNTRIES: [],    // 允許訪問的國家列表（ISO 3166-1 alpha-2 格式，如：TW, JP）
        BLOCKED_COUNTRIES: [],    // 禁止訪問的國家列表（與 ALLOWED_COUNTRIES 互斥）
        BLOCKED_IPS: []          // 禁止訪問的 IP 列表（IPv4 格式）
    },

    // URL 訪問控制配置
    URL_CONTROL: {
        ALLOWED_DOMAIN_PREFIXES: [  // 允許訪問的域名前綴列表
            'https://raw.githubusercontent.com/OG-Open-Source',
            'https://raw.githubusercontent.com'
        ],
        ALLOWED_GENERAL_PATTERN: '' // 允許的通用 URL 模式（可選，用於進一步過濾）
    },

    // 代理請求配置
    PROXY: {
        TIMEOUT: 30              // 代理請求超時時間（單位：秒）
    },

    // 請求計數配置
    REQUEST_COUNT: {
        ENABLED: true,           // 是否啟用請求計數功能（需要 D1 數據庫支持）
    }
}
```

### 3.2 配置項說明
1. **API_ACCESS**
   - `ENABLE_AUTH`：控制是否需要驗證才能訪問 API
   - `UPDATE_KEY`：API 密鑰，用於驗證配置更新請求的合法性

2. **WAF**
   - `ENABLED`：WAF 功能開關
   - `ALLOWED_COUNTRIES`：白名單模式，只允許列表中的國家訪問
   - `BLOCKED_COUNTRIES`：黑名單模式，阻止列表中的國家訪問
   - `BLOCKED_IPS`：IP 黑名單，阻止列表中的 IP 訪問

3. **URL_CONTROL**
   - `ALLOWED_DOMAIN_PREFIXES`：允許代理的域名前綴列表
   - `ALLOWED_GENERAL_PATTERN`：可選的 URL 模式匹配規則

4. **PROXY**
   - `TIMEOUT`：設置代理請求的超時時間，避免請求掛起

5. **REQUEST_COUNT**
   - `ENABLED`：控制是否記錄請求計數，需要配置 D1 數據庫

## 4. API 使用說明
### 4.1 更新 WAF 配置
```bash
# 開啟 WAF 並設定允許的國家
curl -X POST 'https://your-domain.com/api/config' \
-H 'X-Update-Key: your-update-key' \
-H 'Content-Type: application/json' \
-d '{
    "waf": {
        "ENABLED": true,
        "ALLOWED_COUNTRIES": ["TW", "HK", "JP"],
        "BLOCKED_COUNTRIES": [],
        "BLOCKED_IPS": []
    }
}'

# 設定封鎖的國家
curl -X POST 'https://your-domain.com/api/config' \
-H 'X-Update-Key: your-update-key' \
-H 'Content-Type: application/json' \
-d '{
    "waf": {
        "ENABLED": true,
        "ALLOWED_COUNTRIES": [],
        "BLOCKED_COUNTRIES": ["CN", "RU"],
        "BLOCKED_IPS": []
    }
}'

# 設定封鎖的 IP
curl -X POST 'https://your-domain.com/api/config' \
-H 'X-Update-Key: your-update-key' \
-H 'Content-Type: application/json' \
-d '{
    "waf": {
        "ENABLED": true,
        "ALLOWED_COUNTRIES": [],
        "BLOCKED_COUNTRIES": [],
        "BLOCKED_IPS": ["1.2.3.4", "5.6.7.8"]
    }
}'

# 關閉 WAF
curl -X POST 'https://your-domain.com/api/config' \
-H 'X-Update-Key: your-update-key' \
-H 'Content-Type: application/json' \
-d '{
    "waf": {
        "ENABLED": false,
        "ALLOWED_COUNTRIES": [],
        "BLOCKED_COUNTRIES": [],
        "BLOCKED_IPS": []
    }
}'
```

## 5. 注意事項
1. ALLOWED_COUNTRIES 和 BLOCKED_COUNTRIES 不能同時使用
2. 國家代碼使用 ISO 3166-1 alpha-2 格式（如：TW, HK, JP）
3. IP 地址使用標準 IPv4 格式
4. 請求計數功能需要配置 D1 數據庫
5. WAF 配置存儲在 KV 中，需要配置 PROXY_CONFIG KV 命名空間
6. URL 訪問控制使用緩存機制，最大緩存 1000 條記錄
7. 代理請求超時時間可在 GLOBAL_CONFIG.PROXY.TIMEOUT 中設置（默認 30 秒）