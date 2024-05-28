#!/bin/sh
NAME[0]="Zara"
NAME[1]="Qadir"
NAME[2]="Mahnaz"
NAME[3]="Ayan"
NAME[4]="Daisy"
echo "First Index: ${NAME[0]}"
echo "Second Index: ${NAME[1]}"

array_name=("1" "23" "32" "64")

echo "Second Index from array_name: ${array_name[1]}"

#the below output will print the entire indexes from array_name array
echo "Second Index from array_name: ${array_name[@]}"
echo "Second Index from array_name: ${array_name[*]}"