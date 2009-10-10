#!/usr/bin/env bash

# Monitor the stats of all of our web servers like so:
#    watch -n 5 servstats peer1-web1 peer1-web2 peer1-web3 peer1-web4 peer1-web5 peer1-python1

# Override the default stats path like so:
#    statspath=/server-status servstats www.apache.org mayday.indymedia.org www.vertexdev.com

# Default server list
servers=${*:-www.apache.org mayday.indymedia.org www.vertexdev.com}
# Default stats path
statspath=${statspath:-/server-status}
# Create a temporary directory
tempdir=$(mktemp -d -t ${0##*/}.XXXXXX)

index=1
for h in $servers; do
    [[ $((index++)) ]];
    curl -s http://$h$statspath | \
    gawk -v h=$h -v k=14 -v IGNORECASE=1 '
        /<pre>/{
            if(p!=-1){
                gsub("<.*>","");
                p=1;
                l=0
            }
        }
        /<\/pre>/{
            p=-1;
            if(l){
               d="+" l
            }
        }
        p==1{
            for(i=1;i<=length($0);i++){
                ch[substr($0,i,1)]++i
            }
        }
        /^\.+$/{
            l++;
            next
        }
        p==1{
            s=s "\n" $1
        }
        END{
            printf "%-" k "s ", h
            for (c in ch){
                printf "%s: %s    ", c, ch[c]
            }
            print s;
            if(d>0){
                print d;
            }
            print "";
        }' > $tempdir/$index && echo -n "$h " | tee -a $tempdir/0 &
done
wait
clear
echo -e "\n" >> $tempdir/0
cat $tempdir/*
rm -rf $tempdir
