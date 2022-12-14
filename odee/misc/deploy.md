# Deploy/Undeploy
Simple shell scripts will assist in quickly deploying and undeploying specific workers on a DocFactory node.

## deploy
Copy/paste this into a file, e.g. `ODEE_HOME/docfactory/bin/scripts/deploy`. Verify that the DEPLOY path is correct.
```
#!/bin/bash
DEPLOY=/path/to/odee/documaker/docfactory/deploy
STASHDIR=${DEPLOY}/tmp
THEFILE=${STASHDIR}/$1.jar
if [ -f ${THEFILE} ]; then
        echo "Deploying $1..."
        mv ${THEFILE} ${DEPLOY}
else
    	echo "$1 is not stashed; nothing to do."
fi
echo "Done."
```

## undeploy
Copy/paste this into a file, e.g. `ODEE_HOME/docfactory/bin/scripts/undeploy`. Verify that the DEPLOY path is correct.
```
#!/bin/bash
DEPLOY=/path/to/odee/documaker/docfactory/deploy
STASHDIR=${DEPLOY}/tmp
THEFILE=${DEPLOY}/$1.jar
if [ -f ${THEFILE} ]; then
        echo "Undeploying $1..."
        mkdir -p ${STASHDIR}
        mv ${THEFILE} ${STASHDIR}
else
    	# file is not deployed
        echo "$1 is not deployed; nothing to do."
fi
echo "Done."
```

## Setup
Modify the user's path to include the location of the scripts. Depending on the shell, you can add this to `~/.bashrc`, `~/.cshrc` or similar
using the following:
* bash (in `~/.bashrc`): `export PATH=$PATH:/path/to/docfactory/bin/scripts`
* csh (in `~/.cshrc`) : `set path = ($path /path/to/docfactory/bin/scripts)`

## Use
Simply issue the command with the short name of the JAR you want to undeploy/deploy:
* `$ deploy assembler`, which will move `assembler.jar` from the `stash` directory (`/path/to/docfactory/deploy/tmp`) into the `deploy` directory.
* `$ undeploy historian`, which will move `historian.jar` from the `deploy` directory into the `stash` directory. 
You do not need to append `.jar` to the filename, but be aware that it is case-sensitive, so `historian` will work, but `HiStoriAn` will not.

