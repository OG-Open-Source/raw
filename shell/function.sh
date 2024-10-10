#!/bin/bash
# Support OS: apt (Debian, Ubuntu), apk (Alpine Linux), dnf (Fedora), opkg (OpenWrt), pacman (Arch Linux), yum (CentOS, RHEL, Oracle Linux), zypper (OpenSUSE, SLES)
# Author: OGATA Open-Source
# Version: 2.031.001
# License: MIT License

SH="function.sh"
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

log_error() {
	echo -e "${CLR1}$1${CLR0}"
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $SH - $1" >> ./ogos-error.log
}

ADD() {
	CHECK_ROOT
	if [ $# -eq 0 ]; then
		log_error "No packages specified for installation"
		return 1
	fi
	for app in "$@"; do
		echo -e "${CLR3}INSTALL [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
			*apk)
				if ! apk info -e "$app" &>/dev/null; then
					echo "* Package $app is not installed. Attempting installation..."
					if ! apk update; then
						log_error "Failed to update package lists"
						return 1
					fi
					if ! apk add "$app"; then
						log_error "Failed to install $app using apk"
						return 1
					fi
					echo "* Package $app installed successfully."
				else
					echo "* Package $app is already installed."
				fi
				;;
			*apt)
				if ! dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "ok installed"; then
					echo "* Package $app is not installed. Attempting installation..."
					if ! apt update; then
						log_error "Failed to update package lists"
						return 1
					fi
					if ! apt install -y "$app"; then
						log_error "Failed to install $app using apt"
						return 1
					fi
					echo "* Package $app installed successfully."
				else
					echo "* Package $app is already installed."
				fi
				;;
			*dnf)
				if ! dnf list installed "$app" &>/dev/null; then
					echo "* Package $app is not installed. Attempting installation..."
					if ! dnf check-update; then
						log_error "Failed to check for updates"
						return 1
					fi
					if ! dnf install -y "$app"; then
						log_error "Failed to install $app using dnf"
						return 1
					fi
					echo "* Package $app installed successfully."
				else
					echo "* Package $app is already installed."
				fi
				;;
			*opkg)
				if ! opkg list-installed | grep -q "^$app "; then
					echo "* Package $app is not installed. Attempting installation..."
					if ! opkg update; then
						log_error "Failed to update package lists"
						return 1
					fi
					if ! opkg install "$app"; then
						log_error "Failed to install $app using opkg"
						return 1
					fi
					echo "* Package $app installed successfully."
				else
					echo "* Package $app is already installed."
				fi
				;;
			*pacman)
				if ! pacman -Qi "$app" &>/dev/null; then
					echo "* Package $app is not installed. Attempting installation..."
					if ! pacman -Sy; then
						log_error "Failed to synchronize package databases"
						return 1
					fi
					if ! pacman -S --noconfirm "$app"; then
						log_error "Failed to install $app using pacman"
						return 1
					fi
					echo "* Package $app installed successfully."
				else
					echo "* Package $app is already installed."
				fi
				;;
			*yum)
				if ! yum list installed "$app" &>/dev/null; then
					echo "* Package $app is not installed. Attempting installation..."
					if ! yum check-update; then
						log_error "Failed to check for updates"
						return 1
					fi
					if ! yum install -y "$app"; then
						log_error "Failed to install $app using yum"
						return 1
					fi
					echo "* Package $app installed successfully."
				else
					echo "* Package $app is already installed."
				fi
				;;
			*zypper)
				if ! zypper se -i -x "$app" &>/dev/null; then
					echo "* Package $app is not installed. Attempting installation..."
					if ! zypper refresh; then
						log_error "Failed to refresh repositories"
						return 1
					fi
					if ! zypper install -y "$app"; then
						log_error "Failed to install $app using zypper"
						return 1
					fi
					echo "* Package $app installed successfully."
				else
					echo "* Package $app is already installed."
				fi
				;;
			*)
				log_error "No supported package manager found"
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
		log_error "Unknown distribution"
		return 1
	fi
}
CHECK_ROOT() {
	if [ "$EUID" -ne 0 ] || [ "$(id -u)" -ne 0 ]; then
		log_error "Please run this script as root user."
		exit 1
	fi
}
CHECK_VIRT() {
	virt_type=$(systemd-detect-virt 2>/dev/null)
	if [ -z "$virt_type" ]; then
		log_error "Failed to detect virtualization"
		return 1
	fi
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
				return 1
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
CPU_FREQ() {
	if command -v lscpu >/dev/null 2>&1; then
		freq=$(lscpu | awk '/CPU MHz:/ {printf "%.2f", $3/1000}')
	elif [ -f /proc/cpuinfo ]; then
		freq=$(awk '/cpu MHz/ {freq=$4} END {printf "%.2f", freq/1000}' /proc/cpuinfo)
	elif command -v sysctl >/dev/null 2>&1; then
		freq=$(sysctl -n hw.cpufrequency 2>/dev/null | awk '{printf "%.2f", $1/1e9}')
	else
		log_error "Unable to determine CPU frequency"
		return 1
	fi
	if [ -z "$freq" ]; then
		log_error "Failed to retrieve CPU frequency"
		return 1
	fi
	echo "${freq} GHz"
}
CPU_MODEL() {
	if command -v lscpu >/dev/null 2>&1; then
		lscpu | awk -F': +' '/Model name:/ {print $2; exit}'
	elif [ -f /proc/cpuinfo ]; then
		awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo
	elif command -v sysctl >/dev/null 2>&1; then
		sysctl -n machdep.cpu.brand_string 2>/dev/null || echo -e "${CLR1}Unknown${CLR0}"
	else
		log_error "Unable to determine CPU model"
		return 1
	fi
}
COPYRIGHT() {
	echo "Copyright (C) 2024 OG|OS OGATA-Open-Source. All Rights Reserved."
}

DEL() {
	CHECK_ROOT
	if [ $# -eq 0 ]; then
		log_error "No packages specified for removal"
		return 1
	fi
	for app in "$@"; do
		echo -e "${CLR3}REMOVE [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
			*apk)
				if apk info "$app" &>/dev/null; then
					echo "* Package $app is installed. Attempting removal..."
					if ! apk del "$app"; then
						log_error "Failed to remove package $app"
						return 1
					fi
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*apt)
				if dpkg -l | grep -q "^ii  $app"; then
					echo "* Package $app is installed. Attempting removal..."
					if ! apt purge -y "$app"; then
						log_error "Failed to purge package $app"
						return 1
					fi
					if ! apt autoremove -y; then
						log_error "Failed to autoremove package $app"
						return 1
					fi
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*dnf)
				if dnf list installed "$app" &>/dev/null; then
					echo "* Package $app is installed. Attempting removal..."
					if ! dnf remove -y "$app"; then
						log_error "Failed to remove package $app"
						return 1
					fi
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*opkg)
				if opkg list-installed | grep -q "$app"; then
					echo "* Package $app is installed. Attempting removal..."
					if ! opkg remove "$app"; then
						log_error "Failed to remove package $app"
						return 1
					fi
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*pacman)
				if pacman -Q "$app" &>/dev/null; then
					echo "* Package $app is installed. Attempting removal..."
					if ! pacman -Rns --noconfirm "$app"; then
						log_error "Failed to remove package $app"
						return 1
					fi
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*yum)
				if yum list installed "$app" &>/dev/null; then
					echo "* Package $app is installed. Attempting removal..."
					if ! yum remove -y "$app"; then
						log_error "Failed to remove package $app"
						return 1
					fi
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*zypper)
				if zypper se --installed-only "$app" | grep -q "$app"; then
					echo "* Package $app is installed. Attempting removal..."
					if ! zypper remove -y "$app"; then
						log_error "Failed to remove package $app"
						return 1
					fi
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*)
				log_error "Unsupported package manager"
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
DNS_ADDR () {
	if [ ! -f /etc/resolv.conf ]; then
		log_error "/etc/resolv.conf file not found"
		return 1
	fi
	ipv4_servers=$(grep -E '^nameserver' /etc/resolv.conf | awk '{print $2}' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')
	ipv6_servers=$(grep -E '^nameserver' /etc/resolv.conf | awk '{print $2}' | grep -E '^[0-9a-fA-F:]+$')

	if [ -z "$ipv4_servers" ] && [ -z "$ipv6_servers" ]; then
		log_error "No DNS servers found in /etc/resolv.conf"
		return 1
	fi
	ipv4_result=""
	ipv6_result=""
	for server in $ipv4_servers; do
		if [ -z "$ipv4_result" ]; then
			ipv4_result="$server"
		else
			ipv4_result="$ipv4_result, $server"
		fi
	done
	for server in $ipv6_servers; do
		if [ -z "$ipv6_result" ]; then
			ipv6_result="$server"
		else
			ipv6_result="$ipv6_result, $server"
		fi
	done
	if [ -z "$ipv4_result" ] && [ -z "$ipv6_result" ]; then
		log_error "Failed to parse DNS server addresses"
		return 1
	fi
	echo "$ipv4_result   $ipv6_result"
}

FIND() {
	if [ $# -eq 0 ]; then
		log_error "No search terms provided"
		return 1
	fi
	for app in "$@"; do
		echo -e "${CLR3}SEARCH [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
			*apk)
				if ! apk search "$app"; then
					log_error "No results found for $app"
					return 1
				fi
				;;
			*apt)
				if ! apt-cache search "$app"; then
					log_error "No results found for $app"
					return 1
				fi
				;;
			*dnf)
				if ! dnf search "$app"; then
					log_error "No results found for $app"
					return 1
				fi
				;;
			*opkg)
				if ! opkg search "$app"; then
					log_error "No results found for $app"
					return 1
				fi
				;;
			*pacman)
				if ! pacman -Ss "$app"; then
					log_error "No results found for $app"
					return 1
				fi
				;;
			*yum)
				if ! yum search "$app"; then
					log_error "No results found for $app"
					return 1
				fi
				;;
			*zypper)
				if ! zypper search "$app"; then
					log_error "No results found for $app"
					return 1
				fi
				;;
			*)
				log_error "Unsupported package manager"
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
INTERFACE() {
    interfaces=$(cat /proc/net/dev | grep ':' | cut -d':' -f1 | sed 's/^\s*//;s/\s*$//' | grep -iv '^lo\|^sit\|^stf\|^gif\|^dummy\|vmnet\|^vir\|^gre\|^ipip\|^ppp\|^bond\|^tun\|^tap\|^ip6gre\|^ip6tnl\|^teql\|^ocserv\|^vpn\|^warp\|^wgcf\|^wg\|^docker' | sort -n)
    operation="$1"
    direction="$2"
    metric="$3"
    for interface in $interfaces; do
        stats=$(cat /proc/net/dev | grep "$interface" | awk '{print $2, $3, $5, $10, $11, $13}')
        if [ -n "$stats" ]; then
            rx_bytes=$(echo $stats | awk '{print $1}')
            rx_packets=$(echo $stats | awk '{print $2}')
            rx_drop=$(echo $stats | awk '{print $3}')
            tx_bytes=$(echo $stats | awk '{print $4}')
            tx_packets=$(echo $stats | awk '{print $5}')
            tx_drop=$(echo $stats | awk '{print $6}')
            if [ -z "$operation" ]; then
                echo "$interface: RX: $rx_bytes bytes, TX: $tx_bytes bytes"
            else
                case "${operation^^}${direction^^}.${metric^^}" in
                    "RX.BYTES") echo "$rx_bytes" ;;
                    "RX.DROP") echo "$rx_drop" ;;
                    "RX.PACKETS") echo "$rx_packets" ;;
                    "TX.BYTES") echo "$tx_bytes" ;;
                    "TX.DROP") echo "$tx_drop" ;;
                    "TX.PACKETS") echo "$tx_packets" ;;
                esac
            fi
        else
            log_error "No stats found for interface: $interface"
            return 1
        fi
    done
}
IPv4_ADDR() {
	dig +short -4 myip.opendns.com @resolver1.opendns.com 2>/dev/null || \
	curl -s ipv4.ip.sb 2>/dev/null || \
	wget -qO- -4 ifconfig.me 2>/dev/null || \
	{ log_error "N/A"; return 1; }
}
IPv6_ADDR() {
	dig +short -6 myip.opendns.com aaaa @resolver1.opendns.com 2>/dev/null || \
	curl -s ipv6.ip.sb 2>/dev/null || \
	wget -qO- -6 ifconfig.me 2>/dev/null || \
	{ log_error "N/A"; return 1; }
}

LINE() {
	printf '%*s' "$2" '' | tr ' ' "$1"
}
LOAD_AVERAGE() {
	read one_min five_min fifteen_min <<< $(uptime | awk -F'load average:' '{print $2}' | tr -d ',')
	printf "%.2f, %.2f, %.2f (%d cores)" "$one_min" "$five_min" "$fifteen_min" "$(nproc)"
}

MAC_ADDR() {
	mac_address=$(ip link show | awk '/ether/ {print $2}' | head -n1)
	if [[ -n "$mac_address" ]]; then
		echo "$mac_address"
	else
		log_error "Failed to retrieve MAC address"
		return 1
	fi
}
MEM_USAGE() {
	used=$(free -m | awk '/^Mem:/ {printf "%.0f MiB", $3}')
	total=$(free -m | awk '/^Mem:/ {printf "%.0f MiB", $2}')
	percentage=$(free | awk '/^Mem:/ {printf("%.2f"), $3/$2 * 100.0}')
	echo "$used / $total ($percentage%)"
}

NET_PROVIDER() {
	curl -s ipinfo.io | jq -r .org || \
	curl -s https://ipwhois.app/json/ | jq -r .org || \
	curl -s http://ip-api.com/json/ | jq -r .org || \
	dig +short -x $(curl -s ipinfo.io/ip) | sed 's/\.$//' || \
	log_error "N/A"
	return 1
}

PKG_COUNT() {
	case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
		*apk)
			if ! apk info | wc -l; then
				log_error "Failed to count APK packages"
				return 1
			fi
			;;
		*apt)
			if ! dpkg --get-selections | wc -l; then
				log_error "Failed to count APT packages"
				return 1
			fi
			;;
		*dnf|*yum)
			if ! rpm -qa | wc -l; then
				log_error "Failed to count RPM packages"
				return 1
			fi
			;;
		*opkg)
			if ! opkg list-installed | wc -l; then
				log_error "Failed to count OPKG packages"
				return 1
			fi
			;;
		*pacman)
			if ! pacman -Q | wc -l; then
				log_error "Failed to count Pacman packages"
				return 1
			fi
			;;
		*zypper)
			if ! zypper se --installed-only | wc -l; then
				log_error "Failed to count Zypper packages"
				return 1
			fi
			;;
		*)
			log_error "Unsupported package manager"
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
PUBLIC_IP() {
	services=("https://ifconfig.me")
	for service in "${services[@]}"; do
		if ip=$(curl -s -m 5 "$service"); then
			echo "$ip"
			return 0
		fi
	done
	log_error "Unable to determine public IP"
	return 1
}

SHELL_VER() {
	case "${SHELL##*/}" in
		bash)
			${SHELL} --version | head -n 1 | awk '{print "Bash " $4}'
			;;
		*)
			echo "Unknown (${SHELL##*/})"
			;;
	esac
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
				log_error "Failed to clean APK cache"
				return 1
			fi
			if ! rm -rf /tmp/* /var/cache/apk/* /var/log/*; then
				log_error "Failed to remove temporary files"
				return 1
			fi
			if ! apk fix; then
				log_error "Failed to fix APK packages"
				return 1
			fi
			;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				sleep 0.5
			done
			if ! DEBIAN_FRONTEND=noninteractive dpkg --configure -a; then
				log_error "Failed to configure pending packages"
				return 1
			fi
			if ! apt autoremove --purge -y; then
				log_error "Failed to autoremove packages"
				return 1
			fi
			if ! apt clean -y; then
				log_error "Failed to clean APT cache"
				return 1
			fi
			if ! apt autoclean -y; then
				log_error "Failed to autoclean APT cache"
				return 1
			fi
			;;
		*dnf)
			if ! dnf autoremove -y; then
				log_error "Failed to autoremove packages"
				return 1
			fi
			if ! dnf clean all; then
				log_error "Failed to clean DNF cache"
				return 1
			fi
			if ! dnf makecache; then
				log_error "Failed to make DNF cache"
				return 1
			fi
			;;
		*opkg)
			if ! rm -rf /tmp/* /var/log/*; then
				log_error "Failed to remove temporary files"
				return 1
			fi
			if ! opkg update; then
				log_error "Failed to update OPKG"
				return 1
			fi
			if ! opkg clean; then
				log_error "Failed to clean OPKG cache"
				return 1
			fi
			;;
		*pacman)
			if ! pacman -Syu --noconfirm; then
				log_error "Failed to update and upgrade packages"
				return 1
			fi
			if ! pacman -Sc --noconfirm; then
				log_error "Failed to clean pacman cache"
				return 1
			fi
			if ! pacman -Scc --noconfirm; then
				log_error "Failed to clean all pacman cache"
				return 1
			fi
			;;
		*yum)
			if ! yum autoremove -y; then
				log_error "Failed to autoremove packages"
				return 1
			fi
			if ! yum clean all; then
				log_error "Failed to clean YUM cache"
				return 1
			fi
			if ! yum makecache; then
				log_error "Failed to make YUM cache"
				return 1
			fi
			;;
		*zypper)
			if ! zypper clean --all; then
				log_error "Failed to clean Zypper cache"
				return 1
			fi
			if ! zypper refresh; then
				log_error "Failed to refresh Zypper repositories"
				return 1
			fi
			;;
		*)
			log_error "Unsupported package manager. Skipping system-specific cleanup."
			return 1
			;;
	esac
	if command -v journalctl &>/dev/null; then
		if ! journalctl --rotate --vacuum-time=1d --vacuum-size=500M; then
			log_error "Failed to rotate and vacuum journalctl logs"
			return 1
		fi
	fi
	if ! find /var/log -type f -delete; then
		log_error "Failed to delete log files"
		return 1
	fi
	if ! rm -rf /tmp/*; then
		log_error "Failed to remove temporary files"
		return 1
	fi
	for cmd in docker npm pip; do
		if command -v "$cmd" &>/dev/null; then
			case "$cmd" in
				npm)
					if ! npm cache clean --force; then
						log_error "Failed to clean NPM cache"
						return 1
					fi
					;;
				pip)
					if ! pip cache purge; then
						log_error "Failed to purge PIP cache"
						return 1
					fi
					;;
			esac
		fi
	done
	if ! rm -rf ~/.cache/*; then
		log_error "Failed to remove user cache files"
		return 1
	fi
	if ! rm -rf ~/.thumbnails/*; then
		log_error "Failed to remove thumbnail files"
		return 1
	fi
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "${CLR2}FINISHED${CLR0}\n"
}
SYS_INFO() {
	echo -e "${CLR3}System Information${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "- Hostname:\t\t${CLR2}$(hostname)${CLR0}"
	echo -e "- Operating System:\t${CLR2}$(CHECK_OS)${CLR0}"
	echo -e "- Kernel Version:\t${CLR2}$(uname -r)${CLR0}"
	echo -e "- System Language:\t${CLR2}$LANG${CLR0}"
	echo -e "- Shell Version:\t${CLR2}$(SHELL_VER)${CLR0}"
	echo -e "- Last System Update:\t${CLR2}$(date '+%Y-%m-%d %H:%M')${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "- Architecture:\t\t${CLR2}$(uname -m)${CLR0}"
	echo -e "- CPU Model:\t\t${CLR2}$(CPU_MODEL)${CLR0}"
	echo -e "- CPU Cores:\t\t${CLR2}$(nproc)${CLR0}"
	echo -e "- CPU Frequency:\t${CLR2}$(CPU_FREQ)${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "- Memory Usage:\t\t${CLR2}$(MEM_USAGE)${CLR0}"
	echo -e "- Swap Usage:\t\t${CLR2}$(SWAP_USAGE)${CLR0}"
	echo -e "- Disk Usage:\t\t${CLR2}$(DISK_USAGE)${CLR0}"
	echo -e "- File System Type:\t${CLR2}$(df -T / | awk 'NR==2 {print $2}')${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "- IPv4 Address:\t\t${CLR2}$(IPv4_ADDR)${CLR0}"
	echo -e "- IPv6 Address:\t\t${CLR2}$(IPv6_ADDR)${CLR0}"
	echo -e "- MAC Address:\t\t${CLR2}$(MAC_ADDR)${CLR0}"
	echo -e "- Network Provider:\t${CLR2}$(curl -s ipinfo.io | jq -r .org)${CLR0}"
	echo -e "- DNS Servers:\t\t${CLR2}$(DNS_ADDR)${CLR0}"
	echo -e "- Public IP:\t\t${CLR2}$(PUBLIC_IP)${CLR0}"
	echo -e "- Network Interface:\t${CLR2}$(INTERFACE)${CLR0}"
	echo -e "- Connection Speed:\t${CLR2}$(ethtool $(ip route show default | awk '/default/ {print $5}') | grep -oP 'Speed: \K[^ ]*')${CLR0}"
	echo -e "- Timezone:\t\t${CLR2}$(TIMEZONE)${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "- Load Average:\t\t${CLR2}$(LOAD_AVERAGE)${CLR0}"
	echo -e "- Process Count:\t${CLR2}$(ps aux | wc -l)${CLR0}"
	echo -e "- Packages Installed:\t${CLR2}$(PKG_COUNT)${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "- Uptime:\t\t${CLR2}$(uptime -p | sed 's/up //')${CLR0}"
	echo -e "- Boot Time:\t\t${CLR2}$(who -b | awk '{print $3, $4}')${CLR0}"
	echo -e "${CLR8}$(LINE - "32")${CLR0}"
	echo -e "- Virtualization:\t${CLR2}$(CHECK_VIRT)${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
}
SYS_UPDATE() {
	CHECK_ROOT
	echo -e "${CLR3}Updating system software...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
		*apk)
			if ! apk update && apk upgrade; then
				log_error "Failed to update and upgrade packages using apk"
				return 1
			fi
			;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				echo "Waiting for dpkg lock to be released..."
				sleep 1
			done
			if ! DEBIAN_FRONTEND=noninteractive apt update -y && apt full-upgrade -y; then
				log_error "Failed to update and upgrade packages using apt"
				return 1
			fi
			;;
		*dnf)
			if ! dnf -y update; then
				log_error "Failed to update packages using dnf"
				return 1
			fi
			;;
		*opkg)
			if ! opkg update && opkg upgrade; then
				log_error "Failed to update and upgrade packages using opkg"
				return 1
			fi
			;;
		*pacman)
			if ! pacman -Syu --noconfirm; then
				log_error "Failed to update and upgrade packages using pacman"
				return 1
			fi
			;;
		*yum)
			if ! yum -y update; then
				log_error "Failed to update packages using yum"
				return 1
			fi
			;;
		*zypper)
			if ! zypper refresh && zypper update -y; then
				log_error "Failed to refresh and update packages using zypper"
				return 1
			fi
			;;
		*)
			log_error "Unsupported package manager"
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