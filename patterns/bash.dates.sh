#!/bin/bash -eu

_has_date_flag(){
    date --help 2>/dev/null | grep -q -- --date
}

examples=(
"date +%s"
"date '+%Y%m%d%H%M%S'"
"date '+%Y-%m-%d_%H:%M:%S'"
"date '+%Y-%m-%d_%H.%M.%S'"
"date -u '+%Y-%m-%dT%H:%M:%SZ' # UTC and ISO 8601"
"date +%F"
"date -r 1594974441"
)

if _has_date_flag; then
    # GNU date
    examples+=("date --date '-2 weeks +2 days'")
else
    # BSD date
    examples+=("date -v '-2w' -v '+2d'")
fi

for cmd in "${examples[@]}"; do
    echo -e "\n""$cmd"
    eval "$cmd"
done

# vim: set ts=2 sts=2 sw=2 et:
