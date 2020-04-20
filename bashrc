# vim: set ft=bash
# profile:
[[ -z "${MSYSTEM}" && -f /etc/profile ]] && source /etc/profile

# Encoding vars:
export G_FILENAME_ENCODING=UTF-8
export PYTHONIOENCODING=utf-8

# Sanitize Java environment:
unset JAVA_HOME
unset JAVAC

# Set umask:
umask 0022

# Interactive?
[[ "${-}" == *i* ]] || return

# Remove existing aliases:
unalias -a

# Various `ls' flavors:
alias l='ls -sh --color=yes'
alias ls='ls -sh --color=yes'
alias sl='ls -sh --color=yes'
alias la='ls -ash --color=yes'
alias ll='ls -lsh --color=yes'
alias lla='ls -lash --color=yes'
alias lss='ls -shS --color=yes'
alias lls='ls -lshS --color=yes'

# Other aliases:
alias cal='cal -m'
alias caly='cal -y -m'
alias cp='cp -Rvi'
alias df='df -hP'
alias du='du -sh'
alias j='jobs'
alias mv='mv -iv'
alias rm='rm -iv'
alias s='cd ..'
alias rsync='rsync --progress --human-readable'

# Enable color for grep:
export GREP_COLORS="mt=36:sl=:cx=:fn=35:ln=32:bn=32:se=35"
alias grep='grep --color=auto'

# `ls' colors:
if type -P dircolors &> /dev/null; then
	tmp_colors_file="$(mktemp tmp_colors_fileXXXXXXXX --tmpdir=/dev/shm/)"
	[[ -f /etc/DIR_COLORS ]] && cat /etc/DIR_COLORS >> "${tmp_colors_file}"
	[[ -f ~/.dir_colors ]] && cat ~/.dir_colors >> "${tmp_colors_file}"
	eval $(dircolors -b "${tmp_colors_file}")
	\rm -f "${tmp_colors_file}"
fi

# Enable coredumps:
ulimit -c hard

# Enable bash completion:
[[ -f /etc/bash_completion ]] && source /etc/bash_completion

# Check ~/bin/bash_completion.d for additional bash-completion scripts:
[[ -d ~/bin/bash_completion.d ]] && {
	for i in ~/bin/bash_completion.d/*; do
		source "${i}"
	done
}

# Add ~/bin, /sbin, /usr/sbin to PATH:
export PATH="${HOME}/.local/bin:${HOME}/bin:${PATH}:/sbin:/usr/sbin"

# Nice less behavior:
export LESS='-R -M -x4 -F'
export LESSCOLOR=yes
export PAGER="$(which less)"
export EDITOR="$(which vim)"

# bash history settings:
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTCONTROL=erasedups:ignorespace
export HISTIGNORE='l:ls:sl:ll:lla:lss:lls:s:bg:fg:j:history:hstr --*'

shopt -s histappend
shopt -s cmdhist

# For xmllint --format:
export XMLLINT_INDENT="	"

# Ignore CVS and .svn directories:
export FIGNORE=CVS:.svn

# Default PS1:
export PROMPT_DIRTRIM=2
PS1='\[\e[0;33m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\$ '

# Set terminal title using PROMPT_COMMAND:
case "${TERM}" in
	xterm*|rxvt|Eterm|eterm)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/${HOME}/\~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/${HOME}/\~}\033\\"'
		;;
esac

# Augument prompt with git information:
if [[ -e "/usr/share/git-core/contrib/completion/git-prompt.sh" ]]; then
	export GIT_PS1_SHOWDIRTYSTATE=yes
	export GIT_PS1_SHOWUNTRACKEDFILES=yes
	export GIT_PS1_SHOWSTASHSTATE=yes
	export GIT_PS1_DESCRIBE_STYLE=branch
	export GIT_PS1_SHOWCOLORHINTS=yes
	export GIT_PS1_SHOWUPSTREAM="auto verbose"
	source "/usr/share/git-core/contrib/completion/git-prompt.sh"
	PROMPT_COMMAND="__git_ps1 '\[\e[0;33m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\[\e[0m\]' '\[\e[0m\]\$ '; ${PROMPT_COMMAND}"
fi

# Enable use of ccache
if type -P ccache &> /dev/null; then
	export CCACHE_DIR=${HOME}/.ccache
	[[ ! -d "${CCACHE_DIR}" ]] && {
		mkdir -p "${CCACHE_DIR}"
		chmod 700 "${CCACHE_DIR}"
	}
fi

# Pretty man:
function man() {
	if [[ "${1}" = "-k" || "${1}" = "-K" ]]; then
		/usr/bin/man "${@}"
	else
		vim -R -c "Man $1 $2" -c "set nonu" -c "bdelete 1"
	fi
}

bind -x '"\C-\M-R": /usr/bin/reset'

# HSTR settings (https://github.com/dvorka/hstr):
if type -P hstr &> /dev/null; then
	export HSTR_CONFIG=hicolor,warning,raw-history-view,keywords-matching,case-sensitive,prompt-bottom
	export HSTR_PROMPT='> '
	bind '"\C-r": "\C-ahstr -- \C-j"'
	export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
fi

# Windows MSYS Git bash tweaks:
if [[ "${OS}" = "Windows_NT" ]]; then
	unset PAGER
	unset LESS

	alias python='winpty python'
	alias gvim='start gvim'

	fast_git_ps1() {
		printf -- "$(git branch 2>/dev/null | grep -e '\* ' | sed 's/^..\(.*\)/ (\1)/')"
	}
	PS1='\[\e[0;33m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\[\e[0;36m\]$(fast_git_ps1)\[\e[0m\]\$ '
fi

[[ -e ~/.bashrc-site ]] && source ~/.bashrc-site
