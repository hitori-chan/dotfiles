#!/usr/bin/env bash
# lock.sh: hyprlock with its look derived from lockscreen.jpg for the largest
# monitor; the first lock after either changes waits for the derivation.
# No set -e: nothing here may stand between the caller and hyprlock.

art="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/lockscreen.jpg"
cache="${XDG_CACHE_HOME:-$HOME/.cache}/hypr-lock"

read -r w h s < <(hyprctl -j monitors | jq -r 'max_by(.width * .height) | "\(.width) \(.height) \(.scale)"')
key="$cache/$(stat -Lc '%Y-%s' "$art")-${w}x$h@$s"

# a centred area of a logical size; y from the top or, negative, the bottom
area() { # area <width> <height> <y>
	awk -v W="$w" -v H="$h" -v s="$s" -v a="$1" -v b="$2" -v y="$3" \
		'BEGIN { printf "%dx%d+%d+%d", a * s, b * s, (W - a * s) / 2, y < 0 ? H + y * s : y * s }'
}

# linear luminance 0.30 is where white ink drops under 3:1
ink() { # ink <name> <area>
	if [[ "$(magick "$key.jpg" -crop "$2" +repage -colorspace LinearGray -threshold 30% -format '%[fx:mean >= 0.6]' info:)" == 1 ]]; then
		echo "export HYPRLOCK_$1_INK=0C0E12E6 HYPRLOCK_$1_SHADOW=FFFFFF66"
	else
		echo "export HYPRLOCK_$1_INK=FFFFFFF2 HYPRLOCK_$1_SHADOW=00000080"
	fi
}

derive() {
	local slot fill
	rm -f "$cache"/*.jpg "$cache"/*.vars
	# hyprlock aliases an image much larger than the screen
	magick -define "jpeg:size=$((w * 2))x$((h * 2))" "$art" -auto-orient \
		-resize "${w}x$h^" -gravity center -extent "${w}x$h" -quality 92 "$key.jpg" || return

	slot="$(area 232 38 -122)"
	# the box must cover the mark, so it is opaque: the colour a frosted crop
	# would average to
	fill="$(magick "$key.jpg" -crop "$slot" +repage -modulate 100,140 -fill black -colorize 24 \
		-resize '1x1!' -format '%[hex:p{0,0}]' info:)" || return
	{
		echo "export HYPRLOCK_ART='$key.jpg' HYPRLOCK_SCALE=$s HYPRLOCK_BOX=$fill"
		ink CLOCK "$(area 420 140 115)"
		ink MARK "$slot"
		# 0.18: white and black ink read the same on a flat fill
		if [[ "$(magick "xc:#$fill" -colorspace LinearGray -format '%[fx:mean > 0.18]' info:)" == 1 ]]; then
			echo "export HYPRLOCK_BOX_INK=0C0E12 HYPRLOCK_BOX_RIM=00000024"
		else
			echo "export HYPRLOCK_BOX_INK=FFFFFF HYPRLOCK_BOX_RIM=FFFFFF38"
		fi
	} >"$key.tmp" && mv -f "$key.tmp" "$key.vars"
}

mkdir -p "$cache"
{
	flock 9
	[[ -r "$key.vars" ]] || derive
} 9>"$cache/lock"
# shellcheck disable=SC1090
. "$key.vars" 2>/dev/null

exec hyprlock "$@"
