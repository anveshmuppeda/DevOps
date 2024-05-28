#!/bin/bash
<<com
Write a shell script to check to see if the file "/etc/shadow" exists. If it does exist, display
"Shadow passwords are enabled." Next, check to see if you can write to the file. If you can,
display "You have permissions to edit /etc/shadow." If you cannot, display "You do NOT have
permissions to edit /etc/shadow."
com

file="/etc/hosts"
echo "File name: ${file}"

if [ -e ${file} ]; then
    echo "Shadow passwords are enabled."
    if [ -w ${file} ]; then
        echo "You have permissions to edit ${file}"
    else
        echo "You donnot have permissions to edit ${file}"
    fi
    if [ -x ${file} ]; then
        echo "You have permissions to execute ${file}"
    else
        echo "You donnot have permissions to execute ${file}"
    fi
else
    echo "Shadow Password are disabled."    
fi