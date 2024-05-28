#!/bin/bash
<<comment
Modify the previous script so that it accepts the file or directory name as an argument instead of
prompting the user to enter it.
comment
myfile="$1"
echo "Entered file name: ${myfile}"

if [ -e "${myfile}" ]; then 
    if [ -d "${myfile}" ]; then
        echo "${myfile} is a Directory"
    elif [ -f "${myfile}" ]; then
        echo "${myfile} is a Regular File"
    fi
    echo "Long listing for the give file/directory: $(ls "${myfile}")"
else
    echo "No Such file or directory"
fi