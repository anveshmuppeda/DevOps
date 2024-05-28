#!/bin/bash
read -p "Enter your grep string: " stringname
#echo "String name: $stringname"
cat file.txt | grep -i "$stringname"