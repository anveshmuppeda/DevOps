#!/bin/bash
var=2
  
#Pass the variable in string
case "$var" in
    #case 1
    "1") echo "This is from first statement" ;;
      
    #case 2
    "2") echo "This is from second statement" ;;
      
    #case 3
    "3") echo "This is from third statement" ;;
esac