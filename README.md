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
    GitHooksScriptPath=/home/git/<Directory>/Hooks
    SymScript=$GitHooksScriptPath"Environment"
    HookPath=$SymScript"Hooks/"
    WWWHookPath=/home/git/<Directory>/Hooks/Projects
    BashHookPath=/home/git/<Directory>/Hooks/Projects
    RepoPath=/home/git/repositories/
    CommitPath="/home/git/dok"
    TempPath=/tmp/repo
    Log=/var/log/git.log
    Error=/var/log/giterror.log
    ! One empty row only at the end of this file !


* $ chmod 660 scripts/<Directory>/Hooks/local.conf

* $ nano repositories/GitHooks.git/hooks/post-receive

    #!/bin/bash
	~/<Directory>/Hooks/githooks-sync.sh

* $ nano repositories/GitHooks.git/hooks/pre-receive

	#!/bin/bash
	~/<Directory>/Hooks/pre-receive.sh

* $ chmod +x repositories/GitHooks.git/hooks/post-receive
* $ chmod +x repositories/GitHooks.git/hooks/pre-receive
* $ exit

* # touch /var/log/git.log
* # touch /var/log/giterror.log
* # chown git:apache /var/log/git*

Now you can push the GitHooks project to Gitolite


Hook post-receive by create a new repository
------------

* $ nano Repository.git/hooks/post-receive

    #!/bin/bash

    * Normal git repository
    ~/<Directory>/Hooks/post-receive.sh

    * Website repository
    ~/<Directory>/Hooks/post-receive-www.sh

    * BASH git repository
    ~/<Directory>/Hooks/post-receive-bash.sh


* # visudo

    git ALL = (root) NOPASSWD: /bin/sh /home/git/<Directory>/Hooks/Projects/<RepositoryName>HookReceive.sh



## Website Repository


Check the variable HookPath in this shell script, if the path to GitMan alright is

* $ nano <Directory>/Hooks/post-receive-www.sh


## Create a hook in a repository


You can create git hook by the shell script

* $ bash create-repo-hook.sh <Type> <Repository Name>


## License

[GNU GPL Version 3](http://www.gnu.org/copyleft/gpl.html)