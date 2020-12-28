#!/bin/bash

_confirm(){
    local prompt="${2:-Continue?}"
    if [[ ${1:-} == [yY] ]]; then
        [[ "$(read -re -p "$prompt [n/Y]> "; echo "$REPLY")" =~ ^$|^[.\ ]*[yY].* ]]
    else
        [[ "$(read -re -p "$prompt [y/N]> "; echo "$REPLY")" =~    ^[.\ ]*[yY]([eE][sS])?$ ]]
    fi
}

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
            #prompt="${command[*]}"$'\n'"$prompt"
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

_confirm && echo "You got it" || echo "Nevermind"
_confirm y "Go?" && echo "You got it" || echo "Nevermind"
_confirm_ && echo "You got it" || echo "Nevermind"
_confirm_ -y -p "Go?" && echo "You got it" || echo "Nevermind"

echo
_confirm_ -c date +%s
echo
_confirm_ -y -c date +%s
echo
_confirm_ -p "Run?" -y -c date +%s
echo
_confirm_ -p $'Next command:\n'$'%s\n''Are you sure?' -y -c date +%s
