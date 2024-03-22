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
        echo -e " \e[92m>>>\e[0m Pulling \e[94m${img}\e[0m"
        docker image pull "${img}"
    else
        echo -e " \e[91m>>>\e[0m Skipping \e[94m${img}\e[0m - no repository digest"
    fi
done
