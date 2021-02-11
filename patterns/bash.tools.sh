#!/usr/bin/env bash
# NOTE: "set -eu" is called in _entrypoint function
# NOTE: "set -x"  is called in _entrypoint function if DEBUG_XTRACE == 1

[[ ${DEBUG_ENV:-} == 1 ]] && set | less

function usage(){
    cat << Usage

Most common usage is:
1. Update the function update_hosts
    * Each call to the host_alias function within is a request to "make lookups
      for arg1 return the same results as lookups for arg2."
2. Execute this script with a subcommand as arg1. The most common being "start"
    * Ex:
            ./util start

If the OS resolver gets mucked up, it will be restored on reboot. You can clear
the changes to the OS resolver and let the OS try to heal itself without a
reboot by running the clear_dns subcommand.
    * Ex:
            ./util clear_dns

Usage
}

###################################
## Non-Boilerplate Functionality ##
###################################

#######################################
## Non-Boilerplate Utility Functions ##
#######################################

##########################
##  Boilerplate Helpers ##
##########################

_confirm_(){
    local default_value=n
    local default_prompt="Continue?"
    local prompt="$default_prompt"

    OPTIND=1; while getopts "yp:c:" opt; do case "$opt" in
        y)  default_value=y ;;
        p)  prompt=$OPTARG ;;
        c)  command=("${@:$((OPTIND-1))}") ;;
        *)  echo "Unknown option: $opt"; exit1 ;;
    esac; done; shift $((OPTIND-1)); [ "${1:-}" = "--" ] && shift

    if [[ ${#command[@]} -gt 0 ]]; then
        if [[ $prompt == "$default_prompt" ]]; then
            prompt="Run command:"$'\n'"${command[*]}"$'\n'"?"
        else
            # shellcheck disable=SC2059
            prompt="$(printf "$prompt" "${command[*]}")"
        fi
    fi
    if [[ $default_value == y ]]; then
        [[ "$(read -re -p "$prompt [n/Y]> "; echo "$REPLY")" =~ ^$|^[.\ ]*[yY].* ]]
    else
        [[ "$(read -re -p "$prompt [y/N]> "; echo "$REPLY")" =~    ^[.\ ]*[yY]([eE][sS])?$ ]]
    fi 
    error_code=$?
    if [[ ${#command[@]} -gt 0 && $error_code == 0 ]]; then
        "${command[@]}"
    else
        return $error_code
    fi
}

_main(){
    (
        _path_to_this_script cd
        if [[ -z "${1:-}" ]]; then
            _func
        else
            cmd="$1"
            #[[ $cmd == kill ]] && cmd="kill_dnsmasq"
            shift
            $cmd "$@"
        fi
    )
}

_func(){
    declare -F | awk '$2=="-f" && $3~/^[^_]/{print $3}'
}

_join(){ # join stdin lines with arg1, optionally wrapped in arg2 and arg3
    if [[ -n "${2:-}" ]]; then printf "%s" "${2}"; fi
    awk -v d="${1:-}" '{s=( ((NR==1) ? s : (s d)) $0)}END{printf s}'
    if [[ -n "${3:-}" ]]; then printf "%s" "${3}"; elif [[ -n "${2:-}" ]]; then printf "%s" "${2}"; fi
}

_path_to_this_script(){
    local dir; dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
    if [[ ${1:-} == "cd" ]]; then
        cd "$dir"
    else
        echo "$dir/$(basename "${BASH_SOURCE[0]}")"
    fi
}

_entrypoint_for_symlinks(){
    local symlinks=( example1 example2)
    for symlink in "${symlinks[@]}"; do
        if [[ "$(basename "${BASH_SOURCE[0]}")" == "$symlink" ]]; then
            # shellcheck disable=SC2034
            path_to_this_script="$(_path_to_this_script)"
            $symlink "$@"
            exit 0
        fi
    done
}

_entrypoint(){
    set -eu
    [[ ${DEBUG_XTRACE:-} == 1 ]] && set -x
    if [[ $0 == "${BASH_SOURCE[0]}" ]]; then _main "$@"; else _entrypoint_for_symlinks "$@"; fi
}

################
## Always run ##
################

# shellcheck disable=SC2034
git_url_base="https://github.com/richardbronosky"

_entrypoint "$@"
