#!/bin/bash
######################################
######################################
##                                  ##
##  Git Repository checkout script  ##
##  Version 0.0.6                   ##
##                                  ##
######################################
##                                  ##
##  SyncDB.sh                       ##
##  [parameter] [parameter]         ##
##                                  ##
######################################
######################################

# Script Variables
Time=$(date +%d.%m.%Y" "%H:%M)
Start=$(date +%s)

# Export configuration values into shell environment
while read Line; do
    Line=${Line//=/ }
    Var=(${Line})
    export ${Var[0]}=${Var[1]}
done < ${ConfigFile}local.conf

# Check if select branch exists
if [ -z ${CheckoutBranch} ]; then
    CheckoutBranch=${MasterBranch}
fi


#############################
##   Repository Checkout   ##
#############################
# Set envirnoment variables
unset GIT_DIR
export GIT_DIR=${RepoPath}
export GIT_WORK_TREE=${Path}
cd ${Path}

# Checkout branch from Git Repository
git checkout -f ${CheckoutBranch}

# Update Git Submodules
ls .gitmodules > /dev/null 2> /dev/null
if [ $? == 0 ]; then
    git submodule update --init --recursive --force
fi


################################
##   File System operations   ##
################################
# Do correct the user rights from Git Repository
if [ "${GitUser}" != "${GitCheckoutUser}" ]; then
    chown -R ${GitUser}:${GitGroup} ${RepoPath}
fi

# Set user rights from Content who was checkout
if [ "${WWWUser}" != "${GitCheckoutUser}" ]; then
    chown -R ${WWWUser}:${WWWGroup} ${Path}
    find ${Path} -type d -exec chmod ${WWWRightDirectory} {} \;
    find ${Path} -type f -exec chmod ${WWWRightFiles} {} \;
    find ${Path} -type f -name *.sh -exec chmod ${WWWRightScript} {} \;
fi


#############################
##   Database operations   ##
#############################
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