# [GitHooks](https://github.com/Milanowicz/GitHooks)

BASH Shell Scripts for Gitolite to handle git repository hooks.
It will log and checkout a git repository automatic somewhere you like.


## Installation

Create GitHooks repository by gitolite-admin.git and connect to your server

`# su git`

`$ cd`

`$ mkdir Shell`

`$ nano /home/git/local.conf`

    GitUser=git
    GitGroup=git
    MasterBranch=master
    WWWUser=<user>
    WWWGroup=<group>
    WWWRightDirectory=770
    WWWRightFiles=660
    WWWRightScript=771
    HookPath=/home/git/Projects
    GitRepoPath=/home/git/repositories/
    GitHooksScriptPath=/home/git/
    ! One empty row only at the end of this file !


`$ chmod 660 ~/local.conf`

`$ nano repositories/GitHooks.git/hooks/post-receive`

    #!/bin/bash
    ~/Shell/Deploy.sh

`$ nano repositories/GitHooks.git/hooks/pre-receive`

    #!/bin/bash
    ~/pre-receive.sh

`$ chmod +x repositories/GitHooks.git/hooks/post-receive`

`$ chmod +x repositories/GitHooks.git/hooks/pre-receive`

`$ exit`

`# visudo`

    <user> ALL = (<user>) NOPASSWD: /bin/sh /home/git/Projects/*


Copy the `pre-receive.sh` and `Shell/Deploy.sh` to your server, then 
you can push the GitHooks project and it will be checkout.


## Create Git Hooks 

You can create git hooks by the `CreateRepoHook.sh` shell script

`# su git`

`$ cd`

`$ bash Shell/CreateRepoHook.sh <Repository Path> <Hook Name>`


## Create Git Hooks by hand

`$ nano Repository.git/hooks/post-receive`

    #!bin/bash
    ~/post-receive.sh

`$ nano Repository.git/hooks/pre-receive`

    #!bin/bash
    ~/pre-receive.sh

`$ chmod +x Repository.git/hooks/post-receive`

`$ chmod +x Repository.git/hooks/pre-receive`


## License

[GNU GPL Version 3](http://www.gnu.org/copyleft/gpl.html)