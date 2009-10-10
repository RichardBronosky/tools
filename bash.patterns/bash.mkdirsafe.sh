
## Exit on use of an uninitialized variable
set -o nounset
## Exit if any statement returns a non-true return value (non-zero).
set -o errexit

exit_stack_push(){
    exit_stack[${#exit_stack[*]}]=$*
}

exit_stack_pop(){
    unset exit_stack[$((${#exit_stack[*]}-1))]
}

do_exit_stack(){
    if [[ ${#exit_stack[*]} -gt 0 ]]; then
        for c in "${exit_stack[@]}"; do $c; done
    fi
}

## Every string in this array will be executed on exit.
exit_stack=();
trap do_exit_stack EXIT;


mkdirsafe() {
    if mkdir $1 2>/dev/null; then
        echo make passed;
        exit_stack_push "rm -rf $1";
    else
        echo make failed;
        stat -f ' ' $1/* 1>/dev/null 2>&1 || exit_stack_push "rm -rf $1";
    fi
}

mkdirsafe 2
touch 2/list
find . | tee 2/list
# mkdir -p 2;ls>2/fail;lla ./2/
# rm -rf 2;ll
