#!/bin/bash
####################################
####################################
##                                ##
##  GitHook Update Script         ##
##                                ##
##  Script Version 0.0.7          ##
##                                ##
####################################
####################################

# Script variables
Time=$(date +%d.%m.%Y" "%H:%M)

# Export configuration values into shell environment
while read Line; do
    Line=${Line//=/ }
    Var=(${Line})
    export ${Var[0]}=${Var[1]}
done < ${ConfigFile}local.conf


# Read Git parameters
if ! [ -t 0 ]; then
  read -a ref
fi

# Extract sheel script variables
IFS='/' read -ra REF <<< "${ref[2]}"
Branch="${REF[2]}"
Branch="${REF[2]}"
OldRev="${ref[0]}"
NewRev="${ref[1]}"
RevEmpty="0000000000000000000000000000000000000000"
UserName=${GL_USER}
ProjectName=${GL_REPO}


# if script pfad was found
# and the master branch should be updated
if [ -n "${GitHooksScriptPath}" ] && [ "${MasterBranch}" == "${Branch}" ]; then

	GIT_WORK_TREE=${GitHooksScriptPath} git checkout -f

	find ${GitHooksScriptPath} -type f -exec chmod 640 {} \;
	find ${GitHooksScriptPath} -type d -exec chmod 750 {} \;
	find ${GitHooksScriptPath} -type f -name *.sh -exec chmod 751 {} \;

	rm ${GitHooksScriptPath}.gitignore > /dev/null 2> /dev/null
	rm ${GitHooksScriptPath}LICENSE > /dev/null 2> /dev/null
	rm ${GitHooksScriptPath}README.md > /dev/null 2> /dev/null
	rm ${GitHooksScriptPath}Projects/README.md > /dev/null 2> /dev/null

	echo "GitHooks Project updated"
	LogText="update"


# Script path variable is not set
# log it and exit
elif [ -z "${GitHooksScriptPath}" ]; then

	LogText="Error: GitHookScriptPath isn't set in file local.conf!"
	echo ${Time}" "${ProjectName}" by "${UserName}": "${LogText}
	die 1 ${LogText}


# Other branch
else

	# Pruefe ob Branch geloescht wird
	if [ "${NewRev}" == "${RevEmpty}" ]; then
		LogText="delete"

	# Pruefe ob Branch erzeugt wird
	elif [ "$OldRev" == "${RevEmpty}" ]; then
		LogText="create"

	# Gebe aus das Branch geupdatet wurde
	else
		LogText="update"

	fi
fi

# Output message
Output=${Time}" "${ProjectName}": "${LogText}" "${Branch}" by "${UserName}
echo ${Output} >> ~/hook.log
echo ${Output}