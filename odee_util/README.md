# ODEE Utilities

## TransUpdate.java
A handy utility that will change the TRNSTATUS for a given TRN_ID, and then post a message to a queue with the TRN_ID. Optionally you can have the program remove existing data associated with the transaction prior to changing the status.

__Required Libraries__
1. Apache Commons CLI - commons-cli-1.4.jar available [here](https://commons.apache.org/proper/commons-cli/download_cli.cgi)
1. Oracle JDBC - found in `<DB_HOME>/jdbc/lib/ojdbc7.jar`
1. WebLogic Server JMS Client - found in `<WLS_HOME>/wlserver/server/lib/wljmsclient.jar`

__Usage__
1. Download and compile Java code to a class file.
```
javac -cp ./commons-cli-1.4.jar:./ojdbc7.jar:./wljmsclient.jar:. TransUpdate.java
```

2. Execute program with appropriate parameters.
```
java -cp ./commons-cli-1.4.jar:./ojdbc7.jar:./wljmsclient.jar:. TransUpdate
usage: TransUpdate

Change the TRNSTATUS for a given TRN_ID, and then post a message to a
queue with the TRN_ID.

Optionally remove existing data associated with the transaction prior to
changing the status.
 -c,--constring <arg>   Database Connection String (e.g. jdbc:oracle:thin:@localhost:1521:orcl)
 -d,--dbclass <arg>     Database connection class name (default: oracle.jdbc.driver.OracleDriver)
 -f,--qcf <arg>         Queue Connection Factory (default: jms.al1.qcf)
 -i,--id <arg>          Transaction ID(s) to modify (comma-delimited)
 -p,--password <arg>    Assembly Line User Password
 -q,--queue <arg>       Queue (default: jms.al1.assemberreq)
 -r,--remove            Remove TRNS data elements and related
                        BCHS/RCPS/PUBS records. Optional integer argument:
                        [1] removes TRNNAPOL data only.
                        [2] removes related BCHS/RCPS/PUBS records only.
                        [3] removes both.
                        Default behavior is [1].
                        [1] or [3] is recommended if setting TRNSTATUS to 221 for Assembler processing.
 -s,--status <arg>      New Transaction Status (default:221)
 -t,--test              Test run; no updates will be performed or messages actually sent.
 -u,--user <arg>        Assembly Line Database User (e.g. dmkr_asline)
 -w,--wlsurl <arg>      WebLogic JMS Server URL (default: t3://localhost:11001)

Please report issues at https://github.com/calittle/documaker/issues
```
Example execution:

```java -cp ./commons-cli-1.4.jar:/oracle/db/ohome/jdbc/lib/ojdbc7.jar:/oracle/fmw/wcp12c/wlserver/server/lib/wljmsclient.jar:. TransUpdate -r 3 -i 444,434,20234 -s 221 -c jdbc:oracle:thin:@localhost:1521:orcl -p tiger -u scott -w t3://localhost:16200```

### Use Case 1 - Move a stuck transaction
A transaction stuck in DocFactory an arbitrary status can be moved to a previous status. 

### Use Case 2 - Reprocess a transaction
A transaction in complete status 999 can be processed again, but _not as a new transaction_. This means that the transaction will keep its TRN_ID, and any existing BCHS, RCPS, and PUBS will remain associated with the transaction. If you need a wholly new transaction, use _doPublishFromFactory_ instead. You also have the ability to specify the `--remove` option to remove any existing BCHS, RCPS, and PUBS associated with the transaction. 