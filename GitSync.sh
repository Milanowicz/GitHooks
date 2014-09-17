#!/bin/bash
####################################
####################################
##                                ##
##  GitHook Update Script         ##
##                                ##
##  Script Version 0.0.6          ##
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
Branch="${REF[2]}"
OldRev="${ref[0]}"
NewRev="${ref[1]}"
RevEmpty="0000000000000000000000000000000000000000"
UserName=${GL_USER}
ProjectName=${GL_REPO}


# Wenn der Skript Pfad vorhanden
# und die master Branch geupdated werden soll
if [ -n "${GitHooksScriptPath}" ] && [ "${MasterBranch}" == "${Branch}" ]; then

	GIT_WORK_TREE=${GitHooksScriptPath} git checkout -f

	find ${GitHooksScriptPath} -type f -exec chmod 640 {} \;
	find ${GitHooksScriptPath} -type d -exec chmod 750 {} \;
	find ${GitHooksScriptPath} -type f -name *.sh -exec chmod 751 {} \;

	echo "GitHooks Project updated"
	LogText="branch update"


# Skript Pfad Variable nicht gesetzt
# loggen und Skript abbrechen
elif [ -z "${GitHooksScriptPath}" ]; then

	LogText="Error: GitHookScriptPath isn't set in file local.conf!"
	echo ${Time}" "${ProjectName}" by "${UserName}": "${LogText}
	die 1 ${LogText}


# Andere Branch
else

	# Pruefe ob Branch geloescht wird
	if [ "${NewRev}" == "${RevEmpty}" ]; then
		LogText="branch delete"

	# Pruefe ob Branch erzeugt wird
	elif [ "$OldRev" == "${RevEmpty}" ]; then
		LogText="branch create"

	# Gebe aus das Branch geupdatet wurde
	else
		LogText="branch update"

	fi
fi


Output=${Time}" "${ProjectName}": "${Branch}" "${LogText}" by "${UserName}


# Ausgaben
echo ${Output}
