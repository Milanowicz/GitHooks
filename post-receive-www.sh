#!/bin/bash
#####################################
#####################################
##                                 ##
##  Git Post Recevie Hook for WWW  ##
##  it disallow to delelted the    ##
##  master branch                  ##
##  and it's log what happend      ##
##  it can check out a develop     ##
##  enviroment                     ##
##                                 ##
##  Script Version 0.1.1           ##
##                                 ##
#####################################
#####################################

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

	die 1 "Error: ${MasterBranch} can not delete!"

  else

    sudo sh ${WWWHookPath}"/"${ProjectName}"HookReceive.sh"
    LogText="branch update"

  fi


# Andere Branch
else

  CheckOut=no
  # Datei auslesen, worin die Test Branch abgelegt ist
  while read Elem
  do
      SelectBranch=${Elem}
      if [ "${SelectBranch}" == "${Branch}" ]; then
        CheckOut=yes
      fi
  done < ${BranchPath}"/"${ProjectName}"Branch"


  # Pruefe ob es sich dabei um die ausgewaehlte Test Branch
  # handelt, welche gerade gepusht wird UND pruefe ob die Branch
  # gerade NICHT vom Benutzer geloescht wird
  if [ "${CheckOut}" == "yes" ] && [ "${NewRev}" != "${RevEmpty}" ]; then

    sudo sh ${WWWHookPath}"/"${ProjectName}"_"${Branch}".sh"

    # Pruefen auf neu oder update
    if [ "${OldRev}" == "${RevEmpty}" ]; then
      LogText="branch create"
    else
      LogText="branch update"
    fi


  # Andere Branch
  else


    # Pruefe ob Branch geloescht wird
    if [ "${NewRev}" == "${RevEmpty}" ]; then
      LogText="branch delete"

    # Pruefe ob Branch erzeugt wird
    elif [ "${OldRev}" == "${RevEmpty}" ]; then
      LogText="branch create"

    # Branch wurde geupdatet
    else
      LogText="branch update"

    fi

  fi
fi


Output=${Time}" "${ProjectName}": "${Branch}" "${LogText}" by "${UserName}


# Ausgaben
echo ${Output}
