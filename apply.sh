#!/bin/bash

APPLY_FILES="bashrc dir_colors hgignore hgrc inputrc screenrc vimrc"

__DIFF="$(type -P colordiff)"
[[ -z "${__DIFF}" ]] && __DIFF="diff"

for i in ${APPLY_FILES}; do
	"${__DIFF}" -u "${HOME}/.${i}" "${i}"
	cp -fv "${i}" "${HOME}/.${i}"
done
