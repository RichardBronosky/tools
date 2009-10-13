decho()
{
    local arr array_name l k s
    if [[ $1 == '-s' ]]; then
        array_name=$2;
        arr=("${@:3}");
    else
        array_name=$1;
        eval "arr=(\"\${$array_name[@]}\")";
        for k in ${!arr[@]}; do [[ ${arr[$k]} == $2 ]] && arr[$k]=$(for ((l=$(echo -n "${arr[$k]}" | wc -c); $l; l--)); do echo -n ' '; done;); done
        for ((l=$(echo -n "${arr[@]}" | wc -c); $l; l--)); do echo -ne ""; done;
    fi

    unset $array_name s
    for k in ${!arr[@]}; do echo -n "$s${arr[$k]}"; s=' '; eval "$array_name[$k]=\"\${arr[\$k]}\""; done

}

decho -s holder one two three four five six seven eight nine ten
sleep 1; decho holder one
sleep 1; decho holder three
sleep 1; decho holder five
sleep 1; decho holder seven
sleep 1; decho holder nine
sleep 1; decho holder two
sleep 1; decho holder four
sleep 1; decho holder six
sleep 1; decho holder eight
sleep 1; decho holder ten;
echo
