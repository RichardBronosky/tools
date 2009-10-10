#!/usr/bin/env bash

do_on_exit=('echo a. $0 ')

echo0(){ echo b. $0; }
do_on_exit[${#do_on_exit[*]}]=echo0
do_on_exit[${#do_on_exit[*]}]='echo c. yes'
do_on_exit[${#do_on_exit[*]}]='echo d. no'

trap 'for c in "${do_on_exit[@]}"; do $c; done' EXIT
