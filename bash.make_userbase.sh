#!/usr/bin/env bash

# creates a compressed tarball that is ready to be sent to a remote server to create an environment
# that you expect to be available to you for daily use.  This is also very useful for keeping your
# server environments in sync.

# file to create
basename=user_base
extension=.tgz

# files and directories to store
files='./.bashrc ./.bash_aliases ./.bash_logout ./.inputrc ./.screenrc ./.toprc ./.vimrc ./.vim ./.ssh/id*.pub ./.ssh/authorized_keys2 ./.ssh/config ./bin/cpuusage ./bin/d ./bin/COLORS.sh'

# empty directories to create and store
empty='.vim_backup tmp'

# create temp dir
tmp=$(mktemp -d /tmp/$basename.XXXXXX)
basename=$PWD/$basename # Using $PWD & $HOME lets this be ran from any path.

# store files and directories
cd $HOME
tar -cvf $basename $files

# create and store empty directories
cd $tmp
for d in $empty; do
mkdir $d && tar rvf $basename ./$d/
done;

# add MySQL config file filtered of usernames and passwords
cd $HOME
sed '/user/d;/password/d;' ./.my.cnf>$tmp/.my.cnf
cd $tmp
tar rvf $basename ./.my.cnf
cd ..
gzip -f -S .tgz $basename

# remove temp dir
cd /tmp
rm -rf $tmp

# spread the good news
tput setaf 1; tput bold
echo; echo Ready to deploy to remote machine[s] via...
tput setaf 4; tput bold
cat << 'EOF'
remote='dev1 dev2 db1 db2' # OR...
remote=$(sed '/^\s*#/d' /etc/home_synced_servers)
EOF
cmd='for r in $remote; do echo "Sending to $r..."; cat user_base.tgz | ssh $r "tar zxf -; chmod 700 .ssh" ; done'
echo -e "$cmd\n"
echo -e "OR feed a list after the fact with...\nread remote; $cmd\n"
tput sgr0

# copy the url to the clipboard if you are using a Mac
$(which pbcopy > /dev/null 2>1) && echo -n "$cmd" | pbcopy

# vim:ft=sh
