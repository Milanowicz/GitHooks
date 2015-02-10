#!/bin/bash
####################################
####################################
##                                ##
##  Git Pre Recevie Hook Script   ##
##                                ##
##  Script Version 0.0.2          ##
##                                ##
####################################
####################################

Time=$(date +%d.%m.%Y" "%H:%M)

# Read config values
while read Line; do
	Line=${Line//=/ }
	Var=(${Line})
	export ${Var[0]}=${Var[1]}
done < ~/local.conf


# Read Git parameters
if ! [ -t 0 ]; then
  read -a ref
fi

# Extract shell script variables
IFS='/' read -ra REF <<< "${ref[2]}"
Branch="${REF[2]}"
OldRev="${ref[0]}"
NewRev="${ref[1]}"
RevEmpty="0000000000000000000000000000000000000000"
UserName=${GL_USER}
ProjectName=$1


# Check if master branch
if [ "${MasterBranch}" == "${Branch}" ]; then

  if [ "${NewRev}" == "${RevEmpty}" ]; then
    
    Text="Error: You can not delete the ${MasterBranch} branch !!!"
    echo ${Time}" "${ProjektName}" by "${UserName}": "${Text}

    die 1 "Error: ${MasterBranch} can not delete!"

  fi

fi
