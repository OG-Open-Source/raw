#!/bin/bash
# Support OS: apt (Debian, Ubuntu), apk (Alpine Linux), dnf (Fedora), opkg (OpenWrt), pacman (Arch Linux), yum (CentOS, RHEL, Oracle Linux), zypper (OpenSUSE, SLES)
# Author: OGATA Open-Source
# Version: 1.021.002
# License: MIT License

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
	if [ $# -eq 0 ]; then
		echo "No packages specified for installation"
		return 1
	fi
	for app in "$@"; do
		echo -e "${CLR3}INSTALL [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
			*apk)
				if ! apk info "$app" &>/dev/null; then
					if ! apk update && apk add "$app"; then
						echo "Failed to install $app using apk"
						return 1
					fi
				fi
				;;
			*apt)
				if ! dpkg -l | grep -qw "$app"; then
					if ! apt update -y && apt install -y "$app"; then
						echo "Failed to install $app using apt"
						return 1
					fi
				fi
				;;
			*dnf)
				if ! dnf list installed "$app" &>/dev/null; then
					if ! dnf -y update && dnf install -y epel-release "$app"; then
						echo "Failed to install $app using dnf"
						return 1
					fi
				fi
				;;
			*opkg)
				if ! opkg list-installed | grep -qw "$app"; then
					if ! opkg update && opkg install "$app"; then
						echo "Failed to install $app using opkg"
						return 1
					fi
				fi
				;;
			*pacman)
				if ! pacman -Q "$app" &>/dev/null; then
					if ! pacman -Syu --noconfirm && pacman -S --noconfirm "$app"; then
						echo "Failed to install $app using pacman"
						return 1
					fi
				fi
				;;
			*yum)
				if ! yum list installed "$app" &>/dev/null; then
					if ! yum -y update && yum install -y epel-release "$app"; then
						echo "Failed to install $app using yum"
						return 1
					fi
				fi
				;;
			*zypper)
				if ! zypper se --installed-only "$app" &>/dev/null; then
					if ! zypper refresh && zypper install -y "$app"; then
						echo "Failed to install $app using zypper"
						return 1
					fi
				fi
				;;
			*)
				echo "Unsupported package manager"
				return 1
				;;
		esac
		echo -e "${CLR2}FINISHED${CLR0}\n"
	done
}

CHECK_OS() {
	if [ -f /etc/debian_version ]; then
		. /etc/os-release
		if [ "$ID" = "ubuntu" ]; then
			grep PRETTY_NAME /etc/os-release | cut -d '=' -f2 | tr -d '"'
		else
			echo "$NAME $(cat /etc/debian_version)"
		fi
	elif [ -f /etc/os-release ]; then
		. /etc/os-release
		echo "$NAME $VERSION"
	elif [ -f /etc/lsb-release ]; then
		. /etc/lsb-release
		echo "$DISTRIB_DESCRIPTION"
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
	if [ "$EUID" -ne 0 ] || [ "$(id -u)" -ne 0 ]; then
		echo -e "${CLR1}Please run this script as root user.${CLR0}"
		exit 1
	fi
}
CHECK_VIRT() {
	virt_type=$(systemd-detect-virt 2>/dev/null)
	case "$virt_type" in
		kvm)
			if [ -f /sys/class/dmi/id/product_name ] && grep -qi "proxmox" /sys/class/dmi/id/product_name; then
				echo "Proxmox VE (KVM)"
			else
				echo "KVM"
			fi
			;;
		none)
			if [ -f /proc/1/environ ] && grep -q "container=lxc" /proc/1/environ; then
				echo "LXC container"
			elif [ -f /proc/cpuinfo ] && grep -qi "hypervisor" /proc/cpuinfo; then
				echo "Virtual machine (Unknown type)"
			else
				echo "Not detected (possibly bare metal)"
			fi
			;;
		"")
			echo "Not detected (possibly bare metal)"
			;;
		*)
			echo "$virt_type"
			;;
	esac
}
CLEAN() {
	cd ~
	clear
}
CPU_MODEL() {
	if command -v lscpu >/dev/null 2>&1; then
		lscpu | awk -F': +' '/Model name:/ {print $2; exit}'
	elif [ -f /proc/cpuinfo ]; then
		awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo
	elif command -v sysctl >/dev/null 2>&1; then
		sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Unknown CPU model"
	else
		echo "Unable to determine CPU model"
	fi
}
COPYRIGHT() {
	echo "Copyright (C) 2024 OG|OS OGATA-Open-Source. All Rights Reserved."
}

DEL() {
	CHECK_ROOT
	if [ $# -eq 0 ]; then
		echo "No packages specified for removal"
		return 1
	fi
	for app in "$@"; do
		echo -e "${CLR3}REMOVE [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
			*apk)
				if ! apk info "$app" &>/dev/null; then
					echo "Package $app not found"
					return 1
				fi
				if ! apk del "$app"; then
					echo "Failed to remove package $app"
					return 1
				fi
				;;
			*apt)
				if ! dpkg -l | grep -q "^ii  $app"; then
					echo "Package $app not installed"
					return 1
				fi
				if ! apt purge -y "$app"; then
					echo "Failed to remove package $app"
					return 1
				fi
				;;
			*dnf)
				if ! dnf list installed "$app" &>/dev/null; then
					echo "Package $app not installed"
					return 1
				fi
				if ! dnf remove -y "$app"; then
					echo "Failed to remove package $app"
					return 1
				fi
				;;
			*opkg)
				if ! opkg list-installed | grep -q "$app"; then
					echo "Package $app not installed"
					return 1
				fi
				if ! opkg remove "$app"; then
					echo "Failed to remove package $app"
					return 1
				fi
				;;
			*pacman)
				if ! pacman -Q "$app" &>/dev/null; then
					echo "Package $app not installed"
					return 1
				fi
				if ! pacman -Rns --noconfirm "$app"; then
					echo "Failed to remove package $app"
					return 1
				fi
				;;
			*yum)
				if ! yum list installed "$app" &>/dev/null; then
					echo "Package $app not installed"
					return 1
				fi
				if ! yum remove -y "$app"; then
					echo "Failed to remove package $app"
					return 1
				fi
				;;
			*zypper)
				if ! zypper se --installed-only "$app" | grep -q "$app"; then
					echo "Package $app not installed"
					return 1
				fi
				if ! zypper remove -y "$app"; then
					echo "Failed to remove package $app"
					return 1
				fi
				;;
			*)
				echo "Unsupported package manager"
				return 1
				;;
		esac
		echo -e "${CLR2}FINISHED${CLR0}\n"
	done
}
DISK_USAGE() {
	used=$(df -BM / | awk 'NR==2 {gsub("M",""); printf "%.0f MiB", $3}')
	total=$(df -BM / | awk 'NR==2 {gsub("M",""); printf "%.0f MiB", $2}')
	percentage=$(df / | awk 'NR==2 {printf "%.2f", $3/$2 * 100}')
	echo "$used / $total ($percentage%)"
}

FIND() {
	if [ $# -eq 0 ]; then
		echo "No search terms provided"
		return 1
	fi
	for app in "$@"; do
		echo -e "${CLR3}SEARCH [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
			*apk)
				if ! apk search "$app"; then
					echo "No results found for $app"
					return 1
				fi
				;;
			*apt)
				if ! apt-cache search "$app"; then
					echo "No results found for $app"
					return 1
				fi
				;;
			*dnf)
				if ! dnf search "$app"; then
					echo "No results found for $app"
					return 1
				fi
				;;
			*opkg)
				if ! opkg search "$app"; then
					echo "No results found for $app"
					return 1
				fi
				;;
			*pacman)
				if ! pacman -Ss "$app"; then
					echo "No results found for $app"
					return 1
				fi
				;;
			*yum)
				if ! yum search "$app"; then
					echo "No results found for $app"
					return 1
				fi
				;;
			*zypper)
				if ! zypper search "$app"; then
					echo "No results found for $app"
					return 1
				fi
				;;
			*)
				echo "Unsupported package manager"
				return 1
				;;
		esac
		echo -e "${CLR2}FINISHED${CLR0}\n"
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

MEM_USAGE() {
	used=$(free -m | awk '/^Mem:/ {printf "%.0f MiB", $3}')
	total=$(free -m | awk '/^Mem:/ {printf "%.0f MiB", $2}')
	percentage=$(free | awk '/^Mem:/ {printf("%.2f"), $3/$2 * 100.0}')
	echo "$used / $total ($percentage%)"
}

PKG_COUNT() {
	case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
		*apk)
			if ! apk info | wc -l; then
				echo "Failed to count APK packages"
				return 1
			fi
			;;
		*apt)
			if ! dpkg --get-selections | wc -l; then
				echo "Failed to count APT packages"
				return 1
			fi
			;;
		*dnf|*yum)
			if ! rpm -qa | wc -l; then
				echo "Failed to count RPM packages"
				return 1
			fi
			;;
		*opkg)
			if ! opkg list-installed | wc -l; then
				echo "Failed to count OPKG packages"
				return 1
			fi
			;;
		*pacman)
			if ! pacman -Q | wc -l; then
				echo "Failed to count Pacman packages"
				return 1
			fi
			;;
		*zypper)
			if ! zypper se --installed-only | wc -l; then
				echo "Failed to count Zypper packages"
				return 1
			fi
			;;
		*)
			echo "Unsupported package manager"
			return 1
			;;
	esac
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

SWAP_USAGE() {
	used=$(free -m | awk '/^Swap:/ {printf "%.0f MiB", $3}')
	total=$(free -m | awk '/^Swap:/ {printf "%.0f MiB", $2}')
	percentage=$(free | awk '/^Swap:/ {if($2>0) printf("%.2f"), $3/$2 * 100.0; else print "0.00"}')
	echo "$used / $total ($percentage%)"
}
SYS_CLEAN() {
	CHECK_ROOT
	echo -e "${CLR3}Performing system cleanup...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
		*apk)
			if ! apk cache clean; then
				echo -e "${CLR1}Failed to clean APK cache${CLR0}"
				return 1
			fi
			if ! rm -rf /tmp/* /var/cache/apk/* /var/log/*; then
				echo -e "${CLR1}Failed to remove temporary files${CLR0}"
				return 1
			fi
			if ! apk fix; then
				echo -e "${CLR1}Failed to fix APK packages${CLR0}"
				return 1
			fi
			;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				sleep 0.5
			done
			if ! DEBIAN_FRONTEND=noninteractive dpkg --configure -a; then
				echo -e "${CLR1}Failed to configure pending packages${CLR0}"
				return 1
			fi
			if ! apt autoremove --purge -y; then
				echo -e "${CLR1}Failed to autoremove packages${CLR0}"
				return 1
			fi
			if ! apt clean -y; then
				echo -e "${CLR1}Failed to clean APT cache${CLR0}"
				return 1
			fi
			if ! apt autoclean -y; then
				echo -e "${CLR1}Failed to autoclean APT cache${CLR0}"
				return 1
			fi
			;;
		*dnf)
			if ! dnf autoremove -y; then
				echo -e "${CLR1}Failed to autoremove packages${CLR0}"
				return 1
			fi
			if ! dnf clean all; then
				echo -e "${CLR1}Failed to clean DNF cache${CLR0}"
				return 1
			fi
			if ! dnf makecache; then
				echo -e "${CLR1}Failed to make DNF cache${CLR0}"
				return 1
			fi
			;;
		*opkg)
			if ! rm -rf /tmp/* /var/log/*; then
				echo -e "${CLR1}Failed to remove temporary files${CLR0}"
				return 1
			fi
			if ! opkg update; then
				echo -e "${CLR1}Failed to update OPKG${CLR0}"
				return 1
			fi
			if ! opkg clean; then
				echo -e "${CLR1}Failed to clean OPKG cache${CLR0}"
				return 1
			fi
			;;
		*pacman)
			if ! pacman -Syu --noconfirm; then
				echo -e "${CLR1}Failed to update and upgrade packages${CLR0}"
				return 1
			fi
			if ! pacman -Sc --noconfirm; then
				echo -e "${CLR1}Failed to clean pacman cache${CLR0}"
				return 1
			fi
			if ! pacman -Scc --noconfirm; then
				echo -e "${CLR1}Failed to clean all pacman cache${CLR0}"
				return 1
			fi
			;;
		*yum)
			if ! yum autoremove -y; then
				echo -e "${CLR1}Failed to autoremove packages${CLR0}"
				return 1
			fi
			if ! yum clean all; then
				echo -e "${CLR1}Failed to clean YUM cache${CLR0}"
				return 1
			fi
			if ! yum makecache; then
				echo -e "${CLR1}Failed to make YUM cache${CLR0}"
				return 1
			fi
			;;
		*zypper)
			if ! zypper clean --all; then
				echo -e "${CLR1}Failed to clean Zypper cache${CLR0}"
				return 1
			fi
			if ! zypper refresh; then
				echo -e "${CLR1}Failed to refresh Zypper repositories${CLR0}"
				return 1
			fi
			;;
		*)
			echo "Unsupported package manager. Skipping system-specific cleanup."
			return 1
			;;
	esac
	if command -v journalctl &>/dev/null; then
		if ! journalctl --rotate --vacuum-time=1d --vacuum-size=500M; then
			echo -e "${CLR1}Failed to rotate and vacuum journalctl logs${CLR0}"
			return 1
		fi
	fi
	if ! find /var/log -type f -delete; then
		echo -e "${CLR1}Failed to delete log files${CLR0}"
		return 1
	fi
	if ! rm -rf /tmp/*; then
		echo -e "${CLR1}Failed to remove temporary files${CLR0}"
		return 1
	fi
	for cmd in docker npm pip; do
		if command -v "$cmd" &>/dev/null; then
			case "$cmd" in
				npm)
					if ! npm cache clean --force; then
						echo -e "${CLR1}Failed to clean NPM cache${CLR0}"
						return 1
					fi
					;;
				pip)
					if ! pip cache purge; then
						echo -e "${CLR1}Failed to purge PIP cache${CLR0}"
						return 1
					fi
					;;
			esac
		fi
	done
	if ! rm -rf ~/.cache/*; then
		echo -e "${CLR1}Failed to remove user cache files${CLR0}"
		return 1
	fi
	if ! rm -rf ~/.thumbnails/*; then
		echo -e "${CLR1}Failed to remove thumbnail files${CLR0}"
		return 1
	fi
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "${CLR2}FINISHED${CLR0}\n"
}
SYS_INFO() {
	width=19
	printf "${CLR3}System Information${CLR0}\n"
	printf "${CLR8}$(LINE = "24")${CLR0}\n"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Hostname:" "$(hostname)"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Operating System:" "$(CHECK_OS)"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Kernel Version:" "$(uname -r)"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "System Language:" "$LANG"
	printf "${CLR8}$(LINE - "32")${CLR0}\n"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Architecture:" "$(uname -m)"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "CPU Model:" "$(CPU_MODEL)"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "CPU Cores:" "$(nproc)"
	printf "${CLR8}$(LINE - "32")${CLR0}\n"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Memory Usage:" "$(MEM_USAGE)"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Swap Usage:" "$(SWAP_USAGE)"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Disk Usage:" "$(DISK_USAGE)"
	printf "${CLR8}$(LINE - "32")${CLR0}\n"
	if ping -c 1 ipinfo.io &>/dev/null; then
		if timeout 3 ping -c 1 ipv4.ip.sb &>/dev/null; then
			printf "%-${width}s ${CLR2}%s${CLR0}\n" "IPv4 Address:" "$(curl -s ipv4.ip.sb)"
		else
			printf "%-${width}s ${CLR1}%s${CLR0}\n" "IPv4 Address:" "N/A"
		fi
		if timeout 3 ping -c 1 ipv6.ip.sb &>/dev/null; then
			printf "%-${width}s ${CLR2}%s${CLR0}\n" "IPv6 Address:" "$(curl -s ipv6.ip.sb)"
		else
			printf "%-${width}s ${CLR1}%s${CLR0}\n" "IPv6 Address:" "N/A"
		fi
		printf "%-${width}s ${CLR2}%s${CLR0}\n" "Network Provider:" "$(curl -s ipinfo.io | jq -r .org)"
		printf "%-${width}s ${CLR2}%s, %s${CLR0}\n" "Location:" "$(curl -s ipinfo.io | jq -r .city)" "$(curl -s ipinfo.io | jq -r .country)"
	else
		printf "%-${width}s ${CLR1}%s${CLR0}\n" "Network Status:" "OFFLINE"
	fi
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Timezone:" "$(TIMEZONE)"
	printf "${CLR8}$(LINE - "32")${CLR0}\n"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Load Average:" "$(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "System Uptime:" "$(uptime -p | sed 's/up //')"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Boot Time:" "$(who -b | awk '{print $3, $4}')"
	printf "${CLR8}$(LINE - "32")${CLR0}\n"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Packages:" "$(PKG_COUNT)"
	printf "%-${width}s ${CLR2}%s${CLR0}\n" "Process Count:" "$(ps aux | wc -l)"
	printf "%-${width}s " "Virtualization:"
	printf "${CLR2}%s${CLR0}\n" "$(CHECK_VIRT)"
	printf "${CLR8}$(LINE = "24")${CLR0}\n"
}
SYS_UPDATE() {
	CHECK_ROOT
	echo -e "${CLR3}Updating system software...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
		*apk)
			if ! apk update && apk upgrade; then
				echo -e "${CLR1}Failed to update and upgrade packages using apk${CLR0}"
				return 1
			fi
			;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				echo "Waiting for dpkg lock to be released..."
				sleep 1
			done
			if ! DEBIAN_FRONTEND=noninteractive apt update -y && apt full-upgrade -y; then
				echo -e "${CLR1}Failed to update and upgrade packages using apt${CLR0}"
				return 1
			fi
			;;
		*dnf)
			if ! dnf -y update; then
				echo -e "${CLR1}Failed to update packages using dnf${CLR0}"
				return 1
			fi
			;;
		*opkg)
			if ! opkg update && opkg upgrade; then
				echo -e "${CLR1}Failed to update and upgrade packages using opkg${CLR0}"
				return 1
			fi
			;;
		*pacman)
			if ! pacman -Syu --noconfirm; then
				echo -e "${CLR1}Failed to update and upgrade packages using pacman${CLR0}"
				return 1
			fi
			;;
		*yum)
			if ! yum -y update; then
				echo -e "${CLR1}Failed to update packages using yum${CLR0}"
				return 1
			fi
			;;
		*zypper)
			if ! zypper refresh && zypper update -y; then
				echo -e "${CLR1}Failed to refresh and update packages using zypper${CLR0}"
				return 1
			fi
			;;
		*)
			echo -e "${CLR1}Unsupported package manager${CLR0}"
			return 1
			;;
	esac
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "${CLR2}FINISHED${CLR0}\n"
}

TIMEZONE() {
	timezone=$(readlink /etc/localtime | sed 's|^.*/zoneinfo/||' 2>/dev/null) ||
	timezone=$(command -v timedatectl >/dev/null 2>&1 && timedatectl status | awk '/Time zone:/ {print $3}') ||
	timezone=$([ -f /etc/timezone ] && cat /etc/timezone)
	echo "${timezone:-Unknown}"
}