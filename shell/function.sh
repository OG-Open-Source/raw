#!/bin/bash
# Author: OGATA Open-Source
# Version: 3.034.002
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

crontab -l 2>/dev/null | grep -q 'bash <(curl -sL raw.ogtt.tk/shell/function.sh)' || (echo "0 0 * * * bash <(curl -sL raw.ogtt.tk/shell/function.sh)" >> function-update && crontab function-update && rm function-update)
curl -sSL "https://raw.ogtt.tk/shell/function.sh" -o "function.sh"
grep -q "source ./function.sh" ~/.bashrc || {
	echo "source ./function.sh" >> ~/.bashrc
	source ~/.bashrc
}

error() {
	echo -e "${CLR1}$1${CLR0}"
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $SH - $1" >> ./ogos-error.log
	return 1
}

ADD() {
	CHECK_ROOT
	if [ $# -eq 0 ]; then
		error "No packages specified for installation"
	fi
	for app in "$@"; do
		echo -e "${CLR3}INSTALL [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
			*apk)
				if ! apk info -e "$app" &>/dev/null; then
					echo "* Package $app is not installed. Attempting installation..."
					apk update || { error "Failed to update package lists"; continue; }
					apk add "$app" || { error "Failed to install $app using apk"; continue; }
					if apk info -e "$app" &>/dev/null; then
						echo "* Package $app installed successfully."
					else
						error "Package $app installation failed or not verified."
					fi
				else
					echo "* Package $app is already installed."
				fi
				;;
			*apt)
				if ! dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "ok installed"; then
					echo "* Package $app is not installed. Attempting installation..."
					apt update || { error "Failed to update package lists"; continue; }
					apt install -y "$app" || { error "Failed to install $app using apt"; continue; }
					if dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "ok installed"; then
						echo "* Package $app installed successfully."
					else
						error "Package $app installation failed or not verified."
					fi
				else
					echo "* Package $app is already installed."
				fi
				;;
			*dnf)
				if ! dnf list installed "$app" &>/dev/null; then
					echo "* Package $app is not installed. Attempting installation..."
					dnf check-update || { error "Failed to check for updates"; continue; }
					dnf install -y "$app" || { error "Failed to install $app using dnf"; continue; }
					if dnf list installed "$app" &>/dev/null; then
						echo "* Package $app installed successfully."
					else
						error "Package $app installation failed or not verified."
					fi
				else
					echo "* Package $app is already installed."
				fi
				;;
			*opkg)
				if ! opkg list-installed | grep -q "^$app "; then
					echo "* Package $app is not installed. Attempting installation..."
					opkg update || { error "Failed to update package lists"; continue; }
					opkg install "$app" || { error "Failed to install $app using opkg"; continue; }
					if opkg list-installed | grep -q "^$app "; then
						echo "* Package $app installed successfully."
					else
						error "Package $app installation failed or not verified."
					fi
				else
					echo "* Package $app is already installed."
				fi
				;;
			*pacman)
				if ! pacman -Qi "$app" &>/dev/null; then
					echo "* Package $app is not installed. Attempting installation..."
					pacman -Sy || { error "Failed to synchronize package databases"; continue; }
					pacman -S --noconfirm "$app" || { error "Failed to install $app using pacman"; continue; }
					if pacman -Qi "$app" &>/dev/null; then
						echo "* Package $app installed successfully."
					else
						error "Package $app installation failed or not verified."
					fi
				else
					echo "* Package $app is already installed."
				fi
				;;
			*yum)
				if ! yum list installed "$app" &>/dev/null; then
					echo "* Package $app is not installed. Attempting installation..."
					yum check-update || { error "Failed to check for updates"; continue; }
					yum install -y "$app" || { error "Failed to install $app using yum"; continue; }
					if yum list installed "$app" &>/dev/null; then
						echo "* Package $app installed successfully."
					else
						error "Package $app installation failed or not verified."
					fi
				else
					echo "* Package $app is already installed."
				fi
				;;
			*zypper)
				if ! zypper se -i -x "$app" &>/dev/null; then
					echo "* Package $app is not installed. Attempting installation..."
					zypper refresh || { error "Failed to refresh repositories"; continue; }
					zypper install -y "$app" || { error "Failed to install $app using zypper"; continue; }
					if zypper se -i -x "$app" &>/dev/null; then
						echo "* Package $app installed successfully."
					else
						error "Package $app installation failed or not verified."
					fi
				else
					echo "* Package $app is already installed."
				fi
				;;
			*)
				error "No supported package manager found"
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
		error "Unknown distribution"
	fi
}
CHECK_ROOT() {
	if [ "$EUID" -ne 0 ] || [ "$(id -u)" -ne 0 ]; then
		error "Please run this script as root user."
		exit 1
	fi
}
CHECK_VIRT() {
	virt_type=$(systemd-detect-virt 2>/dev/null)
	if [ -z "$virt_type" ]; then
		error "Failed to detect virtualization"
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
	cd "$HOME" || return
	clear
}
CPU_FREQ() {
	if [ ! -f /proc/cpuinfo ]; then
		error "Unable to access /proc/cpuinfo"
	fi
	cpu_freq=$(awk -F ': ' '/^cpu MHz/ {sum += $2; count++} END {if (count > 0) print sum / count; else print "N/A"}' /proc/cpuinfo)
	if [ "$cpu_freq" = "N/A" ]; then
		error "Failed to calculate CPU frequency"
	fi
	cpu_freq_ghz=$(awk -v freq="$cpu_freq" 'BEGIN {printf "%.2f", freq / 1000}')
	if [ -z "$cpu_freq_ghz" ]; then
		error "Failed to convert CPU frequency to GHz"
	fi
	echo "${cpu_freq_ghz} GHz"
}
CPU_MODEL() {
	if command -v lscpu >/dev/null 2>&1; then
		lscpu | awk -F': +' '/Model name:/ {print $2; exit}'
	elif [ -f /proc/cpuinfo ]; then
		awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo
	elif command -v sysctl >/dev/null 2>&1; then
		sysctl -n machdep.cpu.brand_string 2>/dev/null || echo -e "${CLR1}Unknown${CLR0}"
	else
		error "Unable to determine CPU model"
	fi
}
COPYRIGHT() {
	echo "Copyright (C) 2024 OG|OS OGATA-Open-Source. All Rights Reserved."
}

DEL() {
	CHECK_ROOT
	if [ $# -eq 0 ]; then
		error "No packages specified for removal"
	fi
	for app in "$@"; do
		echo -e "${CLR3}REMOVE [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
			*apk)
				if apk info "$app" &>/dev/null; then
					echo "* Package $app is installed. Attempting removal..."
					apk del "$app" || error "Failed to remove package $app"
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*apt)
				if dpkg -l | grep -q "^ii  $app"; then
					echo "* Package $app is installed. Attempting removal..."
					apt purge -y "$app" || error "Failed to purge package $app"
					apt autoremove -y || error "Failed to autoremove package $app"
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*dnf)
				if dnf list installed "$app" &>/dev/null; then
					echo "* Package $app is installed. Attempting removal..."
					dnf remove -y "$app" || error "Failed to remove package $app"
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*opkg)
				if opkg list-installed | grep -q "$app"; then
					echo "* Package $app is installed. Attempting removal..."
					opkg remove "$app" || error "Failed to remove package $app"
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*pacman)
				if pacman -Q "$app" &>/dev/null; then
					echo "* Package $app is installed. Attempting removal..."
					pacman -Rns --noconfirm "$app" || error "Failed to remove package $app"
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*yum)
				if yum list installed "$app" &>/dev/null; then
					echo "* Package $app is installed. Attempting removal..."
					yum remove -y "$app" || error "Failed to remove package $app"
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*zypper)
				if zypper se --installed-only "$app" | grep -q "$app"; then
					echo "* Package $app is installed. Attempting removal..."
					zypper remove -y "$app" || error "Failed to remove package $app"
					echo "* Package $app removed successfully."
				else
					echo "* Package $app is not installed."
				fi
				;;
			*)
				error "Unsupported package manager"
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
		error "/etc/resolv.conf file not found"
	fi
	ipv4_servers=$(grep -E '^nameserver' /etc/resolv.conf | awk '{print $2}' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')
	ipv6_servers=$(grep -E '^nameserver' /etc/resolv.conf | awk '{print $2}' | grep -E '^[0-9a-fA-F:]+$')

	if [ -z "$ipv4_servers" ] && [ -z "$ipv6_servers" ]; then
		error "No DNS servers found in /etc/resolv.conf"
	fi
	ipv4_result=""
	ipv6_result=""
	for server in $ipv4_servers; do
		if [ -z "$ipv4_result" ]; then
			ipv4_result="$server"
		else
			ipv4_result="$ipv4_result $server"
		fi
	done
	for server in $ipv6_servers; do
		if [ -z "$ipv6_result" ]; then
			ipv6_result="$server"
		else
			ipv6_result="$ipv6_result $server"
		fi
	done
	if [ -z "$ipv4_result" ] && [ -z "$ipv6_result" ]; then
		error "Failed to parse DNS server addresses"
	fi
	if [ "$1" = "-4" ]; then
		echo "$ipv4_result"
	elif [ "$1" = "-6" ]; then
		echo "$ipv6_result"
	else
		echo "$ipv4_result   $ipv6_result"
	fi
}

FIND() {
	if [ $# -eq 0 ]; then
		error "No search terms provided"
	fi
	for app in "$@"; do
		echo -e "${CLR3}SEARCH [$app]${CLR0}"
		case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
			*apk)
				apk search "$app" || error "No results found for $app"
				;;
			*apt)
				apt-cache search "$app" || error "No results found for $app"
				;;
			*dnf)
				dnf search "$app" || error "No results found for $app"
				;;
			*opkg)
				opkg search "$app" || error "No results found for $app"
				;;
			*pacman)
				pacman -Ss "$app" || error "No results found for $app"
				;;
			*yum)
				yum search "$app" || error "No results found for $app"
				;;
			*zypper)
				zypper search "$app" || error "No results found for $app"
				;;
			*)
				error "Unsupported package manager"
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
				case "${operation^^}" in
					"RX.BYTES") echo "$rx_bytes" ;;
					"RX.DROP") echo "$rx_drop" ;;
					"RX.PACKETS") echo "$rx_packets" ;;
					"TX.BYTES") echo "$tx_bytes" ;;
					"TX.DROP") echo "$tx_drop" ;;
					"TX.PACKETS") echo "$tx_packets" ;;
				esac
			fi
		else
			error "No stats found for interface: $interface"
		fi
	done
}
IPv4_ADDR() {
	timeout 1s dig +short -4 myip.opendns.com @resolver1.opendns.com 2>/dev/null || \
	timeout 1s curl -s ipv4.ip.sb 2>/dev/null || \
	timeout 1s wget -qO- -4 ifconfig.me 2>/dev/null || \
	{ error "Unable to determine IPv4 address"; }
}
IPv6_ADDR() {
	timeout 1s curl -s ipv6.ip.sb 2>/dev/null || \
	timeout 1s wget -qO- -6 ifconfig.me 2>/dev/null || \
	{ error "Unable to determine IPv6 address"; }
}

LAST_UPDATE() {
	if [ -f /var/log/apt/history.log ]; then
		grep 'End-Date:' /var/log/apt/history.log | tail -n 1 | sed 's/End-Date: *//' | tr -s ' ' || { error "Failed to parse apt history log"; }
	elif [ -f /var/log/dpkg.log ]; then
		tail -n 1 /var/log/dpkg.log | awk '{print $1, $2}' || { error "Failed to parse dpkg log"; }
	elif command -v rpm >/dev/null 2>&1; then
		rpm -qa --last | head -n 1 | awk '{print $3, $4, $5, $6, $7}' || { error "Failed to retrieve RPM package information"; }
	else
		error "Unable to determine last update time"
	fi
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
		error "Failed to retrieve MAC address"
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
	{ error "Unable to determine network provider"; }
}

PKG_COUNT() {
	case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
		*apk)
			apk info | wc -l || error "Failed to count APK packages"
			;;
		*apt)
			dpkg --get-selections | wc -l || error "Failed to count APT packages"
			;;
		*dnf|*yum)
			rpm -qa | wc -l || error "Failed to count RPM packages"
			;;
		*opkg)
			opkg list-installed | wc -l || error "Failed to count OPKG packages"
			;;
		*pacman)
			pacman -Q | wc -l || error "Failed to count Pacman packages"
			;;
		*zypper)
			zypper se --installed-only | wc -l || error "Failed to count Zypper packages"
			;;
		*)
			error "Unsupported package manager"
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
			return
		fi
	done
	error "Unable to determine public IP"
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
			apk cache clean || error "Failed to clean APK cache"
			rm -rf /tmp/* /var/cache/apk/* /var/log/* || error "Failed to remove temporary files"
			apk fix || error "Failed to fix APK packages"
			;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				sleep 0.5
			done
			DEBIAN_FRONTEND=noninteractive dpkg --configure -a || error "Failed to configure pending packages"
			apt autoremove --purge -y || error "Failed to autoremove packages"
			apt clean -y || error "Failed to clean APT cache"
			apt autoclean -y || error "Failed to autoclean APT cache"
			;;
		*dnf)
			dnf autoremove -y || error "Failed to autoremove packages"
			dnf clean all || error "Failed to clean DNF cache"
			dnf makecache || error "Failed to make DNF cache"
			;;
		*opkg)
			rm -rf /tmp/* /var/log/* || error "Failed to remove temporary files"
			opkg update || error "Failed to update OPKG"
			opkg clean || error "Failed to clean OPKG cache"
			;;
		*pacman)
			pacman -Syu --noconfirm || error "Failed to update and upgrade packages"
			pacman -Sc --noconfirm || error "Failed to clean pacman cache"
			pacman -Scc --noconfirm || error "Failed to clean all pacman cache"
			;;
		*yum)
			yum autoremove -y || error "Failed to autoremove packages"
			yum clean all || error "Failed to clean YUM cache"
			yum makecache || error "Failed to make YUM cache"
			;;
		*zypper)
			zypper clean --all || error "Failed to clean Zypper cache"
			zypper refresh || error "Failed to refresh Zypper repositories"
			;;
		*)
			error "Unsupported package manager. Skipping system-specific cleanup."
			;;
	esac
	if command -v journalctl &>/dev/null; then
		journalctl --rotate --vacuum-time=1d --vacuum-size=500M || error "Failed to rotate and vacuum journalctl logs"
	fi
	find /var/log -type f -delete || error "Failed to delete log files"
	rm -rf /tmp/* || error "Failed to remove temporary files"
	for cmd in docker npm pip; do
		if command -v "$cmd" &>/dev/null; then
			case "$cmd" in
				npm)
					npm cache clean --force || error "Failed to clean NPM cache"
					;;
				pip)
					pip cache purge || error "Failed to purge PIP cache"
					;;
			esac
		fi
	done
	rm -rf ~/.cache/* || error "Failed to remove user cache files"
	rm -rf ~/.thumbnails/* || error "Failed to remove thumbnail files"
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
	echo -e "- Last System Update:\t${CLR2}$(LAST_UPDATE)${CLR0}"
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
SYS_OPTIMIZE() {
	CHECK_ROOT
	echo -e "${CLR3}Optimizing system configuration...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	SYSCTL_CONF="/etc/sysctl.d/99-custom-optimizations.conf"
	echo "# Custom system optimizations" > "$SYSCTL_CONF"
	echo "* Adjusting swappiness..."
	echo "vm.swappiness = 10" >> "$SYSCTL_CONF"
	if command -v systemctl &>/dev/null && systemctl list-unit-files | grep -q systemd-oomd; then
		echo "* Enabling and starting systemd-oomd..."
		systemctl enable --now systemd-oomd || error "Failed to enable and start systemd-oomd"
	fi
	echo "* Optimizing disk I/O scheduler..."
	for disk in /sys/block/sd*; do
		if [ -e "$disk/queue/scheduler" ]; then
			echo "mq-deadline" > "$disk/queue/scheduler" || error "Failed to set I/O scheduler for $disk"
			echo "echo mq-deadline > $disk/queue/scheduler" >> /etc/rc.local
		fi
	done
	echo "* Disabling unnecessary services..."
	services_to_disable=("bluetooth" "cups" "avahi-daemon")
	for service in "${services_to_disable[@]}"; do
		if systemctl is-active --quiet "$service"; then
			systemctl disable --now "$service" || error "Failed to disable $service"
		fi
	done
	echo "* Updating system limits..."
	limits_file="/etc/security/limits.conf"
	grep -qxF "* soft nofile 65535" "$limits_file" || echo "* soft nofile 65535" >> "$limits_file"
	grep -qxF "* hard nofile 65535" "$limits_file" || echo "* hard nofile 65535" >> "$limits_file"
	echo "* Adjusting TCP settings and kernel parameters..."
	kernel_params=(
		"net.ipv4.tcp_fin_timeout = 30"
		"net.ipv4.tcp_keepalive_time = 1200"
		"net.ipv4.tcp_max_syn_backlog = 8192"
		"net.ipv4.tcp_tw_reuse = 1"
		"vm.dirty_ratio = 10"
		"vm.dirty_background_ratio = 5"
		"net.core.rmem_max = 16777216"
		"net.core.wmem_max = 16777216"
		"net.ipv4.tcp_rmem = 4096 87380 16777216"
		"net.ipv4.tcp_wmem = 4096 65536 16777216"
		"vm.vfs_cache_pressure = 50"
	)
	for param in "${kernel_params[@]}"; do
		echo "$param" >> "$SYSCTL_CONF"
	done
	echo "* Clearing ARP cache..."
	ip -s -s neigh flush all || error "Failed to clear ARP cache"
	echo "* Applying all sysctl changes..."
	sysctl -p "$SYSCTL_CONF" || error "Failed to apply sysctl changes"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "${CLR2}FINISHED${CLR0}\n"
}
SYS_REBOOT() {
	CHECK_ROOT
	echo -e "${CLR3}Preparing to reboot system...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	active_users=$(who | wc -l)
	if [ "$active_users" -gt 1 ]; then
		echo -e "${CLR1}Warning: There are currently $active_users active users on the system.${CLR0}"
		echo -e "Active users:"
		who | awk '{print $1 " since " $3 " " $4}'
		echo
	fi
	important_processes=$(ps aux --no-headers | grep -vE '^root|^\w+\s+[12]\s+' | wc -l)
	if [ "$important_processes" -gt 0 ]; then
		echo -e "${CLR1}Warning: There are $important_processes non-system processes running.${CLR0}"
		echo -e "Top 5 processes by CPU usage:"
		ps aux --sort=-%cpu | head -n 6
		echo
	fi
	read -p "Are you sure you want to reboot the system now? (y/N) " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		echo -e "${CLR2}Reboot cancelled.${CLR0}"
		return 1
	fi
	echo "* Performing final checks before reboot..."
	sync || error "Failed to sync filesystems"
	echo -e "${CLR3}Initiating system reboot...${CLR0}"
	shutdown -r now "System is going down for reboot" || error "Failed to initiate reboot"
	echo -e "${CLR2}Reboot command issued successfully. The system will reboot momentarily.${CLR0}"
}
SYS_UPDATE() {
	CHECK_ROOT
	echo -e "${CLR3}Updating system software...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	case $(command -v apk apt dnf opkg pacman yum zypper | head -n1) in
		*apk)
			echo "* Updating package lists..."
			apk update || error "Failed to update package lists using apk"
			echo "* Upgrading packages..."
			apk upgrade || error "Failed to upgrade packages using apk"
			;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				echo "* Waiting for dpkg lock to be released..."
				sleep 1
			done
			echo "* Updating package lists..."
			DEBIAN_FRONTEND=noninteractive apt update -y || error "Failed to update package lists using apt"
			echo "* Upgrading packages..."
			DEBIAN_FRONTEND=noninteractive apt full-upgrade -y || error "Failed to upgrade packages using apt"
			;;
		*dnf)
			echo "* Updating packages..."
			dnf -y update || error "Failed to update packages using dnf"
			;;
		*opkg)
			echo "* Updating package lists..."
			opkg update || error "Failed to update package lists using opkg"
			echo "* Upgrading packages..."
			opkg upgrade || error "Failed to upgrade packages using opkg"
			;;
		*pacman)
			echo "* Updating package databases and upgrading packages..."
			pacman -Syu --noconfirm || error "Failed to update and upgrade packages using pacman"
			;;
		*yum)
			echo "* Updating packages..."
			yum -y update || error "Failed to update packages using yum"
			;;
		*zypper)
			echo "* Refreshing repositories..."
			zypper refresh || error "Failed to refresh repositories using zypper"
			echo "* Updating packages..."
			zypper update -y || error "Failed to update packages using zypper"
			;;
		*)
			error "Unsupported package manager"
			;;
	esac
	echo "* Updating shell functions..."
	bash <(curl -L raw.ogtt.tk/shell/function.sh) || error "Failed to update shell functions"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "${CLR2}FINISHED${CLR0}\n"
}

TIMEZONE() {
	timezone=$(readlink /etc/localtime | sed 's|^.*/zoneinfo/||' 2>/dev/null) ||
	timezone=$(command -v timedatectl >/dev/null 2>&1 && timedatectl status | awk '/Time zone:/ {print $3}') ||
	timezone=$([ -f /etc/timezone ] && cat /etc/timezone)
	echo "${timezone:-Unknown}"
}