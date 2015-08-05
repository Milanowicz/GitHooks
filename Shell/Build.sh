#!/bin/bash
######################################
######################################
##                                  ##
##  Git Branch build environment    ##
##  Version 0.0.2                   ##
##                                  ##
######################################
######################################

# Script variables
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
    die 1 "Error: Branch ${CheckoutBranch} unknown!"
fi


ls ${Path} > /dev/null 2> /dev/null
if [ $? != 0 ]; then
    mkdir -p ${Path}
fi

if [ "${WWWUser}" != "${GitCheckoutUser}" ]; then
    chown -R ${WWWUser}:${WWWGroup} ${Path}
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
Output=${Time}" Build Environment --  "${ProcessTime}
echo ${Output}