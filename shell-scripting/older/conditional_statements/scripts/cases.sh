#!/bin/bash
#Capitals of the states

echo "Enter the name of the state:"
read state
case $state in
     "Uttar Pradesh")
          echo "Capital is Lucknow"
     ;;
     "Telangana")
          echo "Capital is Hyderabad"
     ;;
     "AndraPradesh")
          echo "Capital is Amaravathi"
     ;;
     *)
          echo "You discovered an unknown state"
     ;;
esac
