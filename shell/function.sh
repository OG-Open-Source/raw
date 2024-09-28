#!/bin/bash
# Support OS: apt (Debian, Ubuntu), apk (Alpine Linux), dnf (Fedora), opkg (OpenWrt), pacman (Arch Linux), yum (CentOS, RHEL, Oracle Linux), zypper (OpenSUSE, SLES)
# Author: OGATA Open-Source
# Version: 1.1.008

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
	CHECK_ROOT
	[ $# -eq 0 ] && return
	for app in "$@"; do
		echo -e "${CLR3}INSTALL [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
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

CHECK_OS() {
	if [ -f /etc/os-release ]; then
		. /etc/os-release
		echo "$NAME $VERSION"
	elif [ -f /etc/lsb-release ]; then
		. /etc/lsb-release
		echo "$DISTRIB_DESCRIPTION"
	elif [ -f /etc/debian_version ]; then
		echo "Debian $(cat /etc/debian_version)"
	elif [ -f /etc/fedora-release ]; then
		cat /etc/fedora-release
	elif [ -f /etc/centos-release ]; then
		cat /etc/centos-release
	elif [ -f /etc/arch-release ]; then
		echo "Arch Linux"
	elif [ -f /etc/gentoo-release ]; then
		cat /etc/gentoo-release
	elif [ -f /etc/alpine-release ]; then
		echo "Alpine Linux $(cat /etc/alpine-release)"
	elif [ -f /etc/DISTRO_SPECS ]; then
		grep -i "DISTRO_NAME" /etc/DISTRO_SPECS | cut -d'=' -f2
	else
		echo "Unknown distribution"
	fi
}
CHECK_ROOT() {
	if [ "$(id -u)" -ne 0 ]; then
		echo -e "${CLR1}Please run this script as root user.${CLR0}"
		exit 1
	else
		echo
	fi
}
CLEAN() {
	cd ~
	clear
}
COPYRIGHT() {
	echo "Copyright (C) 2024 OG|OS OGATA-Open-Source. All Rights Reserved."
}

DEL() {
	CHECK_ROOT
	[ $# -eq 0 ] && return
	for app in "$@"; do
		echo -e "${CLR3}REMOVE [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
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

FIND() {
	[ $# -eq 0 ] && return
	for app in "$@"; do
		echo -e "${CLR3}SEARCH [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
			*apk) apk search "$app" ;;
			*apt) apt-cache search "$app" ;;
			*dnf) dnf search "$app" ;;
			*opkg) opkg search "$app" ;;
			*pacman) pacman -Ss "$app" ;;
			*yum) yum search "$app" ;;
			*zypper) zypper search "$app" ;;
			*) return ;;
		esac
		echo
	done
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

LINE() {
	printf '%*s' "$2" '' | tr ' ' "$1"
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
	CHECK_ROOT
	echo -e "${CLR3}Performing system cleanup...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
		*apk) apk cache clean; rm -rf /tmp/* /var/cache/apk/* /var/log/* ;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				sleep 0.5
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
	echo -e "Operating System: ${CLR2}$(CHECK_OS)${CLR0}"
	echo -e "Kernel Version:   ${CLR2}$(uname -r)${CLR0}"
	echo -e "System Language:  ${CLR2}$LANG${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "Architecture:     ${CLR2}$(uname -m)${CLR0}"
	echo -e "CPU Model:        ${CLR2}$(lscpu | awk -F': +' '/Model name:/ {print $2; exit}')${CLR0}"
	echo -e "CPU Cores:        ${CLR2}$(nproc)${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "Memory Usage:     ${CLR2}$(free -h | awk '/^Mem:/ {print $3}' | sed 's/Gi/ GiB/g; s/Mi/ MiB/g') / $(free -h | awk '/^Mem:/ {print $2}' | sed 's/Gi/ GiB/g; s/Mi/ MiB/g') ($(free | awk '/^Mem:/ {printf("%.2f"), $3/$2 * 100.0}')%)${CLR0}"
	echo -e "Swap Usage:       ${CLR2}$(free -h | awk '/^Swap:/ {print $3}' | sed 's/Gi/ GiB/g; s/Mi/ MiB/g') / $(free -h | awk '/^Swap:/ {print $2}' | sed 's/Gi/ GiB/g; s/Mi/ MiB/g') ($(free | awk '/^Swap:/ {if($2>0) printf("%.2f"), $3/$2 * 100.0; else print "0.00"}')%)${CLR0}"
	echo -e "Disk Usage:       ${CLR2}$(df -h | awk '$NF=="/"{printf "%s", $3}' | sed 's/G/ GiB/g; s/M/ MiB/g') / $(df -h | awk '$NF=="/"{printf "%s", $2}' | sed 's/G/ GiB/g; s/M/ MiB/g') ($(df -h | awk '$NF=="/"{printf "%.2f", $3/$2 * 100}')%)${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	if ping -c 1 ipinfo.io &>/dev/null; then
		loc=$(curl -s ipinfo.io)
		echo -e "IPv4 Address:     ${CLR2}$(echo "$loc" | jq -r .ip)${CLR0}"
		echo -e "IPv6 Address:     ${CLR2}$(curl -s ipv6.ip.sb)${CLR0}"
		echo -e "Location:         ${CLR2}$(echo "$loc" | jq -r .city), $(echo "$loc" | jq -r .country)${CLR0}"
	else
		echo -e "Network Status:   ${CLR1}OFFLINE${CLR0}"
	fi
	echo -e "Timezone:         ${CLR2}$(TIMEZONE)${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "Load Average:     ${CLR2}$(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')${CLR0}"
	echo -e "System Uptime:    ${CLR2}$(uptime -p | sed 's/up //')${CLR0}"
	echo -e "Boot Time:        ${CLR2}$(who -b | awk '{print $3, $4}')${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	pkg_count=$(case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
		*apk) apk info | wc -l ;;
		*apt) dpkg --get-selections | wc -l ;;
		*dnf|*yum) rpm -qa | wc -l ;;
		*opkg) opkg list-installed | wc -l ;;
		*pacman) pacman -Q | wc -l ;;
		*zypper) zypper se --installed-only | wc -l ;;
	esac)
	echo -e "Packages:         ${CLR2}${pkg_count}${CLR0}"
	if [ -f /proc/cpuinfo ] && grep -q "hypervisor" /proc/cpuinfo; then
		echo -e "Virtualization:   ${CLR2}Running in a virtual machine${CLR0}"
	elif [ -x "$(command -v systemd-detect-virt)" ] && [ "$(systemd-detect-virt)" != "none" ]; then
		echo -e "Virtualization:   ${CLR2}Running in a virtual machine ($(systemd-detect-virt))${CLR0}"
	else
		echo -e "Virtualization:   ${CLR2}Not detected${CLR0}"
	fi
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
}
SYS_UPDATE() {
	CHECK_ROOT
	echo -e "${CLR3}Updating system software...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
		*apk) apk update && apk upgrade ;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				sleep 0.5
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