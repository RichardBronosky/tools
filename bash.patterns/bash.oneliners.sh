# mimic basename
echo ${HOME##*/}

# mimic dirname
echo ${HOME%/*}

# prompt for a bool/char
read -sn 1 -p "Continue? [Y/n] " response; echo

# prompt for a string/int
read -p "username: " user;

# Timestamp for a file name
date +%s

# a readable one
date +%Y%m%d%H%M%S

# DiG format as a clean single line for batch processing
dig +nocmd www.bronosky.com +noall +answer
