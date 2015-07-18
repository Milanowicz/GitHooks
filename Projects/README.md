# Git Hooks Project files

You have the possibility to configure separate in each script the settings you need and checkout the git branch.

Shell Script to sync or dump from or to MySQL Databases.
It's a Git optimized BASH Shell Script to commit the Database with into the Git Repository.

[SyncDB.sh](https://github.com/Milanowicz/SyncDB.sh)


## Example for the `master` branch

### Create Branch
    
`$ nano <Hook Name>_build_master.sh`

    #!/bin/bash

    # Paths
    export ConfigFile="/home/git/Config/"
    export RepoPath="/home/git/repositories/testing.git"

    # Webseiten Content
    export Path="/var/www/<path>"
    # Default is `master` branch
    export CheckoutBranch="master"
    export WWWUser="<user>"
    export WWWGroup="<group>"

    ${ConfigFile}Shell/Build.sh sync user


### Delete Branch

`$ nano <Hook Name>_delete_master.sh`

    #!/bin/bash

    # Paths
    export ConfigFile="/home/git/Config/"
    export RepoPath="/home/git/repositories/testing.git"

    # Webseiten Content
    export Path="/var/www/<path>"
    # Default is `master` branch
    export CheckoutBranch="master"
    
    # Database settings
    export Username="<user>"
    export Password="<password>"
    export Hostname="127.0.0.1"
    export MySQLDB="<sync to this db name>"

    ${ConfigFile}Shell/Delete.sh sync user


### Update Branch

`$ nano <Hook Name>_update_master.sh`

    #!/bin/bash

    # Paths
    export ConfigFile="/home/git/Config/"
    export RepoPath="/home/git/repositories/testing.git"

    # Webseiten Content
    export Path="/var/www/<path>"
    # Default is `master` branch
    export CheckoutBranch="master"
    export WWWUser="<user>"
    export WWWGroup="<group>"
    
    # Database settings
    export Username="<user>"
    export Password="<password>"
    export DBNames="<real db name>"
    export Hostname="127.0.0.1"
    export MySQLDB="<sync to this db name>"
    export DBPath=$Path"/db"

    ${ConfigFile}Shell/CheckOut.sh sync user
