#!/bin/bash
######################################
######################################
##                                  ##
##  Git Branch build environment    ##
##  Version 0.0.1                   ##
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
    die 1 "Error: Branch ${CheckoutBranch} unknown!"
fi


ls ${Path} > /dev/null 2> /dev/null
if [ $? == 0 ]; then
    rm -rf ${Path}
else
    echo "Error: Directory not found!"
fi

if [ -n ${MySQLDB} ]; then

    Prompt=`which mysql`

    # Set Username if empty
    if [ -z ${Username} ]; then
        Username="root"
    fi

    # Set Password if empty
    if [ -z ${Password} ]; then
        Password="123456"
    fi

    # Set Port if empty
    if [ -z ${Port} ]; then
        Port="3306"
    fi

    # Set Hostname if empty
    if [ -z ${Hostname} ]; then
        Hostname="127.0.0.1"
    fi

    ls ${Prompt} > /dev/null 2> /dev/null
    if [ $? == 0 ]; then
        ${Prompt} -u ${Username} -p${Password} -h ${Hostname} -P ${Port} \
            -e "DROP DATABASE IF EXISTS \`"${MySQLDB}"\`;"
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
Output=${Time}" Delete Environment --  "${ProcessTime}
echo ${Output}