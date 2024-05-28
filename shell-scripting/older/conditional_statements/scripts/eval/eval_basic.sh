Hello=Mr.Anvesh
User=Hello
echo \${$User}

#command "eval echo \${$User}" runs the parameter passed to eval. After expansion, remaining parameters are echo and ${Hello}. Hence eval command runs the command echo ${Hello}. And so the output is Mr.Anvesh

date --date="1 week ago"
#Look at the above snapshot, we have passed a parameter (1 week ago) to the date command. This is the last week date and time displayed.


lastweek='date --date="1 week ago"'

$lastweek #won't work here
eval $lastweek #give correct answer

(1934 > 1278) && echo true || false
1934: command not found
#false

((1934 > 1278)) && echo true || false
#true
