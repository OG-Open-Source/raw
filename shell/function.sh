#!/bin/bash
# FILE="function.sh"
# [ ! -f "$FILE" ] && curl -sSL "https://raw.ogtt.tk/shell/function.sh" -o "$FILE"
# [ -f "$FILE" ] && source "$FILE"
COPYRIGHT() { echo "Copyright (C) 2024 OG|OS OGATA-Open-Source. All Rights Reserved."; }

CLR1="\033[31m"
CLR2="\033[32m"
CLR3="\033[33m"
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

CHECK_ROOT() {
	[ "$(id -u)" -ne 0 ] && { echo -e "${CLR1}Please run this script as root user.${CLR0}"; exit 1; }
	echo
}
CLEAN() {
	cd ~
	clear
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

FILE_MANGER() {
	ipp=20
	cp=0
	sq=""
	cd=$(pwd)
	trap 'echo -e "\033[?1000l" && exit' SIGINT
	df() {
		s=$1
		e=$2
		sr=$3
		clear
		echo -e "${CLR8}Current Directory: ${CLR3}$cd${CLR0}"
		printf "${CLR8}%$(tput cols)s\n" | tr ' ' '-'
		printf "${CLR2}%-28s %-20s %-14s %-10s %s${CLR0}\n" "Name" "Modification Date" "Size" "Type" "Permissions"
		printf "${CLR8}%$(tput cols)s\n" | tr ' ' '-'
		find "$cd" -maxdepth 1 | tail -n +2 | awk -v s="$s" -v e="$e" -v sr="$sr" '
		NR > s && NR <= e {
			cmd = "stat --format=\"%y\" \""$0"\" | cut -d \".\" -f 1 | cut -c1-16"
			cmd | getline dt
			close(cmd)
			cmd = "stat --format=\"%A %s %n\" \""$0"\""
			cmd | getline fi
			close(cmd)
			split(fi, ia, " ")
			p = ia[1]
			sz = ia[2]
			n = gensub(/.*\//, "", "g", $0)
			if (sr == "" || tolower(n) ~ tolower(sr)) {
				t = (p ~ /^d/) ? "Directory" : (p ~ /^l/) ? "Link" : "File"
				tc = (p ~ /^d/) ? "'$CLR4'" : (p ~ /^l/) ? "'$CLR6'" : "'$CLR2'"
				if (length(n) > 28) n = substr(n, 1, 25) "...";

				u = (sz >= 1048576) ? "MiB" : (sz >= 1024) ? "KiB" : "Bytes"
				nm = (sz >= 1048576) ? sz/1048576 : (sz >= 1024) ? sz/1024 : sz

				printf "'$CLR9'%-28s'$CLR0' '$CLR3'%-16s'$CLR0' '$CLR6'%8.2f %-6s'$CLR0'    %s%-10s'$CLR0' '$CLR2'%s'$CLR0'\n", \
					n, dt, nm, u, tc, t, p
			}
		}'
		di=$(find "$cd" -maxdepth 1 | tail -n +2 | awk -v s="$s" -v e="$e" -v sr="$sr" 'NR > s && NR <= e && (sr == "" || tolower($0) ~ tolower(sr)) {print}' | wc -l)
		for (( i=di; i<ipp; i++ )); do
			printf "%-28s %-20s %-14s %-10s %s\n" "" "" "" "" ""
		done
		printf "${CLR8}%$(tput cols)s\n" | tr ' ' '-'
		echo -e "${CLR2}Page: ${CLR3}$((current_page + 1))/${total_pages}${CLR0}"
		printf "${CLR8}%56s\n" | tr ' ' '-'
		echo -e "${CLR8}[Up]${CLR0} | ${CLR8}[Down]${CLR0} | ${CLR8}[Prev]${CLR0} | ${CLR8}[Next]${CLR0} | ${CLR8}[Search]${CLR0} | ${CLR8}[Refresh]${CLR0} | ${CLR8}[Exit]${CLR0}"
		printf "${CLR8}%56s\n" | tr ' ' '-'
		echo -e "${CLR8}[Delete]${CLR0} | ${CLR8}[New File]${CLR0} | ${CLR8}[New Dir]${CLR0} | ${CLR8}[Rename]${CLR0} | ${CLR8}[Permissions]${CLR0} | ${CLR8}[Edit]${CLR0}"
		printf "${CLR8}%56s\n" | tr ' ' '-'
		echo -e "${CLR8}[Copy]${CLR0} | ${CLR8}[Move]${CLR0} | ${CLR8}[Tar/Untar]${CLR0} | ${CLR8}[Help]${CLR0} | ${CLR8}[About]${CLR0}"
	}
	rf() {
		tf=$(find "$cd" -maxdepth 1 | tail -n +2 | wc -l)
		tp=$(( (tf + ipp - 1) / ipp ))
		df $((cp * ipp)) $(( (cp + 1) * ipp )) "$sq"
	}
	rn() {
		echo -e "\033[?1000l"
		eval "$@"
		rf
		echo -e "\033[?1000h"
	}
	rf
	echo -e "\033[?1000h"
	while IFS= read -rsn1 m; do
		if [[ $m == $'\033' ]]; then
			read -rsn2 -t 0.001 m
			if [[ $m == '[M' ]]; then
				read -rsn3 p
				x=$(printf '%d' "'${p:1:1}")
				y=$(printf '%d' "'${p:2:1}")
				case "$y" in
					60)
						case "$x" in
							3[3-6]) rn "cd=$(dirname "$cd")" ;;
							4[0-5]) rn "read -e -p \"Enter directory: \" sd && [[ -d \"\$cd/\$sd\" ]] && cd=\$(realpath \"\$cd/\$sd\") || { echo \"Directory '\$sd' does not exist.\"; sleep 1; }" ;;
							49|5[0-4]) rn "((cp > 0)) && ((cp--))" ;;
							5[8-9]|6[0-3]) rn "((cp < tp - 1)) && ((cp++))" ;;
							6[7-9]|7[0-4]) rn "read -e -p \"Search query: \" sq && [[ -n \"\$sq\" ]] && { tf=\$(ls -A1 \"\$cd\" | grep -i -F \"\$sq\" | wc -l); ((tf == 0)) && { echo \"No results found.\"; sleep 1; sq=\"\"; } || { tp=\$(( (tf + ipp - 1) / ipp )); cp=0; }; }; rf" ;;
							7[8-9]|8[0-6]) rn "true" ;;
							9[0-5]) echo -e "\033[?1000l"; break ;;
						esac ;;
					62)
						case "$x" in
							3[3-9]|40) rn "IFS=',' read -ra ftd <<< \$(read -e -p \"Files to delete: \" && echo \"\$resetEPLY\"); for f in \"\${ftd[@]}\"; do [[ -e \"\$cd/\$f\" ]] && { rm -r \"\$cd/\$f\"; echo \"Deleted '\$f'.\"; } || echo \"'\$f' does not exist.\"; done; sleep 1" ;;
							4[4-9]|5[0-3]) rn "read -e -p \"New file name: \" ftc && [[ ! -e \"\$cd/\$ftc\" ]] && touch \"\$cd/\$ftc\" || { echo \"File exists.\"; sleep 1; }" ;;
							5[7-9]|6[0-5]) rn "read -e -p \"New directory name: \" dtc && [[ ! -d \"\$cd/\$dtc\" ]] && mkdir -p \"\$cd/\$dtc\" || { echo \"Directory exists.\"; sleep 1; }" ;;
							69|7[0-6]) rn "read -e -p \"File to rename: \" on && [[ -e \"\$cd/\$on\" ]] && { read -e -p \"New name: \" nn && [[ -n \"\$nn\" ]] && { [[ ! -e \"\$cd/\$nn\" ]] && mv \"\$cd/\$on\" \"\$cd/\$nn\" || echo \"New name exists.\"; }; } || { echo \"'\$on' does not exist.\"; sleep 1; }; rf" ;;
							8[0-9]|9[0-2]) rn "read -e -p \"File to change permissions: \" n && [[ -e \"\$cd/\$n\" ]] && { read -e -p \"New permissions: \" p && chmod \"\$p\" \"\$cd/\$n\"; } || { echo \"'\$n' does not exist.\"; sleep 1; }" ;;
							9[6-9]|10[0-1]) rn "read -e -p \"File to edit: \" fte && [[ -f \"\$cd/\$fte\" ]] && nano \"\$cd/\$fte\" || { echo \"'\$fte' does not exist.\"; sleep 1; }" ;;
						esac ;;
					64)
						case "$x" in
							3[3-8]) rn "read -e -p \"Files to copy (separated by commas): \" i; IFS=',' read -ra ftc <<< \"\$i\"; read -e -p \"Destination: \" d; if [[ -d \"\$(realpath \"\$cd/\$d\")\" ]]; then for f in \"\${ftc[@]}\"; do f=\$(echo \"\$f\" | xargs); if [[ -e \"\$cd/\$f\" ]]; then cp -r \"\$cd/\$f\" \"\$(realpath \"\$cd/\$d\")\"; echo \"Copied '\$f' to '\$d'.\"; else echo \"'\$f' does not exist.\"; fi; done; else echo \"Invalid destination.\"; fi; sleep 1" ;;
							4[2-7]) rn "read -e -p \"Files to move (separated by commas): \" i; IFS=',' read -ra ftm <<< \"\$i\"; read -e -p \"Destination: \" d; if [[ -d \"\$(realpath \"\$cd/\$d\")\" ]]; then for f in \"\${ftm[@]}\"; do f=\$(echo \"\$f\" | xargs); if [[ -e \"\$cd/\$f\" ]]; then mv \"\$cd/\$f\" \"\$(realpath \"\$cd/\$d\")\"; echo \"Moved '\$f' to '\$d'.\"; else echo \"'\$f' does not exist.\"; fi; done; else echo \"Invalid destination.\"; fi; sleep 1" ;;
							5[1-9]|6[0-1]) rn "read -e -p \"File/directory: \" i && [[ -e \"\$cd/\$i\" ]] && { [[ \"\$i\" == *.tar.gz ]] && { echo \"Decompressing '\$i'...\"; pv \"\$cd/\$i\" | tar -xz -C \"\$cd\"; echo \"Decompression complete.\"; } || { echo \"Compressing '\$i'...\"; (cd \"\$cd\" && tar -czf - \"\$i\" | pv -s \$(du -sb \"\$cd/\$i\" | awk '{print \$1}') > \"\$i.tar.gz\"); echo \"Compression complete.\"; }; } || { echo \"'\$i' does not exist.\"; sleep 1; }; rf" ;;
							6[5-9]|70) rn "echo 'Help: File management options: move, copy, delete, rename, etc.'; sleep 2" ;;
							7[4-9]|80) rn "echo 'About: File Manager Script v1.0 by OGOS OGATA.'; sleep 2" ;;
						esac ;;
				esac
			fi
		fi
	done
	echo -e "\033[?1000l"
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
	echo -e "${FONT}${1}${CLR0}"
}

INPUT() {
	read -e -p "$1" "$2"
}

LINE() {
	printf '%*s' "$2" '' | tr ' ' "$1"
}

SYS_CLEAN() {
	echo -e "${CLR3}Performing system cleanup...${CLR0}"
	echo -e "${CLR6}========================${CLR0}"
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
	echo -e "${CLR6}========================${CLR0}"
}
SYS_INFO() {
	echo -e "${CLR3}System Information${CLR0}"
	echo -e "${CLR6}========================${CLR0}"
	echo -e "Hostname:         ${CLR2}$(hostname)${CLR0}"
	echo -e "Operating System: ${CLR2}$(grep '^NAME=' /etc/*release | cut -d'=' -f2 | tr -d '\"') $(if [ -f /etc/debian_version ]; then echo "Debian $(cat /etc/debian_version)"; elif command -v lsb_release >/dev/null 2>&1; then lsb_release -d | cut -f2; else grep '^VERSION=' /etc/*release | cut -d'=' -f2 | tr -d '\"'; fi)${CLR0}"
	echo -e "Kernel Version:   ${CLR2}$(uname -r)${CLR0}"
	echo -e "${CLR6}--------------------------------${CLR0}"
	echo -e "Architecture:     ${CLR2}$(uname -m)${CLR0}"
	echo -e "CPU Model:        ${CLR2}$(lscpu | awk -F': +' '/Model name:/ {print $2; exit}')${CLR0}"
	echo -e "CPU Cores:        ${CLR2}$(nproc)${CLR0}"
	echo -e "${CLR6}--------------------------------${CLR0}"
	echo -e "Total Memory:     ${CLR2}$(free -h | awk '/^Mem:/ {print $3}' | sed 's/Gi/GiB/g' | sed 's/Mi/MiB/g') / $(free -h | awk '/^Mem:/ {print $2}' | sed 's/Gi/GiB/g' | sed 's/Mi/MiB/g')${CLR0}"
	echo -e "Memory Usage:     ${CLR2}$(free | awk '/^Mem:/ {printf("%.2f"), $3/$2 * 100.0}')%${CLR0}"
	echo -e "${CLR6}--------------------------------${CLR0}"
	echo -e "Total Storage:    ${CLR2}$(df -h | awk '$NF=="/"{printf "%s", $3}' | sed 's/G/GiB/g' | sed 's/M/MiB/g') / $(df -h | awk '$NF=="/"{printf "%s", $2}' | sed 's/G/GiB/g' | sed 's/M/MiB/g')${CLR0}"
	echo -e "Disk Usage:       ${CLR2}$(df -h | awk '$NF=="/"{printf "%.2f", $3/$2 * 100}')%${CLR0}"
	echo -e "${CLR6}--------------------------------${CLR0}"
	LOCATION_DATA=$(curl -s ipinfo.io)
	echo -e "IPv4 Address:     ${CLR2}$(echo "$LOCATION_DATA" | jq -r .ip)${CLR0}"
	echo -e "IPv6 Address:     ${CLR2}$(curl -s ipv6.ip.sb)${CLR0}"
	echo -e "Location:         ${CLR2}$(echo "$LOCATION_DATA" | jq -r .city), $(echo "$LOCATION_DATA" | jq -r .country)${CLR0}"
	echo -e "Timezone:         ${CLR2}$(readlink /etc/localtime | sed 's/^.*zoneinfo\///' 2>/dev/null)${CLR0}"
	echo -e "${CLR6}--------------------------------${CLR0}"
	echo -e "Uptime:           ${CLR2}$(uptime -p | sed 's/up //')${CLR0}"
	echo -e "${CLR6}========================${CLR0}"
}
SYS_UPDATE() {
	echo -e "${CLR3}Updating system software...${CLR0}"
	echo -e "${CLR6}========================${CLR0}"
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
	echo -e "${CLR6}========================${CLR0}"
}

TIMEZONE() {
	readlink /etc/localtime | sed 's/^.*zoneinfo\///' 2>/dev/null
}