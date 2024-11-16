#!/bin/bash

# 載入 utilkit.sh
[ -f ~/utilkit.sh ] && source ~/utilkit.sh || bash <(curl -sL https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/update-utilkit.sh) && source ~/utilkit.sh

# 顏色定義
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NC="\033[0m"

# 測試結果計數器
PASSED=0
FAILED=0
TOTAL=0

# 測試函式
run_test() {
	local func="$1"
	local args="$2"
	local description="$3"
	local need_root="${4:-false}"
	local expected_return="${5:-0}"
	((TOTAL++))

	echo -e "${YELLOW}測試 $func $args${NC}"
	echo -e "描述：$description"
	echo -e "預期回傳值：$expected_return"

	if [ "$need_root" = true ] && [ "$(id -u)" -ne 0 ]; then
		echo -e "${YELLOW}跳過：需要 root 權限${NC}"
		return 0
	fi

	eval "$func $args"
	local actual_return=$?

	if [ "$actual_return" -eq "$expected_return" ]; then
		echo -e "${GREEN}✓ 通過 (回傳值: $actual_return)${NC}"
		((PASSED++))
	else
		echo -e "${RED}✗ 失敗 (預期: $expected_return, 實際: $actual_return)${NC}"
		((FAILED++))
	fi
	echo "------------------------"
}

rm -f test.txt rename.txt gtxt.sh file.txt
rm -rf test_dir

# 開始測試
# CLEAN 測試
run_test "CLEAN" "" "測試清理螢幕" false 0
echo "開始測試 utilkit.sh 函式..."
echo "=========================="

# ADD 函式測試
run_test "ADD" "-f test.txt" "測試建立檔案" false 0
run_test "ADD" "-d test_dir" "測試建立目錄" false 0
run_test "ADD" "curl wget checkinstall" "測試安裝套件" true 0
run_test "ADD" "-f /root/test.txt" "測試無權限建立檔案" false 1
run_test "ADD" "https://download.opensuse.org/repositories/home:/virtubox/Debian_12/amd64/nano_8.0-2_amd64.deb" "測試安裝 DEB 套件" true 0

# CHECK 相關函式測試
run_test "CHECK_OS" "" "測試檢查作業系統" false 0
run_test "CHECK_ROOT" "" "測試檢查 root 權限" false 0
run_test "CHECK_VIRT" "" "測試檢查虛擬化環境" false 0

# CHECK_DEPS 測試
run_test "deps=(curl wget);" "CHECK_DEPS" "測試檢查已安裝依賴" false 0
run_test "deps=(nonexistcmd);" "CHECK_DEPS" "測試檢查未安裝依賴" false 0

# CPU 相關函式測試
run_test "CPU_CACHE" "" "測試獲取 CPU 快取大小" false 0
run_test "CPU_FREQ" "" "測試獲取 CPU 頻率" false 0
run_test "CPU_MODEL" "" "測試獲取 CPU 型號" false 0
run_test "CPU_USAGE" "" "測試獲取 CPU 使用率" false 0

# CONVERT_SIZE 測試
run_test "CONVERT_SIZE" "1024 B" "測試轉換檔案大小 (Bytes)" false 0
run_test "CONVERT_SIZE" "1024 KB" "測試轉換檔案大小 (KB)" false 0
run_test "CONVERT_SIZE" "1024 MB" "測試轉換檔案大小 (MB)" false 0
run_test "CONVERT_SIZE" "1024 GB" "測試轉換檔案大小 (GB)" false 0
run_test "CONVERT_SIZE" "1024 TB" "測試轉換檔案大小 (TB)" false 0
run_test "CONVERT_SIZE" "1024 PB" "測試轉換檔案大小 (PB)" false 0
run_test "CONVERT_SIZE" "1024 KiB" "測試轉換檔案大小 (KiB)" false 0
run_test "CONVERT_SIZE" "1024 MiB" "測試轉換檔案大小 (MiB)" false 0
run_test "CONVERT_SIZE" "1024 GiB" "測試轉換檔案大小 (GiB)" false 0
run_test "CONVERT_SIZE" "1024 TiB" "測試轉換檔案大小 (TiB)" false 0
run_test "CONVERT_SIZE" "1024 PiB" "測試轉換檔案大小 (PiB)" false 0
run_test "CONVERT_SIZE" "-1024 KB" "測試負數大小轉換" false 1
run_test "CONVERT_SIZE" "abc KB" "測試無效輸入" false 1

# DEL 函式測試
run_test "DEL" "-f test.txt" "測試刪除檔案" false 0
run_test "DEL" "-d test_dir" "測試刪除目錄" false 0
run_test "DEL" "checkinstall" "測試移除套件" true 0
run_test "DEL" "-f /root/nonexist.txt" "測試刪除不存在檔案" false 1

# DISK_USAGE 測試
run_test "DISK_USAGE" "" "測試獲取磁碟使用情況" false 0

# DNS_ADDR 測試
run_test "DNS_ADDR" "" "測試獲取所有 DNS 伺服器位址" false 0
run_test "DNS_ADDR" "-4" "測試獲取 IPv4 DNS 伺服器" false 0
run_test "DNS_ADDR" "-6" "測試獲取 IPv6 DNS 伺服器" false 0

# FIND 測試
run_test "FIND" "bash" "測試搜尋套件" false 0
run_test "FIND" "" "測試空參數搜尋" false 1

# FONT 測試
run_test "FONT" "RED 測試文字" "測試紅色文字" false 0
run_test "FONT" "GREEN 測試文字" "測試綠色文字" false 0
run_test "FONT" "BLUE 測試文字" "測試藍色文字" false 0
run_test "FONT" "B 粗體測試" "測試粗體文字" false 0
run_test "FONT" "U 底線測試" "測試底線文字" false 0
run_test "FONT" "RGB 255,0,0 RGB顏色測試" "測試 RGB 顏色" false 0
run_test "FONT" "BG.RGB 255,0,0 RGB背景測試" "測試 RGB 背景" false 0
run_test "FONT" "L.RED 測試文字" "測試亮紅色文字" false 0
run_test "FONT" "BG.RED 測試文字" "測試紅色背景" false 0
run_test "FONT" "L.BG.RED 測試文字" "測試亮紅色背景" false 0
run_test "FONT" "INVALID 測試文字" "測試無效樣式" false 0

# GET 測試
run_test "GET" "https://raw.ogtt.tk/space/25mib.txt" "測試下載檔案" false 0
run_test "GET" "https://raw.ogtt.tk/space/25mib.txt -r rename.txt" "測試下載並重新命名檔案" false 0
run_test "GET" "https://raw.ogtt.tk/space/25mib.txt test_dir" "測試下載到指定目錄" false 0
run_test "GET" "https://nonexist.example.com/file.txt" "測試下載不存在檔案" false 1
run_test "GET" "raw.ogtt.tk/space/25mib.txt" "測試自動添加協議" false 0

# INPUT 測試
run_test "INPUT" "'測試輸入：' test_var <<< 'test'" "測試使用者輸入" false 0

# INTERFACE 測試
run_test "INTERFACE" "" "測試獲取網路介面" false 0
run_test "INTERFACE" "-i" "測試獲取網路介面詳細資訊" false 0
run_test "INTERFACE" "RX_BYTES" "測試獲取接收位元組數" false 0
run_test "INTERFACE" "RX_PACKETS" "測試獲取接收封包數" false 0
run_test "INTERFACE" "RX_DROP" "測試獲取接收丟棄數" false 0
run_test "INTERFACE" "TX_BYTES" "測試獲取傳送位元組數" false 0
run_test "INTERFACE" "TX_PACKETS" "測試獲取傳送封包數" false 0
run_test "INTERFACE" "TX_DROP" "測試獲取傳送丟棄數" false 0
run_test "INTERFACE" "INVALID" "測試無效參數" false 1

# IP_ADDR 測試
run_test "IP_ADDR" "" "測試獲取所有 IP 位址" false 0
run_test "IP_ADDR" "-4" "測試獲取 IPv4 位址" false 0
run_test "IP_ADDR" "-6" "測試獲取 IPv6 位址" false 1

# LAST_UPDATE 測試
run_test "LAST_UPDATE" "" "測試獲取最後更新時間" false 0

# LINE 測試
run_test "LINE" "-" "測試繪製預設長度分隔線" false 0
run_test "LINE" "= 50" "測試繪製指定長度分隔線" false 0

# LOAD_AVERAGE 測試
run_test "LOAD_AVERAGE" "" "測試獲取系統負載" false 0

# MAC_ADDR 測試
run_test "MAC_ADDR" "" "測試獲取 MAC 位址" false 0

# MEM_USAGE 測試
run_test "MEM_USAGE" "" "測試獲取記憶體使用情況" false 0

# NET_PROVIDER 測試
run_test "NET_PROVIDER" "" "測試獲取網路供應商" false 0

# PKG_COUNT 測試
run_test "PKG_COUNT" "" "測試獲取已安裝套件數量" false 0

# PROGRESS 測試
run_test "cmds=(\"sleep 1\" \"echo test\");" "PROGRESS" "測試進度條顯示" false 0
run_test "cmds=(\"invalid_command\");" "PROGRESS" "測試無效命令" false 1

# PUBLIC_IP 測試
run_test "PUBLIC_IP" "" "測試獲取公共 IP 位址" false 0

# RUN 測試
run_test "RUN" "echo 'test'" "測試執行本地命令" false 0
run_test "RUN" "OG-Open-Source/raw/space/gtxt.sh <<< '1024'" "測試執行遠端腳本" false 0
run_test "RUN" "OG-Open-Source/raw/space/gtxt.sh -b master" "測試使用指定分支" false 1
run_test "RUN" "OG-Open-Source/raw/space/gtxt.sh -b main -- 1024" "測試傳遞參數" false 0
run_test "RUN" "./utilkit.sh" "測試執行存在本地腳本" false 0
run_test "RUN" "./gttxt.sh" "測試執行不存在本地腳本" false 127

# SHELL_VER 測試
run_test "SHELL_VER" "" "測試獲取 Shell 版本" false 0

# SWAP_USAGE 測試
run_test "SWAP_USAGE" "" "測試獲取 SWAP 使用情況" false 0

# SYS 相關函式測試
run_test "SYS_CLEAN" "" "測試系統清理" true 0
run_test "SYS_INFO" "" "測試顯示系統資訊" false 0
run_test "SYS_OPTIMIZE" "" "測試系統最佳化" true 1
run_test "SYS_REBOOT" "<<< 'n'" "測試系統重啟（取消）" true 0
run_test "SYS_UPDATE" "" "測試系統更新" true 0

# TIMEZONE 測試
run_test "TIMEZONE" "" "測試獲取預設時區" false 0
run_test "TIMEZONE" "-i" "測試獲取內部時區" false 0
run_test "TIMEZONE" "-e" "測試獲取外部時區" false 0

# error 函式測試
run_test "error" "\"測試錯誤訊息\"" "測試錯誤訊息輸出" false 1

# 顯示測試結果摘要
echo "=========================="
echo -e "測試完成！"
echo -e "總計測試：${TOTAL}"
echo -e "${GREEN}通過：${PASSED}${NC}"
echo -e "${RED}失敗：${FAILED}${NC}"
echo "=========================="

# 清理測試檔案
rm -f test.txt rename.txt gtxt.sh
rm -rf test_dir

exit $((FAILED > 0))