#!/bin/bash

for i in *; do
	[[ "${i}" == "apply.sh" ]] && continue
	cp -fv "${i}" "${HOME}/.${i}"
done
