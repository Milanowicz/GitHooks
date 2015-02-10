#!/bin/bash
####################################
####################################
##                                ##
##  Git Post Recevie Hook Script  ##
##  it disallow to delelted the   ##
##  master branch                 ##
##  and check files out where you ##
##  want to                       ##
##                                ##
##  Script Version 0.0.5          ##
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

# Checkout Git Repository
CheckoutRepository(){

    ls ${WWWHookPath}"/"${ProjectName}"_"${Branch}".sh" > /dev/null 2> /dev/null

    if [ $? == 0 ]; then
        sudo sh ${WWWHookPath}"/"${ProjectName}"_"${Branch}".sh"
    fi

}


# Check if master branch
if [ "${MasterBranch}" == "${Branch}" ]; then

  if [ "${NewRev}" == "${RevEmpty}" ]; then

	die 1 "Error: ${MasterBranch} can not delete!"

  else

    CheckoutRepository
    LogText="branch update"

  fi


# Ohter Git Branch
else

  # check if branch should be delete
  if [ "${NewRev}" == "${RevEmpty}" ]; then
    LogText="branch delete"

  # check if branch should be create
  elif [ "${OldRev}" == "${RevEmpty}" ]; then

    CheckoutRepository
    LogText="branch create"

  # branch would be updated
  else

    CheckoutRepository
    LogText="branch update"

  fi

fi


# Output message
Output=${Time}" "${ProjectName}": "${Branch}" "${LogText}" by "${UserName}
echo ${Output}