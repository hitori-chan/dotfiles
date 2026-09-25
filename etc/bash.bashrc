#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source additional bash configuration
if [[ -d /etc/bashrc.d ]]; then
	for rc in /etc/bashrc.d/*.bash; do
		[[ -r "$rc" ]] && . "$rc"
	done
fi
