#!/bin/bash
echo -e "Checking whether the target file with a set of key words exists or not\n"

define()
{
    echo "Defining the set of key words which needs to be verified in target file"
    names=(
    "vamsi"
    "anvesh"
    "manasa"
    "vijay"
    "babi" )
}

pull()
{
    echo -e "\nVerifiying the keywords "
    for target_name in ${names[@]}; do
        #sleep 1
        #here text.txt is target file with some strings
        grep "$target_name" text.txt > /dev/null
        if [ $? -eq 0 ]; then
            echo -e "$target_name is present in the text.txt file \n"
        else
            echo -e "Oops, sorry, $target_name is present in the text.txt file. \n"
            exit;
        fi
    done
    echo "The target file has all the key words present and successfully verified!!"
}




define
pull
