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

# Einlesen der Konfiguration
while read Line; do
	Line=${Line//=/ }
	Var=(${Line})
	export ${Var[0]}=${Var[1]}
done < ~/local.conf


# Auslesen der Git Parameter
if ! [ -t 0 ]; then
  read -a ref
fi

# Shell Skript Variablen
IFS='/' read -ra REF <<< "${ref[2]}"
Branch="${REF[2]}"
OldRev="${ref[0]}"
NewRev="${ref[1]}"
RevEmpty="0000000000000000000000000000000000000000"
UserName=${GL_USER}
ProjectName=$1


# Pruefe auf master Branch
if [ "${MasterBranch}" == "${Branch}" ]; then

  if [ "${NewRev}" == "${RevEmpty}" ]; then
    
    Text="Error: You can not delete the ${MasterBranch} branch !!!"
    echo ${Time}" "${ProjektName}" by "${UserName}": "${Text}

    die 1 "Error: ${MasterBranch} can not delete!"

  fi

fi
