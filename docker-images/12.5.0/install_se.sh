#/bin/bash
# LICENSE CDDL 1.0 + GPL 2.0
#
# Copyright (c) 2017 Oracle and/or its affiliates. All rights reserved.
#
# Since: May, 2017
# Author: andy.little@oracle.com
# Description: Documaker SE Installation script
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 
VERSION=$1

# Useful variables.
# ORACLE_HOME=/u01/oracle \
# INSTALL_FILE_1="V137964-01.zip" \
# RUN_FILE="runDocumaker.sh" \
# INSTALL_BINARIES_FILE="install_se.sh"
# INSTALL_DIR=$ORACLE_HOME/install \
# PATH=$ORACLE_HOME/rel125/bin:/usr/sbin:$PATH \
# LD_LIBRARY_PATH=$ORACLE_HOME/rel125/bin:/usr/lib
# EDITION (se or ee)

# From INSTALL_FILE_1
INSTALL_1=setuprterp125p00b29909.lnx
INSTALL_2=setupsdkrp125p00b29909.lnx
INSTALL_3=sharedobjs125p00b29909.lnx

# From INSTALL_FILE_2
#INSTALL_4=setuprteids028p00b3239.lnx
#INSTALL_5=sharedobjs125p00b29909.lnx

# install Documaker

cd $ORACLE_HOME			&& \
unzip $INSTALL_FILE_1 		&& \
rm -rf ./Readme.html		&& \
rm $INSTALL_FILE_1		&& \
chmod ug+x *.lnx		&& \
export iloc=$ORACLE_HOME/rel125 && \
echo y| ./$INSTALL_1 $ORACLE_HOME/rel125 && \
rm -rf ./$INSTALL_1		&& \
# SDK should not be needed for basic installation.
# however can uncomment here for installation.
# Note: it hasn't been tested to install properly.`
#echo y | ./$INSTALL_2 	&& \
rm -rf ./$INSTALL_2 	&& \
# Shared objects not needed until IDS is installed, skip this one.
rm -rf ./$INSTALL_3	

# install MRL samples
cd $ORACLE_HOME			&& \
unzip "$INSTALL_FILE_3"		&& \
cd "Microsoft Windows"		&& \
unzip dms1.zip			&& \
chmod ug+x dms1/*.sh		&& \
mv dms1 $ORACLE_HOME/rel125/mstrres && \
cd ..				&& \
rm -rf "Microsoft Windows"	&& \
rm "$INSTALL_FILE_3"	

#### Right now, we aren't including IDS in this.
#### TODO for next cut....
# install IDS
# unzip $INSTALL_FILE_2		&& \
# rm $INSTALL_FILE_2		&& \
# rm -rf ./Readme.html		&& \
# chmod ug+x *.lnx	
# ./$INSTALL_4 $ORACLE_HOME/rel125/docupresentment
# run install_5
# rm install_4
# rm install_5	

