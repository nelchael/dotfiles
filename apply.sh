#!/usr/bin/env bash

APPLY_FILES="bashrc gitconfig inputrc ripgreprc config_starship.toml vimrc"
DEPRECATED_FILES="dir_colors screenrc starship.toml"

for i in ${APPLY_FILES}; do
    target_name="${i//_/\/}"
    if [[ "${i}" == *_* ]]; then
        mkdir -p "$(dirname "${HOME}/.${target_name}")"
    fi
    [[ -z "$(diff -Nu "${i}" "${HOME}/.${target_name}")" ]] && continue

    diff --color=auto -Nu "${HOME}/.${target_name}" "${i}"
    \cp -f "${i}" "${HOME}/.${target_name}"
done

for i in ${DEPRECATED_FILES}; do
    [[ -e "${HOME}/.${i}" ]] && { echo " >>> Warning: ~/.${i} exists"; }
done

true
