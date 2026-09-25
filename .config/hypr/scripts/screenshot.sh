#!/usr/bin/env bash
# screenshot.sh <region|window|output> <copy|save>
# grim/slurp-based; window mode grabs the active window via hyprctl.
set -euo pipefail

mode="${1:-region}"
dest="${2:-copy}"

usage() {
	echo "usage: $0 region|window|output copy|save" >&2
}

case "$mode" in
	region | window | output) ;;
	*)
		usage
		exit 1
		;;
esac

case "$dest" in
	copy | save) ;;
	*)
		usage
		exit 1
		;;
esac

dir="$HOME/pic/screenshots"
file="$dir/$(date +%F_%H-%M-%S_%N).png"

grab() {
	case "$mode" in
		region)
			grim -g "$(slurp)" "$1"
			;;
		window)
			local geo
			geo=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
			grim -g "$geo" "$1"
			;;
		output)
			local mon
			mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
			grim -o "$mon" "$1"
			;;
	esac
}

if [[ "$dest" == "save" ]]; then
	mkdir -p "$dir"
	grab "$file"
	notify-send -a osd -u low -t 3000 -i "$file" "Screenshot" "saved: ${file/#$HOME/\~}" || true
else
	# the copy previews itself: tee the grab to a runtime file for the
	# card's icon (wide grabs render card-wide as a hero). Unique names keep
	# overlapping captures independent; old previews expire after decoding.
	preview_dir="${XDG_RUNTIME_DIR:-/tmp}/hypr-screenshots"
	install -d -m 700 "$preview_dir"
	find "$preview_dir" -maxdepth 1 -type f -name 'preview.*.png' -mmin +10 -delete
	tmp=$(mktemp "$preview_dir/preview.XXXXXX.png")
	grab - | tee "$tmp" | wl-copy -t image/png
	notify-send -a osd -u low -t 2000 -i "$tmp" "Screenshot" "$mode copied to clipboard" || true
fi
