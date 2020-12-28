#!/bin/bash

# From: https://superuser.com/questions/365452/how-to-write-awk-here-document/440059#440059
# See:  http://tldp.org/LDP/abs/html/process-sub.html

# The <( begins a process substitution. It's valid to use with -f because what gets
# substituted is a file descriptor like /dev/fd/5
# The quoting on '_EOF_' prevents the shell from expanding the contents of the heredoc,
# as if it were a big double quoted string. So, your $2, $3, etc. are safe.
gawk -f <(cat - <<-'_EOF_'
    BEGIN{
        printf("%s:%s:%s:%s:%s:%s:%s\n", "index", "total", "used", "free", "cached", "buffers", "cache")
    }

    /^#/{
        gsub("#", "")
        printf("%d:", $0+1)
    }

    /^M/{
        printf("%d:%d:%d:%d:", $2,$3,$4,$7)
    }

    /^-/{
        printf("%d:%d\n", $3, $4)
    }
_EOF_
) realmap.log | column -ts: > realmap.csv

gnuplot <<-_EOF_
    set term png
    set out 'realmap.png'
    set xlabel 'index'
    set ylabel 'bytes'
    set style data lp
    plot 'realmap.csv' u 1:2 t col, '' u 1:3 t col, '' u 1:4 t col, '' u 1:5 t col, '' u 1:6 t col, '' u 1:7 t col
_EOF_

rm realmap.csv

display realmap.png

