# jmsmon.py
A handy script for reporting JMS message queue depths on periodic basis. Useful when running performance modeling for ODEE. Written in Python.

* Clone or download this code.
* Update the code and replace the settings shown to allow connection to your AdminServer:
```
username='weblogic'
password='Welcome1'
wlsUrl='t3://127.0.0.1:7001'
```
* Update these settings to indicate the JMS server(s) and module(s) you want to include in output. Comma-delimited.
```
includeServer = ['jms_server_1_1'];
includeJms = ['AL1Server'];
```
* Update to include/exclude queues from reporting.
```
includeDestinations = ['IdentifierReq','PresenterReq','AssemblerReq','DistributorReq','ArchiverReq','ReceiverReq','ReceiverRes','PubNotifierReq','BatcherReq','SchedulerReq','PublisherReq']
```
* Run the script in WLST context:
```
#!/bin/sh
. ./set_middleware_env.sh
wlst.sh jmsmon.py
```