# netreinstall.sh by OG-Open-Source

一鍵網絡重裝多系統腳本，支援 Debian/Ubuntu/Kali/CentOS/Rocky/AlmaLinux/Fedora/Alpine/Windows。

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

netreinstall.sh 是一個強大的網絡重裝系統腳本，支援多種 Linux 發行版和 Windows 系統的網絡重裝，提供了豐富的自定義選項和網絡配置功能。

## 特性

- 支援多種 Linux 發行版網絡重裝
  - Debian 7-12
  - Ubuntu 20.04/22.04/24.04
  - Kali rolling/dev
  - CentOS 7-9
  - Rocky Linux 8-9
  - AlmaLinux 8.10/9.4
  - Fedora 39/40
  - Alpine Linux 3.16-3.20/edge
- 支援 Windows DD 模式安裝
- 支援 IPv4/IPv6 雙棧網絡配置
- 支援 DHCP 和靜態 IP 配置
- 支援 UEFI 和 Legacy BIOS 引導
- 支援自定義 root 密碼和 SSH 端口
- 支援 BBR 加速和系統優化
- 支援 fail2ban 安全防護

## 安裝

```bash
curl -sSLO "https://raw.ogtt.tk/shell/netreinstall.sh"
chmod +x netreinstall.sh
```

## 使用方法

### 基本語法

```bash
bash netreinstall.sh [選項] [參數]
```

### 主要選項

```bash
# Linux 發行版選擇
-debian [7/8/9/10/11/12] 安裝 Debian 系統('12'為穩定版)
-ubuntu [20.04/22.04/24.04] 安裝 Ubuntu 系統('24.04'為穩定版)
-kali [rolling/dev] 安裝 Kali Linux('rolling'為穩定版)
-centos [7/8/9] 安裝 CentOS 系統('9'為穩定版)
-rocky [8/9] 安裝 Rocky Linux('9'為穩定版)
-alma [8.10/9.4] 安裝 AlmaLinux('9.4'為穩定版)
-fedora [39/40] 安裝 Fedora Linux('40'為穩定版)
-alpine [3.16~3.20/edge] 安裝 Alpine Linux('edge'為穩定版)
-windows [DIST] 安裝 Windows 系統

# 系統架構
-architecture [32/i386|64/amd64|arm/arm64] 指定系統架構

# 網絡配置
--ip-addr [IP] 設置 IPv4 地址
--ip-mask [24-32] 設置子網掩碼
--ip-gate [IP] 設置網關
--ip-dns [DNS] 設置 DNS 伺服器
--ip-set [IP] [24-32] [IP] 簡化 IPv4 配置
--ip6-addr [IPv6] 設置 IPv6 地址
--ip6-mask [1-128] 設置 IPv6 子網掩碼
--ip6-gate [IPv6] 設置 IPv6 網關
--ip6-dns [IPv6] 設置 IPv6 DNS 伺服器
--ip6-set [IPv6] [1-128] [IPv6] 簡化 IPv6 配置
--networkstack [IPv4Stack/IPv6Stack/BiStack] 指定網絡協議棧

# 系統優化
--bbr 啟用 BBR 擁塞控制
--fail2ban 安裝並配置 fail2ban
--kejilion 安裝並配置 kejilion.sh (來源 kejilion.pro/kejilion.sh)

# 其他選項
-mirror [URL] 指定鏡像源
-pwd [PASSWORD] 設置 root 密碼
-port [PORT] 設置 SSH 端口
--timezone [TIMEZONE] 設置時區
--hostname [NAME] 設置主機名
--motd 設置登入歡迎信息
--reboot 安裝完成後自動重啟
```

## 示例

### 安裝 Debian 系統

```bash
# 安裝最新穩定版 Debian 12
bash netreinstall.sh -debian 12 -pwd mypassword

# 使用自定義網絡配置
bash netreinstall.sh -debian 12 --ip-addr 192.168.1.100 --ip-mask 24 --ip-gate 192.168.1.1 --ip-dns "1.1.1.1 8.8.8.8"

# 同時安裝多個選項並使用 reboot 重啟
bash netreinstall.sh -debian 12 -pwd mypassword --bbr --fail2ban --kejilion --ip-set 192.168.1.101 24 192.168.1.1 --ip6-set 2001:db8::101 64 2001:db8::1 --reboot
```

### 安裝 Ubuntu 系統

```bash
# 安裝 Ubuntu 24.04 並啟用 BBR
bash netreinstall.sh -ubuntu 24.04 --bbr

# 配置雙棧網絡
bash netreinstall.sh -ubuntu 24.04 --networkstack BiStack --ip-addr 192.168.1.100 --ip6-addr 2001:db8::100
```

### 安裝 Alpine Linux

```bash
# 安裝 Alpine Edge 版本
bash netreinstall.sh -alpine edge -pwd mypassword

# 啟用安全防護
bash netreinstall.sh -alpine edge --fail2ban
```

### 安裝 Windows 系統

```bash
# DD 模式安裝 Windows
bash netreinstall.sh -windows 11 -lang en
```

## 配置

### 網絡配置

腳本支援多種網絡配置方式：

1. DHCP 自動獲取
2. 靜態 IP 配置
3. IPv4/IPv6 雙棧配置
4. 多 IP 配置

### 系統優化

1. BBR 加速
2. fail2ban 防護
3. kejilion 工具集

## 常見問題

### Q：安裝過程中提示記憶體不足？
A：最低要求為 384MB，建議 512MB 以上。

### Q：如何選擇合適的網絡配置？
A：一般情況下自動設定，如需固定 IP 則使用靜態配置。

### Q：支援哪些硬體架構？
A：支援 x86_64/amd64、i386/x86、arm64/aarch64 架構。

## 貢獻指南

1. Fork 本項目
2. 創建您的特性分支
3. 提交您的更改
4. 推送到分支
5. 創建新的 Pull Request

## 許可證

本專案採用 GPL 許可證。