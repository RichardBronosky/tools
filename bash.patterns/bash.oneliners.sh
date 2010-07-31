# Keep these generic and SAFE!
# Anyone should be safe to run these anywhere anytime to see what the pattern does.

# mimic basename
echo ${HOME##*/}

# mimic dirname
echo ${HOME%/*}

# prompt for a bool/char
read -sn 1 -p "Continue? [Y/n] " response; echo

# prompt for a string/int
read -p "username: " user;

# capture pid of last command ($!; is a problem, needs a space)
sleep 1& PID=$! ; ps $PID

# create a pid file init script style
echo $! > ${0%.*}.pid

# do something for n seconds
c=0; sleep 1 & p=$! ; while true; do ps $p >/dev/null && echo $((c++)) || break; done

# Timestamp for a file name
date +%s

# a readable one
date +%Y%m%d%H%M%S

# DiG format as a clean single line for batch processing
dig +nocmd www.bronosky.com +noall +answer
