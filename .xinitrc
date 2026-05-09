# Environment variables
export XDG_CURRENT_DESKTOP=gnome

# Load .Xresources and apply DPI
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
xrandr --dpi $(xrdb -query | awk '/Xft.dpi/ {print $2}')

# Screen lock settings
xset s 600 5
XSECURELOCK_SAVER="$HOME/.local/bin/xsecurelock_bg" \
	XSECURELOCK_SHOW_KEYBOARD_LAYOUT=0 \
	XSECURELOCK_SHOW_DATETIME=1 \
	XSECURELOCK_PAM_SERVICE=system-local-login \
	xss-lock xsecurelock &

# Prevent sleep
caffeine &

# Input method
fcitx5 &

# Network manager applet
nm-applet &

# systemd user environment
[ -f /etc/X11/xinit/xinitrc.d/50-systemd-user.sh ] && . /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# Polkit agent
[ -x /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ] &&
	/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Compositor
picom &

# Start window manager
exec awesome

# vim: ft=sh
