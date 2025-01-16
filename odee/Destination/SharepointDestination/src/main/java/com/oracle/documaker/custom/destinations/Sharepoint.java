package com.oracle.documaker.custom.destinations;
import oracle.documaker.ecmconnector.connectorapi.data.ConfigurationData;
import oracle.documaker.ecmconnector.connectorapi.data.DataIdentifier;
import oracle.documaker.ecmconnector.connectorapi.data.DocumentData;
import oracle.documaker.ecmconnector.connectorapi.data.ECMDocument;
import oracle.documaker.ecmconnector.connectorapi.exceptions.DestinationException;
import oracle.documaker.ecmconnector.connectorapi.exceptions.ExceptionCodes;

import org.apache.log4j.Logger;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.*;

/**
 * A SharePoint destination.
 * - Requires authorization to the endpoint, using credentials, to obtain a Bearer Token
 * - Token must be passed with subsequent requests.
 */
public class Sharepoint {
    private static final Logger logger = Logger.getLogger(Sharepoint.class.getName());
    private static Sharepoint sharepoint;
    private static Hashtable<String, Sharepoint> alternateSystems;
    private String identifier;
    private ConfigurationData configurationData;
    private Sharepoint() {
    }
    static Sharepoint getInstance() {
        if (sharepoint == null) {
            sharepoint = new Sharepoint();
        }
        return sharepoint;
    }
    static synchronized Sharepoint getInstance(String identifier) throws DestinationException {
        try {
            if (identifier == null) {
                return getInstance();
            }
            if (alternateSystems == null) {
                alternateSystems = new Hashtable<>();
            }
            Sharepoint s = alternateSystems.get(identifier);
            if (s == null) {
                s = new Sharepoint();
                s.identifier = identifier;
                alternateSystems.put(identifier, s);
            }
            return s;
        } catch (Exception e) {
            throw new DestinationException(e);
        }
    }
    synchronized void configure(ConfigurationData configData) throws DestinationException {
        this.configurationData = configData;
        for (String prop : configData.stringPropertyNames()){
            logger.debug(prop + " = [" + configData.getProperty(prop) + "]");
        }

        try {
            logger.debug("Custom configuration details:");
//            this.endpoint = configData.getProperty("FileNet.client.endpoint","");
//            logger.debug("client.endpoint [" + this.endpoint + "]");
        } catch (Exception e) {
            logger.error("Exception thrown in configure() [" + e.getMessage() + "]");
            throw new DestinationException(e);
        }
    }
    private Properties populateImportData(DocumentData documentData) throws DestinationException {
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
        } catch (Exception e) {
            logger.error("Exception thrown in populateImportData() [" + e.getMessage() + "]");
            throw new DestinationException(e);
        }
        return returnVal;
    }
    synchronized void uploadDocumentContents(DocumentData documentData) throws DestinationException {
        // Parse document metadata into a Properties object.
        // Obtain document properties for use below.
        Properties documentProperties = populateImportData(documentData);
        String fileMimeType;
        switch (documentProperties.getProperty("document.extension", "none").toUpperCase(Locale.ROOT)) {
            case ("PDF"):
                fileMimeType = "application/pdf";
                break;
            case ("TXT"):
                fileMimeType = "text/plain";
                break;
            default:
                fileMimeType = "application/octet-stream";
                break;
        }
        // Obtain document stream as base-64 encoded string.
        String fileStream;
        ECMDocument ecmDocument = documentData.getECMDocument();
        long fileLength = ecmDocument.getContentLength();

        try (InputStream docInputStream = ecmDocument.acquireStream().getInputStream()) {
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            int readBytes;
            byte[] data = new byte[4];
            while ((readBytes = docInputStream.read(data, 0, data.length)) != -1) {
                buffer.write(data, 0, readBytes);
            }
            buffer.flush();
            byte[] fileBytes = buffer.toByteArray();
            fileStream = Base64.getEncoder().encodeToString(fileBytes);
            documentData.setResultCode(DocumentData.IMPORTED);

        } catch (Exception e) {
            logger.error("Exception thrown in uploadDocumentContents.getInputStream() [" + e.getMessage() + "]");
            throw new DestinationException("Error acquiring document - " + e.getMessage(), ExceptionCodes.CNT0501300003, new Object[]{e.getMessage()});
        }
    }
}
