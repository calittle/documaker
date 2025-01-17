package com.oracle.documaker.custom.destinations.tests;

import com.oracle.documaker.custom.destinations.HttpApiDestination;
import com.oracle.documaker.custom.destinations.HttpApiDestinationSystem;
import oracle.documaker.ecmconnector.connectorapi.data.*;
import oracle.documaker.ecmconnector.connectorapi.exceptions.DestinationException;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

import static org.junit.jupiter.api.Assertions.*;

class httpApiDestinationTest {

    private HttpApiDestinationSystem fnDestinationSystem;
    private HttpApiDestination fnDestination;
    private DocumentData documentData;
    private ConfigurationData configData;

    private void buildDocument(){
        // create a simple local file
        ECMDocument ecmDocument = new FileECMDocument("src/test/resources/document.txt");

        // attach the file and add some metadata.
        documentData = new DocumentData("101", ecmDocument);
        documentData.put(new DataIdentifier("custom.repositoryId",false),"repID");
        documentData.put(new DataIdentifier("custom.authUser",false),"auser");
        documentData.put(new DataIdentifier("custom.folderId",false),"/some_folder");
        documentData.put(new DataIdentifier("custom.versioningState",false),"none"); // none, major, minor, checkedout

        documentData.put(new DataIdentifier("custom.addACES.1.principalId",false),"SSO_PRIN");
        documentData.put(new DataIdentifier("custom.addACES.1.permission",false),"READ");
        documentData.put(new DataIdentifier("custom.addACES.1.direct",false),"true");
        documentData.put(new DataIdentifier("custom.addACES.total",false),"1");

        documentData.put(new DataIdentifier("custom.propertyId.1.definitionId",false),"ClientID");
        documentData.put(new DataIdentifier("custom.propertyId.1.localName",false),"rep-cmis:name");
        documentData.put(new DataIdentifier("custom.propertyId.1.displayName",false),"Customer ID");
        documentData.put(new DataIdentifier("custom.propertyId.1.queryName",false),"cmis:objectId");
        documentData.put(new DataIdentifier("custom.propertyId.1.value",false),"1234EG");
        documentData.put(new DataIdentifier("custom.propertyId.total",false),"1");

        documentData.put(new DataIdentifier("custom.propertyString.1.definitionId",false),"ClientID");
        documentData.put(new DataIdentifier("custom.propertyString.1.localName",false),"rep-cmis:name");
        documentData.put(new DataIdentifier("custom.propertyString.1.displayName",false),"Customer ID");
        documentData.put(new DataIdentifier("custom.propertyString.1.queryName",false),"cmis:objectId");
        documentData.put(new DataIdentifier("custom.propertyString.1.value",false),"1234EG");
        documentData.put(new DataIdentifier("custom.propertyString.total",false),"1");

        documentData.put(new DataIdentifier("custom.propertyBoolean.1.definitionId",false),"ClientID");
        documentData.put(new DataIdentifier("custom.propertyBoolean.1.localName",false),"rep-cmis:name");
        documentData.put(new DataIdentifier("custom.propertyBoolean.1.displayName",false),"Customer ID");
        documentData.put(new DataIdentifier("custom.propertyBoolean.1.queryName",false),"cmis:objectId");
        documentData.put(new DataIdentifier("custom.propertyBoolean.1.value",false),"1234EG");
        documentData.put(new DataIdentifier("custom.propertyBoolean.total",false),"1");

        documentData.put(new DataIdentifier("custom.propertyDateTime.1.definitionId",false),"ClientID");
        documentData.put(new DataIdentifier("custom.propertyDateTime.1.localName",false),"rep-cmis:name");
        documentData.put(new DataIdentifier("custom.propertyDateTime.1.displayName",false),"Customer ID");
        documentData.put(new DataIdentifier("custom.propertyDateTime.1.queryName",false),"cmis:objectId");
        documentData.put(new DataIdentifier("custom.propertyDateTime.1.value",false),"1234EG");
        documentData.put(new DataIdentifier("custom.propertyDateTime.total",false),"1");

        documentData.put(new DataIdentifier("document.extension",false),"txt");
        documentData.put(new DataIdentifier("document.filename",false),"123456");

    }
    @Test
    void importLocalDocumentViaHttpDoesNotThrow(){
        setUpHttp();
        buildDocument();
        Assertions.assertDoesNotThrow(() -> {fnDestination.importDocument(documentData);});
    }
    @Test
    void importLocalDocumentUsingSwaggerDoesNotThrow(){
        setupSwagger();
        buildDocument();
        Assertions.assertDoesNotThrow(() -> {fnDestination.importDocument(documentData);});

    }

    @Test
    void importLocalDocumentViaHttpThrowsAuthenticationError(){
        setUpHttpWithBadAuthentication();
        buildDocument();
        DestinationException thrown = Assertions.assertThrows(
                DestinationException.class,
                ()->fnDestination.importDocument(documentData),
                "importDocument() should throw DestinationException when authentication fails."
        );
    }
    @Test
    void importLocalDocumentViaHttpThrowsBadDataError(){
        setUpHttp();
        buildDocument();
        DestinationException thrown = Assertions.assertThrows(
                DestinationException.class,
                ()->fnDestination.importDocument(documentData),
                "importDocument() should throw DestinationException when authentication fails."
        );
    }
    void setupSwagger(){
        // simulate getting config data from Administrator tables.
        configData = new ConfigurationData();
        configData.put("FileNet.client", "openapi");
        configData.put("FileNet.client.endpoint", "http://127.0.0.1:4010");
        configData.put("FileNet.auth.apiKey.clientId", "theClientId");
        configData.put("FileNet.auth.apiKey.clientSecret", "theClientSecret");
        configData.put("FileNet.swagger.sslCertValidationEnabled", "false");
        configData.put("FileNet.header.applicationName", "theApplicationName");
        configData.put("FileNet.header.traceId", "theTraceId");
        configData.put("FileNet.header.operator", "theOperator");
        Assertions.assertDoesNotThrow(() -> {
            fnDestination = new HttpApiDestination(configData, "FileNet");
        });
    }
    void setupSwaggerWithBadEndpoint(){
        // simulate getting config data from Administrator tables.
        configData = new ConfigurationData();
        configData.put("FileNet.client", "openapi");
        configData.put("FileNet.client.endpoint", "http://127.0.0.1:1");
        configData.put("FileNet.auth.apiKey.clientId", "theClientId");
        configData.put("FileNet.auth.apiKey.clientSecret", "theClientSecret");
        configData.put("FileNet.swagger.sslCertValidationEnabled", "false");
        configData.put("FileNet.header.applicationName", "theApplicationName");
        configData.put("FileNet.header.traceId", "theTraceId");
        configData.put("FileNet.header.operator", "theOperator");
        Assertions.assertDoesNotThrow(() -> {
            fnDestination = new HttpApiDestination(configData, "FileNet");
        });
    }
    void setUpHttpWithBadAuthentication() {
        // simulate getting config data from Administrator tables.
        configData = new ConfigurationData();
        configData.put("FileNet.client","http");
        configData.put("FileNet.client.endpoint","https://localhost:8443");
        configData.put("FileNet.client.hostnameVerificationEnabled","false");
        configData.put("FileNet.auth.basic.authName","basicAuth");
        configData.put("FileNet.header.x-ibm-clientid", "defaultClientId");
        configData.put("FileNet.header.x-ibm-clientsecret", "defaultClientSecret");
        configData.put("FileNet.header.applicationName", "defaultApplicationName");
        configData.put("FileNet.header.traceId", "defaultTraceId");
        configData.put("FileNet.header.operator", "defaultOperator");
        configData.put("FileNet.auth.basic.user","abc");
        configData.put("FileNet.auth.basic.password","abc");

        Assertions.assertDoesNotThrow(() -> {
            fnDestination = new HttpApiDestination(configData, "FileNet");
        });

    }

    void setUpHttp() {
        // simulate getting config data from Administrator tables.
        configData = new ConfigurationData();
        configData.put("FileNet.client","http");
        configData.put("FileNet.client.endpoint","https://localhost:8443");
        configData.put("FileNet.client.hostnameVerificationEnabled","false");
        configData.put("FileNet.auth.basic.authName","basicAuth");
        configData.put("FileNet.header.x-ibm-clientid", "defaultClientId");
        configData.put("FileNet.header.x-ibm-clientsecret", "defaultClientSecret");
        configData.put("FileNet.header.applicationName", "defaultApplicationName");
        configData.put("FileNet.header.traceId", "defaultTraceId");
        configData.put("FileNet.header.operator", "defaultOperator");
        configData.put("FileNet.auth.basic.user","abc");
        configData.put("FileNet.auth.basic.password","123");

        Assertions.assertDoesNotThrow(() -> {
            fnDestination = new HttpApiDestination(configData, "FileNet");
        });

    }

    @Test
    void importLocalDocumentUsingSwaggerDoesThrow() {
        setupSwaggerWithBadEndpoint();
        buildDocument();
        DestinationException thrown = Assertions.assertThrows(
                DestinationException.class,
                ()->fnDestination.importDocument(documentData),
                "importDocument() should throw DestinationException when API is not available."
        );

        assertTrue(thrown.getMessage().contains("Error calling Swagger API"));
    }
}