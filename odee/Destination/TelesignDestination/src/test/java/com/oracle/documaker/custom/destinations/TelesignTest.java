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
        props.setProperty("Telesign.customerid","ADEF119C-883B-4206-BF79-0D75E282F8F2");
        props.setProperty("Telesign.apikey","p/Rp9mnUcwy6icCX0kIpTV54Vd0/R9VqWNVQLJfmHjiscjkxk1PEX3hK5JnvD00YaJL159lsAFbc9BFd61cirg==");
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
