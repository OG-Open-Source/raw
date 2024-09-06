#!/bin/bash
# © 2024 OG|OS OGATA-Open-Source

GRAY() { echo -e "\e[37m$1\e[0m"; }
RED() { echo -e "\e[31m$1\e[0m"; }
YELLOW() { echo -e "\e[33m$1\e[0m"; }
CYAN() { echo -e "\e[96m$1\e[0m"; }
GREEN() { echo -e "\e[32m$1\e[0m"; }

text=(
    "普通文字"
    red=(
        "紅色文字"
        bof=(
            "粗體紅色文字"
        )
        uni=(
            "下劃線紅色文字"
        )
        bof_uni=(
            "粗體+下劃線紅色文字"
        )
    )
    green=(
        "綠色文字"
    )
    yellow=(
        "黃色文字"
    )
    blue=(
        "藍色文字"
    )
    cyan=(
        "青色文字"
    )
    bg_red=(
        "紅色背景白色文字"
    )
    bg_green=(
        "綠色背景白色文字"
    )
    bg_yellow=(
        "黃色背景黑色文字"
    )
    bg_blue=(
        "藍色背景白色文字"
    )
    bg_white=(
        "白色背景黑色文字"
    )
    uni=(
        "下劃線文字"
    )
    bof=(
        "粗體文字"
    )
    bof_uni=(
        "粗體+下劃線文字"
    )
    italic=(
        "斜體文字"
    )
    shadow=(
        "陰影文字"
    )
    blink=(
        "閃爍文字"
    )
)

# 文字樣式函數
TEXT() {
    local style=$1
    local text=$2
    case $style in
        normal) echo "$text" ;;
        red) echo -e "\e[31m$text\e[0m" ;;
        green) echo -e "\e[32m$text\e[0m" ;;
        yellow) echo -e "\e[33m$text\e[0m" ;;
        blue) echo -e "\e[34m$text\e[0m" ;;
        cyan) echo -e "\e[36m$text\e[0m" ;;
        bof) echo -e "\e[1m$text\e[0m" ;;
        uni) echo -e "\e[4m$text\e[0m" ;;
        bg_red) echo -e "\e[41m$text\e[0m" ;;
        bg_green) echo -e "\e[42m$text\e[0m" ;;
        bg_yellow) echo -e "\e[43m\e[30m$text\e[0m" ;;
        bg_blue) echo -e "\e[44m$text\e[0m" ;;
        bg_white) echo -e "\e[47m\e[30m$text\e[0m" ;;
        blink) echo -e "\e[5m$text\e[0m" ;;
        italic) echo -e "\e[3m$text\e[0m" ;;
        shadow) echo -e "\e[2m$text\e[0m" ;;
        *) echo "未知樣式: $style" ;;
    esac
}

# 遞迴函數來處理嵌套的文字樣式
PRINT_TEXT() {
    local -n arr=$1
    for key in "${!arr[@]}"; do
        if [[ "$key" =~ ^[0-9]+$ ]]; then
            TEXT normal "${arr[$key]}"
        else
            if [[ "${arr[$key]}" == *"="* ]]; then
                PRINT_TEXT "${key}"
            else
                TEXT "$key" "${arr[$key]}"
            fi
        fi
    done
}

# 使用示例
PRINT_TEXT text
