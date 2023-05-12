## Source Directories in BASH 
we’re going to import a set of environment variables into a script. The well-known case is reading and setting variables from the user’s .bash_profile (or .profile).

This is especially useful in the case of cron jobs because the shell of cron usually has a very sparse set of environment variables.

Let’s assume that we want to pass all environment variables of the user’s interactive shell to the cron job script. So, let’s begin the script by sourcing profile files:
```
#!/bin/bash
source /etc/profile
source ~/.bash_profile
source ~/.bashrc
# do something useful
```
