#!/bin/bash
######################################
######################################
##                                  ##
##  Create Hook files for gitolite  ##
##  Version 0.1.0                   ##
##                                  ##
######################################
##                                  ##
##  CreateRepoHook.sh               ##
##  <Path> <Name>                   ##
##                                  ##
######################################
######################################

# Variables
Error=0
ErrorMessage=
InputRepo=$1
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


if [ -z ${GitRepoPath} ]; then
    GitRepoPath="/home/git/repositories/"
fi


# Check git repository directory
CheckRepoPathName(){

    ls ${GitRepoPath}${InputRepo} > /dev/null 2> /dev/null

    if [ $? != 0 ]; then

        ls ${GitRepoPath}${InputRepo}".git" > /dev/null 2> /dev/null

        if [ $? == 0 ]; then
            RepoName=${GitRepoPath}${InputRepo}".git"
        fi

    else

        RepoName=${GitRepoPath}${InputRepo}

    fi

    ls ${RepoName} > /dev/null 2> /dev/null
    if [ $? != 0 ]; then
        Error=2
        ErrorMessage=GitRepoPath
    fi

} # End of CheckRepoPathName


# Create a Git Post-Receive Hook file
CreatePostReceiveHook(){

    FileName=${RepoName}"/hooks/post-receive"
    touch ${FileName}

    if [ $? == 0 ]; then

        chmod +x ${FileName}
        echo "#!/bin/bash" > ${FileName}
        # Set post-receive hook
        echo "~/post-receive.sh $2" >> ${FileName}

        chown ${GitUser}:${GitGroup} ${FileName}
        chmod +x ${FileName}

    else

        Error=3
        ErrorMessage=FileName

    fi

    FileName=

} # End of CreatePostReceiveHook


# Create a Git Pre-Receive Hook file
CreatePreReceiveHook(){

    FileName=${RepoName}"/hooks/pre-receive"
    touch ${FileName}

    if [ $? == 0 ]; then

        chmod +x ${FileName}
        echo "#!/bin/bash" > ${FileName}
        echo "~/pre-receive.sh $2" >> ${FileName}

        chown ${GitUser}:${GitGroup} ${FileName}
        chmod +x ${FileName}


    else

        Error=4
        ErrorMessage=FileName

    fi

    FileName=

} # End of CreatePreReceiveHook


# Check if user enter parameter
if [ -z "$1" ] || [ -z "$2" ]; then
    Error=1
fi


# Main Start
if [ ${Error} -eq 0 ]; then

    CheckRepoPathName

    if [ ${Error} -eq 0 ]; then
        CreatePostReceiveHook
    fi

    if [ ${Error} -eq 0 ]; then
        CreatePreReceiveHook
    fi

fi


# Error Messages
if [ ${Error} -eq 1 ]; then

    echo -e "\n $ bash CreateRepoHook.sh <Repository Path> <Hook Name>"

elif [ ${Error} -eq 2 ]; then

    echo -e "\n Error: Repositories directory don't ${ErrorMessage} found!"

elif [ ${Error} -eq 3 ]; then

    echo -e "\nError: Can't create post-receive file: "${ErrorMessage}

elif [ ${Error} -eq 4 ]; then

    echo -e "\nError: Can't create pre-receive file: "${ErrorMessage}

fi