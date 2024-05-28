#!/bin/bash
<<com
Write a shell script that prompts the user for a name of a file or directory and reports if it is a
regular file, a directory, or other type of file.
Also perform an ls command against the file or directory with the long listing option.
com
read -p "Enter File name: " myfile
echo "Entered file name: ${myfile}"

if [ -e ${myfile} ]; then 
    if [ -d "${myfile}" ]; then
        echo "${myfile} is a Directory"
    elif [ -f "${myfile}" ]; then
        echo "${myfile} is a Regular File"
    fi
    echo "Long listing for the give file/directory: $(ls "${myfile}")"
else
    echo "No Such file or directory"
fi