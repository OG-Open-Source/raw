# DD Script by OG-Open-Source

## 1. 功能概述
- 支援重裝 Debian、Ubuntu、CentOS 等主流 Linux 發行版
- 支援 DD 模式安裝自定義鏡像
- 支援網絡配置(IPv4/IPv6)
- 支援自定義 SSH 端口
- 支援自定義 root 密碼
- 支援自定義硬碟分區
- 支援自定義 Grub 引導

## 2. 使用方法
### 2.1 基本語法
```bash
bash dd.sh [選項] [參數]
```

### 2.2 主要選項
```bash
# 發行版選擇
-d, --debian DIST     指定 Debian 發行版
-u, --ubuntu DIST     指定 Ubuntu 發行版  
-c, --centos DIST     指定 CentOS 發行版

# 系統版本
-v, --ver VER        指定系統版本(32/i386 或 64/amd64)

# DD 模式
-dd, --image URL     使用自定義鏡像 URL 進行安裝

# 網絡配置
--ip-addr IP         設置 IP 地址
--ip-gate GATEWAY    設置網關
--ip-mask MASK       設置子網掩碼
--ip-dns DNS         設置 DNS 伺服器

# 其他選項
-p PASSWORD          設置 root 密碼
-port PORT           設置 SSH 端口
--mirror             使用鏡像源
--noipv6             禁用 IPv6
```

## 3. 使用範例
### 3.1 安裝 Debian
```bash
# 安裝 Debian 11 (Bullseye)
bash dd.sh -d bullseye -v 64 -p mypassword

# 使用自定義網絡配置
bash dd.sh -d bullseye -v 64 --ip-addr 192.168.1.100 --ip-gate 192.168.1.1 --ip-mask 255.255.255.0 --ip-dns 8.8.8.8
```

### 3.2 安裝 Ubuntu
```bash
# 安裝 Ubuntu 22.04 (Jammy)
bash dd.sh -u jammy -v 64 -p mypassword

# 使用自定義 SSH 端口
bash dd.sh -u jammy -v 64 -port 2222
```

### 3.3 安裝 CentOS
```bash
# 安裝 CentOS 7
bash dd.sh -c 7 -v 64 -p mypassword

# 使用鏡像源
bash dd.sh -c 7 -v 64 --mirror http://mirror.centos.org/centos
```

### 3.4 DD 模式安裝
```bash
# 使用自定義鏡像
bash dd.sh -dd http://example.com/custom.img
```

## 4. 注意事項
1. 執行腳本需要 root 權限
2. DD 模式會清除所有硬碟數據，請謹慎使用
3. 建議在安裝前備份重要數據
4. 部分功能可能需要特定的硬體支援
5. 網絡配置請確保正確性，避免無法連接
6. 密碼建議使用複雜組合，提高安全性
7. 如使用自定義鏡像，請確保鏡像格式正確

## 5. 錯誤處理

1. 檢查系統日誌
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

3. 檢查硬碟空間
```bash
df -h
```

## 6. 進階配置
### 6.1 自定義分區
可以通過修改腳本中的分區設置來自定義硬碟分區方案：
```bash
d-i partman-auto/choose_recipe select atomic
```

### 6.2 自定義內核參數
可以通過修改 GRUB 配置來添加自定義內核參數：
```bash
d-i debian-installer/add-kernel-opts string net.ifnames=0 biosdevname=0
```

### 6.3 自定義安裝包
可以通過修改預設安裝包列表來自定義安裝：
```bash
d-i pkgsel/include string openssh-server
``` 