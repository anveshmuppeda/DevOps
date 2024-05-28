#!/bin/bash
#Initializing two variables
a=10
b=20
  
#without using else statement
#Check whether they are equal
if [ $a == $b ]
then
    echo "a is equal to b"
fi
  
#Check whether they are not equal
if [ $a != $b ]
then
    echo "a is not equal to b"
fi

#using else statement

if [ $a == $b ]
then
    #If they are equal then print this
    echo "a is equal to b"
else
    #else print this
    echo "a is not equal to b"
fi