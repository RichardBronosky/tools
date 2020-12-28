tput init;
echo -n 'does this work?';
sleep 1;
for i in {1..15}; do tput cub1; done;   # "cursor back 1" 15 times
tput setaf 2;                           # set ANSI foreground color to green
echo -n "does";
for i in {1..6}; do tput cuf1; done;    # "cursor forward 1" 6 times
echo -n 'work';
tput sgr0;                              # clear all altered attributes 
echo;
