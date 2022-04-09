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
	## Note >> oracle user does not exist until after this step.
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
	echo "export ODEE_HOME=$ODEE_HOME" >> /home/oracle/.bashrc
	#chown oracle:oinstall $ODEE_HOME
	echo "export PATH=\$PATH:\$ORACLE_HOME/bin" >> /home/oracle/.bashrc

	echo "export DISPLAY=127.0.0.1:10.0" >> /home/vagrant/.bashrc
	echo "export DISPLAY=127.0.0.1:10.0" >> /home/oracle/.bashrc
	
	echo 'INSTALLER: Environment variables set'
fi

# Install Apache DS
if [ -f "/opt/oracle/provision/apacheds.txt" ]; then	
	echo "INSTALLER: ApacheDS installation skipped."
else
	wget -q -O ~/apacheds.rpm "https://dlcdn.apache.org//directory/apacheds/dist/2.0.0.AM26/apacheds-2.0.0.AM26-x86_64.rpm"
	yum -y localinstall ~/apacheds.rpm
	/etc/init.d/apacheds-2.0.0.AM26-default start
	chkconfig --add /etc/init.d/apacheds-2.0.0.AM26-default
	chkconfig --level 2345 apacheds-2.0.0.AM26-default on
	su -l oracle -c "echo 'delete this file to redploy ApacheDS '>>/opt/oracle/provision/apacheds.txt"
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
		export ORACLE_PWD=`echo $ORACLE_PWD| tr -dc '[:alnum:]'`
		if grep -q VM_ORACLE_PWD /vagrant/.env.local; then
			# do nothing
			echo "INSTALLER: ORACLE_PWD already stored in .env.local"
		else
			echo "VM_ORACLE_PWD=\"${ORACLE_PWD}\"" >> /vagrant/.env.local
		fi

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
		su -l oracle -c "echo 'delete this file to register system services.'>>/opt/oracle/provision/db-step4.txt"
		echo "ORACLE PASSWORD FOR SYS, SYSTEM AND PDBADMIN: $ORACLE_PWD";
	fi
	su -l oracle -c "echo 'delete this file to reinstall'>>/opt/oracle/provision/oracledb.txt"
fi 

# Install JDK 1.8
if [ -f "/opt/oracle/provision/jdk.txt" ]; then
	echo 'INSTALLER: JDK is already installed'
else
	rpm -ivh /vagrant/installs/${RPM_JAVA}
	echo "export JAVA_HOME=$JAVA_PATH" >> /home/oracle/.bashrc
	echo "export PATH=${JAVA_HOME}/bin:\$PATH" >> /home/oracle/.bashrc
	su -l oracle -c "echo 'delete this file to reinstall JDK'>>/opt/oracle/provision/jdk.txt"
	echo 'INSTALLER: JDK installed'
fi

# Install FMW Infra
if [ -f "/opt/oracle/provision/weblogic.txt" ]; then
	 echo "INSTALLER: WebLogic installation skipped."
else
	# Setup password if not already provided.
	export WLS_PWD=${WLS_PWD:-"`openssl rand -base64 9`1"}
	export WLS_PWD=`echo $WLS_PWD| tr -dc '[:alnum:]'`

	if grep -q VM_WLS_PWD /vagrant/.env.local; then
		# do nothing
		echo "INSTALLER: WLS_PWD already stored in .env.local"
	else
		echo "VM_WLS_PWD=\"${ORACLE_PWD}\"" >> /vagrant/.env.local
	fi

	echo "INSTALLER: PASSWORD FOR WebLogic : $WLS_PWD";
	export WLS_ODEE_HOME=$ORACLE_BASE/applications/odee

	# create directories
	mkdir -p $MW_HOME
	mkdir -p $ORACLE_BASE/domains
	mkdir -p $WLS_ODEE_HOME	
	chown oracle:oinstall $MW_HOME
	chown oracle:oinstall $ORACLE_BASE/domains
	chown oracle:oinstall $WLS_ODEE_HOME	
	echo 'INSTALLER: Domain directories created'

	# set environment variables
	if grep -q "ODEE_HOME" /home/oracle/.bashrc; then
		echo 'INSTALLER: Environment variables previously set; retaining.'
	else
		echo "export PATH=\$PATH:\$ORACLE_HOME/bin" >> /home/oracle/.bashrc
		echo "export MW_HOME=$MW_HOME" >> /home/oracle/.bashrc
		echo "export WLS_HOME=$MW_HOME/wlserver" >> /home/oracle/.bashrc
		echo "export WL_HOME=$WLS_HOME" >> /home/oracle/.bashrc
		echo "export JAVA_HOME=$JAVA_PATH" >> /home/oracle/.bashrc
		echo "export JAVA_HOME=$JAVA_PATH" >> /root/.bashrc
		echo "export PATH=$JAVA_HOME/bin:\$PATH" >> /home/oracle/.bashrc
		echo "export WLS_ODEE_HOME=$WLS_ODEE_HOME" >> /home/oracle/.bashrc		
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
	# note we have to wrangle passwords because the installer has weird limitations on PWD characters.
	export ODEE_PWD=${ODEE_PWD:-"`openssl rand -base64 9`1"}
	export ODEE_PWD=`echo $ODEE_PWD| tr -dc '[:alnum:]'`
	if grep -q "VM_ODEE_PWD" /vagrant/.env.local; then
		# do nothing
		echo "INSTALLER: ODEE_PWD already stored in .env.local"
	else
		echo "VM_ODEE_PWD=\"${ODEE_PWD}\"" >> /vagrant/.env.local
	fi
	# have to prefix with alpha otherwise DB scripts complain.
	export ODEE_SCHEMA_PWD=${ODEE_SCHEMA_PWD:-"a`openssl rand -base64 9`1"}
	export ODEE_SCHEMA_PWD=`echo $ODEE_SCHEMA_PWD| tr -dc '[:alnum:]'`
	
	if grep -q "VM_ODEE_SCHEMA_PWD" /vagrant/.env.local; then
		# do nothing
		echo "INSTALLER: WLS_PWD already stored in .env.local"
	else
		echo "VM_ODEE_SCHEMA_PWD=\"${ODEE_SCHEMA_PWD}\"" >> /vagrant/.env.local
	fi

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
	
	echo "INSTALLER: running /home/oracle/Disk1/runInstaller -silent -force -waitforcompletion -ignoreSysPrereqs -responseFile /home/oracle/odee.rsp -jreLoc ${JAVA_PATH}/jre -invPtrLoc ${ORACLE_BASE}/oraInventory/oraInst.loc"	
	su -l oracle -c "/home/oracle/Disk1/runInstaller -waitforcompletion -silent -force -ignoreSysPrereqs -responseFile /home/oracle/odee.rsp -jreLoc ${JAVA_PATH}/jre -invPtrLoc ${ORACLE_BASE}/oraInventory/oraInst.loc"

	if [ -f /opt/oracle/odee/documaker ]; then
		echo 'INSTALLER: ODEE installation failed.'
		exit 2
	else
		echo .
		rm /home/oracle/odee.rsp
		echo 'INSTALLER: ODEE installed.'
		su -l oracle -c "echo 'delete this file to reinstall ODEE. Note you may need to manually remove everything that was created to redo this step'>>/opt/oracle/provision/odee.txt"
	fi
fi

# Provision database artifacts for ODEE
if [ -f "/opt/oracle/provision/odee-1.txt" ]; then
	echo "INSTALLER: ODEE database provision skipped. Delete /opt/oracle/provision/odee-1.txt to attempt reprovision steps."
else
	echo "INSTALLER: Creating ODEE database artifacts."

	su -l oracle -c "cd $ODEE_HOME/documaker/database/oracle11g && sqlplus / as sysdba <<EOF
alter session set container=orclpdb1;
spool /home/oracle/odee_install_sql.log
@dmkr_admin.sql
@dmkr_asline.sql
@dmkr_admin_user_examples.sql
spool off
EOF"
	su -l oracle -c "cd $ODEE_HOME/documaker/mstrres/dmres && ./deploysamplemrl.sh"
	
	echo 'INSTALLER: ODEE database artifacts provisioned.'			
	su -l oracle -c "echo 'delete this file to provision ODEE database artifacts. You will need to manually drop existing users/schemas/datafiles to redo this step'>>/opt/oracle/provision/odee-1.txt"
fi

# # Run RCU
# if [ -f "/opt/oracle/provision/odee-2.txt" ]; then
# 	echo "INSTALLER: ODEE RCU provision skipped. Delete /opt/oracle/provision/odee-2.txt to attempt reprovision steps."
# else
# 	echo "INSTALLER: Running RCU."

# 	cp /vagrant/ora-response/rcu.rsp.tmpl /home/oracle/rcu.properties

# 	sed -i -e "s|###LISTENER_PORT###|$LISTENER_PORT|g" /home/oracle/rcu.properties
# 	sed -i -e "s|###ORACLE_PDB###|$ORACLE_PDB|g" /home/oracle/rcu.properties
	
# 	su -l oracle -c "$MW_HOME/oracle_common/bin/rcu -silent -responseFile /home/oracle/rcu.properties<<EOF
# $ORACLE_PWD
# $ODEE_SCHEMA_PWD
# EOF"
	
# 	echo "INSTALLER: RCU completed. Schema prefix is DEV and password is $ODEE_SCHEMA_PWD"
# 	su -l oracle -c "echo 'delete this file to rerun RCU. You must manually remove the existing artifacts.'>>/opt/oracle/provision/odee-2.txt"
# fi

if [ -f "/opt/oracle/provision/odee-3.txt" ]; then
 	echo "INSTALLER: ODEE Domain provision skipped. Delete /opt/oracle/provision/odee-3.txt to attempt reprovision steps."
 else

	echo "INSTALLER: Deploying WebLogic domain for ODEE."

	
	if [ -f /opt/oracle/weblogic-deploy/bin/createDomain.sh ]; then
		echo "INSTALLER: Found WebLogic Deploy Tooling."
	else
		echo "INSTALLER: Getting WebLogic Deploy Tooling."
		rm -rf /opt/oracle/weblogic-deploy
		wget -q -O /opt/oracle/wdt.zip "https://github.com/oracle/weblogic-deploy-tooling/releases/download/release-2.1.1/weblogic-deploy.zip"
		unzip -qn /opt/oracle/wdt.zip -d /opt/oracle
	fi

	cp /vagrant/ora-response/OdeeDomainModel.properties /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.properties
	cp /vagrant/ora-response/OdeeDomainModel.json /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json

	chown oracle:oinstall -R /opt/oracle

	sed -i -e "s|###WLS_PWD###|$WLS_PWD|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.properties
	sed -i -e "s|###ODEE_SCHEMA_PWD###|$ODEE_SCHEMA_PWD|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.properties

	sed -i -e "s|###JAVA_HOME###|$JAVA_PATH|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json
	sed -i -e "s|###ORACLE_PDB###|$ORACLE_PDB|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json
	sed -i -e "s|###ODEE_SCHEMA_PWD###|$ODEE_SCHEMA_PWD|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json
	
	sed -i -e "s|###ODEE_HOME###|$ODEE_HOME|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json
	sed -i -e "s|###ODEE_PWD###|$ODEE_PWD|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json	
	sed -i -e "s|###LISTENER_PORT###|$LISTENER_PORT|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json
	
	sed -i -e "s|###MW_PORT_ADMIN###|$MW_PORT_ADMIN|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json
	sed -i -e "s|###MW_PORT_DMKR###|$MW_PORT_DMKR|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json	
	sed -i -e "s|###MW_PORT_JMS###|$MW_PORT_JMS|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json

	sed -i -e "s|###MW_SSLPORT_ADMIN###|$MW_SSLPORT_ADMIN|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json	
	sed -i -e "s|###MW_SSLPORT_JMS###|$MW_SSLPORT_JMS|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json
	sed -i -e "s|###MW_SSLPORT_DMKR###|$MW_SSLPORT_DMKR|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json
	
	sed -i -e "s|###ODEE_DOMAIN###|$ODEE_DOMAIN|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json
	sed -i -e "s|###ORACLE_BASE###|$ORACLE_BASE|g" /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json
	
	su -l oracle -c "export MODEL_PWD=$ORACLE_PWD && ~/weblogic-deploy/bin/encryptModel.sh -passphrase_env MODEL_PWD -model_file /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json -variable_file /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.properties -oracle_home $MW_HOME"	
	su -l oracle -c "export WLSDEPLOY_PROPERTIES=-Dwlsdeploy.debugToStdout=true && export MODEL_PWD=$ORACLE_PWD && ~/weblogic-deploy/bin/createDomain.sh -model_file /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.json -variable_file /opt/oracle/weblogic-deploy/bin/OdeeDomainModel.properties -domain_home $ORACLE_BASE/domains/$ODEE_DOMAIN -oracle_home $MW_HOME -domain_type JRF -java_home $JAVA_PATH -run_rcu -rcu_db localhost:$LISTENER_PORT/$ORACLE_PDB -rcu_prefix DEV -rcu_db_user sys -passphrase_env MODEL_PWD <<EOF
$ORACLE_PWD
$ODEE_SCHEMA_PWD
EOF"
	# su -l oracle -c "echo 'delete this file to provision WebLogic ODEE domain. You must manually remove the existing domain artifacts.'>>/opt/oracle/provision/odee-3.txt"
	echo "INSTALLER: WebLogic domain deployed."
fi
# Create WebLogic domain
# if [ -f "/opt/oracle/provision/odee-3.txt" ]; then
# 	echo "INSTALLER: ODEE WebLogic  domain provision skipped. Delete /opt/oracle/provision/odee-2.txt to attempt reprovision steps."
# else
	# echo "INSTALLER: Deploying WebLogic domain for ODEE."

	# echo "INSTALLER: Getting WebLogic Deploy Tooling."
	# wget -q -O /home/oracle/wdt.zip "https://github.com/oracle/weblogic-deploy-tooling/releases/download/release-2.1.1/weblogic-deploy.zip"
	# unzip /home/oracle/wdt.zip -d /home/oracle
	# chown oracle:oinstall -R /home/oracle

	# su -l oracle -c "~/weblogic-deploy/bin/createDomain.cmd -oracle_home c:\wls12213 -domain_type WLS -domain_parent d:\demo\domains -model_file MinimalDemoDomain.yaml	"

	# cp $ODEE_HOME/documaker/j2ee/weblogic/oracle11g/scripts/weblogic_installation.properties $ODEE_HOME/documaker/j2ee/weblogic/oracle11g/scripts/weblogic_installation.tmpl

# 	sed -i -e "s|jdbcAdminPassword='<SECURE VALUE>'|jdbcAdminPassword=$ODEE_SCHEMA_PWD|g" $ODEE_HOME/documaker/j2ee/weblogic/oracle11g/scripts/weblogic_installation.properties
# 	sed -i -e "s|jdbcAslinePassword='<SECURE VALUE>'|jdbcAslinePassword=$ODEE_SCHEMA_PWD|g" $ODEE_HOME/documaker/j2ee/weblogic/oracle11g/scripts/weblogic_installation.properties
# 	sed -i -e "s|jmsCredential='<SECURE VALUE>'|jmsCredential=$WLS_PWD|g" $ODEE_HOME/documaker/j2ee/weblogic/oracle11g/scripts/weblogic_installation.properties
# 	sed -i -e "s|adminPasswd='<SECURE VALUE>'|adminPasswd=$ODEE_PWD|g" $ODEE_HOME/documaker/j2ee/weblogic/oracle11g/scripts/weblogic_installation.properties
# 	sed -i -e "s|weblogicPassword='<SECURE VALUE>'|weblogicPassword=$WLS_PWD|g" $ODEE_HOME/documaker/j2ee/weblogic/oracle11g/scripts/weblogic_installation.properties

# 	cp /vagrant/scripts/wls.py $ODEE_HOME/documaker/j2ee/weblogic/oracle11g/scripts/wls_create_domain_silent.py
# 	chown oracle:oinstall -R $ODEE_HOME/documaker/j2ee/weblogic/oracle11g/scripts

# 	# WebLogic domain creation routine included with base product uses WLS config.sh,
# 	# which invokes the FMW Domain Config tool -- which has no silent mode.
# 	# Therefore we have to use WLST-based scripting to create the domain,
# 	# then invoke the add clustered environment script to deploy Documaker artifacts.
# 	# This is the Method #1 described in the documentaiton. https://docs.oracle.com/cd/F51808_01/DEIG/Content/post-setup.htm

# 	rm -rf /opt/oracle/domains/odee 
# #wls_extend_clustered_server_interactive.sh
# 	su -l oracle -c "$ODEE_HOME/documaker/j2ee/weblogic/oracle11g/scripts && $MW_HOME/oracle_common/common/bin/wlst.sh wls_create_domain_silent.py && ./wls_extended_clustered_server.sh<<EOF
# n
# y

# EOF"

# 	echo 'INSTALLER: ODEE WebLogic domain artifacts provisioned.'			
# 	# su -l oracle -c "echo 'delete this file to provision WebLogic ODEE domain. You must manually remove the existing domain artifacts.'>>/opt/oracle/provision/odee-3.txt"
# fi


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
