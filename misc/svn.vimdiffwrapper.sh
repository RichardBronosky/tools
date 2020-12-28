#!/bin/bash

# To use this you must place this script in your $PATH and:
#     diff-cmd = svn.vimdiffwrapper.sh >> $HOME/.svn/config
# or use a complete path above if you don't place this in your $PATH

shift 5; vimdiff -f "$@" 
