#!/usr/bin/env bash

APPLY_FILES="bashrc gitconfig inputrc ripgreprc vimrc"
DEPRECATED_FILES="dir_colors screenrc"

for i in ${APPLY_FILES}; do
    [[ -z "$(diff -Nu "${i}" "${HOME}/.${i}")" ]] && continue

    diff --color=auto -Nu "${HOME}/.${i}" "${i}"
    \cp -f "${i}" "${HOME}/.${i}"
done

for i in ${DEPRECATED_FILES}; do
    [[ -e "${HOME}/.${i}" ]] && { echo " >>> Warning: ~/.${i} exists"; }
done

true
