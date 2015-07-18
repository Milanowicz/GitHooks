#!/bin/bash
####################################
####################################
##                                ##
##  gitolite-admin                ##
##  post-receive script           ##
##  Version 0.1.1                 ##
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

    ls ${HookPath}"/"${ProjectName}"_create_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null

    if [ $? == 0 ]; then

        cp ${HookPath}"/"${ProjectName}"_create_"${MasterBranch}".sh" ${HookPath}"/"${ProjectName}"_create_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null
        if [ $? == 0 ]; then
            sed -i '/master/c ${CheckoutBranch}' ${HookPath}"/"${ProjectName}"_create_"${CheckoutBranch}".sh"
            Command=${HookPath}"/"${ProjectName}"_create_"${CheckoutBranch}".sh"
            ExecuteCommand
        fi

        cp ${HookPath}"/"${ProjectName}"_delete_"${MasterBranch}".sh" ${HookPath}"/"${ProjectName}"_delete_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null
        if [ $? == 0 ]; then
            sed -i '/master/c ${CheckoutBranch}' ${HookPath}"/"${ProjectName}"_delete_"${CheckoutBranch}".sh"
        fi

        cp ${HookPath}"/"${ProjectName}"_update_"${MasterBranch}".sh" ${HookPath}"/"${ProjectName}"_update_"${CheckoutBranch}".sh" > /dev/null 2> /dev/null
        if [ $? == 0 ]; then
            sed -i '/master/c ${CheckoutBranch}' ${HookPath}"/"${ProjectName}"_update_"${CheckoutBranch}".sh"
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

# Output message
Output=${Time}" "${ProjectName}": "${Action}" "${Branch}" by "${UserName}
echo ${Output} >> ~/hook.log
echo ${Output}