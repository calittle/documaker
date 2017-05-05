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


import thread
import time
from time import gmtime, strftime
  
username='weblogic'
password='Oracle12'
wlsUrl='t3://localhost:11001'
 
connect(username,password, wlsUrl)
 
def getTime():
 return strftime("%Y-%m-%d %H:%M:%S", gmtime())
 
def monitorJms():
 servers = domainRuntimeService.getServerRuntimes();
 if (len(servers) > 0):
     for server in servers:
       jmsRuntime = server.getJMSRuntime();
       jmsServers = jmsRuntime.getJMSServers();
       for jmsServer in jmsServers:
           destinations = jmsServer.getDestinations();
  
           for destination in destinations:
               try:
                    print  getTime() , '|' , server.getName() , '|' , jmsServer.getName() , '|' ,
                            destination.getName() , '|' ,destination.getMessagesCurrentCount(), '|' ,
                            destination.getMessagesPendingCount() , '|', 
                            destination.getMessagesHighCount() , '|' ,
                            destination.getMessagesReceivedCount() , '|' ,
                            destination.getMessagesMovedCurrentCount() , '|' , 
                            destination.getConsumersCurrentCount() , '|' ,
                            destination.getConsumersHighCount() , '|' ,
                            destination.getConsumersTotalCount()
                except:
                    print 'ERROR_DATA';
 
 
print 'Time | ServerName | JMSServerName | DestName | MessagesCurrentCount | MessagesPendingCount | MessagesHighCount | MessagesReceivedCount | MessagesMovedCurrentCount | ConsumersCurrentCount | ConsumersHighCount | ConsumersTotalCount';
while 1:
     monitorJms();
     print '';
     java.lang.Thread.sleep(15000);
