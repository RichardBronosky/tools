#!/usr/bin/env sh

if [ $# -eq 0 ] || [ "-h" = "$1" ] || [ "--help" = "$1" ]; then
    echo "Usage: $0 tarfile.tgz org_file [org_file ...]"
    exit
fi

t=$(mktemp)
o=$(mktemp)
tar ztvf $1|awk '{print $6,$3}'|sort>$t
shift
ls -la $@|awk '{print $9,$5}'|sort>$o
if diff $o $t; then
    echo;echo 'All' $(wc -l $o|awk '{print $1}') 'filenames and sizes match.';echo
else
    echo;echo 'Failed comparing filenames and sizes of originals ('$o') and tar contents ('$t').';echo
fi
