#!/bin/bash
# [ -f ~/function.sh ] && source ~/function.sh || bash <(curl -sL raw.ogtt.tk/shell/update-function.sh) && source ~/function.sh
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

if [ -f ~/function.sh ]; then
	GET https://raw.ogtt.tk/shell/function.sh &>/dev/null
	source function.sh
else
	version=$(curl -sL raw.ogtt.tk/shell/function.sh | grep -oP 'Version="\K[^"]+')
	if [[ $version == 0.* ]]; then
		echo -e "\e[33mWarning: The current version ($version) is a development version. It is not recommended for use.\e[0m"
		echo -e "\e[33mYou can wait for the main version to be released before downloading again.\e[0m"
		read -p "Do you still want to download and use this version? (y/N) " -n 1 -r
		echo
		[[ ! $REPLY =~ ^[Yy]$ ]] && { echo -e "\e[31mDownload cancelled.\e[0m"; exit 1; }
	fi
	crontab -l 2>/dev/null | grep -q "0 0 \* \* \* curl -sL raw.ogtt.tk/shell/update-function.sh | bash" || (crontab -l > function-update 2>/dev/null; echo "0 0 * * * curl -sL raw.ogtt.tk/shell/update-function.sh | bash" >> function-update && crontab function-update && rm -f function-update)
	GET https://raw.ogtt.tk/shell/function.sh &>/dev/null && source function.sh
	grep -q "source ~/function.sh" ~/.bashrc || echo "source ~/function.sh" >> ~/.bashrc
fi