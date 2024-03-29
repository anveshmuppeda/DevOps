# Git Notes
## Pushing code to github using personal access token
### Generate Token
1. click your profile photo, then click Settings.
2. In the left sidebar, click  Developer settings.
3. In the left sidebar, under  Personal access tokens, click Tokens (classic).
4. Select Generate new token, then click Generate new token (classic).
5. In the "Note" field, give your token a descriptive name.
6. To give your token an expiration, select Expiration, then choose a default option or click Custom to enter a date.
7. Select the scopes you'd like to grant this token. To use your token to access repositories from the command line, select repo. A token with no assigned scopes can only access public information. For more information, see "Scopes for OAuth Apps".
8. Click Generate token.
9. Optionally, to copy the new token to your clipboard, click 

### Using a personal access token on the command line
Once you have a token, you can enter it instead of your password when performing Git operations over HTTPS.
For example, on the command line you would enter the following:
```
$ git clone https://github.com/USERNAME/REPO.git
Username: YOUR_USERNAME
Password: YOUR_TOKEN
```

And if username and password already stored on local then remove using the below commands:
```
git credential-cache exit
git config --list
git config --global credential.helper cache
$ git config –-global user.name NEWUSER
$ git config user.name NEWUSER

```
## Git pull issues 
If we are unable to merge the remote branch with the local repo with below command  
```
git pull https://github.com/<username>/<myrepo.git> 
```
Thwn we can use the below command to forceful merge to the local and merge
```
git pull --rebace 
```

### Road Map for git commands
<img width="596" alt="Screenshot 2023-02-22 at 12 24 18 PM" src="https://user-images.githubusercontent.com/115966808/226376046-292ee51c-8c69-4674-87a1-8ae0e5abf19a.png">

