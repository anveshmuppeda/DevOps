#!/bin/bash
source /c/Users/amuppeda/Desktop/Files/DAME/My_Learn/Shell_Scripting/scripts/config.sh

echo "This is $user with $id"



<<com
Many programs use external configuration files. Use of external configuration files prevents a user from making changes to a script. Config file is added with the help of source command.

If a script is shared in many users and every user need a different configuration file, then instead of changing the script each time simply include the config files.

Example:

We have two files, one is parent file (main.sh) and other is configuration file (config.sh). We have to source this configuration file into our parent file.Many programs use external configuration files. Use of external configuration files prevents a user from making changes to a script. Config file is added with the help of source command.

If a script is shared in many users and every user need a different configuration file, then instead of changing the script each time simply include the config files.

Example:

We have two files, one is parent file (main.sh) and other is configuration file (config.sh). We have to source this configuration file into our parent file.
com
