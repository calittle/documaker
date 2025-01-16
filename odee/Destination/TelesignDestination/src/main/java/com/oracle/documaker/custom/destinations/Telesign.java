package com.oracle.documaker.custom.destinations;

import com.telesign.MessagingClient;
import com.telesign.RestClient;

import oracle.documaker.ecmconnector.connectorapi.data.ConfigurationData;
import oracle.documaker.ecmconnector.connectorapi.data.DataIdentifier;
import oracle.documaker.ecmconnector.connectorapi.data.DocumentData;
import oracle.documaker.ecmconnector.connectorapi.exceptions.DestinationException;

import org.apache.log4j.Logger;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Properties;

public class Telesign
{
    private static final Logger logger = Logger.getLogger(Telesign.class.getName());
    private static Telesign ts;
    private String identifier;
    private String customerId;
    private String apiKey;
    private String messageType;
    private String message;
    private String target;
    private static Hashtable<String, Telesign> alternateSystems;
    private ConfigurationData configurationData;
    private Telesign() {
        logger.debug("Instantiated.");
    }
    static Telesign getInstance() {
        logger.debug("Executing getInstance");
        if (ts == null) {
            logger.debug("Creating singleton instance");
            ts = new Telesign();
        }
        return ts;
    }
    static synchronized Telesign getInstance(String identifier) throws DestinationException {
        logger.debug("Executing getInstance for " + identifier);
        try {
            if (identifier == null) {
                return getInstance();
            }
            if (alternateSystems == null) {
                alternateSystems = new Hashtable<>();
            }
            Telesign retVal = alternateSystems.get(identifier);
            if (retVal == null) {
                retVal = new Telesign();
                retVal.identifier = identifier;
                logger.debug("Created " + retVal.identifier);
                alternateSystems.put(identifier, retVal);
            }
            return retVal;
        } catch (Exception e) {
            throw new DestinationException(e);
        }
    }

    synchronized void configure(ConfigurationData configData) throws DestinationException {
        logger.debug("> configure");
        this.configurationData = configData;

        logger.debug("Configuration details:");
        for (String prop : configData.stringPropertyNames()){
            logger.debug(prop + " = [" + configData.getProperty(prop) + "]");
        }

        try {
            logger.debug("Custom configuration details:");

            this.customerId = configData.getProperty("Telesign.customerid","");
            logger.debug("Telesign.customerid [" + this.customerId + "]");
            if (this.customerId.isEmpty()){
                throw new DestinationException("Missing Telesign.customerid configuration value.");
            }

            this.apiKey = configData.getProperty("Telesign.apikey","");
            logger.debug("Telesign.apikey [" + this.apiKey + "]");
            if (this.apiKey.isEmpty()){
                throw new DestinationException("Missing Telesign.apikey configuration value.");
            }

            this.messageType = configData.getProperty("Telesign.messagetype","ARN");
            logger.debug("Telesign.messagetype [" + this.messageType + "]");

            this.message = configData.getProperty("Telesign.message","");
            logger.debug("Telesign.message [" + this.message + "]");
            if (this.message.isEmpty()){
                throw new DestinationException("Missing Telesign.message configuration value.");
            }

            this.target = configData.getProperty("Telesign.target","");
            logger.debug("Telesign.target [" + this.target + "]");
            if (this.target.isEmpty()){
                throw new DestinationException("Missing Telesign.target configuration value.");
            }

        } catch (Exception e) {
            logger.error("Exception thrown in configure() [" + e.getMessage() + "]");
            throw new DestinationException(e);
        }
        logger.debug("< configure");

    }

    private Properties populateImportData(DocumentData documentData) throws DestinationException {
        logger.debug("> populateImportData:");
        Properties returnVal = new Properties();
        try {
            Enumeration<DataIdentifier> propEnum = documentData.keys();
            while (propEnum.hasMoreElements()) {
                DataIdentifier dataDetail = propEnum.nextElement();
                Object dataItem = documentData.get(dataDetail);
                if (dataItem != null) {
                    returnVal.setProperty(dataDetail.getName(), dataItem.toString());
                    logger.debug(dataDetail.getName() + " = " + dataItem);
                }
            }
            logger.debug("< populateImportData");
        } catch (Exception e) {
            logger.error("Exception thrown in populateImportData() [" + e.getMessage() + "]");
            throw new DestinationException(e);
        }
        return returnVal;
    }

    synchronized void sendNotification(DocumentData documentData) throws DestinationException {
       try {
           MessagingClient messagingClient = new MessagingClient(this.customerId, this.apiKey);
           RestClient.TelesignResponse telesignResponse = messagingClient.message(this.target, this.message, this.messageType, null);
           if (telesignResponse.statusCode!=200){
               throw new DestinationException("Unable to send notification. HTTPStatus=(" + telesignResponse.statusCode + ") HTTPResponse=(" + telesignResponse.body +")");
           }else{
               // can capture debug here if needed...
           }
       } catch (Exception e) {
           throw new DestinationException(e);
       }
    }
}
