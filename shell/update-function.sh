#!/bin/bash
# [ -f ~/function.sh ] && source ~/function.sh || bash <(curl -sL raw.ogtt.tk/shell/update-function.sh) && source ~/function.sh

Author="OGATA Open-Source"
License="MIT License"

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

[ "$(curl -s ipinfo.io/country)" = "CN" ] && gh_proxy="https://gh.kejilion.pro/" && display_language="zh" || gh_proxy="" && display_language="en"

GET() {
	[ $# -eq 0 ] && return 1
	url="$1"
	[[ "$url" =~ ^(http|https|ftp):// ]] || url="https://$url"
	output_file="${url##*/}"
	[ -z "$output_file" ] && output_file="index.html"
	target_dir="${2:-.}"
	mkdir -p "$target_dir" || return 1
	output_file="$target_dir/$output_file"
	url=$(echo "$url" | sed -E 's#([^:])/+#\1/#g; s#^(https?|ftp):/+#\1://#')
	curl -L -k -m 5 "$url" -o "$output_file" &>/dev/null || wget --no-check-certificate -T 5 -t 2 "$url" -O "$output_file" &>/dev/null || return 1
}

if [ "$1" = "-r" ]; then
	(crontab -l 2>/dev/null; echo "0 0 * * * curl -sL ${gh_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/update-function.sh | bash") | crontab -
	GET ${gh_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/function.sh &>/dev/null && source function.sh
	echo "source /root/function.sh" >> /root/.bashrc
elif [ -f ~/function.sh ]; then
	GET ${gh_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/function.sh &>/dev/null
	source function.sh
else
	version=$(curl -sL raw.ogtt.tk/shell/function.sh | grep -oP 'Version="\K[^"]+')
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
	if ! crontab -l 2>/dev/null | grep -q "0 0 \* \* \* curl -sL ${gh_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/update-function.sh | bash"; then
		crontab -l > update-function 2>/dev/null
		echo "0 0 * * * curl -sL ${gh_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/update-function.sh | bash" >> update-function
		crontab update-function
		rm -f update-function
	fi
	GET ${gh_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/function.sh &>/dev/null && source function.sh
	grep -q "source ~/function.sh" ~/.bashrc || echo "source ~/function.sh" >> ~/.bashrc
fi