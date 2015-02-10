#!/bin/bash
######################################################
##                                                  ##
## Shell Skript to checkout a git brach to other    ##
## directory on the server                          ##
##                                                  ##
######################################################
######################################################
## Parameter  [Datenbank]                           ##
######################################################

Time=$(date +%d.%m.%Y" "%H:%M)
Start=$(date +%s)

# Einlesen der Konfiguration
while read Line; do
    Line=${Line//=/ }
    Var=(${Line})
    export ${Var[0]}=${Var[1]}
done < /home/git/local.conf


######################################################
##                 Bash Shell Script                ##
######################################################

# Auschecken des Webseiten Content
if [ -z ${CheckoutBranch} ]; then
    CheckoutBranch=${MasterBranch}
fi

GIT_WORK_TREE=${Path} git checkout -f ${MasterBranch}
chown -R ${GitUser}:${GitGroup} ${RepoPath}

# Berechtigung setzen
chown -R ${WWWUser}:${WWWGroup} ${Path}
find ${Path} -type f -exec chmod 660 {} \;
find ${Path} -type d -exec chmod 770 {} \;
if [ "$1" == "sync" ]; then
    find ${DBPath} -type f -name *.sh -exec chmod 751 {} \;
fi

# Datenbank updaten
if [ "$1" == "sync" ]; then
    ${DBPath}"/SyncDB.sh" $1 $2
fi


# Beendiguns-Zeit
End=$(date +%s)
TimeDiff=$(( $End - $Start ))

# Pruefen, ob benoetigte Zeit kleiner als 60 sec ist
if [ ${TimeDiff} -lt 60 ]; then
    ProcessTime=${TimeDiff}' sec'
elif [ ${TimeDiff} -ge 60 ]; then
    ProcessTime=$[${TimeDiff} / 60]':'$[${TimeDiff} % 60]
fi

Output=${Time}" "${LogMessage}" -  Branch -> "${CheckoutBranch}"  --  "${ProcessTime}

echo ${Output}
