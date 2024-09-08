#!/bin/bash
# curl -sSL https://raw.ogtt.tk/shell/function.sh -o function.sh
# source function.sh
COPYRIGHT() { echo "© 2024 OG|OS OGATA-Open-Source"; }

ADD() {
  [ $# -eq 0 ] && return
  for app in "$@"; do
    echo -e "\e[33mINSTALL [$app]\e[0m"
    case $(command -v apk || command -v apt || command -v dnf || command -v opkg || command -v pacman || command -v yum || command -v zypper) in
      *apk) apk info "$app" &>/dev/null || { apk update && apk add "$app"; } ;;
      *apt) dpkg -l | grep -qw "$app" || { apt update -y && apt install -y "$app"; } ;;
      *dnf) dnf list installed "$app" &>/dev/null || { dnf -y update && dnf install -y epel-release "$app"; } ;;
      *opkg) opkg list-installed | grep -qw "$app" || { opkg update && opkg install "$app"; } ;;
      *pacman) pacman -Q "$app" &>/dev/null || { pacman -Syu --noconfirm && pacman -S --noconfirm "$app"; } ;;
      *yum) yum list installed "$app" &>/dev/null || { yum -y update && yum install -y epel-release "$app"; } ;;
      *zypper) zypper se --installed-only "$app" &>/dev/null || { zypper refresh && zypper install -y "$app"; } ;;
      *) return ;;
    esac
    echo -e "\e[32mFINISHED\e[0m"
    echo
  done
}

CHECK_ROOT() {
  [ "$EUID" -ne 0 ] && { echo -e "\e[31mPlease run this script as root user.\e[0m"; exit 1; }
  echo
}
CLEAN() {
  cd ~
  clear
}

DEL() {
  [ $# -eq 0 ] && return
  for app in "$@"; do
    echo -e "\e[33mREMOVE [$app]\e[0m"
    case $(command -v apk || command -v apt || command -v dnf || command -v opkg || command -v pacman || command -v yum || command -v zypper) in
      *apk) apk info "$app" &>/dev/null && apk del "$app" ;;
      *apt) dpkg -l | grep -q "^ii  $app" && apt purge -y "$app" ;;
      *dnf) dnf list installed "$app" &>/dev/null && dnf remove -y "$app" ;;
      *opkg) opkg list-installed | grep -q "$app" && opkg remove "$app" ;;
      *pacman) pacman -Q "$app" &>/dev/null && pacman -Rns --noconfirm "$app" ;;
      *yum) yum list installed "$app" &>/dev/null && yum remove -y "$app" ;;
      *zypper) zypper se --installed-only "$app" | grep -q "$app" && zypper remove -y "$app" ;;
      *) return ;;
    esac
    echo -e "\e[32mFINISHED\e[0m"
    echo
  done
}

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

INPUT() {
  read -p "$1" "$2"
}

LINE() {
  printf '%*s' "$1" '' | tr ' ' '-'
}

SYS_INFO() {
  echo -e "\e[33mSystem Info:\e[0m"
  echo "OS: $(grep '^NAME=' /etc/*release | cut -d'=' -f2 | tr -d '\"') $(grep '^VERSION_ID=' /etc/*release | cut -d'=' -f2 | tr -d '\"')"
  echo "Hostname: $(hostname)"
  echo "Kernel: $(uname -r)"
  echo "Architecture: $(uname -m)"
  echo "CPU Count: $(nproc)"
  echo "Total Memory: $(free -h | awk '/^Mem:/ {print $2}' | sed 's/Gi/GiB/g' | sed 's/Mi/MiB/g')"
  echo "Disk Usage: $(df -h | awk '$NF=="/"{printf "%s\t\t", $3}' | sed 's/G/GiB/g' | sed 's/M/MiB/g')"
}

TIMEZONE() {
  readlink /etc/localtime | sed 's/^.*zoneinfo\///' 2>/dev/null
}