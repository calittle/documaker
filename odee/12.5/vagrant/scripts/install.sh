#!/bin/bash
#
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2022 Oracle and/or its affiliates. All rights reserved.
# 
# Since: 
#	July, 2018
# Authors: 
#	andy.little@oracle.com, gerald.venzl@oracle.com, steven.saunders@oracle.com
# Description: 
#	Installs Oracle Database 19c, Fusion MW 11.1.1.7.0, Documaker 12.5.0
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
#

# Abort on any error
set -e

echo 'INSTALLER: Started up'

# create directories
mkdir -p $ORACLE_HOME
mkdir -p /u01/app
ln -sf $ORACLE_BASE /u01/app/oracle
mkdir -p $ORACLE_BASE/provision

echo 'INSTALLER: Oracle directories created/verified.'

# Check swap file size.
if [ -f "/swapfile" ]; then
	echo 'INSTALLER: Extra swap file exists; no changes made.'
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
	echo 'INSTALLER: System update skipped.'
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

	# Oracle user now available.
	chown oracle:oinstall -R /opt/oracle
	su -l oracle -c "echo 'delete this file to rerun system update. '>>/opt/oracle/provision/sysupdate.txt"
	echo 'INSTALLER: Prerequisite install complete'
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

if grep -q gosu /home/vagrant/.bashrc; then
	echo 'INSTALLER: aliases already set.'
else	
	echo "alias gosu='sudo su -'" >> /home/vagrant/.bashrc
	echo "alias gooracle='sudo su -l oracle'" >> /home/vagrant/.bashrc
	echo "INSTALLER: GO aliases set."
fi

if grep -q DISPLAY /home/vagrant/.bashrc; then
	echo "INSTALLER: X11 variables already set."
else
	#call cookie baking for X forwarding
	su -l vagrant -c "source ~/.bashrc"
	echo "export DISPLAY=127.0.0.1:10.0" >> /home/vagrant/.bashrc
	echo "XCOOKIE=\`xauth list \${DISPLAY#localhost}\`" >> /home/vagrant/.bashrc
	echo 'sudo /home/vagrant/.setx.sh "${XCOOKIE}"'>> /home/vagrant/.bashrc
	
	# create baking script for vagrant
	echo "#!/bin/bash" > /home/vagrant/.setx.sh
	echo "echo \"xauth add \$@ >/dev/null 2>&1\" > /home/oracle/.setx.sh" >> /home/vagrant/.setx.sh
	echo "echo \"xauth add \$@ >/dev/null 2>&1\" > /root/.setx.sh" >> /home/vagrant/.setx.sh
	echo "chmod u+x /home/oracle/.setx.sh" >> /home/vagrant/.setx.sh
	echo "chmod u+x /root/.setx.sh" >> /home/vagrant/.setx.sh
	echo "chown oracle:oinstall /home/oracle/.setx.sh" >>/home/vagrant/.setx.sh
	echo "chown root:root /root/.setx.sh" >>/home/vagrant/.setx.sh
	
	# bake for others... 
	echo "export DISPLAY=127.0.0.1:10.0" >> /home/oracle/.bashrc
	echo "export DISPLAY=127.0.0.1:10.0" >> /root/.bashrc
	echo "~/.setx.sh" >> /root/.bashrc
	echo "~/.setx.sh" >> /home/oracle/.bashrc
	chmod u+x /home/vagrant/.setx.sh
	chown vagrant:vagrant /home/vagrant/.setx.sh
	su -l vagrant -c "touch ~/.Xauthority"
	su -l oracle -c "touch ~/.Xauthority"
	touch ~/.Xauthority
	echo "INSTALLER: display variables set."
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

		if [ -f "/vagrant/installs/${ZIP_ORACLEDB}" ]; then
			echo "INSTALLER: Found /vagrant/installs/${ZIP_ORACLEDB}"
		else
			echo "INSTALLER: ${ZIP_ORACLEDB} NOT FOUND. Review README.md for instructions."
			exit 1
		fi

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
		# # WORKAROUND as mentioned here: https://support.oracle.com/epmos/faces/DocumentDisplay?id=2430487.1
		# su -l oracle -c "echo 'SQLNET.ALLOWED_LOGON_VERSION=11' > $ORACLE_HOME/network/admin/sqlnet.ora"

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
		# Note : added below for workaround for RCU install on 19c as documented here https://support.oracle.com/epmos/faces/DocumentDisplay?id=2747899.1
		#		ALTER SYSTEM SET "_allow_insert_with_update_check"=TRUE scope=both; 
		# 
		su -l oracle -c "sqlplus / as sysdba <<EOF
ALTER PLUGGABLE DATABASE $ORACLE_PDB SAVE STATE;
EXEC DBMS_XDB_CONFIG.SETGLOBALPORTENABLED (TRUE);
ALTER SYSTEM SET LOCAL_LISTENER = '(ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = $LISTENER_PORT))' SCOPE=BOTH;
ALTER SYSTEM REGISTER;
ALTER SYSTEM SET \"_allow_insert_with_update_check\"=TRUE SCOPE=BOTH;
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
		su -l oracle -c "echo 'delete this file to register system services.'>>/opt/oracle/provision/oracledb-step4.txt"
		echo "ORACLE PASSWORD FOR SYS, SYSTEM AND PDBADMIN: $ORACLE_PWD";
	fi
	su -l oracle -c "echo 'delete this file to reinstall'>>/opt/oracle/provision/oracledb.txt"
fi 

# Install JDK 1.8
if [ -f "/opt/oracle/provision/jdk.txt" ]; then
	echo 'INSTALLER: JDK is already installed'
else
	if [ -f "/vagrant/installs/${RPM_JAVA}" ]; then
		echo "INSTALLER: /vagrant/installs/${RPM_JAVA} found"
	else
		echo "INSTALLER: ${RPM_JAVA} NOT FOUND. Review README.md for instructions."
		exit 1
	fi	
	rpm -ivh /vagrant/installs/${RPM_JAVA}
	echo "export JAVA_HOME=$JAVA_PATH" >> /home/oracle/.bashrc
	echo "export PATH=${JAVA_HOME}/bin:\$PATH" >> /home/oracle/.bashrc
	su -l oracle -c "echo 'delete this file to reinstall JDK'>>/opt/oracle/provision/jdk.txt"
	echo 'INSTALLER: JDK installed'
fi

	
#
# run RCU
#
# if [ -f /opt/oracle/provision/rcu.txt ]; then
# 	echo 'INSTALLER: RCU already installed.'
# else
# 	echo 'INSTALLER: Installing RCU.'
# 	TEMPFILE="/vagrant/installs/p16471709_111170_Linux-x86-64.zip"
#  	if [ -f "${TEMPFILE}" ]; then
# 		echo "INSTALLER: Found ${TEMPFILE}"
# 	else
# 		echo "INSTALLER: ${TEMPFILE} NOT FOUND. Review README.md for instructions."
# 		exit 1
# 	fi	
# 	mkdir -p /vagrant/installs/rcu
# 	unzip -qn ${TEMPFILE} -d /vagrant/installs/rcu
	
# 	# WORKAROUND as mentioned here: https://support.oracle.com/epmos/faces/DocumentDisplay?id=2430487.1
# 	# and https://docs.oracle.com/cd/E52734_01/core/IDMRN/admin.htm#IDMRN636 (search for ORA-28040)
		
# 	chmod u+w /vagrant/installs/rcu/rcuHome/jdbc/lib/*.jar
	
# 	if [ -f /vagrant/installs/ojdbc6.jar ]; then
# 		cp /vagrant/installs/ojdbc6.jar /vagrant/installs/rcu/rcuHome/jdbc/lib
# 		echo 'INSTALLER: Copying in vagrant/installs/ojdbc6.jar'
# 	else
# 		echo 'INSTALLER: WARNING >> ojdbc6.jar not found in vagrant/installs directory. Download ojdbc6.jar from https://mvnrepository.com/artifact/com.oracle.database.jdbc/ojdbc6/11.2.0.4 and '
# 		echo 'INSTALLER: place the file in the vagrant/installs directory, then re-run:     vagrant up --provision'
# 		exit 1
# 	fi

# 	echo "INSTALLER: Running RCU. "
	
# 	/vagrant/installs/rcu/rcuHome/bin/rcu -silent -createRepository -connectString localhost:$LISTENER_PORT/$ORACLE_PDB -dbUser sys -dbRole SYSDBA -useSamePasswordForAllSchemaUsers true -schemaPrefix DEV -component OPSS -component IAU -component MDS -component SOAINFRA -component ORASDPM<<EOF
# $ORACLE_PWD
# $ORACLE_PWD
# EOF
# 	su -l oracle -c "echo 'delete this file to rerun RCU'>>/opt/oracle/provision/rcu.txt"	
# fi	


#########################
#                       #
# Install WebSphere 7   #
#                       #
#########################  
if [ -f "/opt/oracle/provision/was7-1.txt" ]; then
	echo 'INSTALLER: WebSphere already installed.'
else
	# delete any previous provisioning. 
	echo 'INSTALLER: Removing previous install at /opt/ibm/was'
	sudo rm -rf /opt/ibm/was
	
	# check if unpacked
	if [ -f "/vagrant/installs/websphere_7/WAS/install" ]; then
		echo 'INSTALLER: WebSphere installer found.'
	else		
		tar -xf /vagrant/installs/was7.tar.gz -C /vagrant/installs
	fi
	echo "INSTALLER: Running WAS installation."

	cp /vagrant/ora-response/was.rsp.tmpl /vagrant/installs/websphere_7/WAS/was.rsp
	
	sed -i -e "s|###WAS_ADMIN###|$WAS_ADMIN|g" /vagrant/installs/websphere_7/WAS/was.rsp
	sed -i -e "s|###WAS_PWD###|$WAS_PWD|g" /vagrant/installs/websphere_7/WAS/was.rsp
	sed -i -e "s|###WAS_HOME###|$WAS_HOME|g" /vagrant/installs/websphere_7/WAS/was.rsp

	/vagrant/installs/websphere_7/WAS/install -options '/vagrant/installs/websphere_7/WAS/was.rsp' -silent
	su -l oracle -c "echo 'delete this file to reinstall WAS. you may need to manually remove previous install. '>>/opt/oracle/provision/was7-1.txt"
	echo 'INSTALLER: WAS7 installed.'
fi

if [ -f "/opt/oracle/provision/was7-2.txt" ]; then
	echo 'INSTALLER: WebSphere Updater already installed.'

else
	# check if updater is unpacked
	if [ -f "/vagrant/installs/webshere_7_updi" ]; then
		echo 'INSTALLER: WAS7 Update Installer found.'
	else
		echo 'INSTALLER: Unpacking WAS7 Update Installer.'
		mkdir -p /vagrant/installs/websphere_7_updi
		unzip -qn "/vagrant/installs/7.0.0.45-WS-UPDI-LinuxAMD64.zip" -d /vagrant/installs/websphere_7_updi
	fi

	echo "INSTALLER: Running WAS Updater installation."
	cp /vagrant/ora-response/updi.rsp.tmpl /vagrant/installs/websphere_7_updi/UpdateInstaller/updi.rsp
	
	sed -i -e "s|###UPDI_HOME###|$UPDI_HOME|g" /vagrant/installs/websphere_7_updi/UpdateInstaller/updi.rsp
	
	/vagrant/installs/websphere_7_updi/UpdateInstaller/install -options '/vagrant/installs/websphere_7_updi/UpdateInstaller/updi.rsp' -silent 
	
	su -l oracle -c "echo 'delete this file to reinstall WAS Updater. you may need to manually remove previous install. '>>/opt/oracle/provision/was7-2.txt"
	echo 'INSTALLER: WAS Updater installed.'
fi

if [ -f "/opt/oracle/provision/was7-3.txt" ]; then
	echo 'INSTALLER: WebSphere Update pack already installed.'
else
	# copy the update PAK file.
	TEMPFILE="7.0.0-WS-WAS-LinuxX64-FP0000027.pak"
	FULLTEMPFILE="/vagrant/installs/${TEMPFILE}"
 	if [ -f "${FULLTEMPFILE}" ]; then
		echo "INSTALLER: Found ${FULLTEMPFILE}"
	else
		echo "INSTALLER: ${FULLTEMPFILE} NOT FOUND. Review README.md for instructions."
		exit 1
	fi		 	
	cp ${FULLTEMPFILE} /opt/ibm/updateinstaller/maintenance
	
	echo "INSTALLER: Running WAS Updater."
	cp /vagrant/ora-response/wasupdate.rsp.tmpl /vagrant/ora-response/wasupdate.rsp
	sed -i -e "s|###UPDI_HOME###|$UPDI_HOME|g" /vagrant/ora-response/wasupdate.rsp
	sed -i -e "s|###WAS_HOME###|$WAS_HOME|g" /vagrant/ora-response/wasupdate.rsp
	sed -i -e "s|###PAKNAME###|$TEMPFILE|g" /vagrant/ora-response/wasupdate.rsp
	/opt/ibm/updateinstaller/update.sh -silent -options /vagrant/ora-response/wasupdate.rsp

	chown oracle:oinstall -R /opt/ibm

	rm /opt/ibm/updateinstaller/maintenance/*.pak
	rm /vagrant/ora-response/wasupdate.rsp
	su -l oracle -c "echo 'delete this file to reinstall WAS'>>/opt/oracle/provision/was7-3.txt"
	echo 'INSTALLER: WAS Update applied.'
fi

#
# Install option: use ADF, or SOA Suite installer. Former is not guaranteed to work.
# Choice driven by variable FMW_OPTION = ADF|SOA. Default is SOA as this is listed as a 
# requirement for Documaker 12.5.0.
#
# if [ ${ADF_OR_SOA} = 'SOA' ]; then
# 	#
# 	# Install SOA
# 	#

# 	if [ -f /opt/oracle/provision/fmw.txt ]; then
# 		echo 'INSTALLER: FMW already installed.'
# 	else
# 		echo 'INSTALLER: Installing FMW via SOA Suite.'

# 		TEMPFILE="/vagrant/installs/soasuite_11.1.1.7.0.tar.gz"
# 	 	if [ -f "${TEMPFILE}" ]; then
# 			echo "INSTALLER: Found ${TEMPFILE}"
# 		else
# 			echo "INSTALLER: ${TEMPFILE} NOT FOUND. Review README.md for instructions."
# 			exit 1
# 		fi	
	 	
# 	 	mkdir -p /vagrant/installs/fmw
# 	 	if [ -f /vagrant/installs/fmw/Disk6/stage/disk.label ]; then
# 	 		echo 'INSTALLER: skipping unpack.'
# 	 	else
# 	 		echo 'INSTALLER: unpacking...'
# 	 		tar xf ${TEMPFILE} -C /vagrant/installs/fmw
# 	 	fi
# 		cp /vagrant/ora-response/fmw.rsp.tmpl /vagrant/ora-response/fmw.rsp
# 		echo "INSTALLER: Running SOA Suite installer."
# 		su -l oracle -c "/vagrant/installs/fmw/Disk1/runInstaller -silent -waitforcompletion -jreLoc /opt/ibm/was/java/jre -responseFile /vagrant/ora-response/fmw.rsp"
# 		echo "INSTALLER: SOA Suite installer completed."
# 		rm /vagrant/ora-response/fmw.rsp
		
# 		echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 odee-1250-vagrant" > /etc/hosts
# 		echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6 odee-1250-vagrant" >>/etc/hosts
# 		echo "127.0.1.1 odee-1250-vagrant odee-1250-vagrant" >> /etc/hosts
# 	fi
# else
	#
	# install ADF
	#
	if [ -f /opt/oracle/provision/adf.txt ]; then
		echo 'INSTALLER: ADF already installed.'
	else
		echo 'INSTALLER: Installing ADF.'
		mkdir -p /vagrant/installs/adf
		##
		# download https://www.oracle.com/tools/downloads/application-development-framework-downloads.html#
		# 11.1.1.7 ADF --> V37382.zip
		##
		# https://docs.oracle.com/cd/E23943_01/web.1111/e17764/screens.htm#WASCW153
		##
		TEMPFILE="/vagrant/installs/V37382-01.zip"
	 	if [ -f "${TEMPFILE}" ]; then
			echo "INSTALLER: Found ${TEMPFILE}"
		else
			echo "INSTALLER: ${TEMPFILE} NOT FOUND. Review README.md for instructions."
			exit 1
		fi	
		unzip -qn ${TEMPFILE} -d /vagrant/installs/adf
		cp /vagrant/ora-response/adf.rsp.tmpl /vagrant/ora-response/adf.rsp
		sed -i -e "s|###MW_HOME###|$MW_HOME|g" /vagrant/ora-response/adf.rsp
		sed -i -e "s|###WAS_HOME###|$WAS_HOME|g" /vagrant/ora-response/adf.rsp
	
		su -l oracle -c "/vagrant/installs/adf/Disk1/runInstaller -silent -waitforcompletion -jreLoc /opt/ibm/was/java/jre -responseFile /vagrant/ora-response/adf.rsp"
		
		echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 odee-1250-vagrant" > /etc/hosts
		echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6 odee-1250-vagrant" >>/etc/hosts
		echo "127.0.1.1 odee-1250-vagrant odee-1250-vagrant" >> /etc/hosts

		rm /vagrant/ora-response/adf.rsp
		su -l oracle -c "echo 'delete this file to reinstall ADF'>>/opt/oracle/provision/adf.txt"
	fi
#fi

if grep -q startas /home/oracle/.bashrc; then
	echo 'INSTALLER: WAS aliases already set.'
else	
	echo "alias startas='/opt/ibm/was/profiles/Custom01/bin/startServer.sh OracleAdminServer -profileName Custom01'" >> /home/oracle/.bashrc
	echo "alias startdm='/opt/ibm/was/profiles/Dmgr01/bin/startManager.sh -profileName Dmgr01'" >> /home/oracle/.bashrc
	echo "alias startnode='/opt/ibm/was/profiles/Custom01/bin/startNode.sh -profileName Custom01'" >> /home/oracle/.bashrc

	echo "alias stopas='/opt/ibm/was/profiles/Custom01/bin/stopServer.sh OracleAdminServer -profileName Custom01'" >> /home/oracle/.bashrc
	echo "alias stopdm='/opt/ibm/was/profiles/Dmgr01/bin/stopManager.sh -profileName Dmgr01'" >> /home/oracle/.bashrc
	echo "alias stopnode='/opt/ibm/was/profiles/Custom01/bin/stopNode.sh -profileName Custom01'" >> /home/oracle/.bashrc

	echo "echo 'Commands'" >> /home/oracle/.bashrc
	echo "echo '-------'">> /home/oracle/.bashrc
	echo "echo '[start|stop]dm    - control Deployment Manager'">> /home/oracle/.bashrc
	echo "echo '[start|stop]node  - control Node'">> /home/oracle/.bashrc
	echo "echo '[start|stop]as    - control OracleAdminServer'">> /home/oracle/.bashrc
	echo "echo ''">> /home/oracle/.bashrc
    echo ''
	echo 'INSTALLER: WebSphere services installed. To start, login as vagrant user, then su -l oracle, then run:'
	echo '       [start|stop]dm   - start/stop the deployment manager'
	echo '       [start|stop]node - start/stop the node manager'
	echo '       [start|stop]as   - start/stop the Oracle AdminServer'
	echo '	     IBM console      -https://localhost:9043/ibm/console'
    echo ''
	echo 'INSTALLER: WAS aliases set.'			
fi

#
# Install ODEE
#
if [ -f "/opt/oracle/provision/odee.txt" ]; then
	echo "INSTALLER: ODEE installation skipped. Delete /opt/oracle/provision/odee.txt to attempt reprovision steps."
else
	if [ -f "/vagrant/installs/${ZIP_ODEE}" ]; then
		echo "INSTALLER: Found /vagrant/installs/${ZIP_ODEE}"
	else
		echo "INSTALLER: /vagrant/installs/${ZIP_ODEE} NOT FOUND. Review README.md for instructions."
		exit 1
	fi		 	
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

	cp /home/oracle/odee.rsp /vagrant/ora-response/odee.rsp
	chown oracle:oinstall -R /home/oracle
	chown oracle:oinstall -R $ORACLE_BASE/oraInventory
	
	echo "INSTALLER: running /home/oracle/Disk1/runInstaller -silent -force -waitforcompletion -ignoreSysPrereqs -responseFile /home/oracle/odee.rsp -jreLoc ${JAVA_PATH}/jre -invPtrLoc ${ORACLE_BASE}/oraInventory/oraInst.loc"	
	su -l oracle -c "/home/oracle/Disk1/runInstaller -waitforcompletion -silent -force -ignoreSysPrereqs -responseFile /home/oracle/odee.rsp -jreLoc ${JAVA_PATH}/jre -invPtrLoc ${ORACLE_BASE}/oraInventory/oraInst.loc" > /dev/null 2>&1

	if [ -f /opt/oracle/odee/documaker ]; then
		echo 'INSTALLER: ODEE installation failed.'
		exit 2
	else
		echo .
		rm /home/oracle/odee.rsp
		rm /vagrant/ora-response/odee.rsp
		echo 'INSTALLER: ODEE installed.'
		su -l oracle -c "echo 'delete this file to reinstall ODEE. Note you may need to manually remove everything that was created to redo this step'>>/opt/oracle/provision/odee.txt" > /dev/null 2>&1
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
EOF" > /dev/null 2>&1
	su -l oracle -c "cd $ODEE_HOME/documaker/mstrres/dmres && ./deploysamplemrl.sh" > /home/oracle/odee-deploymrl.log 2>&1
	
	echo 'INSTALLER: ODEE database artifacts provisioned.'			
	su -l oracle -c "echo 'delete this file to provision ODEE database artifacts. You will need to manually drop existing users/schemas/datafiles to redo this step'>>/opt/oracle/provision/odee-1.txt" > /dev/null 2>&1
fi


#
# ODEE WAS Provisioning
#
if [ -f "/opt/oracle/provision/odee-2.txt" ]; then
	echo "INSTALLER: ODEE WAS Provisioning skipped. Delete /opt/oracle/provision/odee-2.txt to attempt reprovision steps."
else
	echo "INSTALLER: Creating ODEE WebSphere artifacts."

	#MW_HOME == ADF Middleware
	sed -i -e "s|/scratch/home/fap/IBM/middleware|$MW_HOME|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/set_websphere_env.sh
	sed -i -e "s|/scratch/home/fap/IBM/WebSphere/AppServer|$WAS_HOME|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/set_websphere_env.sh
	sed -i -e "s|'<SECURE VALUE>'|$WLS_PWD|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/set_websphere_env.sh
	
	sed -i -e "s|C:/ibm/websphere/appserver|/opt/ibm/was|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/websphere_installation.properties
	sed -i -e "s|C:/oracle_home/documaker/docfactory/lib|/opt/oracle/odee/documaker/docfactory/lib|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/websphere_installation.properties
	sed -i -e "s|jdbcAdminPassword='<SECURE VALUE>'|jdbcAdminPassword=$ODEE_SCHEMA_PWD|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/websphere_installation.properties
	sed -i -e "s|jdbcAslinePassword='<SECURE VALUE>'|jdbcAslinePassword=$ODEE_SCHEMA_PWD|g" /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/websphere_installation.properties
	
	mv /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.original
	echo "ldap.host=localhost" > /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "ldap.port=10389" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "admin.id=uid=admin,ou=system" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "admin.pass=secret" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "idstore.type=ACTIVE_DIRECTORY" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "user.search.bases=cn=users,dc=example,dc=com" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "group.search.bases=cn=groups,dc=example,dc=com" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "user.id.map=*:uid" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "group.id.map=*:cn" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "group.member.id.map=groupofnames:member" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "ssl=false" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "primary.admin.id=uid=admin,ou=system" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "user.filter=(&(uid=%v)(objectclass=person))" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "group.filter=(&(cn=%v)(objectclass=groupofnames))" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "username.attr=uid" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt
	echo "groupname.attr=cn" >> /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts/ldapconfig.txt

	echo 'INSTALLER: WARNING -- YOU MUST MANUALLY RUN THE FOLLOWING SCRIPT AS ORACLE USER within the Vagrant machine.'
	echo "     vagrant ssh "
	echo "     vagrant@${VM_NAME} $ gooracle "
	echo "     oracle@${VM_NAME} $ cd /opt/oracle/odee/documaker/j2ee/websphere/oracle11g/scripts; ./was_create_profile.sh; ./was_add_correspondence.sh"
	echo ""
	echo 'INSTALLER: This component cannot be scripted. Use the following settings:'
	echo "  Select configuration option > Create and Configure Cell > Next"
	echo "  Specify Cell, Profile and Node Name Information > Accept defaults > Next"
	echo "  Specify Deployment Manager Information:"
	echo "	 - Host: ${VM_NAME}"
	echo "	 - WAS Admin User: ${WAS_ADMIN}"
	echo "   - WAS Admin Pass: ${WAS_PWD}"
	echo "   - Next"
	echo "  Creating Cell > Next"
	echo "  Add products to Cell > select Oracle JRF for WebSphere > Next"
	echo "  Configuration Summary > Create > Done."
	echo ""
	echo "  GUI will close, and scripted deployment will commence. Review console output for errors."	
	
	echo 'INSTALLER: The GUI dialog will close and the WAS system will be started and artifacts deployed. This can take some time -- review the output to ensure no errors occurred.'
	echo "INSTALLER: After the above operation concludes, run the following as ORACLE user"
	echo "           oracle@${VM_NAME} $ echo 'delete this file to provision ODEE Websphere artifacts. You will need to manually drop existing profile to redo this step'>>/opt/oracle/provision/odee-2.txt"
	echo 'INSTALLER: ODEE WAS Provisioning partially completed. Review log and complete manual steps to finalize.'
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
