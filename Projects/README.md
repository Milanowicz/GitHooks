# Git Hooks=

Put all the shell hook files in here


## Production website push

* $ nano <Repository>HookReceive.sh

    #!/bin/bash

    # Website content
    export Path="/var/www/<path>"
    export LogMessage="Website Update - <Project>"
    export WWWUser="<user>"
    export WWWGroup="<group>"

    # Database settings
    export Username="<user>"
    export Passwort="<password>"
    export Datenbank="<real db name>"
    export Hostname="127.0.0.1"
    export MySQLDB="<sync to this db name>"
    export DBPath=$Path"/db"
    export PathBin="/usr/bin/"

    /home/git/<Directory>/Hooks/CheckOutHookReceive.sh sync


## Test enviroment website push

    #!/bin/bash

    # Test Verzeichnis
    export TestPath="/var/www/<test>"

    # Webseiten Content
    export ProjectName="<Repository>"
    export LogMessage="Test update - "$ProjectName
    export BranchFile="/home/git/<Directory>/Hooks/Branch/"$ProjectName"Branch"
    export GitRepoURL="ssh://<Repo URL>/"$ProjectName".git"
    export WWWUser="<user>"
    export WWWGroup="<group>"
    export Path=$TestPath"/"$ProjectName


    # Datenbank Einstellung
    export Username="<user>"
    export Passwort="<password>"
    export Datenbank="<real db name>"
    export Hostname="127.0.0.1"
    export MySQLDB="<sync to this db name>"
    export DBPath=$Path"/db"
    export PathBin="/usr/bin/"


    # Test Umgebung erzeugen
    /home/git/<Directory>/Hooks/CheckOutDevEnv.sh sync <framework> <version>
