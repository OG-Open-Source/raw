#!/bin/bash
# URL="https://raw.ogtt.tk/shell/function.sh"
# FILE="function.sh"
# [ ! -f "$FILE" ] && curl -sSL "$URL" -o "$FILE"
# [ -f "$FILE" ] && source "$FILE"
COPYRIGHT() { echo "© 2024 OG|OS OGATA-Open-Source"; }

ADD() {
	[ $# -eq 0 ] && return
	for app in "$@"; do
		echo -e "\e[33mINSTALL [$app]\e[0m"
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
			*apk) apk info "$app" &>/dev/null && apk del "$app";;
			*apt) dpkg -l | grep -q "^ii  $app" && apt purge -y "$app";;
			*dnf) dnf list installed "$app" &>/dev/null && dnf remove -y "$app";;
			*opkg) opkg list-installed | grep -q "$app" && opkg remove "$app";;
			*pacman) pacman -Q "$app" &>/dev/null && pacman -Rns --noconfirm "$app";;
			*yum) yum list installed "$app" &>/dev/null && yum remove -y "$app";;
			*zypper) zypper se --installed-only "$app" | grep -q "$app" && zypper remove -y "$app";;
			*) return;;
		esac
		echo -e "\e[32mFINISHED\e[0m"
		echo
	done
}

FONT() {
    local FONT=""
    declare -A STYLE=(
        [B]="\e[1m" [U]="\e[4m"
        [BLACK]="\e[30m" [RED]="\e[31m" [GREEN]="\e[32m" [YELLOW]="\e[33m"
        [BLUE]="\e[34m" [PURPLE]="\e[35m" [CYAN]="\e[36m" [WHITE]="\e[37m"
        [L.BLACK]="\e[90m" [L.RED]="\e[91m" [L.GREEN]="\e[92m" [L.YELLOW]="\e[93m"
        [L.BLUE]="\e[94m" [L.PURPLE]="\e[95m" [L.CYAN]="\e[96m" [L.WHITE]="\e[97m"
        [BG.BLACK]="\e[40m" [BG.RED]="\e[41m" [BG.GREEN]="\e[42m" [BG.YELLOW]="\e[43m"
        [BG.BLUE]="\e[44m" [BG.PURPLE]="\e[45m" [BG.CYAN]="\e[46m" [BG.WHITE]="\e[47m"
        [L.BG.BLACK]="\e[100m" [L.BG.RED]="\e[101m" [L.BG.GREEN]="\e[102m" [L.BG.YELLOW]="\e[103m"
        [L.BG.BLUE]="\e[104m" [L.BG.PURPLE]="\e[105m" [L.BG.CYAN]="\e[106m" [L.BG.WHITE]="\e[107m"
    )
    while [[ $# -gt 1 ]]; do
        case "$1" in
            RGB)
                shift
                [[ "$1" =~ ^([0-9]{1,3}),([0-9]{1,3}),([0-9]{1,3})$ ]] && FONT+="\e[38;2;${BASH_REMATCH[1]};${BASH_REMATCH[2]};${BASH_REMATCH[3]}m"
                ;;
            BG.RGB)
                shift
                [[ "$1" =~ ^([0-9]{1,3}),([0-9]{1,3}),([0-9]{1,3})$ ]] && FONT+="\e[48;2;${BASH_REMATCH[1]};${BASH_REMATCH[2]};${BASH_REMATCH[3]}m"
                ;;
            *)
                FONT+="${STYLE[$1]:-}"
                ;;
        esac
        shift
    done
    echo -e "${FONT}${1}\e[0m"
}

INPUT() {
	read -p "$1" "$2"
}

LINE() {
	printf '%*s' "$1" '' | tr ' ' '-'
}

SYS_CLEAN() {
	echo -e "\e[33mPerforming system cleanup...\e[0m"
	echo
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
}
SYS_INFO() {
	echo -e "\e[33mSystem Information:\e[0m"
	echo -e "\e[96m$(printf '%*s' "24" '' | tr ' ' '-')\e[0m"
	echo "Hostname: $(hostname)"
	echo "System:   $(grep '^NAME=' /etc/*release | cut -d'=' -f2 | tr -d '\"') $(grep '^VERSION_ID=' /etc/*release | cut -d'=' -f2 | tr -d '\"')"
	echo "Kernel:   $(uname -r)"
	echo -e "\e[96m$(printf '%*s' "24" '' | tr ' ' '-')\e[0m"
	echo "Architecture: $(uname -m)"
	echo "CPU Model:    $(lscpu | awk -F': +' '/Model name:/ {print $2; exit}')"
	echo "CPU Cores:    $(nproc)"
	echo -e "\e[96m$(printf '%*s' "24" '' | tr ' ' '-')\e[0m"
	echo "Total Memory: $(free -h | awk '/^Mem:/ {print $2}' | sed 's/Gi/GiB/g' | sed 's/Mi/MiB/g')"
	echo "Disk Usage:   $(df -h | awk '$NF=="/"{printf "%s\t\t", $3}' | sed 's/G/GiB/g' | sed 's/M/MiB/g')"
	echo -e "\e[96m$(printf '%*s' "24" '' | tr ' ' '-')\e[0m"
	echo "IPv4 Address: $(curl -s ipv4.ip.sb)"
	echo "IPv6 Address: $(curl -s ipv6.ip.sb)"
	echo -e "\e[96m$(printf '%*s' "24" '' | tr ' ' '-')\e[0m"
	echo "Location: $(curl -s ipinfo.io/city), $(curl -s ipinfo.io/country)"
	echo "Timezone: $(readlink /etc/localtime | sed 's/^.*zoneinfo\///' 2>/dev/null)"
	echo -e "\e[96m$(printf '%*s' "24" '' | tr ' ' '-')\e[0m"
	echo "Uptime: $(uptime -p | sed 's/up //')"
}
SYS_UPDATE() {
	echo -e "\e[33mUpdating system software...\e[0m"
	echo
	case $(command -v apk || command -v apt || command -v dnf || command -v opkg || command -v pacman || command -v yum || command -v zypper) in
		*apk) apk update && apk upgrade;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				echo "Waiting for dpkg lock to be released..."
				sleep 1
			done
			DEBIAN_FRONTEND=noninteractive apt update -y
			DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
			;;
		*dnf) dnf -y update;;
		*opkg) opkg update && opkg upgrade;;
		*pacman) pacman -Syu --noconfirm;;
		*yum) yum -y update;;
		*zypper) zypper refresh && zypper update;;
		*) return 1;;
	esac
}
SYS_UPGRADE() {
	echo -e "\e[33mPerforming system version upgrade...\e[0m"
	echo

	if [ -f /etc/os-release ]; then
		. /etc/os-release
		case $ID in
			debian)
				if [ "$VERSION_ID" = "11" ]; then
					sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
					apt update && apt full-upgrade -y
					apt autoremove -y
					echo -e "\e[32mDebian 11 has been upgraded to Debian 12\e[0m"
				else
					echo -e "\e[31mUpgrade for this Debian version is not currently supported\e[0m"
				fi
				;;
			ubuntu)
				if [ "$VERSION_ID" = "22.04" ]; then
					do-release-upgrade -d
					echo -e "\e[32mUbuntu 22.04 has been upgraded to Ubuntu 24.04\e[0m"
				else
					echo -e "\e[31mUpgrade for this Ubuntu version is not currently supported\e[0m"
				fi
				;;
			centos)
				if [ "$VERSION_ID" = "7" ]; then
					yum install -y centos-release-scl
					yum install -y centos-release-scl-rh
					yum install -y rh-python36 rh-python36-python-devel
					yum install -y epel-release yum-utils
					yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
					yum-config-manager --enable remi-php74
					yum update -y
					echo -e "\e[32mCentOS 7 has been updated to the latest version\e[0m"
				elif [ "$VERSION_ID" = "8" ]; then
					dnf upgrade -y
					dnf install -y epel-release
					dnf config-manager --set-enabled PowerTools
					dnf update -y
					echo -e "\e[32mCentOS 8 has been updated to the latest version\e[0m"
				else
					echo -e "\e[31mUpgrade for this CentOS version is not currently supported\e[0m"
				fi
				;;
			*)
				echo -e "\e[31mVersion upgrade is not supported for the current operating system\e[0m"
				;;
		esac
	else
		echo -e "\e[31mUnable to determine the operating system version\e[0m"
	fi
}

TIMEZONE() {
	readlink /etc/localtime | sed 's/^.*zoneinfo\///' 2>/dev/null
}