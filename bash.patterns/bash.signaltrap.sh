#!/usr/bin/env bash

trap "stty echo; echo -e '\ncaught INT';  exit" INT  # Ctrl-C
trap "stty echo; echo -e '\ncaught TERM'; exit" TERM # kill -15 (default for kill)
trap "stty echo; echo -e '\ncaught EXIT'; exit" EXIT # all forms of exit (except kill -9)

echo "You say?";
read 
echo You said, $REPLY;
read -sn 1 -p "Press any key to continue...";
