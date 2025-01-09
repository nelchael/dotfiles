#!/usr/bin/env bash

options="$(getopt -o ogbpv -- "${@}")"
if [[ "${?}" -ne 0 ]]; then
    exit 1
fi
eval set -- "${options}"
while :; do
    case "${1}" in
        -o)
            declare -r option_offline=yes
            ;;
        -g)
            declare -r option_run_gc_prune_all=yes
            ;;
        -b)
            declare -r option_hide_branches=yes
            ;;
        -p)
            declare -r option_purge_branches=yes
            ;;
        -v)
            declare -r option_verbose=yes
            ;;
        --)
            shift
            break
            ;;
        *)
            die "Unexpected argument: ${1}"
            ;;
    esac
    shift
done
unset options

SED="$(which sed)"
"${SED}" --version &> /dev/null || SED="$(which gsed)"
"${SED}" --version &> /dev/null || {
    echo "Failed to find working GNU sed"
    exit 1
}

GIT_OPTIONS="-c core.useBuiltinFSMonitor=false -c core.fsmonitor=false"

declare -a spawned_background_procs=()
for directory in *; do
    [[ -f "${directory}" ]] && continue
    [[ -d "${directory}/.git" ]] || {
        [[ "${option_verbose}" == "yes" ]] && echo -e " \e[1;93m❯\e[0m \e[1m${directory}\e[0m \e[2;31mno .git directory\e[0m"
        continue;
    }

    [[ -f "${directory}/.git/sync-all-skip" ]] && {
        [[ "${option_verbose}" == "yes" ]] && echo -e " \e[1;93m❯\e[0m \e[1m${directory}\e[0m \e[2;31mskipped\e[0m"
        continue;
    }

    if [[ "${option_hide_branches}" != "yes" ]]; then
        branch_info="$(git ${GIT_OPTIONS} -C "${directory}" branch --show-current)"
        if [[ "${branch_info}" = "main" ]]; then
            branch_info=""  # On default "main" branch
        elif [[ "${branch_info}" = "master" ]]; then
            branch_info=" \e[91m${branch_info}\e[0m"
        elif [[ "${branch_info}" = "$(git ${GIT_OPTIONS} -C "${directory}" branch --remotes --list '*/HEAD' | awk -F / '{print $NF}')" ]]; then
            branch_info=""  # On default branch
        else
            branch_info=" \e[92m${branch_info}\e[0m"
        fi
        [[ "${option_offline}" = "yes" ]] || {
            ahead="$(git ${GIT_OPTIONS} -C "${directory}" rev-list @{upstream}..HEAD --count 2> /dev/null)"
            behind="$(git ${GIT_OPTIONS} -C "${directory}" rev-list HEAD..@{upstream} --count 2> /dev/null)"
            [[ "${ahead}" != "" && "${ahead}" != "0" ]] && branch_info="${branch_info}\e[96m+${ahead}\e[0m"
            [[ "${behind}" != "" && "${behind}" != "0" ]] && branch_info="${branch_info}\e[96m-${behind}\e[0m"
        }
    fi
    repo_status=""
    [[ -n "$(git ${GIT_OPTIONS} -C "${directory}" status --porcelain=1 --untracked-files=no)" ]] && { repo_status="\e[30;43m(dirty)\e[0m "; }
    [[ -n "$(git ${GIT_OPTIONS} -C "${directory}" stash list)" ]] && { repo_status="${repo_status}\e[94m(stashed)\e[0m "; }
    echo -e " \e[1;93m❯\e[0m \e[1m${directory}\e[0m${branch_info} ${repo_status}\e[2m$(git ${GIT_OPTIONS} -C "${directory}" remote get-url origin 2> /dev/null || echo 'no remote origin')\e[0m"

    if [[ "${option_offline}" != "yes" && -n "$(git ${GIT_OPTIONS} -C "${directory}" remote show)" ]]; then
        (git ${GIT_OPTIONS} -C "${directory}" pull --rebase --no-stat || git ${GIT_OPTIONS} -C "${directory}" status) 2>&1 | "${SED}" -re "/^Current branch .+ is up to date/d; /^Already up to date./d; /^Fetching submodule/d; ${SYNC_ALL_EXTRA_SED};"


        [[ "${option_purge_branches}" = "yes" ]] && {
            echo -ne "\e[31m"
            git ${GIT_OPTIONS} -C "${directory}" purge-branches
            echo -ne "\e[0m"
        }
    fi

    gc_opt="auto"
    [[ "${option_run_gc_prune_all}" = "yes" ]] && gc_opt="prune=all"
    git ${GIT_OPTIONS} -C "${directory}" gc --${gc_opt} --quiet &
    spawned_background_procs+=(${!})
    if [[ -f "${directory}/.gitmodules" ]]; then
        git ${GIT_OPTIONS} -C "${directory}" submodule --quiet foreach "git ${GIT_OPTIONS} gc --${gc_opt} --quiet" &
        spawned_background_procs+=(${!})
    fi
done

while [[ "${#spawned_background_procs[@]}" -gt 0 ]]; do
    echo -ne "\r \e[1;93m❯\e[0m \e[2mWaiting for background GCs -- ${#spawned_background_procs[@]} remaining…\e[0m\e[K"
    wait -n -p completed_pid "${spawned_background_procs[@]}"
    for index in "${!spawned_background_procs[@]}"; do
        if [[ "${spawned_background_procs[${index}]}" == "${completed_pid}" ]]; then
            unset spawned_background_procs[${index}]
            break
        fi
    done
done
echo -ne "\r\e[K\r"
