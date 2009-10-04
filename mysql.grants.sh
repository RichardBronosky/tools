## Synopsis: mygrants [--options-passed-to-mysql] ...
## Description: Returns grants for all users, each separated by a comment. (Ideal for grepping.)
mygrants()
{
    mysql -BN $@ -e "SELECT DISTINCT CONCAT('SHOW GRANTS FOR ''',user,'''@''',host,''';') AS query FROM mysql.user" | \
    mysql $@ | \
    sed 's/\(GRANT .*\)/\1;/;s/^\(Grants for .*\)/## \1 ##/;/##/{x;p;x;}'
}

[[ $0 == $SHELL ]] || mygrants $@
