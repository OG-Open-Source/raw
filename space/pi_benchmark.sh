#!/bin/bash

# [ -f ~/utilkit.sh ] && source ~/utilkit.sh || bash <(curl -sL raw.ogtt.tk/shell/update-utilkit.sh) && source ~/utilkit.sh

# 設定預設值
DEFAULT_DURATION=10      # 預設執行時間(秒)
DEFAULT_SCALE=1000       # 預設精確度
DEFAULT_THREADS=$(nproc) # 預設使用所有可用 CPU 核心

# 顯示使用方法
show_usage() {
    echo "用法:$0 [-t 執行時間] [-s 精確度] [-p 執行緒數]"
    echo "選項:"
    echo "  -t:執行時間(秒),預設為 ${DEFAULT_DURATION} 秒"
    echo "  -s:計算精確度,預設為 ${DEFAULT_SCALE} 位"
    echo "  -p:並行執行緒數,預設為 ${DEFAULT_THREADS} 個"
    exit 1
}

# 解析命令列參數
DURATION=$DEFAULT_DURATION
SCALE=$DEFAULT_SCALE
THREADS=$DEFAULT_THREADS

while getopts "t:s:p:h" opt; do
    case $opt in
    t) DURATION=$OPTARG ;;
    s) SCALE=$OPTARG ;;
    p) THREADS=$OPTARG ;;
    h) show_usage ;;
    ?) show_usage ;;
    esac
done

# 計算圓周率的函數
calculate_pi() {
    local scale=$1
    echo "scale=$scale; 4*a(1)" | bc -l
}

# 建立暫存目錄和進程控制檔案
TEMP_DIR=$(mktemp -d)
CONTROL_FILE="$TEMP_DIR/running"
RESULT_FILE="$TEMP_DIR/final_result"

# 初始化控制檔案
echo "1" >"$CONTROL_FILE"

# 確保清理所有資源和進程
cleanup() {
    # 先標記停止
    echo "0" >"$CONTROL_FILE"

    # 等待所有背景進程完成
    for pid in ${pids[@]}; do
        wait $pid 2>/dev/null
    done

    # 最後清理資源
    rm -rf "$TEMP_DIR"
}

# 捕獲信號
trap cleanup EXIT INT TERM

# 主要執行邏輯
echo "開始進行圓周率多核心計算效能測試"
echo "執行時間:${DURATION} 秒"
echo "計算精確度:${SCALE} 位"
echo "執行緒數:${THREADS}"
echo "----------------------------"

# 重定向標準錯誤輸出
exec 3>&2
exec 2>/dev/null

start_time=$(date +%s.%N)
declare -a pids=()

# 啟動多個背景進程
for ((i = 1; i <= THREADS; i++)); do
    {
        iterations=0
        last_result=""

        while [ -f "$CONTROL_FILE" ] && [ "$(cat $CONTROL_FILE 2>/dev/null)" = "1" ]; do
            # 計算並保存結果
            last_result=$(calculate_pi $SCALE)
            iterations=$((iterations + 1))

            # 定期保存進度(每10次迭代)
            if [ $((iterations % 10)) -eq 0 ]; then
                echo "$iterations" >"$TEMP_DIR/count_$i"
                echo "$last_result" >"$TEMP_DIR/result_$i"
            fi
        done

        # 最終保存結果
        echo "$iterations" >"$TEMP_DIR/count_$i"
        echo "$last_result" >"$TEMP_DIR/result_$i"
    } &>/dev/null &

    # 保存進程 ID
    pids+=($!)
done

# 設定定時器(靜默執行)
(
    sleep $DURATION
    echo "0" >"$CONTROL_FILE"
) &>/dev/null &
timer_pid=$!

# 等待所有進程完成
for pid in ${pids[@]}; do
    wait $pid 2>/dev/null
done
wait $timer_pid 2>/dev/null

# 恢復標準錯誤輸出
exec 2>&3
exec 3>&-

end_time=$(date +%s.%N)
total_time=$(echo "$end_time - $start_time" | bc)

# 計算總迭代次數
total_iterations=0
last_result=""

for ((i = 1; i <= THREADS; i++)); do
    if [ -f "$TEMP_DIR/count_$i" ]; then
        count=$(cat "$TEMP_DIR/count_$i" 2>/dev/null || echo "0")
        total_iterations=$((total_iterations + count))

        # 保存最後一個有效結果
        if [ -f "$TEMP_DIR/result_$i" ]; then
            last_result=$(cat "$TEMP_DIR/result_$i")
        fi
    fi
done

# 輸出結果
echo -e "\n測試結果:"
echo "總執行次數:$total_iterations"
iterations_per_second=$(echo "scale=2; $total_iterations / $total_time" | bc)
echo "每秒執行次數:$iterations_per_second"
echo "實際執行時間:$total_time 秒"
echo -n "最後計算的圓周率值:"
if [ -n "$last_result" ]; then
    # 移除所有反斜線和換行符號,以單行顯示
    echo "$last_result" | tr -d '\\\n'
else
    echo "無法取得計算結果"
fi
echo # 新增一個空行

# 系統資訊收集
echo -e "\n\n系統資訊:"
echo "CPU 型號:$(CPU_MODEL)"
echo "CPU 核心數:$(nproc)"
echo "CPU 目前頻率:$(CPU_FREQ)"
echo "CPU 負載:$(LOAD_AVERAGE)"
echo "記憶體使用率:$(MEM_USAGE)"
echo "作業系統:$(CHECK_OS)"

# 顯示 CPU 快取大小
echo -e "\nCPU 快取資訊:"
echo "L1d 快取:$(getconf LEVEL1_DCACHE_SIZE 2>/dev/null || echo "無法取得") bytes"
echo "L1i 快取:$(getconf LEVEL1_ICACHE_SIZE 2>/dev/null || echo "無法取得") bytes"
echo "L2 快取:$(getconf LEVEL2_CACHE_SIZE 2>/dev/null || echo "無法取得") bytes"
echo "L3 快取:$(getconf LEVEL3_CACHE_SIZE 2>/dev/null || echo "無法取得") bytes"

# 如果有 GPU,顯示 GPU 資訊
if command -v nvidia-smi &>/dev/null; then
    echo -e "\nGPU 資訊:"
    nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu,memory.used,memory.total --format=csv,noheader
fi
