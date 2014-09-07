# vim: set ft=sh
# profile:
[[ -z "${MSYSTEM}" && -f /etc/profile ]] && source /etc/profile

# GTK+ file name handling:
export G_FILENAME_ENCODING=UTF-8

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
export GREP_COLOR=34
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

# Change the window title of X terminals:
case ${TERM} in
	xterm*|rxvt|Eterm|eterm)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

# Enable bash completion:
[[ -f /etc/bash_completion ]] && source /etc/bash_completion

# Check ~/bin/bash_completion.d for additional bash-completion scripts:
[[ -d ~/bin/bash_completion.d ]] && {
	for i in ~/bin/bash_completion.d/*; do
		source ${i}
	done
}

# Add ~/bin, /sbin, /usr/sbin to PATH:
export PATH=${HOME}/bin:${PATH}:/sbin:/usr/sbin

# Nice less behavior:
export LESS='-R -M -x4 -F'
export LESSCOLOR=yes
export PAGER="$(which less)"
export EDITOR="$(which vim)"

# bash history settings:
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTCONTROL=erasedups

shopt -s histappend

# For xmllint --format:
export XMLLINT_INDENT="	"

# Ignore CVS and .svn directories:
export FIGNORE=CVS:.svn

# Nice prompt colors:
PS1='\[\e[0;33m\]\u@\h\[\e[0m\] \[\e[0;32m\]\w\[\e[0m\]\$ '
if [[ -e "/usr/share/git-core/contrib/completion/git-prompt.sh" ]]; then
	export __GIT_PROMPT="/usr/share/git-core/contrib/completion/git-prompt.sh"
elif [[ -e "/c/Program Files (x86)/Git/etc/git-prompt.sh" ]]; then
	export __GIT_PROMPT="/c/Program Files (x86)/Git/etc/git-prompt.sh"
fi
if [[ -n "${__GIT_PROMPT}" ]]; then
	export GIT_PS1_SHOWDIRTYSTATE=yes
	export GIT_PS1_SHOWUNTRACKEDFILES=yes
	export GIT_PS1_SHOWUPSTREAM=auto
	source "${__GIT_PROMPT}"
	PS1='\[\e[0;33m\]\u@\h\[\e[0m\] \[\e[0;32m\]\w\[\e[0m\]\[\e[0;36m\]$(__git_ps1)\[\e[0m\]\$ '
fi
export PROMPT_DIRTRIM=2

export PYTHONIOENCODING=utf-8

# Enable use of ccache
export CCACHE_DIR=${HOME}/.ccache
[[ ! -d "${CCACHE_DIR}" ]] && {
	mkdir -p "${CCACHE_DIR}"
	chmod 700 "${CCACHE_DIR}"
}

# Pretty man:
function man() {
	if [[ "${1}" = "-k" || "${1}" = "-K" ]]; then
		/usr/bin/man "${@}"
	else
		vim -R -c "Man $1 $2" -c "set nonu" -c "bdelete 1"
	fi
}

bind -x '"\C-\M-R": /usr/bin/reset'

function mvnsrc() {
	mvn -Dmaven.test.skip -DdownloadSources=true eclipse:eclipse
}

[[ -e ~/.bashrc-site ]] && source ~/.bashrc-site
