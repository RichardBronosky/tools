_lines_to_array(){
    local array_name="$1"
    local line
    while IFS='' read -r line; do
        $array_name+=("$line");
    done
    #done < <("${command[@]}")
}

b(){
    # If b is defined in the parent scope, you don't want to clobber it.
    local array=("$@");
    array[13]="spooky";
    echo "count: ${#array[@]}";
    echo "values: ${array[@]}";
    echo "indexes: ${!array[@]}";

    # Remember the proper way to store the values of an array into a new array is to use parenthesis. Otherwise, you get a string.
    # Since we know that arrays have integer indices, we don't have to double quote it.
    i=(${!array[@]});

    # Although it will usually just work, it's safer to zero out a loop counter variable before using it.
    local c=0;
    echo -e "\nThe proper way to iterate an array is with this syntax... "'"${array[@]}"'
    for n in "${array[@]}" ;
        do echo "$((c+1)). ${i[$((c++))]} is $n"; done

    echo -e "\nIf you forget to quote it... "'${array[@]}'
    # This is one of those cases where not zeroing out the counter would mess things up.
    c=0;
    for n in ${array[@]} ;
        do echo "$((c+1)). ${i[$((c++))]} is $n"; done

    echo -e "\nIf you use * instead of @ (unquoted) your get the same thing... "'${array[*]}'
    c=0;
    for n in ${array[*]} ;
        do echo "$((c+1)). ${i[$((c++))]} is $n"; done

    echo -e "\nIf you do quote it you get 1 string (aka: word, see man bash)... "'"${array[*]}"'
    c=0;
    for n in "${array[*]}" ;
        do echo "$((c+1)). ${i[$((c++))]} is $n"; done
}

b 2 4 "This is a test." 6 8
