#!/bin/bash
# [ -f ~/utilkit.sh ] && source ~/utilkit.sh || bash <(curl -sL raw.ogtt.tk/shell/get_utilkit.sh) && source ~/utilkit.sh

Authors="OGATA Open-Source"
Scripts="get_utilkit.sh"
Version="2024.12.27"
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

location=$(curl -s ipinfo.io/country)
cf_proxy=""
if [ "$location" = "CN" ]; then
	dis_lang="zh"
elif [ "$location" = "TW" ]; then
	dis_lang="z1"
else
	dis_lang="en"
fi

text() { echo -e "$1"; }
error() {
	[ -z "$1" ] && {
		text "${CLR1}Unknown error${CLR0}"
		return 1
	}
	text "${CLR1}$1${CLR0}"
	if [ -w "/var/log" ]; then
		log_file="/var/log/ogos-error.log"
		timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
		log_entry="${timestamp} | ${Scripts} - ${Version} - $(text "$1" | tr -d '\n')"
		text "${log_entry}" >>"${log_file}" 2>/dev/null
	fi
}

lang="${1:-$dis_lang}"
apply_translations() {
	curl -sSL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/space/utilkit.json -o "utilkit.json" &>/dev/null
	[ ! -f "utilkit.json" ] && {
		error "Translation file utilkit.json not found"
		return 1
	}
	if ! jq -e ".[\"$lang\"]" "utilkit.json" >/dev/null 2>&1; then
		{
			error "Language '$lang' not found in translation file"
			return 1
		}
	fi
	grep -oP '\*#[A-Za-z0-9_-]+#\*' "utilkit.sh" | sort | uniq | while read -r code; do
		code_value=$(echo "$code" | sed 's/\*#\([A-Za-z0-9_-]\+\)#\*/\1/')
		translation=$(jq -r ".[\"$lang\"][\"$code_value\"]" "utilkit.json")
		if [ -n "$translation" ] && [ "$translation" != "null" ]; then
			escaped_translation=$(echo "$translation" | sed 's/[&/\]/\\&/g')
			sed -i "s/\*#${code_value}#\*/${escaped_translation}/g" "utilkit.sh"
		else
			text "${CLR3}Warning: Translation for $code_value not found in $lang.${CLR0}"
		fi
	done
	rm -rf "utilkit.json"
}

if [ -f ~/utilkit.sh ]; then
	text "${CLR2}Update utilkit.sh${CLR0}"
	curl -sSL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/utilkit.sh -o utilkit.sh &>/dev/null
	text "${CLR2}Apply translations${CLR0}"
	apply_translations
else
	version=$(curl -sL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/utilkit.sh | grep -oP 'Version="\K[^"]+')
	if [[ $version == 0.* ]]; then
		if [ "$dis_lang" = "z1" ]; then
			text "${CLR3}警告：此版本（$version）為開發版本。不建議使用${CLR0}"
			text "${CLR3}建議等待正式版本重新發布後再下載${CLR0}"
			read -p "是否仍然下載使用？(y/N) " -n 1 -r
			text
			[[ ! $REPLY =~ ^[Yy]$ ]] && {
				text "${CLR3}下載已取消${CLR0}"
				exit
			}
		elif [ "$dis_lang" = "zh" ]; then
			text "${CLR3}警告：当前版本（$version）是开发版本。不建议使用。${CLR0}"
			text "${CLR3}您可以等待主版本发布后再次下载。${CLR0}"
			read -p "您是否仍然要下载并使用此版本？(y/N) " -n 1 -r
			text
			[[ ! $REPLY =~ ^[Yy]$ ]] && {
				text "${CLR3}下载已取消。${CLR0}"
				exit
			}
		else
			text "${CLR3}Warning: The current version ($version) is a development version. It is not recommended for use.${CLR0}"
			text "${CLR3}You can wait for the main version to be released before downloading again.${CLR0}"
			read -p "Do you still want to download and use this version? (y/N) " -n 1 -r
			text
			[[ ! $REPLY =~ ^[Yy]$ ]] && {
				text "${CLR3}Download cancelled.${CLR0}"
				exit
			}
		fi
	fi
	if ! crontab -l | grep -F "0 0 \* \* \* curl -sL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/get_utilkit.sh | bash"; then
		crontab -l >utilkit
		echo "0 0 * * * curl -sL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/get_utilkit.sh | bash -s -- $lang" >>utilkit
		crontab utilkit
		rm -f utilkit
	fi
	curl -sSL ${cf_proxy}https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/utilkit.sh -o utilkit.sh &>/dev/null
	apply_translations
	grep -q "source ~/utilkit.sh" ~/.bashrc || echo "source ~/utilkit.sh" >>~/.bashrc
fi
