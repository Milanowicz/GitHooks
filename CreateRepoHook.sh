#!/bin/bash
####################################
####################################
##                                ##
##  Create Hook files in git      ##
##  repository                    ##
##                                ##
##  Script Version 0.0.9          ##
##                                ##
####################################
####################################


# Variables
Error=0
InputRepo=$2
RepoName=
FileName=


######################################################
##                 Bash Shell Script                ##
######################################################

# Einlesen der Konfiguration
while read Line; do
    Line=${Line//=/ }
    Var=(${Line})
    export ${Var[0]}=${Var[1]}
done < ~/local.conf


# Git Repo Verzeichnisnamen pruefen
CheckRepoPathName(){

    ls ${RepoPath}${InputRepo} > /dev/null 2> /dev/null

    if [ $? != 0 ]; then

        ls ${RepoPath}${InputRepo}".git" > /dev/null 2> /dev/null

        if [ $? == 0 ]; then
            RepoName=${RepoPath}${InputRepo}".git"
        fi

    else

        RepoName=${RepoPath}${InputRepo}

    fi

} # End of CheckRepoPathName


# Git Post-Receive Hook anlegen
CreatePostReceiveHook(){

    FileName=${RepoName}"/hooks/post-receive"
    touch ${FileName}

    if [ $? == 0 ]; then

        chmod +x ${FileName}
        echo "#!/bin/bash" > ${FileName}

    else

        echo "Error: Can't create post-receive file: "${FileName}
        Error=2

    fi

} # End of CreatePostReceiveHook


# Git Pre-Receive Hook anlegen
CreatePreReceiveHook(){

    FileName=${RepoName}"/hooks/pre-receive"
    touch ${FileName}

    if [ $? == 0 ]; then

        chmod +x ${FileName}
        echo "#!/bin/bash" > ${FileName}

    else

        echo "Error: Can't create pre-receive file: "${FileName}
        Error=2

    fi

} # End of CreatePreReceiveHook


# Parameter prüfen
if [ -z "$1" ] || [ -z "$2" ]; then

    Error=1

# Bei Parameter Übergaben
# Repo Pfad prüfen und Post Receive Hook erzeugen
else

    CheckRepoPathName
    CreatePostReceiveHook

fi


# Verlinkung zum Type erzeugen
if [ "$1" == "receive" ]; then

    echo "~/scripts/post-receive.sh $3" >> ${FileName}

elif [ "$1" == "bash" ]; then

    echo "~/scripts/post-receive-bash.sh $3" >> ${FileName}

elif [ "$1" == "www" ]; then

    echo "~/scripts/post-receive-www.sh $3" >> ${FileName}

else

    Error=1

fi


# Ausgabe der Hilfe für die Script Parameter
if [ ${Error} -eq 1 ]; then

    echo -e "\n $ bash create-repo-hook.sh <Type> <Repository Path> <Hook Name>"
    echo -e "\n\tParameter Type\tDescription\n"
    echo -e "\treceive\t\tNormal Log receive hook for a repository"
    echo -e "\tbash\t\tShell script hook"
    echo -e "\twww\t\tWebsite project hook\n"

# Wenn kein Fehler aufgetreten ist,
# dann abschliessende Arbeiten erledigen
else

    if [ ${Error} -eq 0 ]; then

        chown ${GitUser}:${GitGroup} ${FileName}
        chmod +x ${FileName}

        FileName=
        CreatePreReceiveHook

        if [ ${Error} -eq 0 ]; then

            echo "~/scripts/pre-receive.sh $3" >> ${FileName}

            chown ${GitUser}:${GitGroup} ${FileName}
            chmod +x ${FileName}

        fi
    fi
fi
