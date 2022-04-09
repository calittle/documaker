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

if grep -q gosu /home/vagrant/.bashrc; then
	echo 'INSTALLER: aliases already set.'
else	
	echo "alias gosu='sudo su -'" >> /home/vagrant/.bashrc
	echo "alias gooracle='sudo su -l oracle'" >> /home/vagrant/.bashrc
fi

if grep -q DISPLAY /home/vagrant/.bashrc; then
	echo "export DISPLAY=127.0.0.1:10.0" >> /home/vagrant/.bashrc
	echo "export DISPLAY=127.0.0.1:10.0" >> /home/oracle/.bashrc
	echo "export DISPLAY=127.0.0.1:10.0" >> /root/.bashrc
	su -l vagrant -c "xauth list" >> out
	xauthset=`cat out`
	rm out
	echo "xauth add $xauthset" >> /home/oracle/.bashrc
	echo "xauth add $xauthset" >> /root/.bashrc
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


# Install WebSphere 7
  
if [ -f "/opt/oracle/provision/was7.txt" ]; then
	echo 'INSTALLER: WebSphere already installed.'
else
	# check if unpacked
	if [ -f "/vagrant/installs/websphere_7/WAS/install" ]; then
		echo 'INSTALLER: WebSphere installer found.'
	else
		mkdir websphere_7
		tar -xf /vagrant/installs/was7.tar.gz -C /vagrant/installs/websphere_7
	fi
	echo "INSTALLER: Running WAS installation. This part cannot be scripted at this time."
	echo "INSTALLER: Perform the installation ONLY to /opt/ibm/was, and do not configure a "
	echo "INSTALLER: node, cluster, repository, or anything else. Only perform the software"
	echo "INSTALLER: installation."

	/vagrant/installs/websphere_7/WAS/install

	read -p "Press any key to resume after WebSphere installation."

	# check if updater is unpacked
	if [ -f "/vagrant/installs/webshere_7_updi" ]; then
		echo 'INSTALLER: WAS7 Update Installer found.'
	else
		mkdir -p /vagrant/installs/websphere_7_updi
		unzip -qn "/vagrant/installs/7.0.0.45-WS-UPDI-LinuxAMD64.zip" -d /vagrant/installs/websphere_7_updi
	fi
	
	echo "INSTALLER: Running WAS Updater installation. This part cannot be scripted at this time."
	echo "INSTALLER: Perform the installation ONLY to /opt/ibm/updateinstaller "
	echo "INSTALLER: After the installation, simply exit -- do not run the updater."

	/vagrant/installs/websphere_7_updi/UpdateInstaller/install

	read -p "Press any key to resume after WebSphere Updater installation."

	# copy the update PAK file.
	if [ -f /vagrant/installs/7.0.0-WS-WAS-LinuxX64-FP0000045.pak ]; then
		cp /vagrant/installs/7.0.0-WS-WAS-LinuxX64-FP0000045.pak /opt/ibm/updateinstaller/maintenance
		echo "INSTALLER: Running WAS Updater. This part cannot be scripted at this time."
		echo "INSTALLER: Accept all defaults and install the 7.0.0.45 update."
		echo "INSTALLER: After the installation, simply exit -- do not run the updater."

		/opt/ibm/updateinstaller/update.sh

		read -p "Press any key to resume after WebSphere Updater."
	fi
	chown oracle:oinstall -R /opt/ibm

	su -l oracle -c "echo 'delete this file to reinstall WAS'>>/opt/oracle/provision/was7.txt"
fi

# install ADF
if [ -f /opt/oracle/provision/adf.txt ]; then
	echo 'INSTALLER: ADF already installed.'
else
	mkdir adf
	##
	# download https://www.oracle.com/tools/downloads/application-development-framework-downloads.html#
	# 11.1.1.7 ADF --> V37382.zip
	##
	unzip -qn V37382-01.zip -d adf
	cp /vagrant/ora-response/adf.rsp.tmpl /vagrant/ora-response/adf.rsp
	su -l oracle -c "/vagrant/installs/adf/Disk1/runInstaller -silent -jreLoc /opt/ibm/was/java/jre -responseFile /vagrant/ora-response/adf.rsp"
	
	echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 odee-1250-vagrant" > /etc/hosts
	echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6 odee-1250-vagrant" >>/etc/hosts
	echo "127.0.1.1 odee-1250-vagrant odee-1250-vagrant" >> /etc/hosts

	echo "alias startas='/opt/ibm/was/profiles/Custom01/bin/startServer.sh -profileName OracleAdminServer -profileName Custom01'" >> /home/oracle/.bashrc
	echo "alias startdm='/opt/ibm/was/profiles/Dmgr01/bin/startManager.sh -profileName Dmgr01'" >> /home/oracle/.bashrc
	echo "alias startnode='/opt/ibm/was/profiles/Custom01/bin/startNode.sh -profileName Custom01'" >> /home/oracle/.bashrc
	echo 'INSTALLER: WebSphere services installed. To start, login as vagrant user, then su -l oracle, then run:'
	echo '	- startdm	to start the deployment manager'
	echo ' 	- startnode	to start the node manager'
	echo ' 	- startas	to start the Oracle AdminServer'
	echo '	Then you can access the IBM console at https://localhost:9043/ibm/console'
	rm /vagrant/oracle/adf.rsp
	su -l oracle -c "echo 'delete this file to reinstall ADF'>>/opt/oracle/provision/adf.txt"
fi


# Install FMW
# if [ -f /opt/oracle/provision/fmw.txt ]; then
# 	echo 'INSTALLER: FMW already installed.'
# else
#  	mkdir fmw
# 	tar xf soasuite_11.1.1.7.0.tar.gz -C fmw
# 	cp /vagrant/ora-response/fmw.rsp.tmpl /vagrant/ora-response/fmw.rsp
# 	su -l oracle -c "/vagrant/installs/fmw/Disk1/runInstaller -silent -jreLoc /opt/ibm/was/java/jre -responseFile /vagrant/ora-response/fmw.rsp"
# 	echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 odee-1250-vagrant" > /etc/hosts
# 	echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6 odee-1250-vagrant" >>/etc/hosts
# 	echo "127.0.1.1 odee-1250-vagrant odee-1250-vagrant" >> /etc/hosts

# 	# modify rcu script to point JRE to IBM dir, add Oracle driver.
# 	JLIB=/opt/oracle/middleware/fmw/inventory/Scripts/ext/jlib
# 	sed -i -e "s|JRE_DIR=\$ORACLE_HOME/jdk/jre|JRE_DIR=/opt/ibm/was/java/jre|g" /opt/oracle/middleware/oracle_common/bin/rcu	
# 	sed -i -e "s|JDBC_CLASSPATH=\$OH/jdbc/lib/\$JDBC_FILE1:\$OH/jdbc/lib/\$JDBC_FILE2:\$Oh/jdbc/lib/\$JDBC_FILE3|JDBC_CLASSPATH=$JLIB/\$JDBC_FILE1:$JLIB/\$JDBC_FILE2:$JLIB/\$JDBC_FILE3|g" /opt/oracle/middleware/oracle_common/bin/rcu
# 	sed -i -e "s|JRE_DIR=\$ORACLE_HOME/jdk/jre|JRE_DIR=/opt/ibm/was/java/jre|g" /opt/oracle/middleware/oracle_common/bin/rcu
# 	sed -i -e "s|XMLPARSER_CLASSPATH=\$ORACLE_HOME/lib/\$XMLPARSER_FILE|XMLPARSER_CLASSPATH=$JLIB/\$XMLPARSER_FILE|g" /opt/oracle/middleware/oracle_common/bin/rcu

# 	su -l oracle -c "/opt/oracle/middleware/fmw/common/bin/was_config.sh"
# fi

# Install ODEE
if [ -f "/opt/oracle/provision/odee.txt" ]; then
	echo "INSTALLER: ODEE installation skipped. Delete /opt/oracle/provision/odee.txt to attempt reprovision steps."
else
	echo "INSTALLER: Installing ODEE"
	unzip -qn "/vagrant/installs/${ZIP_ODEE}" -d /home/oracle
	cp /vagrant/ora-response/odee125.rsp.tmpl /home/oracle/odee.rsp

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


# Provision deploy WAS
if [ -f "/opt/oracle/provision/odee-2.txt" ]; then
	echo "INSTALLER: ODEE WAS Provisioning skipped. Delete /opt/oracle/provision/odee-2.txt to attempt reprovision steps."
else
	echo "INSTALLER: Creating ODEE WebSphere artifacts."

	#MW_HOME == ADF Middleware
	sed -i -e "s|/scratch/home/fap/IBM/middleware|/opt/oracle/fmw|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/set_middleware_env.sh
	sed -i -e "s|/scratch/home/fap/IBM/WebSphere/AppServer|/opt/ibm/was|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/set_middleware_env.sh
	sed -i -e "s|'<SECURE VALUE>'|$WLS_PWD|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/set_middleware_env.sh
	
	sed -i -e "s|C:/ibm/websphere/appserver|/opt/ibm/was|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/websphere_installation.properties
	sed -i -e "s|C:/oracle_home/documaker/docfactory/lib|/opt/oracle/odee/documaker/docfactory/lib|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/websphere_installation.properties
	sed -i -e "s|jdbcAdminPassword='<SECURE VALUE>'|jdbcAdminPassword=$ODEE_SCHEMA_PWD|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/websphere_installation.properties
	sed -i -e "s|jdbcAslinePassword='<SECURE VALUE>'|jdbcAdminPassword=$ODEE_SCHEMA_PWD|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/websphere_installation.properties
	
	mv /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.original
	echo "ldap.host=localhost" > /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "ldap.port=10389" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "admin.id=uid=admin,ou=system" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "admin.pass=secret" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "idstore.type=ACTIVE_DIRECTORY" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "user.search.bases=cn=users,dc=example,dc=com" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "group.search.bases=cn=groups,dc=example,dc=com" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "user.id.map=:uid" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "group.id.map=:cn" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "group.member.id.map=groupofnames:member" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "ssl=false" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "primary.admin.id=uid=admin,ou=system" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "user.filter=(&(uid=%v)(objectclass=person))" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "group.filter=(&(cn=%v)(objectclass=groupofnames))" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "username.attr=uid" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "groupname.attr=cn" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt


	echo "INSTALLER: Running WAS Profile update. This part cannot be scripted at this time."
	echo "	- Select and Configure Existing Cell then Next and accept all defaults and then exit."
	echo "	- No changes will be made since this step has already been performed."
	echo "  - After the profile updater exits, the WAS system will be started. "
	echo "  - then Documaker artifacts will be provisioned to the cell. "

	su -l oracle -c "/opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/was_create_profile.sh"

	read -p "Press any key to resume after WebSphere installation."

	echo 'INSTALLER: ODEE Websphere artifacts provisioned.'			
	su -l oracle -c "echo 'delete this file to provision ODEE Websphere artifacts. You will need to manually drop existing profile to redo this step'>>/opt/oracle/provision/odee-2.txt"
fi

# run user-defined post-setup scripts
echo 'INSTALLER: Running user-defined post-setup scripts'

for f in /vagrant/userscripts/*
	do
		case "${f,,}" in
			*.sh)
				echo "INSTALLER: Running $f"
				. "$f"
				echo "INSTALLER: Done running $f"
				;;
			*.sql)
				echo "INSTALLER: Running $f"
				su -l oracle -c "echo 'exit' | sqlplus -s / as sysdba @\"$f\""
				echo "INSTALLER: Done running $f"
				;;
			/vagrant/userscripts/put_custom_scripts_here.txt)
				:
				;;
			*)
				#echo "INSTALLER: Ignoring $f"
				;;
		esac
	done

# echo 'INSTALLER: Done running user-defined post-setup scripts'

echo "INSTALLER: Installation complete.";