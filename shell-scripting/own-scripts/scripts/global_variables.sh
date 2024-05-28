#!/bin/bash


i=2
var=1
var2=2

fun1()
{
   echo "This is from first function"
   echo $var
   #var = `expr $var + 1`
   #var = $(( $var + 2 ))
   let "i=i+1"
   echo $i
}

fun2()
{
    echo "This is from second function"
    echo $var2
    echo $i
}

echo "calling first function"
fun1

echo "calling second function"
fun2

