#!/bin/bash
####################################
####################################
##                                ##
##  gitolite-admin                ##
##  post-receive script           ##
##  Script Version 0.0.4          ##
##                                ##
##  Git Pre Recevie Hook Script   ##
##                                ##
####################################
##                                ##
##  <parameter> Project Name      ##
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


# Extract sheel script variables
IFS='/' read -ra REF <<< "${ref[2]}"
Branch="${REF[2]}"
OldRev="${ref[0]}"
NewRev="${ref[1]}"
RevEmpty="0000000000000000000000000000000000000000"
UserName=${GL_USER}
ProjectName=$1


# Check if is master branch
if [ "${MasterBranch}" == "${Branch}" ]; then

  if [ "${NewRev}" == "${RevEmpty}" ]; then
    
    Text="Error: You can not delete the ${Branch} branch !!!"
    Output=${Time}" "${ProjektName}" by "${UserName}": "${Text}

    echo ${Output} >> ~/hook.log
    echo ${Output}

    die 1 "Error: ${MasterBranch} can not delete!"

  fi

fi