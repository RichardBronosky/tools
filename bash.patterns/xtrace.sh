#!/bin/bash -eu

xtrace(){
    PS4_fields=(
        '\n'
        '#'
        '(xtrace)'
        '$''(basename "$''{BASH_SOURCE}")'
        'Line: $''{LINENO}'
        '$''([[ -n $''{FUNCNAME[0]:-} ]] && echo "in function: $''{FUNCNAME[0]}()")'
        '\n'
    )
    export PS4="${PS4_fields[*]}"
    set -o xtrace
}

main(){
    date
}

xtrace
main
