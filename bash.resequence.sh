#!/usr/bin/env bash

base=$1
shift

echo Naming $base...

i=0
until [ -z "$1" ]
do
    i=$[$i+1]
    mv $1 ${base}${i}$(echo $1|sed 's/.*\(\.[^.]*\)$/\1/;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/')
    shift
done
