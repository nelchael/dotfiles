#!/usr/bin/env bash

function ebegin() {
    echo -ne " \e[36m❯\e[0m ${@}…"
}

function eend() {
    if [[ "${1}" == "0" ]]; then
        echo -e " \e[32m✓\e[0m"
    else
        echo -e " \e[31m✕\e[0m ${2}"
    fi
}

function check_for_binary() {
    local -r binary_name="${1}"
    ebegin "Checking ${binary_name}"
    type -P "${binary_name}" &> /dev/null
    eend "${?}" "-- missing"
}

# Generic checks:
check_for_binary "vim"
check_for_binary "rg"
check_for_binary "starship"
check_for_binary "gdu"
check_for_binary "jq"
check_for_binary "yq"
check_for_binary "git-graph"

check_for_binary "code"

# Non-Windows checks:
if [[ "${__OS}" != "Msys" ]]; then
    check_for_binary "hstr"
fi

# macOS checks:
if [[ "${__OS}" == "Darwin" ]]; then
    check_for_binary "gls"
    check_for_binary "grm"
    check_for_binary "gdu-go"
fi
