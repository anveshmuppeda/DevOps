#!/bin/bash
<<com
Modify the previous script to accept an unlimited number of files and directories as arguments.
Hint: You'll want to use a special variable.
com
for myfile in "$@"
do
    if [ -e "${myfile}" ]; then 
        if [ -d "${myfile}" ]; then
            echo "${myfile} is a Directory"
        elif [ -f "${myfile}" ]; then
            echo "${myfile} is a Regular File"
        fi
        echo "Long listing for the give file/directory: $(ls "${myfile}")"
    else
        echo ""${myfile}": No Such file or directory"
    fi
done
