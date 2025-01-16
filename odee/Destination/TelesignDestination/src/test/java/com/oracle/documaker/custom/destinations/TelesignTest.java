package com.oracle.documaker.custom.destinations;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import oracle.documaker.ecmconnector.connectorapi.data.ConfigurationData;
import oracle.documaker.ecmconnector.connectorapi.data.DocumentData;
import oracle.documaker.ecmconnector.connectorapi.data.ECMDocument;
import oracle.documaker.ecmconnector.connectorapi.data.ECMInputStream;
import oracle.documaker.ecmconnector.connectorapi.exceptions.ECMDocumentException;

import java.util.Properties;

public class TelesignTest extends TestCase{
    public TelesignTest(String testName )
    {
        super( testName );
    }
    public static Test suite()
    {
        return new TestSuite( TelesignTest.class );
    }

    public void testApp()
    {
        Properties props = new Properties();
        props.setProperty("Telesign.customerid","Your-Customer-ID");
        props.setProperty("Telesign.apikey","Your-APIKey");
        props.setProperty("Telesign.message","This is a test.");
        props.setProperty("Bitly.enabled","false");
        //TO-DO
        props.setProperty("Telesign.target","INPUT-PHONE-NUMBER-HERE-FOR-SMS-DELIVERY");

        ConfigurationData configurationData = new ConfigurationData(props);

        ECMDocument ecmDocument = new ECMDocument() {
            @Override
            public String acquireFilePath() throws ECMDocumentException {
                return null;
            }

            @Override
            public ECMInputStream acquireStream() throws ECMDocumentException {
                return null;
            }

            @Override
            public long getContentLength() {
                return 0;
            }

            @Override
            public void release() throws ECMDocumentException {

            }
        };
        DocumentData documentData = new DocumentData("BATCHID", ecmDocument);
        try {
            TelesignDestination telesignDestination = new TelesignDestination(configurationData, "telesign");
            telesignDestination.importDocument(documentData);
        }
        catch(Exception e){
            // do something.
            e.printStackTrace();
        }
    }
}
