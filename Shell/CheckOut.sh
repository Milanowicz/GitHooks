#!/bin/bash
######################################
######################################
##                                  ##
##  Git Repository checkout script  ##
##  Version 0.0.5                   ##
##                                  ##
######################################
##                                  ##
##  SyncDB.sh                       ##
##  [parameter] [parameter]         ##
##                                  ##
######################################
######################################
Time=$(date +%d.%m.%Y" "%H:%M)
Start=$(date +%s)

# Read config values
while read Line; do
    Line=${Line//=/ }
    Var=(${Line})
    export ${Var[0]}=${Var[1]}
done < ${ConfigFile}local.conf


######################################################
##                 Bash Shell Script                ##
######################################################

# Check if select branch exists
if [ -z ${CheckoutBranch} ]; then
    CheckoutBranch=${MasterBranch}
fi

# Jump to repo and check it out
cd ${RepoPath}
GIT_DIR=${RepoPath}
GIT_WORK_TREE=${Path} git checkout -f ${CheckoutBranch}
chown -R ${GitUser}:${GitGroup} ${RepoPath}

# Set user rights
chown -R ${WWWUser}:${WWWGroup} ${Path}
find ${Path} -type d -exec chmod ${WWWRightDirectory} {} \;
find ${Path} -type f -exec chmod ${WWWRightFiles} {} \;
find ${Path} -type f -name *.sh -exec chmod ${WWWRightScript} {} \;


# Database update
if [ "$1" == "sync" ]; then
    ${DBPath}"/SyncDB.sh" $1 $2
fi


# End Time
End=$(date +%s)
TimeDiff=$(( $End - $Start ))

# Calculate time by check if under 60 seconds
if [ ${TimeDiff} -lt 60 ]; then
    ProcessTime=${TimeDiff}' sec'
elif [ ${TimeDiff} -ge 60 ]; then
    ProcessTime=$[${TimeDiff} / 60]':'$[${TimeDiff} % 60]
fi

# Output message
Output=${Time}" Check Out Environment --  "${ProcessTime}
echo ${Output}