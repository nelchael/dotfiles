#!/usr/bin/env bash

SED="$(which sed)"
"${SED}" --version &> /dev/null || SED="$(which gsed)"
"${SED}" --version &> /dev/null || {
	echo "Failed to find working GNU sed"
	exit 1
}

for img in $(docker image ls | "${SED}" 1d | sort | awk '{ print $1 ":" $2 }'); do
	[[ "${img}" = *":<none>" ]] && continue
	repo_digest="$(docker inspect "${img}" | jq -r '.[].RepoDigests[0]')"
	if [[ "${repo_digest}" != "null" ]]; then
		docker image pull -q "${img}"
	else
		echo "Skipping ${img} - no repository digest"
	fi
done
