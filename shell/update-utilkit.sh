#!/bin/bash
# [ -f ~/utilkit.sh ] && source ~/utilkit.sh || bash <(curl -sL raw.ogtt.tk/shell/update-utilkit.sh) && source ~/utilkit.sh

readonly Author="OGATA Open-Source"
readonly Script="update-utilkit.sh"
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

[ "$(curl -s ipinfo.io/country)" = "CN" ] && cf_proxy="https://proxy.ogtt.tk/" && display_language="zh" || cf_proxy="" && display_language="en"
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

if [ -f ~/utilkit.sh ]; then
	curl -sSL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/utilkit.sh -o utilkit.sh &>/dev/null
else
	version=$(curl -sL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/utilkit.sh | grep -oP 'Version="\K[^"]+')
	if [[ $version == 0.* ]]; then
		if [ "$display_language" = "en" ]; then
			echo -e "${CLR3}Warning: The current version ($version) is a development version. It is not recommended for use.${CLR0}"
			echo -e "${CLR3}You can wait for the main version to be released before downloading again.${CLR0}"
			read -p "Do you still want to download and use this version? (y/N) " -n 1 -r
			echo
			[[ ! $REPLY =~ ^[Yy]$ ]] && { echo -e "\e[31mDownload cancelled.${CLR0}"; exit 1; }
		elif [ "$display_language" = "zh" ]; then
			echo -e "${CLR3}警告：当前版本（$version）是开发版本。不建议使用。${CLR0}"
			echo -e "${CLR3}您可以等待主版本发布后再次下载。${CLR0}"
			read -p "您是否仍然要下载并使用此版本？(y/N) " -n 1 -r
			echo
			[[ ! $REPLY =~ ^[Yy]$ ]] && { echo -e "\e[31m下载已取消。${CLR0}"; exit 1; }
		fi
	fi
	if ! crontab -l 2>/dev/null | grep -q "0 0 \* \* \* curl -sL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/$Script | bash"; then
		crontab -l > utilkit 2>/dev/null
		echo "0 0 * * * curl -sL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/$Script | bash" >> utilkit
		crontab utilkit
		rm -f utilkit
	fi
	curl -sSL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/utilkit.sh -o utilkit.sh &>/dev/null
	grep -q "source ~/utilkit.sh" ~/.bashrc || echo "source ~/utilkit.sh" >> ~/.bashrc
fi