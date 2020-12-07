#!/usr/bin/env bash

options="$(getopt -o opbfvm -- "${@}")"
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
		-m)
			declare -r option_force_master=yes
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

for directory in *; do
	[[ -d "${directory}/.git" ]] || {
		[[ "${option_verbose}" = "yes" ]] && echo -e " \e[1;91m❯\e[0m \e[1m${directory}\e[0m - \e[31mskipped\e[0m";
		continue;
	}

	if [[ "${option_hide_branches}" != "yes" ]]; then
		branch_info="$(git -C "${directory}" branch --show-current)"
		if [[ "${branch_info}" = "master" || "${branch_info}" = "main" ]]; then
			branch_info=""
		else
			branch_info="\e[2m@\e[0m\e[92m${branch_info}\e[0m"
		fi
	fi
	echo -e " \e[1;93m❯\e[0m \e[1m${directory}\e[0m${branch_info} \e[2m$(git -C "${directory}" remote get-url origin 2> /dev/null || echo 'no remote origin')\e[0m"

	[[ "${option_force_master}" = "yes" ]] && {
		git -C "${directory}" checkout master --quiet
	}

	[[ "${option_offline}" = "yes" ]] || {
		git -C "${directory}" gc --auto --quiet
		git -C "${directory}" submodule --quiet foreach 'git gc --auto --quiet'
		(git -C "${directory}" pull --rebase || git -C "${directory}" status) 2>&1 | sed -re '/^Current branch .+ is up to date/d; /^Fetching submodule/d'

		echo -ne "\e[31m"
		git -C "${directory}" branches | grep '\[gone\]'
		echo -ne "\e[0m"
	}

	[[ "${option_force_gcp}" = "yes" ]] && {
		git -C "${directory}" gc --prune=all --quiet
		git -C "${directory}" submodule --quiet foreach 'git gc --prune=all --quiet'
	}

	[[ "${option_force_purge}" = "yes" ]] && {
		git -C "${directory}" purge-branches
	}
done
