# Git Hooks Project files

You have the possibility to configure separate in each script the settings you need and checkout the git branch.

Shell Script to sync or dump MySQL Databases

[SyncDB.sh](https://github.com/Milanowicz/SyncDB.sh)


## Production website push for the `master` branch

* $ nano <Hook Name>HookReceive.sh

    #!/bin/bash

    # Website content
    export Path="/var/www/<path>"
    export LogMessage="Website Update - <Project>"
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


## Test environment website push for other branches

* $ nano <Hook Name>_<Branch>.sh

    #!/bin/bash

    # Webseiten Content
    export Path="/var/www/<path>"
    export CheckoutBranch="test"
    export LogMessage="Test update - "$ProjectName
    export WWWUser="<user>"
    export WWWGroup="<group>"


    # Database settings
    export Username="<user>"
    export Password="<password>"
    export DBNames="<real db name>"
    export Hostname="127.0.0.1"
    export MySQLDB="<sync to this db name>"
    export DBPath=$Path"/db"

    /home/git/scripts/CheckOutDevEnv.sh sync user
