#!/bin/bash
echo "enter your age"
read age
if [ "$age" -ge 18 ]; then
    echo "your are eligible to vote"
else
    echo "you are younger !!"
fi
