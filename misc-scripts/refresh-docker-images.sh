#!/usr/bin/env bash

for img in $(docker image ls --format=json | jq -r '.Repository + ":" + .Tag' | tr -d '\r' | sort --version-sort); do
    [[ "${img}" = *":<none>" ]] && continue
    repo_digest="$(docker image inspect "${img}" | jq -r '.[].RepoDigests[0]')"
    if [[ "${repo_digest}" != "null" ]]; then
        echo -e " \e[92m>>>\e[0m Pulling \e[94m${img}\e[0m"
        docker image pull "${img}"
    else
        echo -e " \e[91m>>>\e[0m Skipping \e[94m${img}\e[0m - no repository digest"
    fi
done
