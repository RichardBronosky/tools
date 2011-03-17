#!/usr/bin/env bash

# This is the only thing that is needed to setup
trap 'for c in "${do_on_exit[@]}"; do $c; done' EXIT

# This is one optional way to add to the stack. It is not manditory to initialize the array. If you doubt, comment out.
do_on_exit=("echo a. $0")
# NOTICE: This would replace an existing array, not add to it.

# This represents a function you may want to call in the exit stack.
echo0(){ echo b. $0; }
# This is the simplest way to add it. If you need to pass the function arguments, quote it like I do the regular echo commands below.
do_on_exit[${#do_on_exit[*]}]=echo0

# Finally a few of the most common use cases.
do_on_exit[${#do_on_exit[*]}]='echo c. yes'

echo 'You could CTRL-C right now and a,b,c would still fire.'
read -n 1
do_on_exit[${#do_on_exit[*]}]='echo d. no'

