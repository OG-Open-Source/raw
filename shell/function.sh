#!/bin/bash
# FILE="function.sh"
# [ ! -f "$FILE" ] && curl -sSL "https://raw.ogtt.tk/shell/function.sh" -o "$FILE"
# [ -f "$FILE" ] && source "$FILE"
COPYRIGHT() { echo "Copyright (C) 2024 OG|OS OGATA-Open-Source. All Rights Reserved."; }

CLR1="\033[31m"
CLR2="\033[32m"
CLR3="\033[0;33m"
CLR4="\033[34m"
CLR5="\033[35m"
CLR6="\033[36m"
CLR7="\033[37m"
CLR8="\033[96m"
CLR9="\033[97m"
CLR0="\033[0m"

ADD() {
	[ $# -eq 0 ] && return
	for app in "$@"; do
		echo -e "${CLR3}INSTALL [$app]${CLR0}"
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
		echo -e "${CLR2}FINISHED${CLR0}"
		echo
	done
}
DEL() {
	[ $# -eq 0 ] && return
	for app in "$@"; do
		echo -e "${CLR3}REMOVE [$app]${CLR0}"
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
		echo -e "${CLR2}FINISHED${CLR0}"
		echo
	done
}
CHECK_ROOT() {
	[ "$(id -u)" -ne 0 ] && { echo -e "${CLR1}Please run this script as root user.${CLR0}"; exit 1; }
	echo
}
CLEAN() {
	cd ~
	clear
}
LINE() {
	printf '%*s' "$2" '' | tr ' ' "$1"
}
FONT() {
	font=""
	declare -A style=(
		[B]="\033[1m" [U]="\033[4m"
		[BLACK]="\033[30m" [RED]="\033[31m" [GREEN]="\033[32m" [YELLOW]="\033[33m"
		[BLUE]="\033[34m" [PURPLE]="\033[35m" [CYAN]="\033[36m" [WHITE]="\033[37m"
		[L.BLACK]="\033[90m" [L.RED]="\033[91m" [L.GREEN]="\033[92m" [L.YELLOW]="\033[93m"
		[L.BLUE]="\033[94m" [L.PURPLE]="\033[95m" [L.CYAN]="\033[96m" [L.WHITE]="\033[97m"
		[BG.BLACK]="\033[40m" [BG.RED]="\033[41m" [BG.GREEN]="\033[42m" [BG.YELLOW]="\033[43m"
		[BG.BLUE]="\033[44m" [BG.PURPLE]="\033[45m" [BG.CYAN]="\033[46m" [BG.WHITE]="\033[47m"
		[L.BG.BLACK]="\033[100m" [L.BG.RED]="\033[101m" [L.BG.GREEN]="\033[102m" [L.BG.YELLOW]="\033[103m"
		[L.BG.BLUE]="\033[104m" [L.BG.PURPLE]="\033[105m" [L.BG.CYAN]="\033[106m" [L.BG.WHITE]="\033[107m"
	)
	while [[ $# -gt 1 ]]; do
		case "$1" in
			RGB)
				shift
				[[ "$1" =~ ^([0-9]{1,3}),([0-9]{1,3}),([0-9]{1,3})$ ]] && font+="\033[38;2;${BASH_REMATCH[1]};${BASH_REMATCH[2]};${BASH_REMATCH[3]}m"
				;;
			BG.RGB)
				shift
				[[ "$1" =~ ^([0-9]{1,3}),([0-9]{1,3}),([0-9]{1,3})$ ]] && font+="\033[48;2;${BASH_REMATCH[1]};${BASH_REMATCH[2]};${BASH_REMATCH[3]}m"
				;;
			*)
				font+="${style[$1]:-}"
				;;
		esac
		shift
	done
	echo -e "${font}${1}${CLR0}"
}
INPUT() {
	read -e -p "$1" "$2"
}
PROGRESS() {
	num_cmds=${#cmds[@]}
	term_width=$(tput cols)
	bar_width=$((term_width - 23))
	stty -echo
	trap '' SIGINT SIGQUIT SIGTSTP
	for ((i=0; i<num_cmds; i++)); do
		progress=$(( i * 100 / num_cmds ))
		filled_width=$((progress * bar_width / 100))
		printf "\r\033[30;42mProgress: [%3d%%]\033[0m [%s%s]" "$progress" "$(printf "%${filled_width}s" | tr ' ' '#')" "$(printf "%$((bar_width - filled_width))s" | tr ' ' '.')"
		if ! output=$(eval "${cmds[$i]}" 2>&1); then
		echo -e "\n$output"
		stty echo
		trap - SIGINT SIGQUIT SIGTSTP
		return 1
		fi
	done
	printf "\r\033[30;42mProgress: [100%%]\033[0m [%s]" "$(printf "%${bar_width}s" | tr ' ' '#')"
	printf "\r%${term_width}s\r"
	stty echo
	trap - SIGINT SIGQUIT SIGTSTP
}

SYS_CLEAN() {
	echo -e "${CLR3}Performing system cleanup...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	case $(command -v apk || command -v apt || command -v dnf || command -v opkg || command -v pacman || command -v yum || command -v zypper) in
		*apk) apk cache clean; rm -rf /tmp/* /var/cache/apk/* /var/log/* ;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				echo "Waiting for dpkg lock to be released..."
				sleep 1
			done
			DEBIAN_FRONTEND=noninteractive dpkg --configure -a
			apt autoremove --purge -y
			apt clean -y
			apt autoclean -y
			 ;;
		*dnf) dnf autoremove -y; dnf clean all; dnf makecache ;;
		*opkg) rm -rf /tmp/* /var/log/*; opkg update; opkg clean ;;
		*pacman) pacman -Sc --noconfirm; pacman -Scc --noconfirm ;;
		*yum) yum autoremove -y; yum clean all; yum makecache ;;
		*zypper) zypper clean --all; zypper refresh ;;
		*) return 1 ;;
	esac

	if command -v journalctl &>/dev/null; then
		journalctl --rotate
		journalctl --vacuum-time=1d
		journalctl --vacuum-size=500M
	fi

	find /var/log -type f -delete
	rm -rf /tmp/*
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
}

SYS_INFO() {
	echo -e "${CLR3}System Information${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "Hostname:         ${CLR2}$(hostname)${CLR0}"
	echo -e "Operating System: ${CLR2}$(grep '^NAME=' /etc/*release | cut -d'=' -f2 | tr -d '\"') $(if [ -f /etc/debian_version ]; then echo "Debian $(cat /etc/debian_version)"; elif command -v lsb_release >/dev/null 2>&1; then lsb_release -d | cut -f2; else grep '^VERSION=' /etc/*release | cut -d'=' -f2 | tr -d '\"'; fi)${CLR0}"
	echo -e "Kernel Version:   ${CLR2}$(uname -r)${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "Architecture:     ${CLR2}$(uname -m)${CLR0}"
	echo -e "CPU Model:        ${CLR2}$(lscpu | awk -F': +' '/Model name:/ {print $2; exit}')${CLR0}"
	echo -e "CPU Cores:        ${CLR2}$(nproc)${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "Total Memory:     ${CLR2}$(free -h | awk '/^Mem:/ {print $3}' | sed 's/Gi/GiB/g' | sed 's/Mi/MiB/g') / $(free -h | awk '/^Mem:/ {print $2}' | sed 's/Gi/GiB/g' | sed 's/Mi/MiB/g')${CLR0}"
	echo -e "Memory Usage:     ${CLR2}$(free | awk '/^Mem:/ {printf("%.2f"), $3/$2 * 100.0}')%${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "Total Storage:    ${CLR2}$(df -h | awk '$NF=="/"{printf "%s", $3}' | sed 's/G/GiB/g' | sed 's/M/MiB/g') / $(df -h | awk '$NF=="/"{printf "%s", $2}' | sed 's/G/GiB/g' | sed 's/M/MiB/g')${CLR0}"
	echo -e "Disk Usage:       ${CLR2}$(df -h | awk '$NF=="/"{printf "%.2f", $3/$2 * 100}')%${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	loc=$(curl -s ipinfo.io)
	echo -e "IPv4 Address:     ${CLR2}$(echo "$loc" | jq -r .ip)${CLR0}"
	echo -e "IPv6 Address:     ${CLR2}$(curl -s ipv6.ip.sb)${CLR0}"
	echo -e "Location:         ${CLR2}$(echo "$loc" | jq -r .city), $(echo "$loc" | jq -r .country)${CLR0}"
	echo -e "Timezone:         ${CLR2}$(readlink /etc/localtime | sed 's/^.*zoneinfo\///' 2>/dev/null)${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "Uptime:           ${CLR2}$(uptime -p | sed 's/up //')${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
}

SYS_UPDATE() {
	echo -e "${CLR3}Updating system software...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	case $(command -v apk || command -v apt || command -v dnf || command -v opkg || command -v pacman || command -v yum || command -v zypper) in
		*apk) apk update && apk upgrade ;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				sleep 1
			done
			DEBIAN_FRONTEND=noninteractive apt update -y && apt full-upgrade -y ;;
		*dnf) dnf -y update ;;
		*opkg) opkg update && opkg upgrade ;;
		*pacman) pacman -Syu --noconfirm ;;
		*yum) yum -y update ;;
		*zypper) zypper refresh && zypper update ;;
		*) return 1 ;;
	esac
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
}

TIMEZONE() {
	readlink /etc/localtime | sed 's/^.*zoneinfo\///' 2>/dev/null
}