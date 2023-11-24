#!/usr/bin/env bash

APPLY_FILES="bashrc gitconfig ripgreprc vimrc"

for i in ${APPLY_FILES}; do
	[[ -z "$(diff -Nu "${i}" "${HOME}/.${i}")" ]] && continue

	diff --color=auto -Nu "${HOME}/.${i}" "${i}"
	\cp -f "${i}" "${HOME}/.${i}"
done
