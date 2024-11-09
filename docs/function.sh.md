# Shell Functions Library by OG-Open-Source

## 1. 函數列表與說明

### ADD - 新增檔案或套件
```bash
# 新增檔案
ADD -f /path/to/file              # 新增檔案
ADD -d /path/to/directory         # 新增目錄

# 安裝套件
ADD package_name                 # 安裝套件
ADD package1 package2            # 安裝多個套件
ADD file.deb                     # 安裝 DEB 套件
```

### CHECK_OS - 檢查作業系統
```bash
CHECK_OS
# 返回: Debian 12 (bookworm), Ubuntu 22.04 等
```

### CHECK_ROOT - 檢查 root 權限
```bash
CHECK_ROOT
# 如非 root 用戶執行會顯示錯誤並退出
```

### CHECK_VIRT - 檢查虛擬化環境
```bash
CHECK_VIRT
# 返回: KVM, Hyper-V, VMware 等
```

### CLEAN - 清理終端
```bash
CLEAN
# 清理終端並返回 HOME 目錄
```

### CONVERT_SIZE - 轉換檔案大小
```bash
CONVERT_SIZE 1024               # 同 CONVERT_SIZE 1024 iB
CONVERT_SIZE 1024 iB            # 轉換位元組到 1 KiB
CONVERT_SIZE 1000 B             # 轉換位元組到 1 KB
CONVERT_SIZE 1.5 GB             # 轉換成 1.50 GB
CONVERT_SIZE 1024 MiB           # 轉換二進位的 1 GiB
```

### COPYRIGHT - 顯示版權資訊
```bash
COPYRIGHT
# 顯示版權聲明
```

### CPU_CACHE - 顯示 CPU 快取
```bash
CPU_CACHE
# 返回: xxx KB
```

### CPU_FREQ - 顯示 CPU 頻率
```bash
CPU_FREQ
# 返回: x.xx GHz
```

### CPU_MODEL - 顯示 CPU 型號
```bash
CPU_MODEL
# 返回: Intel(R) Xeon(R) CPU E5-2680 v3 等
```

### CPU_USAGE - 顯示 CPU 使用率
```bash
CPU_USAGE
# 返回: xx%
```

### DEL - 刪除檔案或套件
```bash
# 刪除檔案
DEL -f /path/to/file             # 刪除檔案
DEL -d /path/to/directory        # 刪除目錄

# 移除套件
DEL package_name                 # 移除套件
DEL package1 package2           # 移除多個套件
```

### DISK_USAGE - 顯示硬碟使用情況
```bash
DISK_USAGE
# 返回: xxx GiB / xxx GiB (xx%)
```

### DNS_ADDR - 顯示 DNS 伺服器
```bash
DNS_ADDR                         # 顯示所有 DNS
DNS_ADDR -4                      # 僅顯示 IPv4 DNS
DNS_ADDR -6                      # 僅顯示 IPv6 DNS
```

### error - 錯誤處理
```bash
error "錯誤訊息"                 # 輸出錯誤訊息
# 錯誤會記錄到 /var/log/ogos-error.log
```

### FIND - 搜尋套件
```bash
FIND package_name               # 搜尋套件
FIND keyword1 keyword2         # 搜尋多個關鍵字
```

### FONT - 設置文字樣式
```bash
FONT B "粗體"                    # 粗體
FONT U "底線"                    # 底線
FONT RED "紅色"                  # 顏色
FONT BG.BLUE "藍底"             # 背景色
FONT RGB 255,0,0 "RGB紅"        # RGB 顏色
```

### GET - 下載檔案
```bash
GET url                         # 下載到當前目錄
GET url /path                   # 下載到指定目錄
GET url /path -r newname        # 下載並重命名
```

### INPUT - 讀取用戶輸入
```bash
INPUT "請輸入: " variable       # 讀取輸入到變數
```

### INTERFACE - 顯示網絡介面
```bash
INTERFACE                       # 顯示介面名稱
INTERFACE -i                    # 顯示詳細資訊
```

### IP_ADDR - 顯示 IP 地址
```bash
IP_ADDR                        # 顯示所有 IP
IP_ADDR -4                     # 僅顯示 IPv4
IP_ADDR -6                     # 僅顯示 IPv6
```

### LAST_UPDATE - 顯示最後更新時間
```bash
LAST_UPDATE
# 返回: YYYY-MM-DD HH:MM:SS
```

### LINE - 繪製分隔線
```bash
LINE                           # 預設分隔線
LINE =                         # 自定義字元
LINE - 50                      # 自定義長度
```

### LOAD_AVERAGE - 顯示系統負載
```bash
LOAD_AVERAGE
# 返回: x.xx, x.xx, x.xx (x cores)
```

### MAC_ADDR - 顯示 MAC 地址
```bash
MAC_ADDR
# 返回: xx:xx:xx:xx:xx:xx
```

### MEM_USAGE - 顯示記憶體使用情況
```bash
MEM_USAGE
# 返回: xxx GiB / xxx GiB (xx%)
```

### NET_PROVIDER - 顯示網絡服務商
```bash
NET_PROVIDER
# 返回: 網絡服務商名稱
```

### PKG_COUNT - 統計已安裝套件
```bash
PKG_COUNT
# 返回: 已安裝套件數量
```

### PROGRESS - 顯示進度條
```bash
# 定義命令陣列
cmds=("command1" "command2" "command3")
PROGRESS
```

### PUBLIC_IP - 顯示公網 IP
```bash
PUBLIC_IP
# 返回: 公網 IP 地址
```

### SHELL_VER - 顯示 Shell 版本
```bash
SHELL_VER
# 返回: Bash x.x 或 Zsh x.x
```

### SWAP_USAGE - 顯示交換分區使用情況
```bash
SWAP_USAGE
# 返回: xxx GiB / xxx GiB (xx%)
```

### SYS_CLEAN - 系統清理
```bash
SYS_CLEAN
# 清理系統垃圾、快取等
```

### SYS_INFO - 顯示系統資訊
```bash
SYS_INFO
# 顯示完整系統資訊
```

### SYS_OPTIMIZE - 系統優化
```bash
SYS_OPTIMIZE
# 優化系統配置
```

### SYS_REBOOT - 系統重啟
```bash
SYS_REBOOT
# 安全重啟系統
```

### SYS_UPDATE - 系統更新
```bash
SYS_UPDATE
# 更新系統和套件
```

### TIMEZONE - 顯示時區
```bash
TIMEZONE -i                    # 顯示內部時區
TIMEZONE -e                    # 顯示外部時區
```

## 2. 使用注意事項
1. 所有函數都會返回狀態碼:
   - 0: 成功
   - 1: 一般錯誤
   - 255: 未知錯誤

2. 錯誤處理:
   - 使用 error 函數輸出錯誤
   - 錯誤記錄在 /var/log/ogos-error.log
   - 部分函數失敗會自動退出

3. 權限要求:
   - 部分函數需要 root 權限
   - 使用 CHECK_ROOT 函數檢查

4. 網絡需求:
   - 網絡相關函數需要網絡連接
   - 部分函數有超時機制

5. 相容性:
   - 支援 Bash 4.0+ 和 Zsh
   - 需要終端支援 ANSI 顏色
   - 部分功能依賴特定系統工具

## 3. 環境變數
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

# 代理設置
cf_proxy="https://proxy.ogtt.tk/"  # 中國大陸使用