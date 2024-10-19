#!/bin/bash

Author="OGATA Open-Source"
Version="3.035.010"
License="MIT License"

SH="function.sh"
CLR1="\033[0;31m"
CLR2="\033[0;32m"
CLR3="\033[0;33m"
CLR4="\033[0;34m"
CLR5="\033[0;35m"
CLR6="\033[0;36m"
CLR7="\033[0;37m"
CLR8="\033[0;96m"
CLR9="\033[0;97m"
CLR0="\033[0m"

error() {
	echo -e "${CLR1}$1${CLR0}"
	echo "$(date '+%Y-%m-%d %H:%M:%S') | $SH - $Version - $(echo -e "$1" | tr -d '\n')" >> /var/log/ogos-error.log
	return 1
}

ADD() {
	CHECK_ROOT
	[ $# -eq 0 ] && { error "No items specified for installation\n"; return 1; }
	mode="package"
	while [ $# -gt 0 ]; do
		case "$1" in
			-f) mode="file"; shift; continue ;;
			-d) mode="directory"; shift; continue ;;
			*.deb)
				deb_file=$(basename "$1")
				echo -e "${CLR3}INSTALL DEB PACKAGE [$deb_file]\n${CLR0}"
				GET "$1"
				if [ -f "$deb_file" ]; then
					dpkg -i "$deb_file" || { error "Failed to install $deb_file using dpkg\n"; rm -f "$deb_file"; shift; continue; }
					apt --fix-broken install -y || { error "Failed to fix dependencies\n"; rm -f "$deb_file"; shift; continue; }
					echo "* DEB package $deb_file installed successfully"
					rm -f "$deb_file"
					echo -e "${CLR2}FINISHED${CLR0}\n"
				else
					error "DEB package file $deb_file not found\n"
					shift
					continue
				fi
				shift
				;;
			*)
				echo -e "${CLR3}INSERT ${mode^^} [$1]${CLR0}"
				case "$mode" in
					"file"|"directory")
						if [ -"${mode:0:1}" "$1" ]; then
							error "${mode^} $1 already exists\n"
							shift
							continue
						else
							case "$mode" in
								"file") touch "$1" ;;
								"directory") mkdir -p "$1" ;;
							esac || { error "Failed to create $mode $1\n"; shift; continue; }
							echo "* ${mode^} $1 created successfully"
							echo -e "${CLR2}FINISHED${CLR0}\n"
						fi
						shift
						;;
					"package")
						pkg_manager=$(command -v apk apt opkg pacman yum zypper dnf | head -n1)
						pkg_manager=${pkg_manager##*/}
						case $pkg_manager in
							apk|apt|opkg|pacman|yum|zypper|dnf)
								is_installed() {
									case $pkg_manager in
										apk) apk info -e "$1" &>/dev/null ;;
										apt) dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "ok installed" ;;
										opkg) opkg list-installed | grep -q "^$1 " ;;
										pacman) pacman -Qi "$1" &>/dev/null ;;
										yum|dnf) $pkg_manager list installed "$1" &>/dev/null ;;
										zypper) zypper se -i -x "$1" &>/dev/null ;;
									esac
								}
								install_package() {
									case $pkg_manager in
										apk) apk update && apk add "$1" ;;
										apt) apt update && apt install -y "$1" ;;
										opkg) opkg update && opkg install "$1" ;;
										pacman) pacman -Sy && pacman -S --noconfirm "$1" ;;
										yum|dnf) $pkg_manager install -y "$1" ;;
										zypper) zypper refresh && zypper install -y "$1" ;;
									esac
								}
								if ! is_installed "$1"; then
									echo "* Package $1 is not installed. Attempting installation..."
									if install_package "$1"; then
										if is_installed "$1"; then
											echo "* Package $1 installed successfully"
											echo -e "${CLR2}FINISHED${CLR0}\n"
										else
											error "Failed to install $1 using $pkg_manager\n"
										fi
									else
										error "Failed to install $1 using $pkg_manager\n"
									fi
								else
									echo "* Package $1 is already installed"
									echo -e "${CLR2}FINISHED${CLR0}\n"
								fi
								;;
							*)
								error "Unsupported package manager\n"
								;;
						esac
						shift
						;;
				esac
				;;
		esac
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
		return 1
	fi
}
CHECK_ROOT() {
	if [ "$EUID" -ne 0 ] || [ "$(id -u)" -ne 0 ]; then
		error "Please run this script as root user\n"
		exit 1
	fi
}
CHECK_VIRT() {
	virt_type=$(systemd-detect-virt 2>/dev/null)
	if [ -z "$virt_type" ]; then
		error "Failed to detect virtualization"
		return 1
	fi
	case "$virt_type" in
		kvm)
			grep -qi "proxmox" /sys/class/dmi/id/product_name 2>/dev/null && echo "Proxmox VE (KVM)" || echo "KVM"
			;;
		microsoft)
			echo "Microsoft Hyper-V"
			;;
		none)
			if grep -q "container=lxc" /proc/1/environ 2>/dev/null; then
				echo "LXC container"
			elif grep -qi "hypervisor" /proc/cpuinfo 2>/dev/null; then
				echo "Virtual machine (Unknown type)"
			else
				echo "Not detected (possibly bare metal)"
			fi
			;;
		*)
			echo "${virt_type:-Not detected (possibly bare metal)}"
			;;
	esac
}
CLEAN() {
	cd "$HOME" || return
	clear
}
CPU_FREQ() {
	[ ! -f /proc/cpuinfo ] && { error "Unable to access /proc/cpuinfo"; return 1; }
	cpu_freq=$(awk '
		/^cpu MHz/ {
			sum += $4
			count++
		}
		END {
			if (count > 0)
				printf "%.2f", sum / count / 1000
			else
				print "N/A"
		}
	' /proc/cpuinfo)
	[ "$cpu_freq" = "N/A" ] && { error "N/A"; return 1; }
	echo "${cpu_freq} GHz"
}
CPU_MODEL() {
	if command -v lscpu &>/dev/null; then
		lscpu | awk -F': +' '/Model name/ {print $2; exit}'
	elif [ -f /proc/cpuinfo ]; then
		sed -n 's/^model name[[:space:]]*: //p' /proc/cpuinfo | head -n1
	elif command -v sysctl &>/dev/null && sysctl -n machdep.cpu.brand_string &>/dev/null; then
		sysctl -n machdep.cpu.brand_string
	else
		echo -e "${CLR1}Unknown${CLR0}"
		return 1
	fi
}
CONVERT_SIZE() {
	[ -z "$1" ] && return
	size=$1
	unit=${2:-B}
	base=${3:-1024}
	suffixes=("B" "KiB" "MiB" "GiB" "TiB" "PiB" "EiB" "ZiB" "YiB")
	[ "$base" -eq 1000 ] && suffixes=("B" "KB" "MB" "GB" "TB" "PB" "EB" "ZB" "YB")
	i=0
	while (( $(echo "$size >= $base" | bc -l) )); do
		size=$(echo "scale=2; $size / $base" | bc -l)
		((i++))
	done
	printf "%.2f %s\n" $size "${suffixes[$i]}"
}
COPYRIGHT() {
	echo "Copyright (C) 2024 OG|OS OGATA-Open-Source. All Rights Reserved."
}

DEL() {
	CHECK_ROOT
	[ $# -eq 0 ] && { error "No items specified for deletion\n"; return 1; }
	mode="package"
	while [ $# -gt 0 ]; do
		case "$1" in
			-f) mode="file"; shift; continue ;;
			-d) mode="directory"; shift; continue ;;
			*)
				echo -e "${CLR3}REMOVE ${mode^^} [$1]${CLR0}"
				case "$mode" in
					"file"|"directory")
						if [ -"${mode:0:1}" "$1" ]; then
							echo "* ${mode^} $1 exists. Attempting removal..."
							rm -rf"${mode:0:1}" "$1" || { error "Failed to remove $mode $1\n"; shift; continue; }
							echo "* ${mode^} $1 removed successfully"
							echo -e "${CLR2}FINISHED${CLR0}\n"
						else
							error "${mode^} $1 does not exist\n"
						fi
						;;
					"package")
						pkg_manager=$(command -v apk apt opkg pacman yum zypper dnf | head -n1)
						pkg_manager=${pkg_manager##*/}
						case $pkg_manager in
							apk|apt|opkg|pacman|yum|zypper|dnf)
								is_installed() {
									case $pkg_manager in
										apk) apk info -e "$1" &>/dev/null ;;
										apt) dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "ok installed" ;;
										opkg) opkg list-installed | grep -q "^$1 " ;;
										pacman) pacman -Qi "$1" &>/dev/null ;;
										yum|dnf) $pkg_manager list installed "$1" &>/dev/null ;;
										zypper) zypper se -i -x "$1" &>/dev/null ;;
									esac
								}
								remove_package() {
									case $pkg_manager in
										apk) apk del "$1" ;;
										apt) apt purge -y "$1" && apt autoremove -y ;;
										opkg) opkg remove "$1" ;;
										pacman) pacman -Rns --noconfirm "$1" ;;
										yum|dnf) $pkg_manager remove -y "$1" ;;
										zypper) zypper remove -y "$1" ;;
									esac
								}
								if is_installed "$1"; then
									echo "* Package $1 is installed. Attempting removal..."
									if remove_package "$1"; then
										if ! is_installed "$1"; then
											echo "* Package $1 removed successfully"
											echo -e "${CLR2}FINISHED${CLR0}\n"
										else
											error "Failed to remove $1 using $pkg_manager\n"
										fi
									else
										error "Failed to remove $1 using $pkg_manager\n"
									fi
								else
									error "Package $1 is not installed\n"
								fi
								;;
							*)
								error "Unsupported package manager\n"
								;;
						esac
						;;
				esac
				shift
				;;
		esac
	done
}
DISK_USAGE() {
	used=$(df -B1 / | awk 'NR==2 {printf "%.0f", $3}')
	total=$(df -B1 / | awk 'NR==2 {printf "%.0f", $2}')
	percentage=$(df / | awk 'NR==2 {printf "%.2f", $3/$2 * 100}')
	echo "$(CONVERT_SIZE "$used") / $(CONVERT_SIZE "$total") ($percentage%)"
}
DNS_ADDR () {
	[ ! -f /etc/resolv.conf ] && { error "/etc/resolv.conf file not found"; return 1; }
	ipv4_servers=()
	ipv6_servers=()
	while read -r server; do
		if [[ $server =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
			ipv4_servers+=("$server")
		elif [[ $server =~ ^[0-9a-fA-F:]+$ ]]; then
			ipv6_servers+=("$server")
		fi
	done < <(grep -E '^nameserver' /etc/resolv.conf | awk '{print $2}')
	[[ ${#ipv4_servers[@]} -eq 0 && ${#ipv6_servers[@]} -eq 0 ]] && { error "No DNS servers found in /etc/resolv.conf"; return 1; }
	case "$1" in
		-4)
			[ ${#ipv4_servers[@]} -eq 0 ] && { error "No IPv4 DNS servers found"; return 1; }
			echo "${ipv4_servers[*]}"
			;;
		-6)
			[ ${#ipv6_servers[@]} -eq 0 ] && { error "No IPv6 DNS servers found"; return 1; }
			echo "${ipv6_servers[*]}"
			;;
		*)
			[ ${#ipv4_servers[@]} -eq 0 -a ${#ipv6_servers[@]} -eq 0 ] && { error "No DNS servers found"; return 1; }
			echo "${ipv4_servers[*]}   ${ipv6_servers[*]}"
			;;
	esac
}

FIND() {
	[ $# -eq 0 ] && { error "No search terms provided\n"; return 1; }
	package_manager=$(command -v apk apt opkg pacman yum zypper dnf | head -n1)
	case ${package_manager##*/} in
		apk) search_command="apk search" ;;
		apt) search_command="apt-cache search" ;;
		opkg) search_command="opkg search" ;;
		pacman) search_command="pacman -Ss" ;;
		yum) search_command="yum search" ;;
		zypper) search_command="zypper search" ;;
		dnf) search_command="dnf search" ;;
		*) error "Unsupported package manager\n"; return 1 ;;
	esac
	for target in "$@"; do
		echo -e "${CLR3}SEARCH [$target]${CLR0}"
		$search_command "$target" || { error "No results found for $target\n"; return 1; }
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

GET() {
	[ $# -eq 0 ] && { error "No URL specified for download\n"; return 1; }
	url="$1"
	if ! [[ "$url" =~ ^(http|https|ftp):// ]]; then
		if [[ "$url" =~ ^[a-zA-Z0-9.-]+(/[a-zA-Z0-9.-/]+)?$ ]]; then
			domain="${url%%/*}"
			if ping -c 1 -W 2 "$domain" &>/dev/null; then
				url="https://$url"
			else
				error "Unable to reach the specified domain: $domain\n"
				return 1
			fi
		else
			error "Invalid URL or domain format: $url\n"
			return 1
		fi
	fi
	target_dir="."
	output_file="${url##*/}"
	[ -z "$output_file" ] && output_file="index.html"
	rename_flag=false
	shift
	while [ $# -gt 0 ]; do
		case "$1" in
			-r)
				rename_flag=true
				if [ -z "$2" ] || [[ "$2" == -* ]]; then
					error "No filename specified after -r option\n"
					return 1
				fi
				output_file="$2"
				shift 2
				;;
			*)
				target_dir="$1"
				shift
				;;
		esac
	done
	mkdir -p "$target_dir" || { error "Failed to create directory $target_dir\n"; return 1; }
	output_file="$target_dir/$output_file"
	url=$(echo "$url" | sed -E 's#([^:])/+#\1/#g')
	url=$(echo "$url" | sed -E 's#^(https?|ftp):/+#\1://#')
	echo -e "${CLR3}DOWNLOAD [$url]${CLR0}"
	if ! curl -L -k -m 5 "$url" -o "$output_file"; then
		wget --no-check-certificate --timeout=5 --tries=2 "$url" -O "$output_file" || { error "Failed to download file using curl and wget is not available\n"; return 1; }
	fi
	if [ -f "$output_file" ]; then
		echo "* File downloaded successfully to $output_file"
		echo -e "${CLR2}FINISHED${CLR0}\n"
	else
		error "Failed to download file\n"
		return 1
	fi
}

INPUT() {
	read -e -p "$1" "$2"
}
INTERFACE() {
	interface=""
	Interfaces=()
	allInterfaces=$(cat /proc/net/dev | grep ':' | cut -d':' -f1 | sed 's/\s//g' | grep -iv '^lo\|^sit\|^stf\|^gif\|^dummy\|^vmnet\|^vir\|^gre\|^ipip\|^ppp\|^bond\|^tun\|^tap\|^ip6gre\|^ip6tnl\|^teql\|^ocserv\|^vpn\|^warp\|^wgcf\|^wg\|^docker' | sort -n)
	for interfaceItem in $allInterfaces; do
		Interfaces[${#Interfaces[@]}]=$interfaceItem
	done
	interfacesNum="${#Interfaces[*]}"
	default4Route=$(ip -4 route show default | grep -A 3 "^default")
	default6Route=$(ip -6 route show default | grep -A 3 "^default")
	getArrItemIdx() {
		item="$1"
		shift
		arr=("$@")
		for index in "${!arr[@]}"; do
			[[ "$item" == "${arr[index]}" ]] && return "$index"
		done
		return 255
	}
	for item in "${Interfaces[@]}"; do
		[ -z "$item" ] && continue
		if [[ "$default4Route" == *"$item"* ]] && [ -z "$interface4" ]; then
			interface4="$item"
			interface4DeviceOrder=$(getArrItemIdx "$item" "${Interfaces[@]}")
		fi
		if [[ "$default6Route" == *"$item"* ]] && [ -z "$interface6" ]; then
			interface6="$item"
			interface6DeviceOrder=$(getArrItemIdx "$item" "${Interfaces[@]}")
		fi
		[ -n "$interface4" ] && [ -n "$interface6" ] && break
	done
	interface="$interface4 $interface6"
	[[ "$interface4" == "$interface6" ]] && interface=$(echo "$interface" | cut -d' ' -f 1)
	[[ -z "$interface4" || -z "$interface6" ]] && {
		interface=$(echo "$interface" | sed 's/[[:space:]]//g')
		[[ -z "$interface4" ]] && interface4="$interface"
		[[ -z "$interface6" ]] && interface6="$interface"
	}
	if [ "$1" = "-i" ]; then
		for interface in $interface; do
			if stats=$(awk -v iface="$interface" '$1 ~ iface":" {print $2, $10}' /proc/net/dev); then
				read rx_bytes tx_bytes <<< "$stats"
				echo "$interface: RX: $(CONVERT_SIZE $rx_bytes), TX: $(CONVERT_SIZE $tx_bytes)"
			else
				error "No stats found for interface: $interface"
				return 1
			fi
		done
	else
		for interface in $interface; do
			if stats=$(awk -v iface="$interface" '$1 ~ iface":" {print $2, $3, $5, $10, $11, $13}' /proc/net/dev); then
				read rx_bytes rx_packets rx_drop tx_bytes tx_packets tx_drop <<< "$stats"
				echo "$interface"
			else
				error "No stats found for interface: $interface"
				return 1
			fi
		done
	fi
}
IP_ADDR() {
	version="$1"
	case "$version" in
		-4)
			ipv4_addr=$(timeout 1s dig +short -4 myip.opendns.com @resolver1.opendns.com 2>/dev/null) ||
			ipv4_addr=$(curl -m 1 -sL ipv4.ip.sb 2>/dev/null) ||
			ipv4_addr=$(wget --timeout=1 -qO- -4 ifconfig.me 2>/dev/null) ||
			[ -n "$ipv4_addr" ] && echo "$ipv4_addr" || { error "N/A"; return 1; }
			;;
		-6)
			ipv6_addr=$(curl -m 1 -sL ipv6.ip.sb 2>/dev/null) ||
			ipv6_addr=$(wget --timeout=1 -qO- -6 ifconfig.me 2>/dev/null) ||
			[ -n "$ipv6_addr" ] && echo "$ipv6_addr" || { error "N/A"; return 1; }
			;;
		*)
			ipv4_addr=$(IP_ADDR -4)
			ipv6_addr=$(IP_ADDR -6)
			[ -z "$ipv4_addr$ipv6_addr" ] && { error "N/A"; return 1; }
			[ -n "$ipv4_addr" ] && echo "IPv4: $ipv4_addr"
			[ -n "$ipv6_addr" ] && echo "IPv6: $ipv6_addr"
			return
			;;
	esac
}

LAST_UPDATE() {
	if [ -f /var/log/apt/history.log ]; then
		last_update=$(awk '/End-Date:/ {date=$2" "$3; time=$4; exit} END {print date, time}' /var/log/apt/history.log)
	elif [ -f /var/log/dpkg.log ]; then
		last_update=$(tail -n 1 /var/log/dpkg.log | awk '{print $1, $2}')
	elif command -v rpm &>/dev/null; then
		last_update=$(rpm -qa --last | head -n 1 | awk '{print $3, $4, $5, $6, $7}')
	fi
	[ -n "$last_update" ] && echo "$last_update" || { error "N/A"; return 1; }
}
LINE() {
	char="${1:--}"
	length="${2:-80}"
	printf '%*s\n' "$length" | tr ' ' "$char"
}
LOAD_AVERAGE() {
	read one_min five_min fifteen_min <<< $(uptime | awk -F'load average:' '{print $2}' | tr -d ',')
	printf "%.2f, %.2f, %.2f (%d cores)" "$one_min" "$five_min" "$fifteen_min" "$(nproc)"
}

MAC_ADDR() {
	mac_address=$(ip link show | awk '/ether/ {print $2; exit}')
	if [[ -n "$mac_address" ]]; then
		echo "$mac_address"
	else
		error "Failed to retrieve MAC address"
		return 1
	fi
}
MEM_USAGE() {
	used=$(free -b | awk '/^Mem:/ {print $3}')
	total=$(free -b | awk '/^Mem:/ {print $2}')
	percentage=$(free | awk '/^Mem:/ {printf("%.2f"), $3/$2 * 100.0}')
	echo "$(CONVERT_SIZE "$used") / $(CONVERT_SIZE "$total") ($percentage%)"
}
NET_PROVIDER() {
	result=$(curl -sL -m 1 ipinfo.io | jq -r .org) ||
	result=$(curl -sL -m 1 ipwhois.app/json | jq -r .org) ||
	result=$(curl -sL -m 1 ip-api.com/json | jq -r .org) ||
	[ -n "$result" ] && echo "$result" || { error "N/A"; return 1; }
}

PKG_COUNT() {
	pkg_manager=$(command -v apk apt opkg pacman yum zypper dnf 2>/dev/null | head -n1)
	case ${pkg_manager##*/} in
		apk) count_cmd="apk info" ;;
		apt) count_cmd="dpkg --get-selections" ;;
		opkg) count_cmd="opkg list-installed" ;;
		pacman) count_cmd="pacman -Q" ;;
		yum|dnf) count_cmd="rpm -qa" ;;
		zypper) count_cmd="zypper se --installed-only" ;;
		*) error "Unsupported package manager"; return 1 ;;
	esac
	$count_cmd | wc -l || { error "Failed to count packages for ${pkg_manager##*/}"; return 1; }
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
	ip=$(curl -sL -m 5 https://ifconfig.me)
	[ -n "$ip" ] && echo "$ip" || { error "N/A"; return 1; }
}

SHELL_VER() {
	if [ -n "${BASH_VERSION-}" ]; then
		echo "Bash ${BASH_VERSION}"
	elif [ -n "${ZSH_VERSION-}" ]; then
		echo "Zsh ${ZSH_VERSION}"
	else
		error "Unsupported shell"
		return 1
	fi
}
SWAP_USAGE() {
	used=$(free -b | awk '/^Swap:/ {printf "%.0f", $3}')
	total=$(free -b | awk '/^Swap:/ {printf "%.0f", $2}')
	percentage=$(free | awk '/^Swap:/ {if($2>0) printf("%.2f"), $3/$2 * 100.0; else print "0.00"}')
	echo "$(CONVERT_SIZE "$used") / $(CONVERT_SIZE "$total") ($percentage%)"
}
SYS_CLEAN() {
	CHECK_ROOT
	echo -e "${CLR3}Performing system cleanup...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	case $(command -v apk apt opkg pacman yum zypper dnf | head -n1) in
		*apk)
			apk cache clean || { error "Failed to clean APK cache"; return 1; }
			rm -rf /tmp/* /var/cache/apk/* || { error "Failed to remove temporary files"; return 1; }
			apk fix || { error "Failed to fix APK packages"; return 1; }
			;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				sleep 1
			done
			DEBIAN_FRONTEND=noninteractive dpkg --configure -a || { error "Failed to configure pending packages"; return 1; }
			apt autoremove --purge -y || { error "Failed to autoremove packages"; return 1; }
			apt clean -y || { error "Failed to clean APT cache"; return 1; }
			apt autoclean -y || { error "Failed to autoclean APT cache"; return 1; }
			;;
		*opkg)
			rm -rf /tmp/* || { error "Failed to remove temporary files"; return 1; }
			opkg update || { error "Failed to update OPKG"; return 1; }
			opkg clean || { error "Failed to clean OPKG cache"; return 1; }
			;;
		*pacman)
			pacman -Syu --noconfirm || { error "Failed to update and upgrade packages"; return 1; }
			pacman -Sc --noconfirm || { error "Failed to clean pacman cache"; return 1; }
			pacman -Scc --noconfirm || { error "Failed to clean all pacman cache"; return 1; }
			;;
		*yum)
			yum autoremove -y || { error "Failed to autoremove packages"; return 1; }
			yum clean all || { error "Failed to clean YUM cache"; return 1; }
			yum makecache || { error "Failed to make YUM cache"; return 1; }
			;;
		*zypper)
			zypper clean --all || { error "Failed to clean Zypper cache"; return 1; }
			zypper refresh || { error "Failed to refresh Zypper repositories"; return 1; }
			;;
		*dnf)
			dnf autoremove -y || { error "Failed to autoremove packages"; return 1; }
			dnf clean all || { error "Failed to clean DNF cache"; return 1; }
			dnf makecache || { error "Failed to make DNF cache"; return 1; }
			;;
		*)
			error "Unsupported package manager. Skipping system-specific cleanup"
			return 1
			;;
	esac
	if command -v journalctl &>/dev/null; then
		journalctl --rotate --vacuum-time=1d --vacuum-size=500M || { error "Failed to rotate and vacuum journalctl logs"; return 1; }
	fi
	rm -rf /tmp/* || { error "Failed to remove temporary files"; return 1; }
	for cmd in docker npm pip; do
		if command -v "$cmd" &>/dev/null; then
			case "$cmd" in
				docker)
					docker system prune -af || { error "Failed to clean Docker system"; return 1; }
					;;
				npm) npm cache clean --force || { error "Failed to clean NPM cache"; return 1; }
					;;
				pip)
					pip cache purge || { error "Failed to purge PIP cache"; return 1; }
					;;
			esac
		fi
	done
	rm -rf ~/.cache/* || { error "Failed to remove user cache files"; return 1; }
	rm -rf ~/.thumbnails/* || { error "Failed to remove thumbnail files"; return 1; }
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

	echo -e "- IPv4 Address:\t\t${CLR2}$(IP_ADDR -4)${CLR0}"
	echo -e "- IPv6 Address:\t\t${CLR2}$(IP_ADDR -6)${CLR0}"
	echo -e "- MAC Address:\t\t${CLR2}$(MAC_ADDR)${CLR0}"
	echo -e "- Network Provider:\t${CLR2}$(NET_PROVIDER)${CLR0}"
	echo -e "- DNS Servers:\t\t${CLR2}$(DNS_ADDR)${CLR0}"
	echo -e "- Public IP:\t\t${CLR2}$(PUBLIC_IP)${CLR0}"
	echo -e "- Network Interface:\t${CLR2}$(INTERFACE -i)${CLR0}"
	echo -e "- Internal Timezone:\t${CLR2}$(TIMEZONE -i)${CLR0}"
	echo -e "- External Timezone:\t${CLR2}$(TIMEZONE -e)${CLR0}"
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
		systemctl enable --now systemd-oomd || { error "Failed to enable and start systemd-oomd"; return 1; }
	fi
	echo "* Optimizing disk I/O scheduler..."
	for disk in /sys/block/sd*; do
		if [ -e "$disk/queue/scheduler" ]; then
			echo "mq-deadline" > "$disk/queue/scheduler" || { error "Failed to set I/O scheduler for $disk"; return 1; }
			echo "echo mq-deadline > $disk/queue/scheduler" >> /etc/rc.local
		fi
	done
	echo "* Disabling unnecessary services..."
	services_to_disable=("bluetooth" "cups" "avahi-daemon")
	for service in "${services_to_disable[@]}"; do
		if systemctl is-active --quiet "$service"; then
			systemctl disable --now "$service" || { error "Failed to disable $service"; return 1; }
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
	ip -s -s neigh flush all || { error "Failed to clear ARP cache"; return 1; }
	echo "* Applying all sysctl changes..."
	sysctl -p "$SYSCTL_CONF" || { error "Failed to apply sysctl changes"; return 1; }
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "${CLR2}FINISHED${CLR0}\n"
}
SYS_REBOOT() {
	CHECK_ROOT
	echo -e "${CLR3}Preparing to reboot system...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"

	active_users=$(who | wc -l)
	if [ "$active_users" -gt 1 ]; then
		echo -e "${CLR1}Warning: There are currently $active_users active users on the system.\n${CLR0}"
		echo -e "Active users:"
		who | awk '{print $1 " since " $3 " " $4}'
		echo
	fi

	important_processes=$(ps aux --no-headers | awk '$3 > 1.0 || $4 > 1.0' | wc -l)
	if [ "$important_processes" -gt 0 ]; then
		echo -e "${CLR1}Warning: There are $important_processes important processes running.\n${CLR0}"
		echo -e "${CLR8}Top 5 processes by CPU usage:${CLR0}"
		ps aux --sort=-%cpu | head -n 6
		echo
	fi

	read -p "Are you sure you want to reboot the system now? (y/N) " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		echo -e "${CLR2}Reboot cancelled.\n${CLR0}"
		return 1
	fi

	echo "* Performing final checks before reboot..."
	sync || { error "Failed to sync filesystems"; return 1; }
	echo -e "${CLR3}Initiating system reboot...${CLR0}"
	reboot || { error "Failed to initiate reboot"; return 1; }
	echo -e "${CLR2}Reboot command issued successfully. The system will reboot momentarily.${CLR0}"
}
SYS_UPDATE() {
	CHECK_ROOT
	echo -e "${CLR3}Updating system software...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"

	update_packages() {
		cmd="$1"
		update_cmd="$2"
		upgrade_cmd="$3"

		echo "* Updating package lists..."
		$update_cmd || { error "Failed to update package lists using $cmd"; return 1; }
		echo "* Upgrading packages..."
		$upgrade_cmd || { error "Failed to upgrade packages using $cmd"; return 1; }
	}

	case $(command -v apk apt opkg pacman yum zypper dnf | head -n1) in
		*apk)
			update_packages "apk" "apk update" "apk upgrade"
			;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				echo "* Waiting for dpkg lock to be released..."
				sleep 1
			done
			echo "* Configuring pending packages..."
			DEBIAN_FRONTEND=noninteractive dpkg --configure -a || { error "Failed to configure pending packages"; return 1; }
			update_packages "apt" "apt update -y" "apt full-upgrade -y"
			;;
		*opkg)
			update_packages "opkg" "opkg update" "opkg upgrade"
			;;
		*pacman)
			echo "* Updating package databases and upgrading packages..."
			pacman -Syu --noconfirm || { error "Failed to update and upgrade packages using pacman"; return 1; }
			;;
		*yum)
			update_packages "yum" "yum check-update" "yum -y update"
			;;
		*zypper)
			update_packages "zypper" "zypper refresh" "zypper update -y"
			;;
		*dnf)
			update_packages "dnf" "dnf check-update" "dnf -y update"
			;;
		*)
			error "Unsupported package manager"
			return 1
			;;
	esac

	echo "* Updating shell functions..."
	bash <(curl -L raw.ogtt.tk/shell/function.sh) || { error "Failed to update shell functions"; return 1; }
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "${CLR2}FINISHED${CLR0}\n"
}

TIMEZONE() {
	case "$1" in
		-e)
			result=$(curl -sL -m 1 ipapi.co/timezone) ||
			result=$(curl -sL -m 1 worldtimeapi.org/api/ip | grep -oP '"timezone":"\K[^"]+') ||
			result=$(curl -sL -m 1 ip-api.com/json | grep -oP '"timezone":"\K[^"]+') ||
			[ -n "$result" ] && echo "$result" || { error "N/A"; return 1; }
			;;
		-i|*)
			result=$(readlink /etc/localtime | sed 's|^.*/zoneinfo/||') 2>/dev/null ||
			result=$(command -v timedatectl &>/dev/null && timedatectl status | awk '/Time zone:/ {print $3}') ||
			result=$(cat /etc/timezone 2>/dev/null | uniq) ||
			[ -n "$result" ] && echo "$result" || { error "N/A"; return 1; }
			;;
	esac
}

crontab -l &>/dev/null | grep -q 'bash <(curl -sL raw.ogtt.tk/shell/function.sh)' || (echo "0 0 * * * PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin bash -c 'curl -sL raw.ogtt.tk/shell/function.sh | bash'" >> function-update && crontab function-update && rm -f function-update)
GET https://raw.ogtt.tk/shell/function.sh &>/dev/null || { error "Failed to download function.sh"; return 1; }
grep -q "source ~/function.sh" ~/.bashrc || echo "source ~/function.sh" >> ~/.bashrc