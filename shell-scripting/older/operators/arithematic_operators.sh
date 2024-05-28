

#!/bin/bash

#reading data from the user
echo "enter a value"
read a
echo "enter b value"
read b

echo "Sum of a and b = $((a + b))"

echo "Subtraction of a and b = $((a - b))"

echo "Multiplication of a and b = $((a * b))"

echo "Division of a and b = $((a / b))"

echo "Modulus of a and b = $((a % b))"

echo "Increment of a = $((++a))"
echo "After Increment a value = $a "

echo "Decrement of b = $((b--))"
echo "After Decrement b value = $b "
