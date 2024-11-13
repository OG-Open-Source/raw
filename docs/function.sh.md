# function.sh by OG-Open-Source

一個功能豐富的 Shell 函數庫，提供系統管理、網路配置、效能監控等多種實用功能。

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

function.sh 是一個全面的 Shell 函數庫，專為系統管理員和開發者設計。它提供了豐富的系統管理功能，包括套件管理、系統監控、網路配置等，大大簡化了日常系統維護工作。

## 特性

- 完整的系統管理功能（安裝、更新、清理等）
- 系統效能監控（CPU、記憶體、硬碟使用率）
- 網路管理工具（IP 配置、DNS 設定等）
- 自動化系統優化
- 錯誤處理和日誌記錄
- 支援多種 Linux 發行版
- 自動更新機制

## 安裝

### 方法一：直接下載

```bash
curl -sSLO 'https://raw.ogtt.tk/shell/function.sh'
chmod +x function.sh
```

### 方法二：使用安裝腳本

```bash
bash <(curl -sL 'https://raw.ogtt.tk/shell/update-function.sh')
```

## 使用方法

### 基本命令格式

```bash
source function.sh
函數名稱 [參數]
```

### 主要函數分類

#### 系統管理
- `SYS_INFO` - 顯示系統資訊
- `SYS_UPDATE` - 系統更新
- `SYS_CLEAN` - 系統清理
- `SYS_OPTIMIZE` - 系統優化
- `SYS_REBOOT` - 系統重啟

#### 套件管理
- `ADD` - 新增檔案或安裝套件
- `DEL` - 刪除檔案或移除套件
- `FIND` - 搜尋套件
- `PKG_COUNT` - 統計已安裝套件數量

#### 系統監控
- `CPU_USAGE` - CPU 使用率
- `MEM_USAGE` - 記憶體使用情況
- `DISK_USAGE` - 硬碟使用情況
- `LOAD_AVERAGE` - 系統負載

#### 網路工具
- `IP_ADDR` - 顯示 IP 地址
- `DNS_ADDR` - 顯示 DNS 伺服器
- `MAC_ADDR` - 顯示 MAC 地址
- `NET_PROVIDER` - 顯示網路服務商
- `PUBLIC_IP` - 顯示公網 IP

## 示例

### 系統資訊查詢
```bash
source function.sh
SYS_INFO
```

### 安裝套件
```bash
source function.sh
ADD nginx
```

### 系統優化
```bash
source function.sh
SYS_OPTIMIZE
```

## 配置

### 環境變數設定

```bash
# 顏色定義
CLR1="\033[0;31m"    # 紅色
CLR2="\033[0;32m"    # 綠色
CLR3="\033[0;33m"    # 黃色
CLR4="\033[0;34m"    # 藍色
CLR5="\033[0;35m"    # 紫色
CLR6="\033[0;36m"    # 青色
CLR7="\033[0;37m"    # 白色
CLR8="\033[0;96m"    # 亮青色
CLR9="\033[0;97m"    # 亮白色
CLR0="\033[0m"       # 重置

# 代理設置（中國大陸使用）
cf_proxy="https://proxy.ogtt.tk/"
```

## 常見問題

1. **為什麼某些命令需要 root 權限？**
   - 系統層級的操作（如更新、安裝套件等）需要 root 權限以確保安全性。

2. **如何處理網路連接問題？**
   - 確保系統能夠訪問網際網路
   - 中國大陸用戶可使用內建的代理服務

3. **自動更新無法運作？**
   - 檢查 crontab 設定
   - 確認網路連接狀態
   - 檢查系統時間是否正確

## 貢獻指南

1. Fork 專案
2. 創建功能分支
3. 提交更改
4. 發起 Pull Request

歡迎提供：
- 錯誤修復
- 新功能建議
- 文檔改進
- 使用案例

## 許可證

本專案採用 MIT 許可證。