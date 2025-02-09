# netreinstall.sh

一鍵網絡重裝多系統腳本，支援主流 Linux 發行版和 Windows。

---

## 目錄

- [簡介](#簡介)
- [特性](#特性)
- [安裝](#安裝)
- [使用方法](#使用方法)
- [示例](#示例)
- [配置](#配置)
- [常見問題](#常見問題)
- [Contributing](#contributing)
- [License](#license)

---

## 簡介

netreinstall.sh 是一個功能強大的網絡重裝系統工具，支援多種主流 Linux 發行版和 Windows 系統的網絡重裝，提供豐富的自定義選項和網絡配置功能。適用於需要快速部署或重裝系統的伺服器管理員。

## 特性

- 支援多種主流 Linux 發行版
  - Debian 10-12
  - Ubuntu 20.04/22.04/24.04
  - Kali rolling/dev
  - CentOS 7-9
  - Rocky Linux 8-9
  - AlmaLinux 8.10/9.4
  - Fedora 39/40
  - Alpine Linux 3.16-3.20/edge
- 支援 Windows DD 模式安裝
- 完整的網絡配置支援
  - IPv4/IPv6 雙棧
  - DHCP/靜態 IP
  - 多 IP 配置
- 系統優化與安全加固
  - BBR 加速
  - fail2ban 防護
  - kejilion 工具集

## 安裝

### 環境要求

- 記憶體：最低 384MB，建議 512MB 以上
- 硬碟：最低 10GB 可用空間
- 網絡：穩定的網絡連接
- 架構：支援 x86_64/amd64、i386/x86、arm64/aarch64

{:.important}
> 執行腳本前請確保有 root 權限，並備份重要數據。

```bash
curl -sSLO "https://raw.ogtt.tk/shell/netreinstall.sh"
chmod +x netreinstall.sh
```

## 使用方法

### 基本語法

```bash
bash netreinstall.sh [選項] [參數]
```

### 系統選擇

```bash
# Linux 發行版
-debian [10-12]             # Debian 系統
-ubuntu [20.04/22.04/24.04] # Ubuntu 系統
-kali [rolling/dev]         # Kali Linux
-centos [7-9]               # CentOS 系統
-rocky [8/9]                # Rocky Linux
-alma [8.10/9.4]            # AlmaLinux
-fedora [39/40]             # Fedora Linux
-alpine [3.16-3.20/edge]    # Alpine Linux
-windows [DIST]             # Windows 系統
```

### 網絡配置

```bash
# IPv4 配置
--ip-addr [IP]             # 設置 IPv4 地址
--ip-mask [24-32]          # 設置子網掩碼
--ip-gate [IP]             # 設置網關
--ip-dns [DNS]             # 設置 DNS 伺服器
--ip-set [IP] [24-32] [IP] # 快速 IPv4 配置

# IPv6 配置
--ip6-addr [IPv6]          # 設置 IPv6 地址
--ip6-mask [1-128]         # 設置 IPv6 子網掩碼
--ip6-gate [IPv6]          # 設置 IPv6 網關
--ip6-dns [IPv6]           # 設置 IPv6 DNS
```

### 系統優化

```bash
--bbr                      # 啟用 BBR 擁塞控制
--fail2ban                 # 安裝 fail2ban
--kejilion                 # 安裝 kejilion 工具集
```

## 示例

### Debian 安裝

```bash
# 基本安裝
bash netreinstall.sh -debian 12 -pwd mypassword

# 完整配置
bash netreinstall.sh -debian 12 \
 --ip-set 192.168.1.100 24 192.168.1.1 \
 --ip6-set 2001:db8::100 64 2001:db8::1 \
 --bbr --fail2ban --kejilion \
 --reboot
```

{:.tip}
> 使用 `--reboot` 參數可在安裝完成後自動重啟系統。

### Ubuntu 安裝

```bash
# 安裝最新版本
bash netreinstall.sh -ubuntu 24.04 --bbr

# 雙棧網絡配置
bash netreinstall.sh -ubuntu 24.04 \
 --networkstack BiStack \
 --ip-addr 192.168.1.100 \
 --ip6-addr 2001:db8::100
```

## 配置

### 網絡配置模式

1. DHCP 自動配置
2. 靜態 IP 配置
3. 雙棧網絡配置
4. 多 IP 配置

{:.caution}
> 使用靜態 IP 時，請確保配置的 IP 地址在網絡中未被佔用。

## 常見問題

**Q：安裝過程中記憶體不足？**  
A：最低需要 384MB 記憶體，建議使用 512MB 或更多。可以通過建立 swap 分區臨時解決。

**Q：如何選擇網絡配置模式？**  
A：

- 動態 IP：適合測試環境
- 靜態 IP：適合生產環境
- 雙棧網絡：需要同時支援 IPv4/IPv6 時使用

**Q：支援哪些硬體架構？**  
A：目前支援：

- x86_64/amd64
- i386/x86
- arm64/aarch64

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Open a Pull Request

## License

This repository is licensed under the [GPL License](https://www.gnu.org/licenses/gpl-3.0.html).

---

© 2025 [OG-Open-Source](https://github.com/OG-Open-Source). All rights reserved.
