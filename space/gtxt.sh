#!/bin/bash

# 設定預設輸出檔案名稱
output_file="text.txt"

# 檢查是否有命令列參數
if [ $# -eq 1 ] && [[ $1 =~ ^[0-9]+$ ]]; then
	word_count=$1
else
	# 互動式輸入
	while true; do
		read -p "請輸入要生成的字數: " word_count
		if [[ $word_count =~ ^[0-9]+$ ]] && [ $word_count -gt 0 ]; then
			break
		fi
		echo "輸入無效，請輸入數字。"
	done
fi

# 記錄開始時間
start_time=$(date +%s.%N)

# 生成隨機文字，使用更有效率的方式
< /dev/urandom LC_ALL=C tr -dc 'a-zA-Z0-9' | head -c $word_count > "$output_file"
echo >> "$output_file"

# 記錄結束時間並計算執行時間
end_time=$(date +%s.%N)
execution_time=$(echo "$end_time - $start_time" | bc)

# 確認檔案是否成功生成
if [ -f "$output_file" ]; then
	echo "已成功生成 $word_count 字的隨機文字到檔案 $output_file 中。"
	echo "執行時間: ${execution_time} 秒"
else
	echo "檔案生成失敗。"
	exit 1
fi
