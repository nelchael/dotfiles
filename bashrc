
# profile:
[[ -f /etc/profile ]] && source /etc/profile

# Setup important things:
# Firefox settings:
export BROWSER=mozilla
export MOZILLA_NEWTYPE='tab'

# GTK+ file name handling:
export G_FILENAME_ENCODING=ISO-8859-2
export G_BROKEN_FILENAMES=1

# Sanitize Java environment:
unset JAVA_HOME
unset JAVAC

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
alias cp='cp -Rvi'
alias df='df -hP'
alias du='du -sh'
alias mv='mv -iv'
alias pst='pstree -achGp'
alias rm='rm -iv'
alias s='cd ..'
alias ss='cd ../..'
alias cal='cal -m'
alias caly='cal -y -m'
alias shredv='shred -v -z -n 32'
alias cdrip='cdda2wav dev=/dev/cdrom -stereo -alltracks'
alias netselect='sudo netselect'
# ;)
alias ':q'='exit'

# Enable color for grep:
if [[ -n "$(grep --help | grep -- --color)" ]]; then
	export GREP_COLOR=34
	alias grep='grep --color=auto'
fi

# `ls' colors:
[[ -f /etc/DIR_COLORS ]] && {
	eval $(dircolors -b /etc/DIR_COLORS)
	textfiles=(
		'*.c'
		'*.cc'
		'*.conf'
		'*.cpp'
		'*.cxx'
		'*.h'
		'*.hh'
		'*.hpp'
		'*.html'
		'*.java'
		'*.odp'
		'*.ods'
		'*.odt'
		'*.properties'
		'*.sxw'
		'*.xml'
		'*.xsl'
		'*history'
		'*rc'
	)
	for i in "${textfiles[@]}"; do
		export LS_COLORS="${LS_COLORS}${i}=00;32:"
	done
	unset textfiles i
}

# Disallow coredumps:
ulimit -c 0

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
[[ -f /etc/profile.d/bash-completion.sh ]] && source /etc/profile.d/bash-completion.sh

# Check ~/bin/bash_completion.d for additional bash-completion scripts:
[[ -d ~/bin/bash_completion.d ]] && {
	for i in ~/bin/bash_completion.d/*; do
		source ${i}
	done
}

# Add ~/bin, /sbin, /usr/sbin to PATH:
export PATH=${HOME}/bin:${PATH}:/sbin:/usr/sbin

# Nice less behavior:
export LESS='-R -M -x4'

# bash history settings:
export HISTFILESIZE=2500
export HISTSIZE=2500

# For xmllint --format:
export XMLLINT_INDENT="	"

# Nice prompt colors:
PS1='\[\e[06;33m\]\u@\h\[\e[0m\] \[\e[06;32m\]\W\[\e[0m\]\$ '

# Default to Qt4:
[[ -d /usr/lib/qt4 ]] && export QTDIR=/usr/lib/qt4
[[ -d ~/.qt/plugins4 ]] && export QT_PLUGIN_PATH=~/.qt/plugins4

# Check PYTHONPATH
[[ -d ~/.hgextensions ]] && export PYTHONPATH=~/.hgextensions:${PYTHONPATH}

# Enable use of ccache
[[ -n "$(type -P ccache)" ]] && {
	export PATH=/usr/lib/ccache/bin:${PATH}
	export CCACHE_DIR=/var/tmp/nelchael-ccache
	[[ ! -d "${CCACHE_DIR}" ]] && {
		mkdir -p "${CCACHE_DIR}"
		chmod 700 "${CCACHE_DIR}"
	}
}

# Pretty man:
function man() {
	if [[ "${1}" = "-k" || "${1}" = "-K" ]]; then
		/usr/bin/man "${@}"
	else
		vim -R -c "Man $1 $2" -c "set nonu" -c "bdelete 1"
	fi
}

# whois:
function whois() { /usr/bin/whois -h whois.ripe.net "${@}"; }

# keychain handling:
function keychain() {
	if [[ -z "${1}" ]]; then
		export PORTDIR="${HOME}/gentoo/gentoo-x86"
		eval $(/usr/bin/keychain --quiet --eval --agents gpg,ssh id_dsa BC555551)
	else
		case "${1}" in
			--stop|-s|stop)
				/usr/bin/keychain --quiet --stop all
			;;
			*)
				/usr/bin/keychain ${@}
			;;
		esac
	fi
}

bind -x '"\C-\M-R": /usr/bin/reset'

function mvnsrc() {
	mvn -Dmaven.test.skip -DdownloadSources=true eclipse:eclipse
}

[[ -e ~/.bashrc-site ]] && source ~/.bashrc-site
