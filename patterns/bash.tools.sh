#!/usr/bin/env bash
# NOTE: "set -eu" is called in _entrypoint function
# NOTE: "set -x"  is called in _entrypoint function if DEBUG_XTRACE == 1

[[ ${DEBUG_ENV:-} == 1 ]] && set | less

function usage(){
    cat << Usage

Most common usage is:
    $0 usage # TODO: Change this Boilerplate

Other public functions:
$(_func | xargs -n 1 printf '%4s%s %s\n' ' ' "$0")

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

_join(){ # join stdin lines with arg1, optionally wrapped in arg2 and arg3
    if [[ -n "${2:-}" ]]; then printf "%s" "${2}"; fi
    awk -v d="${1:-}" '{s=( ((NR==1) ? s : (s d)) $0)}END{printf s}'
    if [[ -n "${3:-}" ]]; then printf "%s" "${3}"; elif [[ -n "${2:-}" ]]; then printf "%s" "${2}"; fi
}

_get_never_run_lines(){
    awk '/[#]+ Never run [#]+/{print_after=NR+1} print_after>0 && NR>print_after{print}' "$(_path_to_this_script)"
}

_path_to_this_script(){
    [[ -n ${__work_dir:-} ]] || __work_dir="$(pwd -P)"
    local dir; dir="$(cd $__work_dir; cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
    if [[ ${1:-} == "cd" ]]; then
        cd "$dir"
    else
        echo "$dir/$(basename "${BASH_SOURCE[0]}")"
    fi
}

_entrypoint_for_symlinks(){
    local symlinks=( example1 example2 )
    for symlink in "${symlinks[@]}"; do
        if [[ "$(basename "${BASH_SOURCE[0]}")" == "$symlink" ]]; then
            # shellcheck disable=SC2034
            path_to_this_script="$(_path_to_this_script)"
            $symlink "$@"
            exit 0
        fi
    done
}

_func(){
    declare -F | awk '$2=="-f" && $3~/^[^_]/{print $3}'
}

_main(){
    (
        _path_to_this_script cd
        if [[ -z "${1:-}" ]]; then
            usage
        else
            cmd="$1"
            #[[ $cmd == kill ]] && cmd="kill_dnsmasq"
            shift
            $cmd "$@"
        fi
    )
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

exit;

###############
## Never run ##
###############
uno
dos
tres
