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
    Var=($Line)
    export ${Var[0]}=${Var[1]}
done < /home/git/local.conf

######################################################
##                 Bash Shell Script                ##
######################################################

# Branch Datei auslesen
while read Elem
do
    SelectBranch=$Elem

done < $BranchFile


# Verzeichnis loeschen
ls $Path > /dev/null 2> /dev/null
if [ $? == 0 ]; then
    rm -R $Path > /dev/null 2> /dev/null
fi


# Repo clonen
cd $TestPath
echo -e "\nBegin Repo to clone\n"
git clone -b $SelectBranch $GitRepoURL
echo -e "\nEnd of clone\n\nBranch "$SelectBranch" is clone\n"


# Dateirechte setzen
chown -R $WWWUser:$WWWGroup $Path
find $Path -type f -exec chmod 640 {} \;
find $Path -type d -exec chmod 750 {} \;

if [ "$1" == "sync" ]; then
        find $DBPath -type f -name *.sh -exec chmod 751 {} \;
fi


# Datenbank updaten
if [ "$1" == "sync" ]; then
    $DBPath"/SyncDB.sh" $1 $2
fi


End=$(date +%s)
TimeDiff=$(( $End - $Start ))

# Pruefen, ob benoetigte Zeit kleiner als 60 sec ist
if [ $TimeDiff -lt 60 ]; then
    ProcessTime=$TimeDiff' sec'
elif [ $TimeDiff -ge 60 ]; then
    ProcessTime=$[$TimeDiff / 60] ':'$[$TimeDiff % 60] ''
fi


Output=$Time" "$LogMessage" -  Branch -> "$SelectBranch"  --  "$ProcessTime


# Ausgaben
echo $Output >> $Log
echo $Output


