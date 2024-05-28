#!/bin/bash
a=0
#Iterate the loop until a less than 10
while [ $a -lt 10 ]
do
    # Print the values
    echo $a
     
    # increment the value
    a=`expr $a + 1`
done