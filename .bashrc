# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]]; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Put your fun stuff here.

osc7_cwd() {
	local strlen=${#PWD}
	local encoded=""
	local pos c o
	for ((pos = 0; pos < strlen; pos++)); do
		c=${PWD:$pos:1}
		case "$c" in
		[-/:_.!\'\(\)~[:alnum:]]) o="${c}" ;;
		*) printf -v o '%%%02X' "'${c}" ;;
		esac
		encoded+="${o}"
	done
	printf '\e]7;file://%s%s\e\\' "${HOSTNAME}" "${encoded}"
}
PROMPT_COMMAND=${PROMPT_COMMAND:+${PROMPT_COMMAND%;}; }osc7_cwd

# Color for other-writable directories
export LS_COLORS="${LS_COLORS}:ow=1;37;42"

export GOPATH="$HOME/.go"

path_add() {
	[ -d "$1" ] || return
	case ":$PATH:" in
	*:"$1":*) ;;
	*) PATH="${PATH:+$PATH:}$1" ;;
	esac
}

path_add "$HOME/.local/bin"
path_add "$HOME/.cargo/bin"
path_add "$GOPATH/bin"
path_add "$HOME/.local/share/solana/install/active_release/bin"
export PATH

# Color for man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

b64safe() {
	until s=$(openssl rand -base64 ${1:-32} | tr -d '\n') && [[ $s != *[+/]* ]]; do :; done
	echo $s
}

# Manage dotfiles
if [ -d "$HOME/.dotfiles" ]; then
	dotfile_cmd="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
	alias dotfile=$dotfile_cmd

	$dotfile_cmd config status.showUntrackedFiles no

	[ -r /usr/share/bash-completion/completions/git ] &&
		source /usr/share/bash-completion/completions/git &&
		__git_complete dotfile __git_main
fi

export npm_config_prefix="$HOME/.local"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
