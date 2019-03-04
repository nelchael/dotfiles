#!/bin/bash

APPLY_FILES="bashrc dir_colors gitconfig inputrc screenrc vimrc"
APPLY_DIRECTORIES="vim-autoload:.vim/autoload vim-colors:.vim/colors vim-plugin:.vim/plugin vim-syntax:.vim/syntax"

__DIFF="$(type -P colordiff)"
[[ -z "${__DIFF}" ]] && __DIFF="diff"

for i in ${APPLY_FILES}; do
	[[ -z "$(diff -Nu "${i}" "${HOME}/.${i}")" ]] && continue

	"${__DIFF}" -Nu "${HOME}/.${i}" "${i}"
	\cp -f "${i}" "${HOME}/.${i}"
done

echo "${APPLY_DIRECTORIES} " | while IFS=":" read -d " " -s src_dir dest_dir; do
	[[ -z "${src_dir}" || -z "${dest_dir}" ]] && continue
	dest_dir="${HOME}/${dest_dir}"
	[[ -z "$(diff -Nru "${src_dir}" "${dest_dir}")" ]] && continue

	"${__DIFF}" -Nru "${src_dir}" "${dest_dir}"
	rm -rf "${dest_dir}"
	mkdir -p "${dest_dir}"
	\cp -fRv "${src_dir}"/* "${dest_dir}/"
done
