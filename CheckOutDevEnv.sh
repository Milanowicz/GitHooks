#!/bin/bash
######################################################
##                                                  ##
## Shell Skript fuer die Testumgebung beim          ##
## Entwicklungs-System, damit wird eine separate    ##
## Umgebung eingerichtet.                           ##
##                                                  ##
######################################################
######################################################
## Parameter  [Datenbank] [CMS] [CMS Version]       ##
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

# Projekt auschecken
GIT_WORK_TREE=${Path} git checkout -f ${CheckoutBranch}

# Dateirechte setzen
chown -R $WWWUser:$WWWGroup ${Path}
find ${Path} -type f -exec chmod 640 {} \;
find ${Path} -type d -exec chmod 750 {} \;

# Datenbank updaten
if [ "$1" == "sync" ]; then
  find $DBPath -type f -name *.sh -exec chmod 751 {} \;
  ${DBPath}"/SyncDB.sh" $1 $2
fi

End=$(date +%s)
TimeDiff=$(( $End - $Start ))

# Pruefen, ob benoetigte Zeit kleiner als 60 sec ist
if [ $TimeDiff -lt 60 ]; then
  ProcessTime=$TimeDiff' sec'
elif [ $TimeDiff -ge 60 ]; then
  ProcessTime=$[$TimeDiff / 60] ':'$[$TimeDiff % 60] ''
fi


Output=${Time}" "${LogMessage}" -  Branch -> "${CheckoutBranch}"  --  "${ProcessTime}


# Ausgaben
echo ${Output}


