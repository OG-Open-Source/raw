#!/bin/bash
# © 2024 OG|OS OGATA-Open-Source
# curl -sSL https://raw.ogtt.tk/shell/function.sh -o function.sh
# source function.sh

CLEAN() { cd ~; clear; }
INPUT() { read -p "$1" "$2"; }

FONT() {
    local FONT=""
    declare -A STYLE=(
        [B]="\e[1m" [U]="\e[4m" 
        [BLACK]="\e[30m" [RED]="\e[31m" [GREEN]="\e[32m"
        [YELLOW]="\e[33m" [BLUE]="\e[34m" [PINK]="\e[35m"
        [SKYBLUE]="\e[36m" [GRAY]="\e[37m" [CYAN]="\e[96m" 
        [BG.BLACK]="\e[40m" [BG.RED]="\e[41m" [BG.GREEN]="\e[42m"
        [BG.YELLOW]="\e[43m" [BG.BLUE]="\e[44m" [BG.PINK]="\e[45m"
        [BG.SKYBLUE]="\e[46m" [BG.GRAY]="\e[47m"
    )
    for arg in "$@"; do
        FONT+="${STYLE[$arg]}"
    done
    echo -e "${FONT}${arg}\e[0m"
}

TEXT=()
for i in "${!TEXT[@]}"; do
    printf "$(FONT CYAN "%3d.") %s\n" $((i + 1)) "${TEXT[i]}"
done