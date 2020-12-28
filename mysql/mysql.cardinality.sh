## Synopsis: mycardinality [--options-passed-to-mysql] ... database_name table_name
## Description: Returns 3 columns ideal for 'sort -n': cardinality decimal, cardinality ratio, column
## NOTE: This is much more expensive on InnoDB than on MyISAM.
## TODO: Currently every column is examined in its own connection. That should be corrected.
mycardinality(){
    unset a;
    while [[ $# -gt 2 ]];
    do
        a=("${a[@]}" "$1");
        shift;
    done;

    schema=$1;
    table=$2;
    shift 2;

    for column in $(mysql -BN $@ -e "select column_name from information_schema.columns where table_schema='$schema' and table_name='$table';");
    do
        mysql -BN $@ -e "
            select @c1:=count(distinct \`$column\`) from \`$schema\`.\`$table\`;
            select @c2:=count(0) from \`$schema\`.\`$table\`;
            select @c1/@c2, concat(@c1, ':', @c2);
        " | \
        awk -v "col=$schema.$table.$column" 'NR==3{printf "%16s %12s    %s\n", $1, $2, col}';
    done
}

[[ $0 == $SHELL ]] || mycardinality $@
