#!/usr/bin/env bash

APPLY_FILES="bashrc dir_colors gitconfig inputrc screenrc vimrc"

for i in ${APPLY_FILES}; do
	[[ -z "$(diff -Nu "${i}" "${HOME}/.${i}")" ]] && continue

	diff --color=auto -Nu "${HOME}/.${i}" "${i}"
	\cp -f "${i}" "${HOME}/.${i}"
done
