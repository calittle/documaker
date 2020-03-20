# ODEE Utilities

## TransUpdate.java
A handy utility that will change the TRNSTATUS for a given TRN_ID, and then post a message to a queue with the TRN_ID.

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
 -c,--constring <arg>   Connection String (e.g.jdbc:oracle:thin:@localhost:1521:orcl)
 -f,--qcf <arg>         Queue Connection Factory (default: jms.al1.qcf)
 -i,--id <arg>          Transaction ID
 -p,--password <arg>    Database Password
 -q,--queue <arg>       Queue (default: jms.al1.assemberreq)
 -s,--status <arg>      Transaction Status (default:211)
 -u,--user <arg>        Database User (e.g. dmkr_asline)
 -w,--wlsurl <arg>      WebLogic JMS Server URL (default: t3://localhost:11001)
```
Example execution:
```java -cp ./commons-cli-1.4.jar:/oracle/db/ohome/jdbc/lib/ojdbc7.jar:/oracle/fmw/wcp12c/wlserver/server/lib/wljmsclient.jar:. TransUpdate -i 444 -s 221 -c jdbc:oracle:thin:@localhost:1521:orcl -p tiger -u scott -w t3://localhost:16200```

### Use Case 1 - Move a stuck transaction
A transaction stuck in DocFactory an arbitrary status can be moved to a previous status. 

### Use Case 2 - Reprocess a transaction
A transaction in complete status 999 can be processed again -- _not as a new transaction_. Keep in mind this will generate new recipients, batches, and publications so you if you do __not__ want the old data you will need to modify the program to do this. 