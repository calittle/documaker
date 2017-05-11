# LICENSE CDDL 1.0 + GPL 2.0
#
# Copyright (c) 2017 Oracle and/or its affiliates. All rights reserved.
#
# Since: May, 2017
# Author: andy.little@oracle.com
# Description: WebLogic JMS Monitor
# Useful for tracking JMS Message levels in Documaker
# Enterprise environments.
#
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
#

import time
from time import gmtime, strftime

username='weblogic'
password='Welcome1'
wlsUrl='t3://127.0.0.1:7001'
sleepTime=5000;
connect(username,password, wlsUrl)
includeServer = ['jms_server'];
includeJms = ['AL1Server'];
# remove any destinations here you don't want to be included in your output.
includeDestinations = ['IdentifierReq','PresenterReq','AssemblerReq','DistributorReq','ArchiverReq','ReceiverReq','ReceiverRes','PubNotifierReq','BatcherReq','SchedulerReq','PublisherReq']

def getTime():
 return strftime("%Y-%m-%d %H:%M:%S", gmtime())

def monitorJms():
 servers = domainRuntimeService.getServerRuntimes();
 if (len(servers) > 0):
     for server in servers:
       serverName = server.getName()
       if serverName in includeServer:
                jmsRuntime = server.getJMSRuntime();
                jmsServers = jmsRuntime.getJMSServers();
                for jmsServer in jmsServers:
                        jmsName = jmsServer.getName();
                        if jmsName in includeJms:
                                destinations = jmsServer.getDestinations();
                                for destination in destinations:
                                        destName = destination.getName();
                                        destName = destName[destName.find('@')+1:];
                                        if destName in includeDestinations:
                                                try:
                                                        print "%s,%s,%s,%s,%s,%s,%s" %(getTime(),serverName,jmsName,destName,destination.getMessagesCurrentCount(),destination.getMessagesHighCount(),destination.getConsumersCurrentCount());
                                                except:
                                                        print 'ERROR_DATA';

print 'Time,ServerName,JMSServer,Destination,Msgs Cur,Msgs High,ConsumersCur';
#print '        Time        | ServerName | JMSServer | DestName                 | Mesg Cur,High         | ConsumersCurrentCount ';
while 1:
     monitorJms();
     print '';
     java.lang.Thread.sleep(sleepTime);
