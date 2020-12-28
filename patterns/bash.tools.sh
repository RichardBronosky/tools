#!/bin/bash -eu

_join(){
    awk -v d="${1:-}" '{s=(NR==1?s:s d)$0}END{print s}'
}

_func(){
    declare -F | awk '$2=="-f" && $3~/^[^_]/{print $3}'
}

_path_to_this_script(){
    (
        cd "$(dirname "${BASH_SOURCE[0]}")"
        echo -n "$PWD/"
        basename "${BASH_SOURCE[0]}"
    )
}

_main(){
    path_to_this_script="$(_path_to_this_script)"
    if [[ -z "${1:-}" ]]; then
        _func
    else
        "$@"
    fi
}

_entrypoint_for_symlink(){
    symlink=$1; shift
    if [[ $(basename "${BASH_SOURCE[0]}") == "$symlink" ]]; then
        path_to_this_script="$(_path_to_this_script)"
        "$symlink" "$@"
        exit 0
    fi
}

#set|less
_entrypoint_for_symlink page "$@"
[[ $0 == "${BASH_SOURCE[0]}" ]] && _main "$@"
