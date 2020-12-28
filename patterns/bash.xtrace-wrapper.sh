#!/bin/bash

# NOT PERFECT
# from: https://stackoverflow.com/a/32258062/117471

function xtrace() {
  # Print the line as if xtrace was turned on, using perl to filter out
  # the extra colon character and the following "set +x" line.
  (
    set -x
    # Colon is a no-op in bash, so nothing will execute.
    : "$@"
  ) #2>&1 | perl -ne 's/^[+] :/+/ and print' 1>&2
  # Execute the original line unmolested
  "$@"
}

# Example
for value in $(date); do
  computed_value=$(echo "$value" | sed 's/\(:..\):/\1 /')
  xtrace echo "$computed_value"
done

