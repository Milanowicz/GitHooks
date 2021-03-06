#!/bin/bash
####################################
####################################
##                                ##
##  gitolite-admin                ##
##  post-receive script           ##
##  Version 0.1.2                 ##
##                                ##
##  Git Post Recevie Hook Script  ##
##  it disallow to delelted the   ##
##  master branch                 ##
##  and it's log what happend     ##
##                                ##
####################################
##                                ##
## <parameter> Project = filename ##
##                                ##
####################################
####################################

# Script Variables
Time=$(date +%d.%m.%Y" "%H:%M)
Start=$(date +%s)

# Export configuration values into shell environment
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
CheckoutBranch=${Branch}
Action=
Command=


# Execute shell command as user
ExecuteCommand () {
    if [ "${GitCheckoutUser}" == "root" ] || [ -z ${GitCheckoutUser} ]; then
        sudo sh ${Command}
    elif [ "${GitCheckoutUser}" == `whoami` ]; then
        ${Command}
    else
        su - ${GitCheckoutUser} -c "sh ${Command}"
    fi
}

# Checkout Git Repository
CheckoutRepository () {

    ls ${HookPath}"/"${ProjectName}"_update_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null

    if [ $? == 0 ]; then
        Command=${HookPath}"/"${ProjectName}"_update_"${CheckoutBranch}".sh"
        ExecuteCommand
    fi

}

# Build new Branch environment
BuildEnvironment () {

    ls ${HookPath}"/"${ProjectName}"_delete_"${MasterBranch}".sh" > /dev/null 2> /dev/null
    if [ $? == 0 ]; then
        cp ${HookPath}"/"${ProjectName}"_delete_"${MasterBranch}".sh" ${HookPath}"/"${ProjectName}"_delete_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null
        if [ $? == 0 ]; then
            sed -i "s/master/${CheckoutBranch}/g" ${HookPath}"/"${ProjectName}"_delete_"${CheckoutBranch}".sh"
        fi
    fi

    ls ${HookPath}"/"${ProjectName}"_update_"${MasterBranch}".sh" > /dev/null 2> /dev/null
    if [ $? == 0 ]; then
        cp ${HookPath}"/"${ProjectName}"_update_"${MasterBranch}".sh" ${HookPath}"/"${ProjectName}"_update_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null
        if [ $? == 0 ]; then
            sed -i "s/master/${CheckoutBranch}/g" ${HookPath}"/"${ProjectName}"_update_"${CheckoutBranch}".sh"
        fi
    fi

    ls ${HookPath}"/"${ProjectName}"_create_"${MasterBranch}".sh" > /dev/null 2> /dev/null
    if [ $? == 0 ]; then
        cp ${HookPath}"/"${ProjectName}"_create_"${MasterBranch}".sh" ${HookPath}"/"${ProjectName}"_create_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null
        if [ $? == 0 ]; then
            sed -i "s/master/${CheckoutBranch}/g" ${HookPath}"/"${ProjectName}"_create_"${CheckoutBranch}".sh"
            Command=${HookPath}"/"${ProjectName}"_create_"${CheckoutBranch}".sh"
            ExecuteCommand
        fi
    fi

}

# Delete Branch environment
DeleteEnvironemnt () {

    ls ${HookPath}"/"${ProjectName}"_delete_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null

    if [ $? == 0 ]; then
        Command=${HookPath}"/"${ProjectName}"_delete_"${CheckoutBranch}".sh"
        ExecuteCommand

        rm ${HookPath}"/"${ProjectName}"_create_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null
        rm ${HookPath}"/"${ProjectName}"_delete_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null
        rm ${HookPath}"/"${ProjectName}"_update_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null
    fi
}


# Check if is master branch
if [ "${MasterBranch}" == "${Branch}" ]; then

    if [ "${NewRev}" == "${RevEmpty}" ]; then

	    die 1 "Error: ${MasterBranch} can not by deleted!"

    else

        Action="update"
        CheckoutRepository

    fi

# Other branch
else

    # check if branch should be delete
    if [ "${NewRev}" == "${RevEmpty}" ]; then

        Action="delete"
        git symbolic-ref HEAD refs/heads/${MasterBranch}
        DeleteEnvironemnt

    # check if branch should be create
    elif [ "${OldRev}" == "${RevEmpty}" ]; then

        Action="create"
        BuildEnvironment
        CheckoutRepository

    # branch would be updated
    else

        Action="update"
        CheckoutRepository

    fi
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
Output=${Time}" "${ProjectName}": "${Action}" in "${ProcessTime}" for "${Branch}" by "${UserName}
echo ${Output} >> ~/hook.log
echo ${Output}