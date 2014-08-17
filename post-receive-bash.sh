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

# Einlesen der Konfiguration
while read Line; do
	Line=${Line//=/ }
	Var=($Line)
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
UserName=$GL_USER
ProjectName=$1


# Pruefe auf master Branch
if [ "$MasterBranch" == "$Branch" ]; then

  if [ "$NewRev" == "$RevEmpty" ]; then

	die 1 "Error: $MasterBranch can not delete!"

  else

    sudo sh $BashHookPath""$ProjectName"HookReceive.sh"
    LogText="branch update"

  fi


# Andere Branch
else


    # Pruefe ob Branch geloescht wird
    if [ "$NewRev" == "$RevEmpty" ]; then
      LogText="branch delete"

    # Pruefe ob eine neue Branch erzeugt wird
    elif [ "$OldRev" == "$RevEmpty" ]; then
      LogText="branch create"

    # Branch wurde geupdatet
    else
      LogText="branch update"

    fi

fi


Output=$Time" "$ProjectName": "$Branch" "$LogText" by "$UserName


# Ausgaben
echo $Output >> $Log
echo $Output

