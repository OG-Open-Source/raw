# SDCL 1.1

以下是 OGATA 標準通用數據字符儲存格式語言（OGATA's Standard Data Character Storage Language，簡稱 OGATA-SDCL 或 SDCL）的完整格式規範，涵蓋所有語法規則、類型系統及高級功能。

---

## 目錄

- [基本語法結構](#基本語法結構)
- [類型系統](#類型系統)
- [資料結構與嵌套](#資料結構與嵌套)
- [多行字串處理](#多行字串處理)
- [錯誤代碼總覽](#錯誤代碼總覽)
- [最佳實踐](#最佳實踐)
- [附錄](#附錄)
- [貢獻指南](#貢獻指南)
- [許可證](#許可證)

---

## 基本語法結構

### 鍵值對基礎

```sdcl
# 基本鍵值對
key: value

# 等價的三種括號形式
object1: { a:1, b:2 }
object2: [ a:1, b:2 ]
object3: ( a:1, b:2 )

# 列表結構
list: [1, "text", <int>3</int>]
```

---

## 類型系統

### 類型標籤規範

| 標籤            | 正確用法範例                | 錯誤用法範例          | 解析規則               |
|-----------------|----------------------------|-----------------------|------------------------|
| `<str></str>`   | `<str>text</str>`          | `<str>text`           | 必須閉合標籤           |
| `<int></int>`   | `<int>8080</int>`          | `<int>"8080"`         | 內容需為純數字          |
| `<float></float>` | `<float>3.14</float>`      | `<float>3,14</float>` | 小數點格式錯誤         |
| `<null>`        | `<null/>` 或 `<null>`      | `<null> </null>`      | 空標籤禁止內容         |

### 自動類型推斷

```sdcl
42         → <int>       # 整數
"text"     → <str>       # 字串
true       → <bool>      # 布林值
{}/[]/()   → null        # 空結構等價 null
```

---

## 資料結構與嵌套

### TOML 風格路徑語法

```sdcl
# 路徑式鍵名展開
server.ports.http: 80
server.ports.https: 443

# 解析結果
server: {
  ports: {
    http: 80
    https: 443
  }
}
```

### 顯式列表結構

```sdcl
# 列表內含鍵值對
server.ports: [
  http: 80
  https: 443
]

# 解析結果
server: {
  ports: [
    { http: 80 },
    { https: 443 }
  ]
}
```

### 特殊鍵名結構

```sdcl
# 引號包裹的複合鍵名
"server.ports": [
  http: 80
  https: 443
]

# 解析結果
{
  "server.ports": [
    { http: 80 },
    { https: 443 }
  ]
}
```

---

## 多行字串處理

### 多行語法形式

```sdcl
# 縮進塊模式 (自動去除首尾空行)
text1:
  Line 1
  Line 2
→ "Line 1\nLine 2"

# 標籤模式 (等同雙引號轉義)
text2: <str>
  Line 1
    Line 2
</str>
→ "Line 1\n  Line 2"
```

### 轉義規則對照

| 語法形式       | 輸入內容            | 解析結果           |
|----------------|---------------------|--------------------|
| `"..."`        | `"Line\nEnd"`      | `Line\nEnd`        |
| `<str>...</str>` | `<str>Line\nEnd</str>` | `Line\nEnd`    |
| `'...'`        | `'Line\nEnd'`      | `Line\\nEnd`       |

---

## 錯誤代碼總覽

| 代碼  | 類型                 | 觸發條件範例                  | 解決方案               |
|-------|----------------------|-------------------------------|------------------------|
| T002  | 類型標籤未閉合       | `<int>8080`                   | 補全 `</int>`          |
| S203  | 多行未包裹逗號       | ```[<br>item1,<br>item2<br>]``` | 改用換行或包裹逗號    |
| S204  | 鍵值對跨行未對齊     | ```key:<br>  value```         | 保持縮進一致          |
| D001  | 日期格式錯誤         | `<date>20231001</date>`       | 改用 `YYYY-MM-DD`     |

---

## 最佳實踐

### 類型標籤規範化

```sdcl
# ✅ 統一閉合標籤
port: <int>8080</int>
api_version: <str>v1.2.3</str>

# ❌ 避免混合風格
err: <int>8080</float>  # 標籤不匹配
```

### 結構選擇建議

```sdcl
# 簡單配置使用路徑語法
db.mysql.timeout: 30

# 複雜數據使用顯式列表
users: [
  { name: "Alice", roles: ["admin"] }
  { name: "Bob", roles: ["user"] }
]
```

### 錯誤預防配置

```sdcl
# 啟用嚴格模式
strict_mode: {
  tag_closure: true      # 強制標籤閉合
  multiline_comma: false # 禁止多行逗號
}
```

---

## 附錄

### 速查表

| 場景                | 標準寫法                   | 等價形式                  |
|---------------------|---------------------------|---------------------------|
| 類型強制轉換        | `<int>8080</int>`         | 整數 8080                |
| 多層路徑鍵名        | `server.(port.config): 80` | `server: { port.config: 80 }` |
| 空值表示            | `log_level: <null/>`      | 明確標記為 null          |

## 貢獻指南

1. Fork 專案
2. 創建功能分支
3. 提交更改
4. 發起 Pull Request

## 許可證

本專案採用 MIT 許可證。
