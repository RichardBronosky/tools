# sample output can be found at http://gist.github.com/550332#file_bash.log.sh.log
LOGFILE=/tmp/${0##*/}.log

# a general purpose logging function that is used as prefix similar to time see: man time
log(){
    if [[ $1 == '-s' ]];then
        shift
        echo -e "$*" >> $LOGFILE
        return 0
    fi
    echo -e "\n###########################################\n" >> $LOGFILE
    cmd="$*"
    if [[ ! -t 0 ]]; then
        {
            echo "$cmd << FROM_STDIN" >> $LOGFILE
            eval $cmd << EOF
$(cat /dev/stdin | tee -a $LOGFILE; echo "FROM_STDIN" >> $LOGFILE)
EOF
        } 2>&1 | tee -a $LOGFILE
    else
        echo $cmd >> $LOGFILE
        {
            eval "$cmd";
        } 2>&1 | tee -a $LOGFILE
    fi
}

# a function for demoing
my_func(){
    echo $* to standard out > /dev/stdout
    echo to standard error > /dev/stderr
}

# truncate the file
echo -n >$LOGFILE

# log a string
log -s "starting a\nnew log..."

# log a simple command
log date

# log a complex command (`du` prefixed with `time` prefixed with `log`) that will [likely] encounter permissions errors
log time du -sh /etc/

# log a function call with arguments
log my_func alfa bravo charlie

# log a pipe
cat /etc/hosts | log wc

# log a redirect
log wc < /etc/hosts

# log a heredoc
log wc << EOF
Acknowledgments:
    Copyright (c) 2010 Richard Bronosky
    Offered under the terms of the MIT License.
    http://www.opensource.org/licenses/mit-license.php
    Created while employed by CMGdigital
EOF

# show the result
echo -e "\n\n########## LOG CONTENTS ##########\n"
cat $LOGFILE
