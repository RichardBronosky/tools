#!/bin/bash

# Make script crontab friendly:
#cd $(dirname $0)

usage(){
	echo "
Usage:
	$(basename $0) [-o outfile] mysql_dump.gz mysql_dump.gz [mysql_dump.gz ...]

Summary:
	Compares (in the order received) the list of mysql_dump files given, and
simplifies them into compressed tar file.  The tar file consists of the first
file and a series of diff files that can be used to patch the first files into
the state of each subsequent file in the list.

Note:
   It is possible for one of the diffs to be larger than the sql file.
   Detecting this would be a good feature enhancement.

Acknowledgments:
	Copyright 2007 by Richard Bronosky.
   Offered under the terms of the GPL Version 2.
"
exit $1;
}

[ -z "$*" ] && usage

while getopts ":o:" opt; do
	case $opt in
		o  ) OUT=$OPTARG
		     shift 2 ;;
		\? ) usage 1 ;;
	esac
done

[ -z "$OUT" ] && OUT="$PWD/$(basename ${0%%.*}).tar.gz"

TMP="$(mktemp -d -t $(basename ${0%%.*}).XXXX)"
echo "Working dir: $TMP"

echo "Compacting..."
filelist=""
for current in "$@";
do
	if [ -n "$previous" ]; then
		echo "Comparing $previous to $current..."
		filename="$(basename $current .gz).diff"
		zdiff $previous $current > $TMP/$filename
		filelist="$filelist $filename"
	else
		echo "Using $current as the base of diffs."
		filename="$(basename $current)"
		first="$TMP/$filename"
		cp "$current" "$first"
		filelist="$filelist ${filename%%.gz}"
	fi
	previous="$current";
done

gunzip "$first"
echo "Compressing $OUT..."
tar czvf "$OUT" -C "$TMP" $filelist
rm -rf "$TMP"
