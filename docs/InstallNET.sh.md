# InstallNET Script by OG-Open-Source

## 1. 功能概述
- 支援多種 Linux 發行版網絡重裝(Debian/Ubuntu/Kali/CentOS/Rocky/AlmaLinux/Fedora/Alpine)
- 支援 Windows DD 模式安裝
- 支援 IPv4/IPv6 雙棧網絡配置
- 支援 DHCP 和靜態 IP 配置
- 支援 UEFI 和 Legacy BIOS 引導
- 支援自定義 root 密碼和 SSH 端口
- 支援 BBR 加速和系統優化
- 支援 fail2ban 安全防護

## 2. 使用方法
### 2.1 基本語法
```bash
bash InstallNET.sh [選項] [參數]
```

### 2.2 主要選項
```bash
# Linux 發行版選擇
-debian [7/8/9/10/11/12]        安裝 Debian 系統('12'為穩定版)
-ubuntu [20.04/22.04/24.04]     安裝 Ubuntu 系統('24.04'為穩定版)
-kali [rolling/dev]             安裝 Kali Linux('rolling'為穩定版)
-centos [7/8/9]                 安裝 CentOS 系統('9'為穩定版)
-rocky [8/9]                    安裝 Rocky Linux('9'為穩定版)
-alma [8.10/9.4]                安裝 AlmaLinux('9.4'為穩定版)
-fedora [39/40]                 安裝 Fedora Linux('40'為穩定版)
-alpine [3.16~3.20/edge]        安裝 Alpine Linux('edge'為穩定版)
-windows [DIST]                 安裝 Windows 系統

# 系統架構
-architecture [32/i386|64/amd64|arm/arm64]  指定系統架構

# 網絡配置
--ip-addr [IP]                   設置 IPv4 地址
--ip-mask [24-32]                設置子網掩碼
--ip-gate [IP]                   設置網關
--ip-dns [DNS]                   設置 DNS 伺服器
--ip-set [IP] [24-32] [IP]       簡化 IPv4 配置
--ip6-addr [IPv6]                設置 IPv6 地址
--ip6-mask [1-128]               設置 IPv6 子網掩碼
--ip6-gate [IPv6]                設置 IPv6 網關
--ip6-dns [IPv6]                 設置 IPv6 DNS 伺服器
--ip6-set [IPv6] [1-128] [IPv6]  簡化 IPv6 配置
--networkstack [IPv4Stack/IPv6Stack/BiStack]  指定網絡協議棧

# 系統優化
--bbr                         啟用 BBR 擁塞控制
--fail2ban                    安裝並配置 fail2ban
--kejilion                    安裝並配置 kejilion.sh (來源 kejilion.pro/kejilion.sh)

# 其他選項
-mirror [URL]                 指定鏡像源
-pwd [PASSWORD]               設置 root 密碼
-port [PORT]                  設置 SSH 端口
--timezone [TIMEZONE]         設置時區
--hostname [NAME]             設置主機名
--motd                        設置登入歡迎信息
--reboot                      安裝完成後自動重啟
```

## 3. 使用範例
### 3.1 安裝 Debian 系統
```bash
# 安裝最新穩定版 Debian 12
bash InstallNET.sh -debian 12 -pwd mypassword

# 使用自定義網絡配置
bash InstallNET.sh -debian 12 --ip-addr 192.168.1.100 --ip-mask 24 --ip-gate 192.168.1.1 --ip-dns "1.1.1.1 8.8.8.8"

# 同時安裝多個選項並使用 reboot 重啟
bash InstallNET.sh -debian 12 -pwd mypassword --bbr --fail2ban --kejilion --ip-set 192.168.1.101 24 192.168.1.1 --ip6-set 2001:db8::101 64 2001:db8::1 --reboot
```

### 3.2 安裝 Ubuntu 系統
```bash
# 安裝 Ubuntu 24.04 並啟用 BBR
bash InstallNET.sh -ubuntu 24.04 --bbr

# 配置雙棧網絡
bash InstallNET.sh -ubuntu 24.04 --networkstack BiStack --ip-addr 192.168.1.100 --ip6-addr 2001:db8::100
```

### 3.3 安裝 Alpine Linux
```bash
# 安裝 Alpine Edge 版本
bash InstallNET.sh -alpine edge -pwd mypassword

# 啟用安全防護
bash InstallNET.sh -alpine edge --fail2ban --kejilion
```

### 3.4 安裝 Windows 系統
```bash
# DD 模式安裝 Windows
bash InstallNET.sh -windows 11 -lang en
```

## 4. 注意事項
1. 執行腳本需要 root 權限
2. 安裝過程會清除硬碟數據，請提前備份
3. 確保網絡暢通且帶寬充足
4. IPv6 配置需要網絡環境支援
5. 部分功能可能因硬體限制無法使用
6. 建議使用穩定版本以避免兼容性問題
7. Windows 安裝僅支持 x86_64 架構

## 5. 錯誤處理
1. 檢查安裝日誌
```bash
tail -f /var/log/syslog
```

2. 檢查網絡連接
```bash
# IPv4 連接測試
ping -4 dl-cdn.alpinelinux.org

# IPv6 連接測試
ping -6 dl-cdn.alpinelinux.org
```

3. 檢查硬體資訊
```bash
lscpu        # CPU 資訊
free -h      # 記憶體資訊
lsblk        # 硬碟資訊
```

## 6. 進階配置
### 6.1 自定義分區
```bash
# 設置 RAID
--raid [0/1/5/6/10]

# 設置檔案系統
--filesystem [ext4/xfs]

# 設置分區表
--partition [mbr/gpt]
```

### 6.2 網絡優化
```bash
# 啟用 BBR 並優化網絡參數
--bbr
--networkstack BiStack
```

### 6.3 安全加固
```bash
# 安裝安全組件
--fail2ban
--motd
```

### 6.4 系統優化
```bash
# 安裝輔助工具
--kejilion

# 設置時區
--timezone Asia/Taipei
```

### 6.5 其他選項
```bash
# 設置無人職守自動安裝
--reboot
```