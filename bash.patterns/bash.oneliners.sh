# Keep these generic and SAFE!
# Anyone should be safe to run these anywhere anytime to see what the pattern does.

# mimic basename
echo ${HOME##*/}

# mimic dirname
echo ${HOME%/*}

# convert a relative path to absolute (this one works for files or dirs as long as the path exits)
cd /usr/local/share/man/; relative=../../bin/git; ll -d $relative; # the setup
absolute=$(cd $(dirname $relative); echo -n $(pwd)/$(basename $relative));
echo $absolute; ll -d $absolute # the proof

# ...this one uses string replacement and doesn't require the path to exist.
absolute=$(echo $(pwd)/$(echo $relative | sed 's,//,/,g;s,^\./,,')|sed 's,.*//,/,'); echo $absolute; while echo $absolute | grep -q '[^/]\+/\.\./'; do absolute=$(echo $absolute | awk '{if(sub("[^/]+/\\.\\./","")){print}else{exit 1}}'); done; echo $absolute

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
