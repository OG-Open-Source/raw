#!/bin/bash

readonly Author="OGATA Open-Source"
readonly Script="utilkit.sh"
readonly Version="5.042.001"
readonly License="MIT License"

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

[ "$(curl -s ipinfo.io/country)" = "CN" ] && cf_proxy="https://proxy.ogtt.tk/" || cf_proxy=""
error() {
	[ -z "$1" ] && { echo -e "${CLR1}Unknown error${CLR0}"; return 1; }
	echo -e "${CLR1}$1${CLR0}"
	if [ -w "/var/log" ]; then
		log_file="/var/log/ogos-error.log"
		timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
		log_entry="${timestamp} | ${Script} - ${Version} - $(echo -e "$1" | tr -d '\n')"
		echo "${log_entry}" >> "${log_file}" 2>/dev/null
	fi
}

function ADD() {
	[ $# -eq 0 ] && { error "No items specified for insertion. Please provide at least one item to add"; return 2; }
	[ "$1" = "-f" -o "$1" = "-d" ] && [ $# -eq 1 ] && { error "No file or directory path specified after -f or -d"; return 2; }
	[ "$1" = "-f" -o "$1" = "-d" ] && [ "$2" = "" ] && { error "No file or directory path specified after -f or -d"; return 2; }
	mode="package"
	failed=0
	while [ $# -gt 0 ]; do
		case "$1" in
			-f) mode="file"; shift; continue ;;
			-d) mode="directory"; shift; continue ;;
			*.deb)
				CHECK_ROOT
				deb_file=$(basename "$1")
				echo -e "${CLR3}INSERT DEB PACKAGE [$deb_file]\n${CLR0}"
				GET "$1"
				if [ -f "$deb_file" ]; then
					dpkg -i "$deb_file" || { error "Failed to install $deb_file. Check package compatibility and dependencies\n"; rm -f "$deb_file"; failed=1; shift; continue; }
					apt --fix-broken install -y || { error "Failed to fix dependencies"; rm -f "$deb_file"; failed=1; shift; continue; }
					echo "* DEB package $deb_file installed successfully"
					rm -f "$deb_file"
					echo -e "${CLR2}FINISHED${CLR0}\n"
				else
					error "DEB package $deb_file not found or download failed\n"
					failed=1
					shift
					continue
				fi
				shift
				;;
			*)
				echo -e "${CLR3}INSERT $(FORMAT -AA "$mode") [$1]${CLR0}"
				case "$mode" in
					"file")
						[ -d "$1" ] && { error "Directory $1 already exists. Cannot create file with the same name\n"; failed=1; shift; continue; }
						[ -f "$1" ] && { error "File $1 already exists\n"; failed=1; shift; continue; }
						touch "$1" || { error "Failed to create file $1. Check permissions and disk space\n"; failed=1; shift; continue; }
						echo "* File $1 created successfully"
						echo -e "${CLR2}FINISHED${CLR0}\n"
						;;
					"directory")
						[ -f "$1" ] && { error "File $1 already exists. Cannot create directory with the same name\n"; failed=1; shift; continue; }
						[ -d "$1" ] && { error "Directory $1 already exists\n"; failed=1; shift; continue; }
						mkdir -p "$1" || { error "Failed to create directory $1. Check permissions and path validity\n"; failed=1; shift; continue; }
						echo "* Directory $1 created successfully"
						echo -e "${CLR2}FINISHED${CLR0}\n"
						;;
					"package")
						CHECK_ROOT
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
											failed=1
											shift; continue
										fi
									else
										error "Failed to install $1 using $pkg_manager\n"
										failed=1
										shift; continue
									fi
								else
									echo "* Package $1 is already installed"
									echo -e "${CLR2}FINISHED${CLR0}\n"
								fi
								;;
							*)
								error "Package manager not found. Please install a supported package manager\n"
								failed=1
								shift; continue
								;;
						esac
						;;
				esac
				shift
				;;
		esac
	done
	return $failed
}

function CHECK_DEPS() {
	for dep in "${deps[@]}"; do
		if command -v "$dep" &>/dev/null; then
			status="${CLR2}[Available]${CLR0}"
		else
			status="${CLR1}[Not Found]${CLR0}"
		fi
		echo -e "$status\t$dep"
	done
}
function CHECK_OS() {
	case "$1" in
		-v)
			if [ -f /etc/os-release ]; then
				source /etc/os-release
				if [ "$ID" = "debian" ]; then
					cat /etc/debian_version
				else
					echo "$VERSION_ID"
				fi
			elif [ -f /etc/debian_version ]; then
				cat /etc/debian_version
			elif [ -f /etc/fedora-release ]; then
				grep -oE '[0-9]+' /etc/fedora-release
			elif [ -f /etc/centos-release ]; then
				grep -oE '[0-9]+\.[0-9]+' /etc/centos-release
			elif [ -f /etc/alpine-release ]; then
				cat /etc/alpine-release
			else
				{ error "Unknown distribution version"; return 1; }
			fi
			;;
		-n)
			if [ -f /etc/os-release ]; then
				source /etc/os-release
				echo "$ID" | sed 's/.*/\u&/'
			elif [ -f /etc/DISTRO_SPECS ]; then
				grep -i "DISTRO_NAME" /etc/DISTRO_SPECS | cut -d'=' -f2 | awk '{print $1}'
			else
				{ error "Unknown distribution"; return 1; }
			fi
			;;
		*)
			if [ -f /etc/os-release ]; then
				source /etc/os-release
				if [ "$ID" = "debian" ]; then
					echo "$NAME $(cat /etc/debian_version)"
				else
					echo "$PRETTY_NAME"
				fi
			elif [ -f /etc/DISTRO_SPECS ]; then
				grep -i "DISTRO_NAME" /etc/DISTRO_SPECS | cut -d'=' -f2
			else
				{ error "Unknown distribution"; return 1; }
			fi
			;;
	esac
}
function CHECK_ROOT() {
	if [ "$EUID" -ne 0 ] || [ "$(id -u)" -ne 0 ]; then
		error "Please run this script as root user"
		exit 1
	fi
}
function CHECK_VIRT() {
	if command -v systemd-detect-virt >/dev/null 2>&1; then
		virt_type=$(systemd-detect-virt 2>/dev/null)
		[ -z "$virt_type" ] && { error "Unable to detect virtualization environment"; return 1; }
		case "$virt_type" in
			kvm) grep -qi "proxmox" /sys/class/dmi/id/product_name 2>/dev/null && echo "Proxmox VE (KVM)" || echo "KVM" ;;
			microsoft) echo "Microsoft Hyper-V" ;;
			none)
				if grep -q "container=lxc" /proc/1/environ 2>/dev/null; then
					echo "LXC container"
				elif grep -qi "hypervisor" /proc/cpuinfo 2>/dev/null; then
					echo "Virtual machine (Unknown type)"
				else
					echo "Not detected (possibly bare metal)"
				fi
				;;
			*) echo "${virt_type:-Not detected (possibly bare metal)}" ;;
		esac
	elif [ -f /proc/cpuinfo ]; then
		virt_type=$(grep -i "hypervisor" /proc/cpuinfo >/dev/null && echo "VM" || echo "none")
	else
		virt_type="Unknown"
	fi
}
function CLEAN() {
	cd "$HOME" || { error "Failed to change directory to HOME"; return 1; }
	clear
}
function CPU_CACHE() {
	[ ! -f /proc/cpuinfo ] && { error "Cannot access CPU information. /proc/cpuinfo not available"; return 1; }
	cpu_cache=$(awk '/^cache size/ {sum+=$4; count++} END {print (count>0) ? sum/count : "N/A"}' /proc/cpuinfo)
	[ "$cpu_cache" = "N/A" ] && { error "Unable to determine CPU cache size"; return 1; }
	echo "${cpu_cache} KB"
}
function CPU_FREQ() {
	[ ! -f /proc/cpuinfo ] && { error "Cannot access CPU information. /proc/cpuinfo not available"; return 1; }
	cpu_freq=$(awk '/^cpu MHz/ {sum+=$4; count++} END {print (count>0) ? sprintf("%.2f", sum/count/1000) : "N/A"}' /proc/cpuinfo)
	[ "$cpu_freq" = "N/A" ] && { error "Unable to determine CPU frequency"; return 1; }
	echo "${cpu_freq} GHz"
}
function CPU_MODEL() {
	if command -v lscpu &>/dev/null; then
		lscpu | awk -F': +' '/Model name/ {print $2; exit}'
	elif [ -f /proc/cpuinfo ]; then
		sed -n 's/^model name[[:space:]]*: //p' /proc/cpuinfo | head -n1
	elif command -v sysctl &>/dev/null && sysctl -n machdep.cpu.brand_string &>/dev/null; then
		sysctl -n machdep.cpu.brand_string
	else
		{ echo -e "${CLR1}Unknown${CLR0}"; return 1; }
	fi
}
function CPU_USAGE() {
	read -r cpu user nice system idle iowait irq softirq <<< $(awk '/^cpu / {print $1,$2,$3,$4,$5,$6,$7,$8}' /proc/stat) || { error "Failed to read CPU statistics from /proc/stat"; return 1; }
	total1=$((user + nice + system + idle + iowait + irq + softirq))
	idle1=$idle
	sleep 0.3
	read -r cpu user nice system idle iowait irq softirq <<< $(awk '/^cpu / {print $1,$2,$3,$4,$5,$6,$7,$8}' /proc/stat) || { error "Failed to read CPU statistics from /proc/stat"; return 1; }
	total2=$((user + nice + system + idle + iowait + irq + softirq))
	idle2=$idle
	total_diff=$((total2 - total1))
	idle_diff=$((idle2 - idle1))
	usage=$(( 100 * (total_diff - idle_diff) / total_diff ))
	echo "$usage%"
}
function CONVERT_SIZE() {
	[ -z "$1" ] && { error "No size value provided for conversion"; return 2; }
	size=$1
	unit=${2:-iB}
	unit_lower=$(FORMAT -aa "$unit")
	if ! [[ "$size" =~ ^[+-]?[0-9]*\.?[0-9]+$ ]]; then
		{ error "Invalid size value. Must be a numeric value"; return 2; }
	elif [[ "$size" =~ ^[-].*$ ]]; then
		{ error "Size value cannot be negative"; return 2; }
	elif [[ "$size" =~ ^[+].*$ ]]; then
		size=${size#+}
	fi
	case "$unit_lower" in
		b) bytes=$size ;;
		kb|kib) bytes=$(LC_NUMERIC=C awk -v size="$size" -v unit="$unit_lower" 'BEGIN {printf "%.0f", size * (unit == "kb" ? 1000 : 1024)}') ;;
		mb|mib) bytes=$(LC_NUMERIC=C awk -v size="$size" -v unit="$unit_lower" 'BEGIN {printf "%.0f", size * (unit == "mb" ? 1000000 : 1048576)}') ;;
		gb|gib) bytes=$(LC_NUMERIC=C awk -v size="$size" -v unit="$unit_lower" 'BEGIN {printf "%.0f", size * (unit == "gb" ? 1000000000 : 1073741824)}') ;;
		tb|tib) bytes=$(LC_NUMERIC=C awk -v size="$size" -v unit="$unit_lower" 'BEGIN {printf "%.0f", size * (unit == "tb" ? 1000000000000 : 1099511627776)}') ;;
		pb|pib) bytes=$(LC_NUMERIC=C awk -v size="$size" -v unit="$unit_lower" 'BEGIN {printf "%.0f", size * (unit == "pb" ? 1000000000000000 : 1125899906842624)}') ;;
		*) bytes=$size ;;
	esac
	[[ ! "$bytes" =~ ^[0-9]+\.?[0-9]*$ ]] && { error "Failed to convert size value"; return 1; }
	LC_NUMERIC=C awk -v bytes="$bytes" -v is_binary="$([[ $unit_lower =~ ^.*ib$ ]] && echo 1 || echo 0)" '
	BEGIN {
		base = is_binary ? 1024 : 1000
		units = is_binary ? "B KiB MiB GiB TiB PiB" : "B KB MB GB TB PB"
		split(units, unit_array, " ")
		power = 0
		value = bytes
		while (value >= base && power < 5) {
			value /= base
			power++
		}
		if (power == 0) {
			printf "%d %s\n", bytes, unit_array[power + 1]
		} else {
			if (value >= 100) {
				printf "%.1f %s\n", value, unit_array[power + 1]
			} else if (value >= 10) {
				printf "%.2f %s\n", value, unit_array[power + 1]
			} else {
				printf "%.3f %s\n", value, unit_array[power + 1]
			}
		}
	}'
}
function COPYRIGHT() {
	echo -e "$Script $Version"
	echo -e "Copyright (C) 2024 $Author."
}

function DEL() {
	[ $# -eq 0 ] && { error "No items specified for deletion. Please provide at least one item to delete"; return 2; }
	[ "$1" = "-f" -o "$1" = "-d" ] && [ $# -eq 1 ] && { error "No file or directory path specified after -f or -d"; return 2; }
	[ "$1" = "-f" -o "$1" = "-d" ] && [ "$2" = "" ] && { error "No file or directory path specified after -f or -d"; return 2; }
	mode="package"
	failed=0
	while [ $# -gt 0 ]; do
		case "$1" in
			-f) mode="file"; shift; continue ;;
			-d) mode="directory"; shift; continue ;;
			*)
				echo -e "${CLR3}REMOVE $(FORMAT -AA "$mode") [$1]${CLR0}"
				case "$mode" in
					"file")
						[ ! -f "$1" ] && { error "File $1 does not exist\n"; failed=1; shift; continue; }
						echo "* File $1 exists. Attempting removal..."
						rm -f "$1" || { error "Failed to remove file $1\n"; failed=1; shift; continue; }
						echo "* File $1 removed successfully"
						echo -e "${CLR2}FINISHED${CLR0}\n"
						;;
					"directory")
						[ ! -d "$1" ] && { error "Directory $1 does not exist\n"; failed=1; shift; continue; }
						echo "* Directory $1 exists. Attempting removal..."
						rm -rf "$1" || { error "Failed to remove directory $1\n"; failed=1; shift; continue; }
						echo "* Directory $1 removed successfully"
						echo -e "${CLR2}FINISHED${CLR0}\n"
						;;
					"package")
						CHECK_ROOT
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
								if ! is_installed "$1"; then
									error "Package $1 is not installed\n"
									failed=1
									shift
									continue
								fi
								echo "* Package $1 is installed. Attempting removal..."
								if ! remove_package "$1"; then
									error "Failed to remove $1 using $pkg_manager\n"
									failed=1
									shift
									continue
								fi
								if is_installed "$1"; then
									error "Failed to remove $1 using $pkg_manager\n"
									failed=1
									shift
									continue
								fi
								echo "* Package $1 removed successfully"
								echo -e "${CLR2}FINISHED${CLR0}\n"
								;;
							*) { error "Unsupported package manager"; return 1; } ;;
						esac
						;;
				esac
				shift
				;;
		esac
	done
	return $failed
}
function DISK_USAGE() {
	used=$(df -B1 / | awk '/^\/dev/ {print $3}') || { error "Failed to get disk usage statistics"; return 1; }
	total=$(df -B1 / | awk '/^\/dev/ {print $2}') || { error "Failed to get total disk space"; return 1; }
	percentage=$(df / | awk '/^\/dev/ {printf("%.2f"), $3/$2 * 100.0}')
	echo "$(CONVERT_SIZE "$used") / $(CONVERT_SIZE "$total") ($percentage%)"
}
function DNS_ADDR () {
	[ ! -f /etc/resolv.conf ] && { error "DNS configuration file /etc/resolv.conf not found"; return 1; }
	ipv4_servers=()
	ipv6_servers=()
	while read -r server; do
		if [[ $server =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
			ipv4_servers+=("$server")
		elif [[ $server =~ ^[0-9a-fA-F:]+$ ]]; then
			ipv6_servers+=("$server")
		fi
	done < <(grep -E '^nameserver' /etc/resolv.conf | awk '{print $2}')
	[[ ${#ipv4_servers[@]} -eq 0 && ${#ipv6_servers[@]} -eq 0 ]] && { error "No DNS servers configured in /etc/resolv.conf"; return 1; }
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

function FIND() {
	[ $# -eq 0 ] && { error "No search terms provided. Please specify what to search for"; return 2; }
	package_manager=$(command -v apk apt opkg pacman yum zypper dnf | head -n1)
	case ${package_manager##*/} in
		apk) search_command="apk search" ;;
		apt) search_command="apt-cache search" ;;
		opkg) search_command="opkg search" ;;
		pacman) search_command="pacman -Ss" ;;
		yum) search_command="yum search" ;;
		zypper) search_command="zypper search" ;;
		dnf) search_command="dnf search" ;;
		*) { error "Package manager not found or unsupported"; return 1; } ;;
	esac
	for target in "$@"; do
		echo -e "${CLR3}SEARCH [$target]${CLR0}"
		$search_command "$target" || { error "No results found for $target\n"; return 1; }
		echo -e "${CLR2}FINISHED${CLR0}\n"
	done
}
function FONT() {
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
			*) font+="${style[$1]:-}" ;;
		esac
		shift
	done
	echo -e "${font}${1}${CLR0}"
}
function FORMAT() {
	option="$1"
	value="$2"
	result=""
	[ -z "$value" ] && { error "No value provided for formatting"; return 2; }
	[ -z "$option" ] && { error "No formatting option provided"; return 2; }
	case "$option" in
		-AA) result=$(echo "$value" | tr '[:lower:]' '[:upper:]') ;;
		-aa) result=$(echo "$value" | tr '[:upper:]' '[:lower:]') ;;
		-Aa) result=$(echo "$value" | tr '[:upper:]' '[:lower:]' | sed 's/\b\(.\)/\u\1/') ;;
		*) result="$value" ;;
	esac
	echo "$result"
}

function GET() {
	extract="false"
	target_dir="."
	rename_file=""
	url=""
	while [ $# -gt 0 ]; do
		case "$1" in
			-x) extract=true; shift ;;
			-r)
				[ -z "$2" ] || [[ "$2" == -* ]] && { error "No filename specified after -r option\n"; return 2; }
				rename_file="$2"
				shift 2
				;;
			-*) { error "Invalid option: $1\n"; return 2; } ;;
			*) [ -z "$url" ] && url="$1" || target_dir="$1"; shift ;;
		esac
	done
	[ -z "$url" ] && { error "No URL specified. Please provide a URL to download"; return 2; }
	[[ "$url" =~ ^(http|https|ftp):// ]] || url="https://$url"
	output_file="${url##*/}"
	[ -z "$output_file" ] && output_file="index.html"
	[ "$target_dir" != "." ] && { mkdir -p "$target_dir" || { error "Failed to create directory $target_dir\n"; return 1; }; }
	[ -n "$rename_file" ] && output_file="$rename_file"
	output_path="$target_dir/$output_file"
	url=$(echo "$url" | sed -E 's#([^:])/+#\1/#g; s#^(https?|ftp):/+#\1://#')
	echo -e "${CLR3}DOWNLOAD [$url]${CLR0}"
	file_size=$(curl -sI "$url" | grep -i content-length | awk '{print $2}' | tr -d '\r')
	size_limit="26214400"
	if [ -n "$file_size" ] && [ "$file_size" -gt "$size_limit" ]; then
		wget --no-check-certificate --timeout=5 --tries=2 "$url" -O "$output_path" || { error "Failed to download file using wget\n"; return 1; }
	else
		curl --location --insecure --connect-timeout 5 --retry 2 "$url" -o "$output_path" || { error "Failed to download file using curl\n"; return 1; }
	fi
	if [ -f "$output_path" ]; then
		echo "* File downloaded successfully to $output_path"
		if [ "$extract" = true ]; then
			case "$output_file" in
				*.tar.gz|*.tgz) tar -xzf "$output_path" -C "$target_dir" || { error "Failed to extract tar.gz file\n"; return 1; } ;;
				*.tar) tar -xf "$output_path" -C "$target_dir" || { error "Failed to extract tar file\n"; return 1; } ;;
				*.tar.bz2|*.tbz2) tar -xjf "$output_path" -C "$target_dir" || { error "Failed to extract tar.bz2 file\n"; return 1; } ;;
				*.tar.xz|*.txz) tar -xJf "$output_path" -C "$target_dir" || { error "Failed to extract tar.xz file\n"; return 1; } ;;
				*.zip) unzip "$output_path" -d "$target_dir" || { error "Failed to extract zip file\n"; return 1; } ;;
				*.7z) 7z x "$output_path" -o"$target_dir" || { error "Failed to extract 7z file\n"; return 1; } ;;
				*.rar) unrar x "$output_path" "$target_dir" || { error "Failed to extract rar file\n"; return 1; } ;;
				*.zst) zstd -d "$output_path" -o "$target_dir" || { error "Failed to extract zst file\n"; return 1; } ;;
				*) echo "* File format not recognized for auto-extraction" ;;
			esac
			[ $? -eq 0 ] && echo "* File extracted successfully to $target_dir"
		fi
		echo -e "${CLR2}FINISHED${CLR0}\n"
	else
		{ error "Download failed. Check your internet connection and URL validity"; return 1; }
	fi
}

function INPUT() {
	read -e -p "$1" "$2" || { error "Failed to read user input"; return 1; }
}
function INTERFACE() {
	interface=""
	declare -a interfaces=()
	all_interfaces=$(
		cat /proc/net/dev | \
		grep ':' | \
		cut -d':' -f1 | \
		sed 's/\s//g' | \
		grep -iv '^lo\|^sit\|^stf\|^gif\|^dummy\|^vmnet\|^vir\|^gre\|^ipip\|^ppp\|^bond\|^tun\|^tap\|^ip6gre\|^ip6tnl\|^teql\|^ocserv\|^vpn\|^warp\|^wgcf\|^wg\|^docker' | \
		sort -n
	) || { error "Failed to get network interfaces from /proc/net/dev"; return 1; }
	i=1
	while read -r interface_item; do
		[ -n "$interface_item" ] && interfaces[$i]="$interface_item"
		((i++))
	done <<< "$all_interfaces"
	interfaces_num="${#interfaces[*]}"
	default4_route=$(ip -4 route show default | grep -A 3 "^default")
	default6_route=$(ip -6 route show default | grep -A 3 "^default")
	get_arr_item_idx() {
		item="$1"
		shift
		arr=("$@")
		for ((i=1; i<=${#arr[@]}; i++)); do
			if [ "$item" = "${arr[$i]}" ]; then
				echo "$i"
				return 0
			fi
		done
		return 255
	}
	for ((i=1; i<=${#interfaces[@]}; i++)); do
		item="${interfaces[$i]}"
		[ -z "$item" ] && continue
		if [[ "$default4_route" == *"$item"* ]] && [ -z "$interface4" ]; then
			interface4="$item"
			interface4_device_order=$(get_arr_item_idx "$item" "${interfaces[@]}")
		fi
		if [[ "$default6_route" == *"$item"* ]] && [ -z "$interface6" ]; then
			interface6="$item"
			interface6_device_order=$(get_arr_item_idx "$item" "${interfaces[@]}")
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
	for interface in $interface; do
		if stats=$(awk -v iface="$interface" '$1 ~ iface":" {print $2, $3, $5, $10, $11, $13}' /proc/net/dev); then
			read rx_bytes rx_packets rx_drop tx_bytes tx_packets tx_drop <<< "$stats"
			case "$1" in
				RX_BYTES) echo "$rx_bytes" ;;
				RX_PACKETS) echo "$rx_packets" ;;
				RX_DROP) echo "$rx_drop" ;;
				TX_BYTES) echo "$tx_bytes" ;;
				TX_PACKETS) echo "$tx_packets" ;;
				TX_DROP) echo "$tx_drop" ;;
				-i) echo "$interface: RX: $(CONVERT_SIZE $rx_bytes), TX: $(CONVERT_SIZE $tx_bytes)" ;;
				"") echo "$interface" ;;
				*) { error "Invalid parameter: $1. Valid parameters are: RX_BYTES, RX_PACKETS, RX_DROP, TX_BYTES, TX_PACKETS, TX_DROP, -i"; return 2; } ;;
			esac
		else
			{ error "No stats found for interface: $interface"; return 1; }
		fi
	done
}
function IP_ADDR() {
	version="$1"
	case "$version" in
		-4)
			ipv4_addr=$(timeout 1s dig +short -4 myip.opendns.com @resolver1.opendns.com 2>/dev/null) ||
			ipv4_addr=$(timeout 1s curl -sL ipv4.ip.sb 2>/dev/null) ||
			ipv4_addr=$(timeout 1s wget -qO- -4 ifconfig.me 2>/dev/null) ||
			[ -n "$ipv4_addr" ] && echo "$ipv4_addr" || { error "Failed to retrieve IPv4 address. Check your internet connection"; return 1; }
			;;
		-6)
			ipv6_addr=$(timeout 1s curl -sL ipv6.ip.sb 2>/dev/null) ||
			ipv6_addr=$(timeout 1s wget -qO- -6 ifconfig.me 2>/dev/null) ||
			[ -n "$ipv6_addr" ] && echo "$ipv6_addr" || { error "Failed to retrieve IPv6 address. Check your internet connection"; return 1; }
			;;
		*)
			ipv4_addr=$(IP_ADDR -4)
			ipv6_addr=$(IP_ADDR -6)
			[ -z "$ipv4_addr$ipv6_addr" ] && { error "Failed to retrieve IP addresses"; return 1; }
			[ -n "$ipv4_addr" ] && echo "IPv4: $ipv4_addr"
			[ -n "$ipv6_addr" ] && echo "IPv6: $ipv6_addr"
			return
			;;
	esac
}

function LAST_UPDATE() {
	if [ -f /var/log/apt/history.log ]; then
		last_update=$(awk '/End-Date:/ {print $2, $3, $4; exit}' /var/log/apt/history.log 2>/dev/null)
	elif [ -f /var/log/dpkg.log ]; then
		last_update=$(tail -n 1 /var/log/dpkg.log | awk '{print $1, $2}')
	elif command -v rpm &>/dev/null; then
		last_update=$(rpm -qa --last | head -n 1 | awk '{print $3, $4, $5, $6, $7}')
	fi
	[ -z "$last_update" ] && { error "Unable to determine last system update time. Update logs not found"; return 1; } || echo "$last_update"
}
function LINE() {
	char="${1:--}"
	length="${2:-80}"
	printf '%*s\n' "$length" | tr ' ' "$char" || { error "Failed to print line"; return 1; }
}
function LOAD_AVERAGE() {
	if [ ! -f /proc/loadavg ]; then
		load_data=$(uptime | sed 's/.*load average: //' | sed 's/,//g') || { error "Failed to get load average from uptime command"; return 1; }
	else
		read -r one_min five_min fifteen_min _ _ < /proc/loadavg || { error "Failed to read load average from /proc/loadavg"; return 1; }
	fi
	[[ $one_min =~ ^[0-9.]+$ ]] || one_min=0
	[[ $five_min =~ ^[0-9.]+$ ]] || five_min=0
	[[ $fifteen_min =~ ^[0-9.]+$ ]] || fifteen_min=0
	LC_ALL=C printf "%.2f, %.2f, %.2f (%d cores)" "$one_min" "$five_min" "$fifteen_min" "$(nproc)"
}

function MAC_ADDR() {
	mac_address=$(ip link show | awk '/ether/ {print $2; exit}')
	if [[ -n "$mac_address" ]]; then
		echo "$mac_address"
	else
		{ error "Unable to retrieve MAC address. Network interface not found"; return 1; }
	fi
}
function MEM_USAGE() {
	used=$(free -b | awk '/^Mem:/ {print $3}') || used=$(vmstat -s | grep 'used memory' | awk '{print $1*1024}') || { error "Failed to get memory usage statistics"; return 1; }
	total=$(free -b | awk '/^Mem:/ {print $2}') || total=$(grep MemTotal /proc/meminfo | awk '{print $2*1024}')
	percentage=$(free | awk '/^Mem:/ {printf("%.2f"), $3/$2 * 100.0}') || percentage=$(awk '/^MemTotal:/ {total=$2} /^MemAvailable:/ {available=$2} END {printf("%.2f", (total-available)/total * 100.0)}' /proc/meminfo)
	echo "$(CONVERT_SIZE "$used") / $(CONVERT_SIZE "$total") ($percentage%)"
}

function NET_PROVIDER() {
	result=$(timeout 1s curl -sL ipinfo.io | grep -oP '"org"\s*:\s*"\K[^"]+') ||
	result=$(timeout 1s curl -sL ipwhois.app/json | grep -oP '"org"\s*:\s*"\K[^"]+') ||
	result=$(timeout 1s curl -sL ip-api.com/json | grep -oP '"org"\s*:\s*"\K[^"]+') ||
	[ -n "$result" ] && echo "$result" || { error "Unable to detect network provider. Check your internet connection"; return 1; }
}

function PKG_COUNT() {
	pkg_manager=$(command -v apk apt opkg pacman yum zypper dnf 2>/dev/null | head -n1)
	case ${pkg_manager##*/} in
		apk) count_cmd="apk info" ;;
		apt) count_cmd="dpkg --get-selections" ;;
		opkg) count_cmd="opkg list-installed" ;;
		pacman) count_cmd="pacman -Q" ;;
		yum|dnf) count_cmd="rpm -qa" ;;
		zypper) count_cmd="zypper se --installed-only" ;;
		*) { error "Unable to count installed packages. Package manager not supported"; return 1; } ;;
	esac
	if ! package_count=$($count_cmd 2>/dev/null | wc -l) || [[ -z "$package_count" || "$package_count" -eq 0 ]]; then
		{ error "Failed to count packages for ${pkg_manager##*/}"; return 1; }
	fi
	echo "$package_count"
}
function PROGRESS() {
	num_cmds=${#cmds[@]}
	term_width=$(tput cols) || { error "Failed to get terminal width"; return 1; }
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
			{ error "Command execution failed: ${cmds[$i]}"; return 1; }
		fi
	done
	printf "\r\033[30;42mProgress: [100%%]\033[0m [%s]" "$(printf "%${bar_width}s" | tr ' ' '#')"
	printf "\r%${term_width}s\r"
	stty echo
	trap - SIGINT SIGQUIT SIGTSTP
}
function PUBLIC_IP() {
	ip=$(timeout 5s curl -sL https://ifconfig.me)
	[ -n "$ip" ] && echo "$ip" || { error "Unable to detect public IP address. Check your internet connection"; return 1; }
}

function RUN() {
	commands=()
	# ADD bash-completion &>/dev/null
	_run_completions() {
		cur="${COMP_WORDS[COMP_CWORD]}"
		prev="${COMP_WORDS[COMP_CWORD-1]}"
		opts="${commands[*]}"
		COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
		[[ ${#COMPREPLY[@]} -eq 0 ]] && COMPREPLY=( $(compgen -c -- "$cur") )
	}
	complete -F _run_completions RUN
	[ $# -eq 0 ] && { error "No command specified"; return 2; }
	if [[ "$1" == *"/"* ]]; then
		if [[ "$1" =~ ^[^/]+/[^/]+/.+ ]]; then
			repo_owner=$(echo "$1" | cut -d'/' -f1)
			repo_name=$(echo "$1" | cut -d'/' -f2)
			script_path=$(echo "$1" | cut -d'/' -f3-)
			script_name=$(basename "$script_path")
			branch="main"
			shift
			while [[ $# -gt 0 ]]; do
				case "$1" in
					-b) [[ -z "$2" || "$2" == -* ]] && { error "Branch name required after -b"; return 2; }; branch="$2"; shift 2 ;;
					*) break ;;
				esac
			done
			echo -e "${CLR3}Downloading and executing script [${script_name}] from ${repo_owner}/${repo_name}${CLR0}"
			github_url="https://raw.githubusercontent.com/${repo_owner}/${repo_name}/refs/heads/${branch}/${script_path}"
			if [[ "$branch" == "main" ]]; then
				echo "* Checking main branch..."
				response=$(curl -sL "$github_url")
				if [[ "$response" == "404: Not Found" ]]; then
					echo "* Checking master branch..."
					branch="master"
					github_url="https://raw.githubusercontent.com/${repo_owner}/${repo_name}/refs/heads/${branch}/${script_path}"
					response=$(curl -sL "$github_url")
					[[ "$response" == "404: Not Found" ]] && { error "Script not found in either main or master branch"; return 1; }
				fi
			else
				echo "* Checking ${branch} branch..."
				response=$(curl -sL "$github_url")
				[[ "$response" == "404: Not Found" ]] && { error "Script not found in ${branch} branch"; return 1; }
			fi
			TASK "* Downloading script" "
				GET \"$github_url\" &>/dev/null || { error \"Failed to download script $script_name\"; return 1; }
				chmod +x \"$script_name\" || { error \"Failed to set execute permission for $script_name\"; return 1; }
			"
			echo -e "${CLR8}$(LINE = "24")${CLR0}"
			if [[ "$1" == "--" ]]; then
				shift
				./"$script_name" "$@" || { error "Failed to execute script $script_name"; return 1; }
			else
				./"$script_name" || { error "Failed to execute script $script_name"; return 1; }
			fi
			echo -e "${CLR8}$(LINE = "24")${CLR0}"
			echo -e "${CLR2}FINISHED${CLR0}\n"
		else
			[ -x "$1" ] || chmod +x "$1"
			if [[ "$2" == "--" ]]; then
				shift 2
				"$script_name" "$@"
			else
				"$1" "${@:2}"
			fi
		fi
	else
		eval "$*"
	fi
}

function SHELL_VER() {
	LC_ALL=C
	if [ -n "${BASH_VERSION-}" ]; then
		echo "Bash ${BASH_VERSION}"
	elif [ -n "${ZSH_VERSION-}" ]; then
		echo "Zsh ${ZSH_VERSION}"
	else
		{ error "Unsupported shell"; return 1; }
	fi
}
function SWAP_USAGE() {
	used=$(free -b | awk '/^Swap:/ {printf "%.0f", $3}')
	total=$(free -b | awk '/^Swap:/ {printf "%.0f", $2}')
	percentage=$(free | awk '/^Swap:/ {if($2>0) printf("%.2f"), $3/$2 * 100.0; else print "0.00"}')
	echo "$(CONVERT_SIZE "$used") / $(CONVERT_SIZE "$total") ($percentage%)"
}
function SYS_CLEAN() {
	CHECK_ROOT
	echo -e "${CLR3}Performing system cleanup...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	case $(command -v apk apt opkg pacman yum zypper dnf | head -n1) in
		*apk)
			TASK "* Cleaning APK cache" "apk cache clean" || { error "Failed to clean APK cache"; return 1; }
			TASK "* Removing temporary files" "rm -rf /tmp/* /var/cache/apk/*" || { error "Failed to remove temporary files"; return 1; }
			TASK "* Fixing APK packages" "apk fix" || { error "Failed to fix APK packages"; return 1; }
			;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				TASK "* Waiting for dpkg lock" "sleep 1" || return 1
				((wait_time++))
				[ "$wait_time" -gt 300 ] && { error "Timeout waiting for dpkg lock to be released"; return 1; }
			done
			TASK "* Configuring pending packages" "DEBIAN_FRONTEND=noninteractive dpkg --configure -a" || { error "Failed to configure pending packages"; return 1; }
			TASK "* Autoremoving packages" "apt autoremove --purge -y" || { error "Failed to autoremove packages"; return 1; }
			TASK "* Cleaning APT cache" "apt clean -y" || { error "Failed to clean APT cache"; return 1; }
			TASK "* Autocleaning APT cache" "apt autoclean -y" || { error "Failed to autoclean APT cache"; return 1; }
			;;
		*opkg)
			TASK "* Removing temporary files" "rm -rf /tmp/*" || { error "Failed to remove temporary files"; return 1; }
			TASK "* Updating OPKG" "opkg update" || { error "Failed to update OPKG"; return 1; }
			TASK "* Cleaning OPKG cache" "opkg clean" || { error "Failed to clean OPKG cache"; return 1; }
			;;
		*pacman)
			TASK "* Updating and upgrading packages" "pacman -Syu --noconfirm" || { error "Failed to update and upgrade packages using pacman"; return 1; }
			TASK "* Cleaning pacman cache" "pacman -Sc --noconfirm" || { error "Failed to clean pacman cache"; return 1; }
			TASK "* Cleaning all pacman cache" "pacman -Scc --noconfirm" || { error "Failed to clean all pacman cache"; return 1; }
			;;
		*yum)
			TASK "* Autoremoving packages" "yum autoremove -y" || { error "Failed to autoremove packages"; return 1; }
			TASK "* Cleaning YUM cache" "yum clean all" || { error "Failed to clean YUM cache"; return 1; }
			TASK "* Making YUM cache" "yum makecache" || { error "Failed to make YUM cache"; return 1; }
			;;
		*zypper)
			TASK "* Cleaning Zypper cache" "zypper clean --all" || { error "Failed to clean Zypper cache"; return 1; }
			TASK "* Refreshing Zypper repositories" "zypper refresh" || { error "Failed to refresh Zypper repositories"; return 1; }
			;;
		*dnf)
			TASK "* Autoremoving packages" "dnf autoremove -y" || { error "Failed to autoremove packages"; return 1; }
			TASK "* Cleaning DNF cache" "dnf clean all" || { error "Failed to clean DNF cache"; return 1; }
			TASK "* Making DNF cache" "dnf makecache" || { error "Failed to make DNF cache"; return 1; }
			;;
		*) { error "Unsupported package manager. Skipping system-specific cleanup"; return 1; } ;;
	esac
	if command -v journalctl &>/dev/null; then
		TASK "* Rotating and vacuuming journalctl logs" "journalctl --rotate --vacuum-time=1d --vacuum-size=500M" || { error "Failed to rotate and vacuum journalctl logs"; return 1; }
	fi
	TASK "* Removing temporary files" "rm -rf /tmp/*" || { error "Failed to remove temporary files"; return 1; }
	for cmd in docker npm pip; do
		if command -v "$cmd" &>/dev/null; then
			case "$cmd" in
				docker) TASK "* Cleaning Docker system" "docker system prune -af" || { error "Failed to clean Docker system"; return 1; } ;;
				npm) TASK "* Cleaning NPM cache" "npm cache clean --force" || { error "Failed to clean NPM cache"; return 1; } ;;
				pip) TASK "* Purging PIP cache" "pip cache purge" || { error "Failed to purge PIP cache"; return 1; } ;;
			esac
		fi
	done
	TASK "* Removing user cache files" "rm -rf ~/.cache/*" || { error "Failed to remove user cache files"; return 1; }
	TASK "* Removing thumbnail files" "rm -rf ~/.thumbnails/*" || { error "Failed to remove thumbnail files"; return 1; }
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "${CLR2}FINISHED${CLR0}\n"
}
function SYS_INFO() {
	echo -e "${CLR3}System Information${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"

	echo -e "- Hostname:\t\t${CLR2}$(uname -n || { error "Failed to get hostname"; return 1; })${CLR0}"
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
	echo -e "- CPU Usage:\t\t${CLR2}$(CPU_USAGE)${CLR0}"
	echo -e "- CPU Cache:\t\t${CLR2}$(CPU_CACHE)${CLR0}"
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
function SYS_OPTIMIZE() {
	CHECK_ROOT
	echo -e "${CLR3}Optimizing system configuration for long-running servers...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"

	SYSCTL_CONF="/etc/sysctl.d/99-server-optimizations.conf"
	echo "# Server optimizations for long-running systems" > "$SYSCTL_CONF"

	TASK "* Optimizing memory management" "
		echo 'vm.swappiness = 1' >> $SYSCTL_CONF
		echo 'vm.vfs_cache_pressure = 50' >> $SYSCTL_CONF
		echo 'vm.dirty_ratio = 15' >> $SYSCTL_CONF
		echo 'vm.dirty_background_ratio = 5' >> $SYSCTL_CONF
		echo 'vm.min_free_kbytes = 65536' >> $SYSCTL_CONF
	" || { error "Failed to optimize memory management"; return 1; }

	TASK "* Optimizing network settings" "
		echo 'net.core.somaxconn = 65535' >> $SYSCTL_CONF
		echo 'net.core.netdev_max_backlog = 65535' >> $SYSCTL_CONF
		echo 'net.ipv4.tcp_max_syn_backlog = 65535' >> $SYSCTL_CONF
		echo 'net.ipv4.tcp_fin_timeout = 15' >> $SYSCTL_CONF
		echo 'net.ipv4.tcp_keepalive_time = 300' >> $SYSCTL_CONF
		echo 'net.ipv4.tcp_keepalive_probes = 5' >> $SYSCTL_CONF
		echo 'net.ipv4.tcp_keepalive_intvl = 15' >> $SYSCTL_CONF
		echo 'net.ipv4.tcp_tw_reuse = 1' >> $SYSCTL_CONF
		echo 'net.ipv4.ip_local_port_range = 1024 65535' >> $SYSCTL_CONF
	" || { error "Failed to optimize network settings"; return 1; }

	TASK "* Optimizing TCP buffers" "
		echo 'net.core.rmem_max = 16777216' >> $SYSCTL_CONF
		echo 'net.core.wmem_max = 16777216' >> $SYSCTL_CONF
		echo 'net.ipv4.tcp_rmem = 4096 87380 16777216' >> $SYSCTL_CONF
		echo 'net.ipv4.tcp_wmem = 4096 65536 16777216' >> $SYSCTL_CONF
		echo 'net.ipv4.tcp_mtu_probing = 1' >> $SYSCTL_CONF
	" || { error "Failed to optimize TCP buffers"; return 1; }

	TASK "* Optimizing filesystem settings" "
		echo 'fs.file-max = 2097152' >> $SYSCTL_CONF
		echo 'fs.nr_open = 2097152' >> $SYSCTL_CONF
		echo 'fs.inotify.max_user_watches = 524288' >> $SYSCTL_CONF
	" || { error "Failed to optimize filesystem settings"; return 1; }

	TASK "* Optimizing system limits" "
		echo '* soft nofile 1048576' >> /etc/security/limits.conf
		echo '* hard nofile 1048576' >> /etc/security/limits.conf
		echo '* soft nproc 65535' >> /etc/security/limits.conf
		echo '* hard nproc 65535' >> /etc/security/limits.conf
	" || { error "Failed to optimize system limits"; return 1; }

	TASK "* Optimizing I/O scheduler" "
		for disk in /sys/block/[sv]d*; do
			echo 'none' > \$disk/queue/scheduler 2>/dev/null || true
			echo '256' > \$disk/queue/nr_requests 2>/dev/null || true
		done
	" || { error "Failed to optimize I/O scheduler"; return 1; }

	TASK "* Disabling non-essential services" "
		for service in bluetooth cups avahi-daemon postfix nfs-server rpcbind autofs; do
			systemctl disable --now \$service 2>/dev/null || true
		done
	" || { error "Failed to disable services"; return 1; }

	TASK "* Applying system parameters" "sysctl -p $SYSCTL_CONF" || { error "Failed to apply system parameters"; return 1; }

	TASK "* Clearing system cache" "
		sync
		echo 3 > /proc/sys/vm/drop_caches
		ip -s -s neigh flush all
	" || { error "Failed to clear system cache"; return 1; }

	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "${CLR2}FINISHED${CLR0}\n"
}
function SYS_REBOOT() {
	CHECK_ROOT
	echo -e "${CLR3}Preparing to reboot system${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	active_users=$(who | wc -l) || { error "Failed to get active user count"; return 1; }
	if [ "$active_users" -gt 1 ]; then
		echo -e "${CLR1}Warning: There are currently $active_users active users on the system.\n${CLR0}"
		echo -e "Active users:"
		who | awk '{print $1 " since " $3 " " $4}'
		echo
	fi
	important_processes=$(ps aux --no-headers | awk '$3 > 1.0 || $4 > 1.0' | wc -l) || { error "Failed to check running processes"; return 1; }
	if [ "$important_processes" -gt 0 ]; then
		echo -e "${CLR1}Warning: There are $important_processes important processes running.\n${CLR0}"
		echo -e "${CLR8}Top 5 processes by CPU usage:${CLR0}"
		ps aux --sort=-%cpu | head -n 6
		echo
	fi
	read -p "Are you sure you want to reboot the system now? (y/N) " -n 1 -r
	echo
	[[ ! $REPLY =~ ^[Yy]$ ]] && { echo -e "${CLR2}Reboot cancelled.\n${CLR0}"; return 0; }
	TASK "* Performing final checks" "sync" || { error "Failed to sync filesystems"; return 1; }
	TASK "* Initiating reboot" "reboot || sudo reboot" || { error "Failed to initiate reboot"; return 1; }
	echo -e "${CLR2}Reboot command issued successfully. The system will reboot momentarily.${CLR0}"
}
function SYS_UPDATE() {
	CHECK_ROOT
	echo -e "${CLR3}Updating system software...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	update_packages() {
		cmd="$1"
		update_cmd="$2"
		upgrade_cmd="$3"
		TASK "* Updating package lists" "$update_cmd" || { error "Failed to update package lists using $cmd"; return 1; }
		TASK "* Upgrading packages" "$upgrade_cmd" || { error "Failed to upgrade packages using $cmd"; return 1; }
	}
	case $(command -v apk apt opkg pacman yum zypper dnf | head -n1) in
		*apk) update_packages "apk" "apk update" "apk upgrade" ;;
		*apt)
			while fuser /var/lib/dpkg/lock-frontend &>/dev/null; do
				TASK "* Waiting for dpkg lock" "sleep 1" || return 1
				((wait_time++))
				[ "$wait_time" -gt 300 ] && { error "Timeout waiting for dpkg lock to be released"; return 1; }
			done
			TASK "* Configuring pending packages" "DEBIAN_FRONTEND=noninteractive dpkg --configure -a" || { error "Failed to configure pending packages"; return 1; }
			update_packages "apt" "apt update -y" "apt full-upgrade -y"
			;;
		*opkg) update_packages "opkg" "opkg update" "opkg upgrade" ;;
		*pacman)
			TASK "* Updating and upgrading packages" "pacman -Syu --noconfirm" || { error "Failed to update and upgrade packages using pacman"; return 1; }
			;;
		*yum) update_packages "yum" "yum check-update" "yum -y update" ;;
		*zypper) update_packages "zypper" "zypper refresh" "zypper update -y" ;;
		*dnf) update_packages "dnf" "dnf check-update" "dnf -y update" ;;
		*) { error "Unsupported package manager"; return 1; } ;;
	esac
	TASK "* Updating $Script" "bash <(curl -L ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/update-$Script)" || { error "Failed to update $Script"; return 1; }
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "${CLR2}FINISHED${CLR0}\n"
}
function SYS_UPGRADE() {
	CHECK_ROOT
	echo -e "${CLR3}Upgrading system to next major version...${CLR0}"
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	os_name=$(CHECK_OS -n)
	case "$os_name" in
		Debian)
			echo "* Detected Debian system"
			TASK "* Updating package lists" "apt update -y" || { error "Failed to update package lists"; return 1; }
			TASK "* Upgrading current packages" "apt full-upgrade -y" || { error "Failed to upgrade current packages"; return 1; }
			echo "* Starting Debian release upgrade..."
			current_codename=$(lsb_release -cs)
			target_codename=$(curl -s http://ftp.debian.org/debian/dists/stable/Release | grep "^Codename:" | awk '{print $2}')
			[ "$current_codename" = "$target_codename" ] && { error "System is already running the latest stable version (${target_codename})"; return 1; }
			echo "* Upgrading from ${current_codename} to ${target_codename}"
			TASK "* Backing up sources.list" "cp /etc/apt/sources.list /etc/apt/sources.list.backup" || { error "Failed to backup sources.list"; return 1; }
			TASK "* Updating sources.list" "sed -i 's/${current_codename}/${target_codename}/g' /etc/apt/sources.list" || { error "Failed to update sources.list"; return 1; }
			TASK "* Updating package lists for new release" "apt update -y" || { error "Failed to update package lists for new release"; return 1; }
			TASK "* Upgrading to new Debian release" "apt full-upgrade -y" || { error "Failed to upgrade to new Debian release"; return 1; }
			;;
		Ubuntu)
			echo "* Detected Ubuntu system"
			TASK "* Updating package lists" "apt update -y" || { error "Failed to update package lists"; return 1; }
			TASK "* Upgrading current packages" "apt full-upgrade -y" || { error "Failed to upgrade current packages"; return 1; }
			echo "* Installing update-manager-core..."
			TASK "* Installing update-manager-core" "apt install -y update-manager-core" || { error "Failed to install update-manager-core"; return 1; }
			echo "* Starting Ubuntu release upgrade..."
			TASK "* Upgrading Ubuntu release" "do-release-upgrade -f DistUpgradeViewNonInteractive" || { error "Failed to upgrade Ubuntu release"; return 1; }
			SYS_REBOOT
			;;
		*) { error "Your system is not yet supported for major version upgrades"; return 1; } ;;
	esac
	echo -e "${CLR8}$(LINE = "24")${CLR0}"
	echo -e "${CLR2}System upgrade completed.${CLR0}\n"
}

function TASK() {
	message="$1"
	command="$2"
	temp_file=$(mktemp)
	echo -ne "${message}... "
	if eval "$command" > "$temp_file" 2>&1; then
		echo -e "${CLR2}Done${CLR0}"
		ret=0
	else
		ret=$?
		echo -e "${CLR1}Failed (${ret})${CLR0}"
		if [[ -s "$temp_file" ]]; then
			echo -e "${CLR8}$(cat "$temp_file")${CLR0}"
		fi
	fi
	rm -f "$temp_file"
	return $ret
}
function TIMEZONE() {
	case "$1" in
		-e)
			result=$(timeout 1s curl -sL ipapi.co/timezone) ||
			result=$(timeout 1s curl -sL worldtimeapi.org/api/ip | grep -oP '"timezone":"\K[^"]+') ||
			result=$(timeout 1s curl -sL ip-api.com/json | grep -oP '"timezone":"\K[^"]+') ||
			[ -n "$result" ] && echo "$result" || { error "Failed to detect timezone from external services"; return 1; }
			;;
		-i|*)
			result=$(readlink /etc/localtime | sed 's|^.*/zoneinfo/||') 2>/dev/null ||
			result=$(command -v timedatectl &>/dev/null && timedatectl status | awk '/Time zone:/ {print $3}') ||
			result=$(cat /etc/timezone 2>/dev/null | uniq) ||
			[ -n "$result" ] && echo "$result" || { error "Failed to detect system timezone"; return 1; }
			;;
	esac
}

[ ! -f ~/$Script ] && bash <(curl -sL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/update-$Script)
if ! crontab -l 2>/dev/null | grep -q "0 0 \* \* \* curl -sL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/update-$Script | bash"; then
	crontab -l > $Script 2>/dev/null
	echo "0 0 * * * curl -sL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/update-$Script | bash" >> $Script
	crontab $Script
	rm -f $Script
fi