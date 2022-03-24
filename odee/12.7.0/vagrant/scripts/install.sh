#!/bin/bash
#
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2022 Oracle and/or its affiliates. All rights reserved.
# 
# Since: July, 2018
# Author: andy.little@oracle.com, gerald.venzl@oracle.com, steven.saunders@oracle.com
# Description: Installs Oracle Database 19c, WebLogic Infra 12.2.1.4, Documaker 12.7.0
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
#

# Abort on any error
set -e

echo 'INSTALLER: Started up'

echo 'INSTALLER: Checking required installation packages...'
# check for required install files.
if [ -f "/vagrant/installs/${ZIP_ORACLEFMW}" ]; then
	echo "/vagrant/installs/${ZIP_ORACLEFMW} found"
else
	echo "INSTALLER: ${ZIP_ORACLEFMW} NOT FOUND. Review README.md for instructions."
	exit 1
fi
if [ -f "/vagrant/installs/${ZIP_ORACLEDB}" ]; then
	echo "/vagrant/installs/${ZIP_ORACLEDB} found"
else
	echo "INSTALLER: ${ZIP_ORACLEDB} NOT FOUND. Review README.md for instructions."
	exit 1
fi
if [ -f "/vagrant/installs/${RPM_JAVA}" ]; then
	echo "/vagrant/installs/${RPM_JAVA} found"
else
	echo "INSTALLER: ${RPM_JAVA} NOT FOUND. Review README.md for instructions."
	exit 1
fi
if [ -f "/vagrant/installs/${ZIP_ODEE}" ]; then
	echo "/vagrant/installs/${ZIP_ODEE} found"
else
	echo "INSTALLER: ${ZIP_ODEE} NOT FOUND. Review README.md for instructions."
	exit 1
fi

# create directories
mkdir -p $ORACLE_HOME
mkdir -p /u01/app
ln -sf $ORACLE_BASE /u01/app/oracle
mkdir -p $ORACLE_BASE/provision
echo 'INSTALLER: Oracle directories created'

# Check swap file size.
if [ -f "/swapfile" ]; then
	echo 'INSTALLER: extra swap file exists.'
else 
	echo "INSTALLER: adjusting swap to $VM_SWAP"
	fallocate -l ${VM_SWAP} /swapfile
	chown root:root /swapfile
	chmod 0600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	swapon -s
	grep -i --color swap /proc/meminfo
	echo "/swapfile none            swap    sw              0       0" >> /etc/fstab
	echo 'INSTALLER: swap adjusted.'
fi

if [ -f "/opt/oracle/provision/sysupdate.txt" ]; then
	echo 'INSTALLER: system update skipped.'
else
	# get up to date
	echo 'INSTALLER: Updating System via yum'
	yum upgrade -y -q
	echo 'INSTALLER: System updated.'

	# fix locale warning	
	yum reinstall -y -q glibc-common
	echo LANG=en_US.utf-8 >> /etc/environment
	echo LC_ALL=en_US.utf-8 >> /etc/environment
	echo 'INSTALLER: Locale set'

	# set system time zone
	sudo timedatectl set-timezone $SYSTEM_TIMEZONE
	echo "INSTALLER: System time zone set to $SYSTEM_TIMEZONE"

	# Install Oracle Database prereq and openssl packages
	echo 'INSTALLER: Installing prerequisites via yum'
	yum install -q -y oracle-database-preinstall-19c openssl nfs-utils xauth curl sysstat-10.1.5 binutils compat-libcap1 compat-libstdc++-33 compat-libstdc++-33.i686 glibc glibc.i686 glibc-devel glibc-devel.i686 ksh libaio libaio.i686 libaio-devel libaio-devel.i686 libX11 libX11.i686 libXau libXau.i686 libXi libXi.i686 libXtst libXtst.i686 xorg-x11-apps xdpyinfo libXp.i686 libXrender.i686  libXp libgcc libgcc.i686 libstdc++ libstdc++.i686 libstdc++-devel libstdc++-devel.i686 libxcb libxcb.i686 make  smartmontools sysstat unixODBC unixODBC-devel libtiff-4.0.3-27.el7_3.i686 	
	echo 'delete this file to rerun system update. '>>/opt/oracle/provision/sysupdate.txt
	echo 'INSTALLER: Prerequisite install complete'
fi

# set environment variables if they don't already exist
if grep -q ORACLE_SID /home/oracle/.bashrc; then
	echo 'INSTALLER: Environment variables previously set; retaining.'
else
	echo "export ORACLE_BASE=$ORACLE_BASE" >> /home/oracle/.bashrc
	echo "export ORACLE_HOME=$ORACLE_HOME" >> /home/oracle/.bashrc
	echo "export ORACLE_SID=$ORACLE_SID" >> /home/oracle/.bashrc
	echo "export PATH=\$PATH:\$ORACLE_HOME/bin" >> /home/oracle/.bashrc
	echo 'INSTALLER: Environment variables set'
fi

# Install Oracle
if [ -f "/opt/oracle/provision/oracledb.txt" ]; then
	echo "INSTALLER: Database setup skipped."
else

	if [ -f "/opt/oracle/provision/oracledb-step1.txt" ]; then
		echo "INSTALLER: Database unpack skipped."
	else
		echo "INSTALLER: Unpacking database."
		unzip -qn "/vagrant/installs/$ZIP_ORACLEDB" -d $ORACLE_HOME/
		cp /vagrant/ora-response/db_install.rsp.tmpl /vagrant/ora-response/db_install.rsp
		sed -i -e "s|###ORACLE_BASE###|$ORACLE_BASE|g" /vagrant/ora-response/db_install.rsp
		sed -i -e "s|###ORACLE_HOME###|$ORACLE_HOME|g" /vagrant/ora-response/db_install.rsp
		sed -i -e "s|###ORACLE_EDITION###|$ORACLE_EDITION|g" /vagrant/ora-response/db_install.rsp
		chown oracle:oinstall -R $ORACLE_BASE

		echo "INSTALLER: Installing database."
		su -l oracle -c "yes | $ORACLE_HOME/runInstaller -silent -ignorePrereqFailure -waitforcompletion -responseFile /vagrant/ora-response/db_install.rsp"
		$ORACLE_BASE/oraInventory/orainstRoot.sh
		$ORACLE_HOME/root.sh
		rm /vagrant/ora-response/db_install.rsp
		su -l oracle -c "echo 'delete this file to unpack and setup database'>>/opt/oracle/provision/oracledb-step1.txt"
		echo 'INSTALLER: Database installed'
	fi
	if [ -f "/opt/oracle/provision/db-step2.txt" ]; then
		echo "INSTALLER: Listener setup skipped."
	else
	
		# create sqlnet.ora, listener.ora and tnsnames.ora
		su -l oracle -c "mkdir -p $ORACLE_HOME/network/admin"
		su -l oracle -c "echo 'NAME.DIRECTORY_PATH= (TNSNAMES, EZCONNECT, HOSTNAME)' > $ORACLE_HOME/network/admin/sqlnet.ora"

		# Listener.ora
		su -l oracle -c "echo 'LISTENER = (DESCRIPTION = (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1))(ADDRESS=(PROTOCOL=TCP)(HOST= 0.0.0.0)(PORT = $LISTENER_PORT)))' > $ORACLE_HOME/network/admin/listener.ora"
		su -l oracle -c "echo 'DEDICATED_THROUGH_BROKER_LISTENER=ON' >> $ORACLE_HOME/network/admin/listener.ora"
		su -l oracle -c "echo 'DIAG_ADR_ENABLED = off' >> $ORACLE_HOME/network/admin/listener.ora"
		

		su -l oracle -c "echo '$ORACLE_SID=localhost:$LISTENER_PORT/$ORACLE_SID' > $ORACLE_HOME/network/admin/tnsnames.ora"
		su -l oracle -c "echo '$ORACLE_PDB=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=0.0.0.0)(PORT= $LISTENER_PORT))(CONNECT_DATA=(SERVER = DEDICATED)(SERVICE_NAME=$ORACLE_PDB)))' >> $ORACLE_HOME/network/admin/tnsnames.ora"

		# Start LISTENER
		su -l oracle -c "lsnrctl start"
		su -l oracle -c "echo 'delete this file to setup listener database'>>/opt/oracle/provision/oracledb-step2.txt"
		echo 'INSTALLER: Listener created'
	fi
	# Create database
	if [ -f "/opt/oracle/provision/oracledb-step3.txt" ]; then
		echo "INSTALLER: CDB/PDB setup skipped."
	else    
		# Auto generate ORACLE PWD if not passed on
		export ORACLE_PWD=${ORACLE_PWD:-"`openssl rand -base64 9`1"}
		echo "INSTALLER: ORACLE_PWD set to $ORACLE_PWD"

		cp /vagrant/ora-response/dbca.rsp.tmpl /vagrant/ora-response/dbca.rsp
		sed -i -e "s|###ORACLE_SID###|$ORACLE_SID|g" /vagrant/ora-response/dbca.rsp
		sed -i -e "s|###ORACLE_PDB###|$ORACLE_PDB|g" /vagrant/ora-response/dbca.rsp
		sed -i -e "s|###ORACLE_CHARACTERSET###|$ORACLE_CHARACTERSET|g" /vagrant/ora-response/dbca.rsp
		sed -i -e "s|###ORACLE_PWD###|$ORACLE_PWD|g" /vagrant/ora-response/dbca.rsp
		sed -i -e "s|###EM_EXPRESS_PORT###|$EM_EXPRESS_PORT|g" /vagrant/ora-response/dbca.rsp

		# Create DB
		su -l oracle -c "dbca -silent -createDatabase -responseFile /vagrant/ora-response/dbca.rsp"

		# Post DB setup tasks
		su -l oracle -c "sqlplus / as sysdba <<EOF
ALTER PLUGGABLE DATABASE $ORACLE_PDB SAVE STATE;
EXEC DBMS_XDB_CONFIG.SETGLOBALPORTENABLED (TRUE);
ALTER SYSTEM SET LOCAL_LISTENER = '(ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = $LISTENER_PORT))' SCOPE=BOTH;
ALTER SYSTEM REGISTER;
exit;
EOF"
		rm /vagrant/ora-response/dbca.rsp
		su -l oracle -c "echo 'delete this file to set CDB/PDB databases'>>/opt/oracle/provision/oracledb-step3.txt"
		echo 'INSTALLER: Database created'
	fi
	if [ -f "/opt/oracle/provision/oracledb-step4.txt" ]; then
		echo "INSTALLER: System registration skipped."
	else   
		sed -i -e "\$s|${ORACLE_SID}:${ORACLE_HOME}:N|${ORACLE_SID}:${ORACLE_HOME}:Y|" /etc/oratab
		echo 'INSTALLER: Oratab configured'

		# configure systemd to start oracle instance on startup
		sudo cp /vagrant/scripts/oracle-rdbms.service /etc/systemd/system/
		sudo sed -i -e "s|###ORACLE_HOME###|$ORACLE_HOME|g" /etc/systemd/system/oracle-rdbms.service
		sudo systemctl daemon-reload
		sudo systemctl enable oracle-rdbms
		sudo systemctl start oracle-rdbms
		echo "INSTALLER: Created and enabled oracle-rdbms systemd's service"

		sudo cp /vagrant/scripts/setPassword.sh /home/oracle/
		sudo chmod a+rx /home/oracle/setPassword.sh
		echo "INSTALLER: setPassword.sh file setup";
		su -l oracle -c "echo 'delete this file to register system services.'>>/opt/oracle/db-step4.txt"
		echo "ORACLE PASSWORD FOR SYS, SYSTEM AND PDBADMIN: $ORACLE_PWD";
	fi
	su -l oracle -c "echo 'delete this file to reinstall'>>/opt/oracle/provision/oracledb.txt"
fi 

# Install JDK 1.8
if [ -f "/opt/oracle/provision/jdk.txt" ]; then
	echo 'INSTALLER: JDK is already installed'
else
	rpm -ivh /vagrant/installs/${RPM_JAVA}
	su -l oracle -c "echo 'delete this file to reinstall JDK'>>/opt/oracle/provision/jdk.txt"
	echo 'INSTALLER: JDK installed'
fi

# Install FMW Infra
if [ -f "/opt/oracle/provision/weblogic.txt" ]; then
	 echo "INSTALLER: WebLogic installation skipped."
else
	# Setup password if not already provided.
	export WLS_PWD=${WLS_PWD:-"`openssl rand -base64 9`1"}
	echo "INSTALLER: PASSWORD FOR WebLogic : $WLS_PWD";
	export ODEE_HOME=$ORACLE_BASE/applications/odee

	# create directories
	mkdir -p $MW_HOME
	mkdir -p $ORACLE_BASE/domains
	mkdir -p $ODEE_HOME	
	chown oracle:oinstall $MW_HOME
	chown oracle:oinstall $ORACLE_BASE/domains
	chown oracle:oinstall $ODEE_HOME	
	echo 'INSTALLER: Domain directories created'

	# set environment variables
	if grep -q ODEE_HOME /home/oracle/.bashrc; then
		echo 'INSTALLER: Environment variables previously set; retaining.'
	else
		echo "export PATH=\$PATH:\$ORACLE_HOME/bin" >> /home/oracle/.bashrc
		echo "export MW_HOME=$MW_HOME" >> /home/oracle/.bashrc
		echo "export WLS_HOME=$MW_HOME/wlserver" >> /home/oracle/.bashrc
		echo "export WL_HOME=$WLS_HOME" >> /home/oracle/.bashrc
		echo "export JAVA_HOME=$JAVA_PATH" >> /home/oracle/.bashrc
		echo "export JAVA_HOME=$JAVA_PATH" >> /root/.bashrc
		echo "export PATH=$JAVA_HOME/bin:\$PATH" >> /home/oracle/.bashrc
		echo "export ODEE_HOME=$ODEE_HOME" >> /home/oracle/.bashrc		
		echo 'INSTALLER: Environment variables set'
	fi
	
	if [ -f "/opt/oracle/provision/weblogic-step1.txt" ]; then
		 echo "INSTALLER: WebLogic installation skipped. Delete /opt/oracle/provision/weblogic-step1.txt to reprovision."
	else
		# Install WLS
		echo "INSTALLER: Installing WebLogic"
		unzip -qn "/vagrant/installs/${ZIP_ORACLEFMW}" -d /home/oracle
		chown oracle:oinstall -R /home/oracle
		cp /vagrant/ora-response/wls.rsp.tmpl /vagrant/ora-response/wls.rsp
		sed -i -e "s|###MW_HOME###|$MW_HOME|g" /vagrant/ora-response/wls.rsp
		# fix oraInv permissions, which were weird for some reason.
		chown oracle:oinstall -R "$ORACLE_BASE/oraInventory"
		su -l oracle -c "java -jar $JAR_ORACLEFMW -silent -responseFile /vagrant/ora-response/wls.rsp -invPtrLoc $ORACLE_BASE/oraInventory/oraInst.loc"
		su -l oracle -c "echo 'delete this file to reinstall WebLogic. Note you may need to manually remove everything that was created to redo this step!'>>/opt/oracle/provision/weblogic-step1.txt"
		rm /vagrant/ora-response/wls.rsp
		echo 'INSTALLER: WebLogic installed.'		
	
	fi
	su -l oracle -c "echo 'delete this file to reinstall WebLogic. Note you may need to manually remove everything that was created to redo this step!'>>/opt/oracle/provision/weblogic.txt"
fi 
# Install ODEE
if [ -f "/opt/oracle/provision/odee.txt" ]; then
	echo "INSTALLER: ODEE installation skipped. Delete /opt/oracle/provision/odee.txt to attempt reprovision steps."

else
	echo "INSTALLER: Installing ODEE"
	# set up passwords if not already provisioned
	export ODEE_PWD=${ODEE_PWD:-"`openssl rand -base64 9`1"}
	export ODEE_SCHEMA_PWD=${ODEE_SCHEMA_PWD:-"`openssl rand -base64 9`1"}

	unzip -qn "/vagrant/installs/${ZIP_ODEE}" -d /home/oracle
	cp /vagrant/ora-response/odee.rsp.tmpl /home/oracle/odee.rsp

	sed -i -e "s|###ODEE_HOME###|$ODEE_HOME|g" /home/oracle/odee.rsp	
	sed -i -e "s|###ODEE_PWD###|$ODEE_PWD|g" /home/oracle/odee.rsp	
	sed -i -e "s|###LISTENER_PORT###|$LISTENER_PORT|g" /home/oracle/odee.rsp	
	sed -i -e "s|###ORACLE_PDB###|$ORACLE_PDB|g" /home/oracle/odee.rsp	
	sed -i -e "s|###ODEE_SCHEMA_PWD###|$ODEE_SCHEMA_PWD|g" /home/oracle/odee.rsp	
	sed -i -e "s|###WLS_PWD###|$WLS_PWD|g" /home/oracle/odee.rsp	
	sed -i -e "s|###MW_PORT_ADMIN###|$MW_PORT_ADMIN|g" /home/oracle/odee.rsp	
	sed -i -e "s|###ODEE_DOMAIN###|$ODEE_DOMAIN|g" /home/oracle/odee.rsp	
	sed -i -e "s|###ORACLE_BASE###|$ORACLE_BASE|g" /home/oracle/odee.rsp	
	sed -i -e "s|###MW_PORT_JMS###|$MW_PORT_JMS|g" /home/oracle/odee.rsp	

	chown oracle:oinstall -R /home/oracle
	chown oracle:oinstall -R $ORACLE_BASE/oraInventory
	
	su -l oracle -c "/home/oracle/Disk1/runInstaller -silent -responseFile /home/oracle/odee.rsp -jreLoc /usr/java/jdk1.8.0_311-amd64/jre -invPtrLoc $ORACLE_BASE/oraInventory/oraInst.loc"
	
	# rm /home/oracle/odee.rsp
	
	echo 'INSTALLER: ODEE installed.'		
	
	su -l oracle -c "echo 'delete this file to reinstall ODEE. Note you may need to manually remove everything that was created to redo this step!'>>/opt/oracle/provision/odee.txt"
fi

# run user-defined post-setup scripts
# echo 'INSTALLER: Running user-defined post-setup scripts'

# for f in /vagrant/userscripts/*
# 	do
# 		case "${f,,}" in
# 			*.sh)
# 				echo "INSTALLER: Running $f"
# 				. "$f"
# 				echo "INSTALLER: Done running $f"
# 				;;
# 			*.sql)
# 				echo "INSTALLER: Running $f"
# 				su -l oracle -c "echo 'exit' | sqlplus -s / as sysdba @\"$f\""
# 				echo "INSTALLER: Done running $f"
# 				;;
# 			/vagrant/userscripts/put_custom_scripts_here.txt)
# 				:
# 				;;
# 			*)
# 				#echo "INSTALLER: Ignoring $f"
# 				;;
# 		esac
# 	done

# echo 'INSTALLER: Done running user-defined post-setup scripts'

echo "INSTALLER: Installation complete, ODEE system ready to use!";
