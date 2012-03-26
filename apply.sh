#!/bin/bash

APPLY_FILES="bashrc hgignore hgrc screenrc vimrc"

for i in ${APPLY_FILES}; do
	colordiff -u "${HOME}/.${i}" "${i}"
	cp -fv "${i}" "${HOME}/.${i}"
done
