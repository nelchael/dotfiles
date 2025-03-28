# vim: set ft=bash
# profile:
[[ -f /etc/profile ]] && source /etc/profile

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

# Set a variable with the system name:
export __OS="$(uname -o)"

# Remove existing aliases:
unalias -a

# Early setup:
if [[ -e ~/.bashrc-early ]]; then source ~/.bashrc-early; fi

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
alias j='jobs'
alias mv='mv -iv'
alias rm='rm -iv'
alias s='cd ..'
alias rsync='rsync --progress --human-readable'
alias diff='diff --color=auto'

# MacOS specific tweaks:

if [[ "${__OS}" == "Darwin" ]]; then
    if type -P gls &> /dev/null; then
        alias l='gls -sh --color=yes'
        alias ls='gls -sh --color=yes'
        alias sl='gls -sh --color=yes'
        alias la='gls -ash --color=yes'
        alias ll='gls -lsh --color=yes'
        alias lla='gls -lash --color=yes'
        alias lss='gls -shS --color=yes'
        alias lls='gls -lshS --color=yes'
    fi

    if type -P grm &> /dev/null; then
        alias rm='grm -iv'
    fi

    if type -P gdircolors &> /dev/null; then
        alias dircolors=gdircolors
    fi
fi

# Enable color for grep and set up ripgrep configuration:
export GREP_COLORS="mt=36:sl=:cx=:fn=35:ln=32:bn=32:se=35"
alias grep='grep --color=auto'
export RIPGREP_CONFIG_PATH="${HOME}/.ripgreprc"

# `ls' colors:
if type -t dircolors &> /dev/null; then
    eval "$(dircolors -b)"
    for ext in conf diff html ini json log md patch properties toml txt xml xsl yaml yml; do
        export LS_COLORS="${LS_COLORS}*.${ext}=00;33:"
    done
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

# Add ~/.local/bin, ~/.bin to PATH:
export PATH="${HOME}/.local/bin:${HOME}/bin:${PATH}"

# Nice less behavior:
export LESS="-R -M -x4 -F"
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
export XMLLINT_INDENT="  "

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

function _bashrc_terminal_title() { echo -ne "\033]0;${USER:-${USERNAME:-???}}@${HOSTNAME%%.*}:${PWD/${HOME}/\~}\007"; }
starship_precmd_user_func=_bashrc_terminal_title

# HSTR settings (https://github.com/dvorka/hstr):
if type -P hstr &> /dev/null; then
    export HSTR_CONFIG=hicolor,warning,raw-history-view,keywords-matching,case-sensitive,prompt-bottom
    export HSTR_PROMPT='> '
    bind '"\C-r": "\C-ahstr -- \C-j"'
    function _bashrc_hrc_enabled() {
        _bashrc_terminal_title
        history -a
        history -n
    }
    starship_precmd_user_func=_bashrc_hrc_enabled
fi

eval "$(starship init bash)"
eval "$(starship completions bash)"

if type -P aws &> /dev/null; then
    complete -C "$(which aws_completer)" aws
fi
if type -P code &> /dev/null; then
    export KUBE_EDITOR="$(which code) --wait"
fi
export KUBECTL_EXTERNAL_DIFF="diff -Nu --color=auto"
export HELM_DIFF_COLOR="true"

# Windows MSYS Git bash tweaks:
if [[ "${__OS}" = "Msys" ]]; then
    unset PAGER
    alias gvim='start gvim'
fi

# Late setup (a.k.a. fix-ups):
if [[ -e ~/.bashrc-late ]]; then source ~/.bashrc-late; fi
