#!/usr/bin/env bash
# screenshot.sh region|window|output copy|save
set -euo pipefail

# the target comes first: a cancelled selection leaves the clipboard alone
flag=-g
case "$1" in
	region) target=$(slurp) ;;
	window) target=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"') ;;
	output)
		flag=-o
		target=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
		;;
esac

if [[ "$2" == save ]]; then
	dir=~/pic/screenshots
	mkdir -p "$dir"
	file="$dir/$(date +%F_%H-%M-%S_%N).png"
	grim "$flag" "$target" "$file"
	notify-send -e -a osd -u low -t 3000 -i "$file" Screenshot "saved: ${file/#$HOME/\~}"
else
	# the card's preview: a runtime file per grab, aged out
	dir="$XDG_RUNTIME_DIR/hypr-screenshots"
	install -d -m 700 "$dir"
	find "$dir" -type f -mmin +10 -delete
	file=$(mktemp "$dir/XXXXXX.png")
	grim "$flag" "$target" "$file"
	wl-copy -t image/png <"$file"
	notify-send -e -a osd -u low -t 2000 -i "$file" Screenshot "$1 copied to clipboard"
fi
