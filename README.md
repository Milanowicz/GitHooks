# Git Repository Hooks

BASH Shell Scripts for Gitolite for git repository hooks to log or automatic checkout (copy) somewhere you want.


## GitHooks Project Installation

* create a repository via gitolite-admin.git
* init a root remote session to your server

* # su git
* $ cd
* $ mkdir <Directory>

/home/git/local.conf

    GitUser=git
    GitGroup=git
    MasterBranch=master
    GitPath=/home/git/
    GitHooksScriptPath=/home/git/scripts
    WWWHookPath=/home/git/scripts/Projects
    BashHookPath=/home/git/scripts/Projects
    RepoPath=/home/git/repositories/
    ! One empty row only at the end of this file !


* $ chmod 660 ~/local.conf

* $ nano repositories/GitHooks.git/hooks/post-receive

    #!/bin/bash
	~/scripts/GitSync.sh

* $ nano repositories/GitHooks.git/hooks/pre-receive

	#!/bin/bash
	~/scripts/pre-receive.sh

* $ chmod +x repositories/GitHooks.git/hooks/post-receive
* $ chmod +x repositories/GitHooks.git/hooks/pre-receive
* $ exit

Now you can push the GitHooks project to Gitolite


Hook post-receive by create a new repository
------------

* $ nano Repository.git/hooks/post-receive

    #!/bin/bash

    * Normal git repository
    ~/scripts/post-receive.sh

    * Website repository
    ~/scripts/post-receive-www.sh

    * BASH git repository
    ~/scripts/post-receive-bash.sh


* # visudo

    git ALL = (root) NOPASSWD: /bin/sh /home/git/scripts/Projects/<RepositoryName>HookReceive.sh



## Website Repository


Check the variable HookPath in this shell script, if the path to GitMan alright is

* $ nano ~/scripts/post-receive-www.sh


## Create a hook in a repository


You can create git hook by the shell script

* $ bash CreateRepoHook.sh <Type> <Repository Name>


## License

[GNU GPL Version 3](http://www.gnu.org/copyleft/gpl.html)