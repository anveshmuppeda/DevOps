#!/bin/bash
<<com
Write a shell script that displays "man", "bear", "pig", "dog", "cat", and "sheep" to the screen with
each appearing on a separate line. Try to do this in as few lines as possible.
com

for i in "man" "bear" "pig" "dog" "cat" "sheep"
do
    echo "${i}"
done