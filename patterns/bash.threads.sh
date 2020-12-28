#!/bin/bash

read -sn 1 -p "Run threaded? [y/N] " threaded; echo
tempdir=$(mktemp -d -t ${0##*/}.XXXXXX)
slowurl="http://drupal.org/project/issues/statistics/drupal"

io()
{
    while [[ $((++n)) -lt 5 ]];
    do
        if [[ $threaded =~ [yY] ]];
        then
            echo "thread $n"
            curl -s $slowurl?$n > $tempdir/$n &
        else
            echo "loop $n"
            curl -s $slowurl?$n > $tempdir/$n
        fi
    done;
    if [[ $threaded =~ [yY] ]];
    then
        echo -n "waiting for threads to complete... "
        wait
        echo "done."
    fi
}
time io
read -sn 1 -p "See HTML? [y/N] " see; echo
[[ $see =~ [yY] ]] && cat $tempdir/*
rm -rf $tempdir
