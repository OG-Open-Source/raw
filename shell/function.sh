#!/bin/bash
# FILE="function.sh"
# [ ! -f "$FILE" ] && curl -sSL "https://raw.ogtt.tk/shell/function.sh" -o "$FILE"
# [ -f "$FILE" ] && source "$FILE"
COPYRIGHT() { echo "Copyright (C) 2024 OG|OS OGATA-Open-Source. All Rights Reserved."; }

ADD() {
	[ $# -eq 0 ] && return
	for app in "$@"; do
		echo -e "\033[33mINSTALL [$app]\033[0m"
		case $(command -v apk || command -v apt || command -v dnf || command -v opkg || command -v pacman || command -v yum || command -v zypper) in
			*apk) apk info "$app" &>/dev/null || { apk update && apk add "$app"; };;
			*apt) dpkg -l | grep -qw "$app" || { apt update -y && apt install -y "$app"; };;
			*dnf) dnf list installed "$app" &>/dev/null || { dnf -y update && dnf install -y epel-release "$app"; };;
			*opkg) opkg list-installed | grep -qw "$app" || { opkg update && opkg install "$app"; };;
			*pacman) pacman -Q "$app" &>/dev/null || { pacman -Syu --noconfirm && pacman -S --noconfirm "$app"; };;
			*yum) yum list installed "$app" &>/dev/null || { yum -y update && yum install -y epel-release "$app"; };;
			*zypper) zypper se --installed-only "$app" &>/dev/null || { zypper refresh && zypper install -y "$app"; };;
			*) return;;
		esac
		echo -e "\033[32mFINISHED\033[0m"
		echo
	done
}

CHECK_ROOT() {
	[ "$(id -u)" -ne 0 ] && { echo -e "\033[31mPlease run this script as root user.\033[0m"; exit 1; }
	echo
}
CLEAN() {
	cd ~
	clear
}

DEL() {
	[ $# -eq 0 ] && return
	for app in "$@"; do
		echo -e "\033[33mREMOVE [$app]\033[0m"
		case $(command -v apk || command -v apt || command -v dnf || command -v opkg || command -v pacman || command -v yum || command -v zypper) in
			*apk) apk info "$app" &>/dev/null && apk del "$app";;
			*apt) dpkg -l | grep -q "^ii  $app" && apt purge -y "$app";;
			*dnf) dnf list installed "$app" &>/dev/null && dnf remove -y "$app";;
			*opkg) opkg list-installed | grep -q "$app" && opkg remove "$app";;
			*pacman) pacman -Q "$app" &>/dev/null && pacman -Rns --noconfirm "$app";;
			*yum) yum list installed "$app" &>/dev/null && yum remove -y "$app";;
			*zypper) zypper se --installed-only "$app" | grep -q "$app" && zypper remove -y "$app";;
			*) return;;
		esac
		echo -e "\033[32mFINISHED\033[0m"
		echo
	done
}

FONT() {
	local FONT=""
	declare -A STYLE=(
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
				[[ "$1" =~ ^([0-9]{1,3}),([0-9]{1,3}),([0-9]{1,3})$ ]] && FONT+="\033[38;2;${BASH_REMATCH[1]};${BASH_REMATCH[2]};${BASH_REMATCH[3]}m"
				;;
			BG.RGB)
				shift
				[[ "$1" =~ ^([0-9]{1,3}),([0-9]{1,3}),([0-9]{1,3})$ ]] && FONT+="\033[48;2;${BASH_REMATCH[1]};${BASH_REMATCH[2]};${BASH_REMATCH[3]}m"
				;;
			*)
				FONT+="${STYLE[$1]:-}"
				;;
		esac
		shift
	done
	echo -e "${FONT}${1}\033[0m"
}

INPUT() {
	read -e -p "$1" "$2"
}

LINE() {
	printf '%*s' "$2" '' | tr ' ' "$1"
}

SYS_CLEAN() {
	echo -e "\033[33mPerforming system cleanup...\033[0m"
	echo -e "\033[96m========================\033[0m"
	case $(command -v apk || command -v apt || command -v dnf || command -v opkg || command -v pacman || command -v yum || command -v zypper) in
		*apk) apk cache clean; rm -rf /tmp/* /var/cache/apk/* /var/log/*;;
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
		*dnf) dnf autoremove -y; dnf clean all; dnf makecache;;
		*opkg) rm -rf /tmp/* /var/log/*; opkg update; opkg clean;;
		*pacman) pacman -Sc --noconfirm; pacman -Scc --noconfirm;;
		*yum) yum autoremove -y; yum clean all; yum makecache;;
		*zypper) zypper clean --all; zypper refresh;;
		*) return 1;;
	esac

	if command -v journalctl &>/dev/null; then
		journalctl --rotate
		journalctl --vacuum-time=1d
		journalctl --vacuum-size=500M
	fi

	find /var/log -type f -delete
	rm -rf /tmp/*
	echo -e "\033[96m========================\033[0m"
}
SYS_INFO() {
	echo -e "\033[33mSystem Information\033[0m"
	echo -e "\033[96m========================\033[0m"
	echo -e "Hostname:         \033[32m$(hostname)\033[0m"
	echo -e "Operating System: \033[32m$(grep '^NAME=' /etc/*release | cut -d'=' -f2 | tr -d '\"') $(if [ -f /etc/debian_version ]; then echo "Debian $(cat /etc/debian_version)"; elif command -v lsb_release >/dev/null 2>&1; then lsb_release -d | cut -f2; else grep '^VERSION=' /etc/*release | cut -d'=' -f2 | tr -d '\"'; fi)\033[0m"
	echo -e "Kernel Version:   \033[32m$(uname -r)\033[0m"
	echo -e "\033[96m--------------------------------\033[0m"
	echo -e "Architecture:     \033[32m$(uname -m)\033[0m"
	echo -e "CPU Model:        \033[32m$(lscpu | awk -F': +' '/Model name:/ {print $2; exit}')\033[0m"
	echo -e "CPU Cores:        \033[32m$(nproc)\033[0m"
	echo -e "\033[96m--------------------------------\033[0m"
	echo -e "Total Memory:     \033[32m$(free -h | awk '/^Mem:/ {print $3}' | sed 's/Gi/GiB/g' | sed 's/Mi/MiB/g') / $(free -h | awk '/^Mem:/ {print $2}' | sed 's/Gi/GiB/g' | sed 's/Mi/MiB/g')\033[0m"
	echo -e "Memory Usage:     \033[32m$(free | awk '/^Mem:/ {printf("%.2f"), $3/$2 * 100.0}')%\033[0m"
	echo -e "\033[96m--------------------------------\033[0m"
	echo -e "Total Storage:    \033[32m$(df -h | awk '$NF=="/"{printf "%s", $3}' | sed 's/G/GiB/g' | sed 's/M/MiB/g') / $(df -h | awk '$NF=="/"{printf "%s", $2}' | sed 's/G/GiB/g' | sed 's/M/MiB/g')\033[0m"
	echo -e "Disk Usage:       \033[32m$(df -h | awk '$NF=="/"{printf "%.2f", $3/$2 * 100}')%\033[0m"
	echo -e "\033[96m--------------------------------\033[0m"
	LOCATION_DATA=$(curl -s ipinfo.io)
	echo -e "IPv4 Address:     \033[32m$(echo "$LOCATION_DATA" | jq -r .ip)\033[0m"
	echo -e "IPv6 Address:     \033[32m$(curl -s ipv6.ip.sb)\033[0m"
	echo -e "Location:         \033[32m$(echo "$LOCATION_DATA" | jq -r .city), $(echo "$LOCATION_DATA" | jq -r .country)\033[0m"
	echo -e "Timezone:         \033[32m$(readlink /etc/localtime | sed 's/^.*zoneinfo\///' 2>/dev/null)\033[0m"
	echo -e "\033[96m--------------------------------\033[0m"
	echo -e "Uptime:           \033[32m$(uptime -p | sed 's/up //')\033[0m"
	echo -e "\033[96m========================\033[0m"
}
SYS_UPDATE() {
	echo -e "\033[33mUpdating system software...\033[0m"
	echo -e "\033[96m========================\033[0m"
	case $(command -v apk || command -v apt || command -v dnf || command -v opkg || command -v pacman || command -v yum || command -v zypper) in
		*apk) apk update && apk upgrade;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				sleep 1
			done
			DEBIAN_FRONTEND=noninteractive apt update -y && apt full-upgrade -y;;
		*dnf) dnf -y update;;
		*opkg) opkg update && opkg upgrade;;
		*pacman) pacman -Syu --noconfirm;;
		*yum) yum -y update;;
		*zypper) zypper refresh && zypper update;;
		*) return 1;;
	esac
	echo -e "\033[96m========================\033[0m"
}

TIMEZONE() {
	readlink /etc/localtime | sed 's/^.*zoneinfo\///' 2>/dev/null
}