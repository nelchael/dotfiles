#!/bin/bash

for i in *; do
	[[ "${i}" == "apply.sh" ]] && continue
	colordiff -u "${HOME}/.${i}" "${i}"
	cp -fv "${i}" "${HOME}/.${i}"
done
