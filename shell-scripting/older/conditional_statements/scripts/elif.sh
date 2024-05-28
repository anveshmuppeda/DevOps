#!/bin/bash
echo "Choose color from Red, Green, Blue, Orage"
read color

if [ $color == Red ]
then
    echo "your are cheerful"


elif [ $color == Blue ]
then
     echo "You are lucky"
else
    echo "you are both !!"
fi
