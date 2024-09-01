#!/bin/bash

# 讀取用戶輸入
read -p "請輸入內容: " user_input

# 將用戶輸入上傳到GitHub上的腳本
response=$(curl -s -X POST -d "input=$user_input" https://raw.ogtt.tk/Xray-Shell-Server.sh)

# 顯示來自GitHub腳本的回應
echo "來自GitHub腳本的回應: $response"