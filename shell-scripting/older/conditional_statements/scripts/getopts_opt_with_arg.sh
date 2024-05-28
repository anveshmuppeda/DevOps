#!/bin/bash

while getopts ":ab:c" option;
do
   case $option in
   a)
    echo received -a
    ;;
   b)
    echo received -b with $OPTARG
    ;;
   c)
    echo received -c
    ;;
    :)
     echo "option -$OPTARG needs an argument"
    ;;
    *)
     echo "invalid option $OPTARG"
     ;;
   esac
   done


<<comm
The getopts options are used in shell scripts to parse arguments passed to them. When arguments are passed on the command line, getopts parse those arguments instead of command lines.

Options are written starting with a hyphen (-), followed by the letter. For example, -a, -b, -c, -d, etc.
comm
