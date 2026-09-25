#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# tty1 -> Hyprland. Other TTYs stay plain shells (debugging escape hatch).
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
	exec start-hyprland
fi
