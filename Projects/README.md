# Git Hooks Project files

You have the possibility to configure separate in each script the settings you need and checkout the git branch.

Shell Script to sync or dump MySQL Databases

[SyncDB.sh](https://github.com/Milanowicz/SyncDB.sh)


## Website push example for the `master` branch

* $ nano <Hook Name>_master.sh

    #!/bin/bash

    # Website content
    export Path="/var/www/<path>"
    export LogMessage="Website Update - <Project>"
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

    /home/git/scripts/CheckOutHookReceive.sh sync user

