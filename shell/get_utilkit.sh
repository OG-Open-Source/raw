#!/bin/bash
# [ -f ~/utilkit.sh ] && source ~/utilkit.sh || bash <(curl -sL raw.ogtt.tk/shell/get_utilkit.sh) && source ~/utilkit.sh

Authors="OGATA Open-Source"
Scripts="get_utilkit.sh"
Version="2025.03.07"
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

detect_language() {
	local loc=$(curl -s "https://developers.cloudflare.com/cdn-cgi/trace" | grep "^loc=" | cut -d= -f2)
	case "$loc" in
	CN) echo "zh" ;;
	TW) echo "z1" ;;
	*) echo "en" ;;
	esac
}

lang="${1:-$(detect_language)}"

apply_translations() {
	local temp_dir=$(mktemp -d)
	local json_file="${temp_dir}/utilkit.json"
	local sed_script="${temp_dir}/translations.sed"

	text "${CLR2}Downloading translation file...${CLR0}"
	if ! curl -sSL "https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/space/utilkit.json" -o "$json_file"; then
		error "Failed to download translation file"
		rm -rf "$temp_dir"
		return 1
	fi

	if ! jq -e ".[\"$lang\"]" "$json_file" >/dev/null 2>&1; then
		text "${CLR3}Language '$lang' not found, falling back to English${CLR0}"
		lang="en"
		if ! jq -e ".[\"$lang\"]" "$json_file" >/dev/null 2>&1; then
			error "English translations not found in file"
			rm -rf "$temp_dir"
			return 1
		fi
	fi

	text "${CLR2}Preparing translations for $lang...${CLR0}"

	>"$sed_script"

	jq -r ".[\"$lang\"] | to_entries[] | .key" "$json_file" | while read -r key; do
		value=$(jq -r ".[\"$lang\"][\"$key\"]" "$json_file")
		escaped_value=$(echo "$value" | sed -e 's/[\/&]/\\&/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g')
		echo "s/\\*#${key}#\\*/${escaped_value}/g" >>"$sed_script"
	done

	local translation_count=$(wc -l <"$sed_script")

	if [ "$translation_count" -eq 0 ]; then
		error "No translations found for language $lang"
		rm -rf "$temp_dir"
		return 1
	fi

	text "${CLR2}Applying $translation_count translations...${CLR0}"

	sed -i -f "$sed_script" "utilkit.sh"

	text "${CLR2}Translation completed successfully${CLR0}"
	rm -rf "$temp_dir"
}

if [ -f ~/utilkit.sh ]; then
	text "${CLR2}Updating utilkit.sh...${CLR0}"
	if ! curl -sSL "https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/utilkit.sh" -o "utilkit.sh"; then
		error "Failed to download utilkit.sh"
		exit 1
	fi
	apply_translations
	text "${CLR2}utilkit.sh has been updated successfully${CLR0}"
else
	version=$(curl -sL "https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/utilkit.sh" | grep -oP 'Version="\K[^"]+')
	if [[ $version == 0.* ]]; then
		case "$lang" in
		z1)
			text "${CLR3}警告：此版本（$version）為開發版本。不建議使用${CLR0}"
			text "${CLR3}建議等待正式版本重新發布後再下載${CLR0}"
			read -p "是否仍然下載使用？(y/N) " -n 1 -r
			;;
		zh)
			text "${CLR3}警告：当前版本（$version）是开发版本。不建议使用。${CLR0}"
			text "${CLR3}您可以等待主版本发布后再次下载。${CLR0}"
			read -p "您是否仍然要下载并使用此版本？(y/N) " -n 1 -r
			;;
		*)
			text "${CLR3}Warning: The current version ($version) is a development version. Not recommended for use.${CLR0}"
			text "${CLR3}You can wait for the main version to be released before downloading again.${CLR0}"
			read -p "Do you still want to download and use this version? (y/N) " -n 1 -r
			;;
		esac
		text
		[[ ! $REPLY =~ ^[Yy]$ ]] && {
			text "${CLR3}Download cancelled.${CLR0}"
			exit 0
		}
	fi

	if ! crontab -l 2>/dev/null | grep -q "get_utilkit.sh"; then
		(crontab -l 2>/dev/null || echo "") | {
			cat
			echo "0 0 * * * curl -sL https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/get_utilkit.sh | bash -s -- $lang"
		} | crontab -
		text "${CLR2}Added daily auto-update to crontab${CLR0}"
	fi

	text "${CLR2}Downloading utilkit.sh...${CLR0}"
	if ! curl -sSL "https://raw.githubusercontent.com/OG-Open-Source/raw/refs/heads/main/shell/utilkit.sh" -o "utilkit.sh"; then
		error "Failed to download utilkit.sh"
		exit 1
	fi

	apply_translations

	if ! grep -q "source ~/utilkit.sh" ~/.bashrc; then
		echo "source ~/utilkit.sh" >>~/.bashrc
		text "${CLR2}Added source command to ~/.bashrc${CLR0}"
	fi

	text "${CLR2}utilkit.sh has been installed successfully${CLR0}"
	text "${CLR2}Please run 'source ~/utilkit.sh' to use it in the current session${CLR0}"
fi
