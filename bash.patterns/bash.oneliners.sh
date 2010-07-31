# mimic basename
echo ${HOME##*/}

# mimic dirname
echo ${HOME%/*}

# Timestamp for a file name
date +%s

# a readable one
date +%Y%m%d%H%M%S
