# odee-12.5.0-vagrant

This Vagrant project provisions:
- Oracle Linux 7
- Oracle Database 19c
- IBM WebSphere 7.0.0.45
- Oracle SOA Suite 11.1.1.7.0 or ADF 11.1.1.7.0
- Oracle Documaker Enterprise Edition 12.5.0 [Documentation](https://docs.oracle.com/cd/F51808_01/)

Instructions assume a POSIX-based terminal is used for installation, however, these instructions can be easily adapted to Windows-based systems.

## Prerequisites

1. Install [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://vagrantup.com/)

## Getting started

1. Clone this repository `git clone https://github.com/calittle/documaker.git` into a folder of your choice, e.g. `vagrant-projects`
2. Change into the `vagrant-projects/documaker/odee/12.7.0/vagrant` directory. This is the *project root* directory.
3. Download the installation zip files into the `project-root/installs` directory. See [INSTALLS README]('INSTALLS-README.md') for additional details.
  
4. Run `vagrant up`
   1. The first time you run this it will provision everything and may take a while. Ensure you have a good internet connection as the scripts will update the VM to the latest via `yum`.
   2. The main script is in `scripts\install.sh` - this takes care of installing and deploying the software and performing initial configuration.
   3. The installation can be customized, if desired (see [Configuration](#configuration)).
5. Connect to the database (see [Connecting to Oracle](#connecting-to-oracle-database))
6. You can shut down the VM via the usual `vagrant halt` and then start it up again via `vagrant up`. You can also [reprovision[(#reprovision)]].

## Connecting to Oracle Database

The default database connection parameters are:

* Hostname: `localhost`
* Port: `1521`
* SID: `ORCLCDB`
* PDB: `ORCLPDB1`
* EM Express port: `5500`
* Database passwords are auto-generated and printed on install

These parameters can be customized, if desired (see [Configuration](#configuration)).

## Connecting to WebLogic servers

Ports are automatically forwarded from your host machine, so you can access the apps from your browser:
* WebLogic Console [http://localhost:7001/console](http://localhost:7001/console)
* Documaker Administrator [http://localhost:10001/DocumakerAdministrator](http://localhost:10001/DocumakerAdministrator)
* Documaker Dashboard [http://localhost:10001/DocumakerDashboard](http://localhost:10001/DocumakerDashboard)
* Documaker Interactive [http://localhost:12001/DocumakerInteractive](http://localhost:10001/DocumakerInteractive)


## Services
Before accessing servers, ensure the appropriate services are started by running the following commands:
```
vagrant ssh
```
Then use the WebLogic console to start the managed servers

## Resetting Database password

You can reset the password of the Oracle database accounts (SYS, SYSTEM and PDBADMIN only) by switching to the oracle user (`sudo su - oracle`), then executing `/home/oracle/setPassword.sh <Your new password>`.

## Running scripts after setup

You can have the installer run scripts after setup by putting them in the `userscripts` directory below the directory where you have this file checked out. Any shell (`.sh`) or SQL (`.sql`) scripts you put in the `userscripts` directory will be executed by the installer after the database is set up and started. Only shell and SQL scripts will be executed; all other files will be ignored. These scripts are completely optional.

Shell scripts will be executed as root. SQL scripts will be executed as SYS. SQL scripts will run against the CDB, not the PDB, unless you include an `ALTER SESSION SET CONTAINER = <pdbname>` statement in the script.

To run scripts in a specific order, prefix the file names with a number, e.g., `01_shellscript.sh`, `02_tablespaces.sql`, `03_shellscript2.sh`, etc.

## Reprovision

Sometimes it may be necessary to reprovision the VM if something did not deploy correctly, or simply just to start over. To reprovision, make sure your VM is in a halted stated (e.g. `vagrant halt`) and then run `vagrant up --provision`). Before you do that, make sure you have corrected the elements of the deployment that failed. In order to provide more granular control over what steps are rerun, the deployment scripts create some simple txt files at various points of the deployment process. Delete these files to rerun that step. Note that there isn't a rollback, so sometimes you might need to undo what the deployment step did. This isn't foolproof, so use your best judgment (e.g. if you're not sure, just `vagrant destroy oipa-vagrant` and then `vagrant up` to redo the whole thing.) 

- `/opt/oracle/provision/oracledb.txt` - delete this file to redo the entire unpacking and installation of the database software, and listener configuration, CDB/PDB deployment, and database services.
- `/opt/oracle/provision/oracledb-step1.txt` - delete this file to redo the database sfotware unpack and install.
- `/opt/oracle/provision/oracledb-step2.txt` - delete this file to redo the listener configuration.
- `/opt/oracle/provision/oracledb-step3.txt` - delete this file to redo the CDB/PDB creation.
- `/opt/oracle/oracledb-step4.txt` - delete this file to redo the database service registration with the OS.

- `/opt/oracle/provision/weblogic.txt` - delete this file to redo WebLogic/FMW install and deployment.
- `/opt/oracle/provision/weblogic-step1.txt` - delete this file to reinstall Fusion Middleware infrastructure.

## Configuration

The `Vagrantfile` can be used _as-is_, without any additional configuration. However, there are several parameters you can set to tailor the installation to your needs.

### How to configure

There are three ways to set parameters:

1. Update the `Vagrantfile`. This is straightforward; the downside is that you will lose changes when you update this repository.
2. Use environment variables. It might be difficult to remember the parameters used when the VM was instantiated.
3. Use the `.env`/`.env.local` files (requires
[vagrant-env](https://github.com/gosuri/vagrant-env) plugin). You can configure your installation by editing the `.env` file, but `.env` will be overwritten on updates, so it's better to make a copy of `.env` called `.env.local`, then make changes in `.env.local`. The `.env.local` file won't be overwritten when you update this repository and it won't mark your Git tree as changed (you won't accidentally commit your local configuration!).

Parameters are considered in the following order (first one wins):

1. Environment variables
2. `.env.local` (if it exists and the  [vagrant-env](https://github.com/gosuri/vagrant-env) plugin is installed)
3. `.env` (if the [vagrant-env](https://github.com/gosuri/vagrant-env) plugin is installed)
4. `Vagrantfile` definitions

### VM parameters

* `VM_NAME` (default: `oipa-vagrant`): VM name.
* `VM_MEMORY` (default: `8192`): memory for the VM (in MB).
* `VM_SYSTEM_TIMEZONE` (default: host time zone (if possible)): VM time zone.
  * The system time zone is used by the database for SYSDATE/SYSTIMESTAMP.
  * The guest time zone will be set to the host time zone when the host time zone is a full hour offset from GMT.
  * When the host time zone isn't a full hour offset from GMT (e.g., in India and parts of Australia), the guest time zone will be set to UTC.
  * You can specify a different time zone using a time zone name (e.g., "America/Los_Angeles") or an offset from GMT (e.g., "Etc/GMT-2"). For more information on specifying time zones, see [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

### Oracle Database parameters

* `VM_ORACLE_BASE` (default: `/opt/oracle/`): Oracle base directory.
* `VM_ORACLE_HOME` (default: `/opt/oracle/product/19c/dbhome_1`): Oracle home directory.
* `VM_ORACLE_SID` (default: `ORCLCDB`): Oracle SID.
* `VM_ORACLE_PDB` (default: `ORCLPDB1`): PDB name.
* `VM_ORACLE_CHARACTERSET` (default: `AL32UTF8`): database character set.
* `VM_ORACLE_EDITION` (default: `EE`): Oracle Database edition. Either `EE` for Enterprise Edition or `SE2` for Standard Edition 2.
* `VM_LISTENER_PORT` (default: `1521`): Listener port.
* `VM_EM_EXPRESS_PORT` (default: `5500`): EM Express port.
* `VM_ORACLE_PWD` (default: automatically generated): Oracle Database password for the SYS, SYSTEM and PDBADMIN accounts.
* `VM_ZIP_ORACLEDB` (default :`LINUX.X64_193000_db_home.zip`): Oracle Database installer ZIP.
  
### Oracle WebLogic Server parameters

* `VM_WLS_PWD` (default: automatically generated): password for the WebLogic administrator account (_weblogic_)
* `VM_VM_MW_HOME` (default: `/opt/oracle/middleware`): base directory for WebLogic.
* `VM_MW_DOMAIN` (default: `odee`): WebLogic domain name
* `VM_WLS_PORT_ADMIN` (default: `7001`): WebLogic administrative port
* `VM_JAVA_PATH` (default: `/usr/java/jdk1.8.0_311-amd64`): Java installation path on VM
* `VM_ZIP_FMW` (default: `V983368-01.zip`): FMW Infra zip file
* `VM_JAR_FMW` (default: `fmw_12.2.1.4.0_infrastructure.jar`): JAR installer for FMW Infra (contained within `VM_ZIP_FMW`)
* `VM_MW_PORT_ADMIN` (default: `7001`): WebLogic AdminServer console app port
* `VM_MW_PORT_DMKR` (default: `10001`): Documaker Admin/Dashboard app port
* `VM_MW_PORT_JMS` (default: `11001`): DocFactory JMS Server port
* `VM_MW_PORT_IDM` (default: `12001`): Documaker Interactive app port
    
### ODEE parameters

* `VM_ZIP_ODEE` (default: `V1018888-01.zip`): Oracle Documaker installer ZIP.
* `VM_ODEE_HOME` (default: `/opt/oracle/odee`): Oracle Docuamker home directory.
* `VM_ODEE_DOMAIN` (default: `odee`): WebLogic domain name for Oracle Documaker
* `VM_ODEE_PWD` (default: auto-generated): Password for Documaker administrative user
* `VM_ODEE_SCHEMA_PWD` (default: auto-generated): Password for DMKR_ASLINE and DMKR_ADMIN schemas.

## Optional plugins

When installed, this Vagrant project will make use of the following third party Vagrant plugins:

* [vagrant-env](https://github.com/gosuri/vagrant-env): loads environment
variables from .env files;
* [vagrant-proxyconf](https://github.com/tmatilai/vagrant-proxyconf): set
proxies in the guest VM if you need to access the Internet through a proxy. See
the plugin documentation for configuration.

To install Vagrant plugins run:

```shell
vagrant plugin install <name>...
```

## Other info

* If you need to, you can connect to the virtual machine via `vagrant ssh`.
* You can `sudo su - oracle` to switch to the oracle user.
* On the guest OS, the directory `/vagrant` is a shared folder and maps to wherever you have this file checked out.
* If you need to X11 with any user other than the `vagrant` user:
  - `vagrant ssh` -- login to your vm
  - `$ echo $DISPLAY` -- note the current display value, e.g. `localhost:10.0`
  - `$ echo xauth add `xauth list ${DISPLAY#localhost}`` -- copy the entire line that is output
  - `$ sudo su - oracle` -- switch to the oracle user
  - `$ echo $DISPLAY` -- if this is empty, set it to the value for the `vagrant` user, e.g. `$ export DISPLAY=localhost:10.0`
  - Paste the echoed string from the `echo xauth` command, and hit enter.
  - X11 should work now for the `oracle` user
ri
