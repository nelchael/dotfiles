#!/usr/bin/env bash

options="$(getopt -o opbfv -- "${@}")"
if [[ "${?}" -ne 0 ]]; then
	exit 1
fi
eval set -- "${options}"
while :; do
	case "${1}" in
		-o)
			declare -r option_offline=yes
			;;
		-p)
			declare -r option_force_gcp=yes
			;;
		-b)
			declare -r option_hide_branches=yes
			;;
		-f)
			declare -r option_force_purge=yes
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

GIT_OPTIONS="-c core.useBuiltinFSMonitor=false"

for directory in *; do
	[[ -d "${directory}/.git" ]] || {
		[[ "${option_verbose}" = "yes" ]] && echo -e " \e[1;91m❯\e[0m \e[1m${directory}\e[0m - \e[31mskipped\e[0m";
		continue;
	}

	if [[ "${option_hide_branches}" != "yes" ]]; then
		branch_info="$(git ${GIT_OPTIONS} -C "${directory}" branch --show-current)"
		if [[ "${branch_info}" = "main" ]]; then
			branch_info=""
		elif [[ "${branch_info}" = "master" ]]; then
			branch_info="\e[2m@\e[0m\e[91m${branch_info}\e[0m"
		else
			branch_info="\e[2m@\e[0m\e[92m${branch_info}\e[0m"
		fi
		ahead="$(git ${GIT_OPTIONS} -C "${directory}" rev-list @{upstream}..HEAD --count 2> /dev/null)"
		behind="$(git ${GIT_OPTIONS} -C "${directory}" rev-list HEAD..@{upstream} --count 2> /dev/null)"
		[[ "${ahead}" != "" && "${ahead}" != "0" ]] && branch_info="${branch_info}\e[96m+${ahead}\e[0m"
		[[ "${behind}" != "" && "${behind}" != "0" ]] && branch_info="${branch_info}\e[96m-${behind}\e[0m"
	fi
	echo -e " \e[1;93m❯\e[0m \e[1m${directory}\e[0m${branch_info} \e[2m$(git ${GIT_OPTIONS} -C "${directory}" remote get-url origin 2> /dev/null || echo 'no remote origin')\e[0m"

	if [[ -n "$(git ${GIT_OPTIONS} -C "${directory}" remote show)" ]]; then
		[[ "${option_offline}" = "yes" ]] || {
			(git ${GIT_OPTIONS} -C "${directory}" pull --rebase || git ${GIT_OPTIONS} -C "${directory}" status) 2>&1 | "${SED}" -re "/^Current branch .+ is up to date/d; /^Already up to date./d; /^Fetching submodule/d; ${SYNC_ALL_EXTRA_SED};"

			echo -ne "\e[31m"
			git ${GIT_OPTIONS} -C "${directory}" branches | grep '\[gone\]'
			echo -ne "\e[0m"
		}

		[[ "${option_force_purge}" = "yes" ]] && {
			git ${GIT_OPTIONS} -C "${directory}" purge-branches
		}
	else
		[[ "${option_verbose}" = "yes" ]] && echo -e " \e[1;91m❯\e[0m \e[1m${directory}\e[0m - \e[31mno remotes, skippied pull\e[0m";
	fi

	if [[ "${option_force_gcp}" = "yes" ]]; then
		git ${GIT_OPTIONS} -C "${directory}" gc --prune=all --quiet
		git ${GIT_OPTIONS} -C "${directory}" submodule --quiet foreach 'git ${GIT_OPTIONS} gc --prune=all --quiet'
	else
		git ${GIT_OPTIONS} -C "${directory}" gc --auto --quiet
		git ${GIT_OPTIONS} -C "${directory}" submodule --quiet foreach 'git ${GIT_OPTIONS} gc --auto --quiet'
	fi
done
