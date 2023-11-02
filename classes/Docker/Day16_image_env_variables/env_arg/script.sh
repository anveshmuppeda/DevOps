#!/bin/bash
sum_env=$(expr $env1 + $env2)
echo "The sum of env1 and env2 is:: $sum_env"

sum_arg=$(expr $arg1 + $arg2)
echo "The sum of arg1 and arg2 is:: $sum_arg"