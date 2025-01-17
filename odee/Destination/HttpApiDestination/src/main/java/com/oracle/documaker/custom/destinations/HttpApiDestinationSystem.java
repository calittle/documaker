package com.oracle.documaker.custom.destinations;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import io.swagger.client.ApiClient;
import io.swagger.client.Configuration;
import io.swagger.client.api.DefaultApi;
import io.swagger.client.auth.ApiKeyAuth;
import io.swagger.client.auth.HttpBasicAuth;
import io.swagger.client.model.*;
import oracle.documaker.ecmconnector.connectorapi.data.ConfigurationData;
import oracle.documaker.ecmconnector.connectorapi.data.DataIdentifier;
import oracle.documaker.ecmconnector.connectorapi.data.DocumentData;
import oracle.documaker.ecmconnector.connectorapi.data.ECMDocument;
import oracle.documaker.ecmconnector.connectorapi.exceptions.DestinationException;
import oracle.documaker.ecmconnector.connectorapi.exceptions.ExceptionCodes;

import java.io.*;
import java.math.BigDecimal;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.*;

import org.apache.log4j.Logger;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

public class HttpApiDestinationSystem {
    private static final Logger logger = Logger.getLogger(HttpApiDestinationSystem.class.getName());
    private static HttpApiDestinationSystem fnDestinationSystem;
    private static Hashtable<String, HttpApiDestinationSystem> alternateSystems;
    //private boolean configured;
    private String identifier;

    private String clientId;
    private String clientSecret;
    private String applicationName;
    private String traceId;
    private String operator;
    private String endpoint;
    private String authUsername;
    private String authPassword;

    private ClientType clientType = ClientType.HTTP;

    private ConfigurationData configurationData;

    private String authorizationHeaderValue;

    private boolean hostNameVerificationEnabled = true;
    private String basicAuthName;
    private static final String DEBUG_NAME = "fileNetDestinationSystem";
    private HttpApiDestinationSystem() {
        logger.debug(DEBUG_NAME + " > Instantiated.");
        //this.configured = false;
    }

    /**
     * Creates a new singleton instance of the fileNetDestinationSystem, if an alternative is needed.
     *
     * @return a new instance.
     */
    static HttpApiDestinationSystem getInstance() {
        logger.debug(DEBUG_NAME + " > Executing getInstance");
        if (fnDestinationSystem == null) {
            logger.debug(DEBUG_NAME + " > Creating singleton instance");
            fnDestinationSystem = new HttpApiDestinationSystem();
        }
        return fnDestinationSystem;
    }

    /**
     * Creates a new instance of the FileNetDestinationSystem.
     *
     * @param identifier - the batch identifier that the system will process
     * @return a fileNetDestinationSystem object
     * @throws DestinationException when a configuration error occurs or when an exception halts the processing.
     */
    static synchronized HttpApiDestinationSystem getInstance(String identifier) throws DestinationException {
        logger.debug(DEBUG_NAME + " > Executing getInstance for " + identifier);
        try {
            if (identifier == null) {
                return getInstance();
            }
            if (alternateSystems == null) {
                alternateSystems = new Hashtable<>();
            }
            HttpApiDestinationSystem retVal = alternateSystems.get(identifier);
            if (retVal == null) {
                retVal = new HttpApiDestinationSystem();
                retVal.identifier = identifier;
                logger.debug("Created " + retVal.identifier);
                alternateSystems.put(identifier, retVal);
            }
            return retVal;
        } catch (Exception e) {
            throw new DestinationException(e);
        }
    }

    /**
     * Configures the FileNetDestinationSystem with configuration parameters passed from Documaker Administrator's
     * database of settings.
     *
     * @param configData containing the parameters to use for configuration
     * @throws DestinationException when configuration fails or exceptions are handled (by rethrowing)
     */
    synchronized void configure(ConfigurationData configData) throws DestinationException {
        logger.debug(DEBUG_NAME + " > configure");
        this.configurationData = configData;
        logger.debug("Configuration details:");
        for (String prop : configData.stringPropertyNames()){
            logger.debug(prop + " = [" + configData.getProperty(prop) + "]");
        }

        try {
            logger.debug("Custom configuration details:");

            if (configData.getProperty("FileNet.client","http").equalsIgnoreCase("openapi")){
                this.clientType = ClientType.OPENAPI;
                logger.debug("Using ClientType OPENAPI. To override this behavior, set client = 'http' in Configuration.");
            }else{
                this.clientType = ClientType.HTTP;
                logger.debug("Using ClientType HTTP. To override this behavior, set client = 'openapi' in Configuration.");
            }

            this.endpoint = configData.getProperty("FileNet.client.endpoint","");
            logger.debug("client.endpoint [" + this.endpoint + "]");

            this.basicAuthName = configData.getProperty("FileNet.auth.basic.authName","basicAuth");
            logger.debug("auth.basic.authName [" + this.basicAuthName + "]");

//            if (useHttp = Boolean.parseBoolean(configData.getProperty("FileNet.debug.useHttp", "false"));
//            logger.debug("debug.useHttp = [" + useHttp + "]");

//            endpoint = configData.getProperty("FileNet.debug.httpEndpoint", "http://localhost:8080");
//            logger.debug("debug.httpEndpoint = [" + endpoint + "]");

            clientId = configData.getProperty("FileNet.auth.apiKey.clientId", "defaultClientId");
            logger.debug("auth.apiKey.clientId = [" + clientId + "]");

            clientSecret = configData.getProperty("FileNet.auth.apiKey.clientSecret", "defaultClientSecret");
            logger.debug("auth.apiKey.clientSecret = [" + clientSecret + "]");

            applicationName = configData.getProperty("FileNet.header.applicationName", "defaultApplicationName");
            logger.debug("header.applicationName = [" + applicationName + "]");

            traceId = configData.getProperty("FileNet.header.traceId", "defaultTraceId");
            logger.debug("header.traceId = [" + traceId + "]");

            operator = configData.getProperty("FileNet.header.operator", "defaultOperator");
            logger.debug("header.operator = [" + operator + "]");

            // CAL 13JUN23 added to map configuration properties for endpoint authentication.
            authUsername = configData.getProperty("FileNet.auth.basic.user","");
            if (!authUsername.isEmpty())
                logger.debug("auth.basic.user = [" + authUsername + "]");

            authPassword = configData.getProperty("FileNet.auth.basic.password","");
            if (!authPassword.isEmpty())
                logger.debug("auth.basic.password = [***]");

            if (!authPassword.isEmpty() && !authUsername.isEmpty()){
                // create authentication data.
                String auth = authUsername + ":" + authPassword;
                byte[] encodedAuth = Base64.getEncoder().encode(auth.getBytes(StandardCharsets.UTF_8));
                this.authorizationHeaderValue = "Basic " + new String(encodedAuth);
            }

            hostNameVerificationEnabled = Boolean.parseBoolean(configData.getProperty("FileNet.client.hostnameVerificationEnabled","true"));
            logger.debug("client.hostnameVerificationEnabled = " + hostNameVerificationEnabled);

        } catch (Exception e) {
            logger.error("Exception thrown in configure() [" + e.getMessage() + "]");
            throw new DestinationException(e);
        }
        logger.debug(DEBUG_NAME + " < configure");

    }

    /**
     * Helper function to parse document metadata into a Properties object.
     *
     * @param documentData - a key/list hash of metadata elements about the current document.
     * @return Properties - a properties object containing parsed document metadata.
     * @throws DestinationException when an error occurs.
     */
    private Properties populateImportData(DocumentData documentData) throws DestinationException {
        logger.debug(DEBUG_NAME + " > populateImportData:");

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
            logger.debug(DEBUG_NAME + "< populateImportData");
        } catch (Exception e) {
            logger.error("Exception thrown in populateImportData() [" + e.getMessage() + "]");
            throw new DestinationException(e);
        }
        return returnVal;
    }

    /**
     * Use document data and metadata from Archiver to create a POST request using OpenAPI.
     * This serves as the interface between DocFactory Archiver and FileNet.
     *
     * @param documentData - a DocFactory object containing document stream and metadata
     * @throws DestinationException when errors occur.
     */
    synchronized void uploadDocumentContents(DocumentData documentData) throws DestinationException {

        logger.debug(DEBUG_NAME + " > uploadDocumentContents");
        // track if any swagger properties were set.
        boolean propertiesSet = false;

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
        String fileName = documentProperties.getProperty("document.filename");
        String repositoryId = documentProperties.getProperty("custom.repositoryId");
        String authUser = documentProperties.getProperty("custom.authUser");
        String folderId = documentProperties.getProperty("custom.folderId");
        String versioningState = documentProperties.getProperty("custom.versioningState");

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
        } catch (Exception e) {
            logger.error("Exception thrown in uploadDocumentContents.getInputStream() [" + e.getMessage() + "]");
            throw new DestinationException("Error acquiring document - " + e.getMessage(), ExceptionCodes.CNT0501300003, new Object[]{e.getMessage()});
        }

        DocumentsRequest body;
        try {
            body = new DocumentsRequest();
            // set the content stream (document file)
            io.swagger.client.model.ContentStream cs = new io.swagger.client.model.ContentStream();
            cs.setFilename(fileName);
            cs.setLength(BigDecimal.valueOf(fileLength));
            cs.setMimeType(fileMimeType);
            cs.setStream(fileStream);
            body.setContentStream(cs);

            // Set custom properties
            //
            // Id
            //
            io.swagger.client.model.Properties swaggerProps = new io.swagger.client.model.Properties();
            int counter = Integer.parseInt(documentProperties.getProperty("custom.propertyId.total", "0"));
            while (counter > 0) {
                propertiesSet = true;
                Elements swaggerPropElements = new Elements();
                swaggerPropElements.setDefinitionId(documentProperties.getProperty("custom.propertyId." + counter + ".definitionId"));
                swaggerPropElements.setLocalName(documentProperties.getProperty("custom.propertyId." + counter + ".localName"));
                swaggerPropElements.setDisplayName(documentProperties.getProperty("custom.propertyId." + counter + ".displayName"));
                swaggerPropElements.setQueryName(documentProperties.getProperty("custom.propertyId." + counter + ".queryName"));
                swaggerPropElements.setValue(documentProperties.getProperty("custom.propertyId." + counter + ".value"));
                swaggerProps.addPropertyIdItem(swaggerPropElements);
                counter--;
            }
            //
            // Boolean
            //
            counter = Integer.parseInt(documentProperties.getProperty("custom.propertyBoolean.total", "0"));
            while (counter > 0) {
                propertiesSet = true;
                Elements swaggerPropElements = new Elements();
                swaggerPropElements.setDefinitionId(documentProperties.getProperty("custom.propertyBoolean." + counter + ".definitionId"));
                swaggerPropElements.setLocalName(documentProperties.getProperty("custom.propertyBoolean." + counter + ".localName"));
                swaggerPropElements.setDisplayName(documentProperties.getProperty("custom.propertyBoolean." + counter + ".displayName"));
                swaggerPropElements.setQueryName(documentProperties.getProperty("custom.propertyBoolean." + counter + ".queryName"));
                swaggerPropElements.setValue(documentProperties.getProperty("custom.propertyBoolean." + counter + ".value"));
                swaggerProps.addPropertyBooleanItem(swaggerPropElements);
                counter--;
            }
            //
            // String
            //
            counter = Integer.parseInt(documentProperties.getProperty("custom.propertyString.total", "0"));
            while (counter > 0) {
                propertiesSet = true;
                Elements swaggerPropElements = new Elements();
                swaggerPropElements.setDefinitionId(documentProperties.getProperty("custom.propertyString." + counter + ".definitionId"));
                swaggerPropElements.setLocalName(documentProperties.getProperty("custom.propertyString." + counter + ".localName"));
                swaggerPropElements.setDisplayName(documentProperties.getProperty("custom.propertyString." + counter + ".displayName"));
                swaggerPropElements.setQueryName(documentProperties.getProperty("custom.propertyString." + counter + ".queryName"));
                swaggerPropElements.setValue(documentProperties.getProperty("custom.propertyString." + counter + ".value"));
                swaggerProps.addPropertyStringItem(swaggerPropElements);
                counter--;
            }
            //
            // DateTime
            //
            counter = Integer.parseInt(documentProperties.getProperty("custom.propertyDateTime.total", "0"));
            while (counter > 0) {
                propertiesSet = true;
                Elements swaggerPropElements = new Elements();
                swaggerPropElements.setDefinitionId(documentProperties.getProperty("custom.propertyDateTime." + counter + ".definitionId"));
                swaggerPropElements.setLocalName(documentProperties.getProperty("custom.propertyDateTime." + counter + ".localName"));
                swaggerPropElements.setDisplayName(documentProperties.getProperty("custom.propertyDateTime." + counter + ".displayName"));
                swaggerPropElements.setQueryName(documentProperties.getProperty("custom.propertyDateTime." + counter + ".queryName"));
                swaggerPropElements.setValue(documentProperties.getProperty("custom.propertyDateTime." + counter + ".value"));
                swaggerProps.addPropertyDateTimeItem(swaggerPropElements);
                counter--;
            }

            //
            // Add properties if not empty.
            //
            if (propertiesSet)
                body.setProperties(swaggerProps);

            //
            // Add Access Control Entries
            //
            boolean aceSet = false;
            List<AccessControlEntries> aceList = new ArrayList<>();
            counter = Integer.parseInt(documentProperties.getProperty("custom.addACES.total", "0"));
            while (counter > 0) {
                aceSet = true;
                AccessControlEntries ace = new AccessControlEntries();
                ace.setPrincipalId(documentProperties.getProperty("custom.addACES." + counter + ".principalId"));
                ace.setDirect(Boolean.parseBoolean(documentProperties.getProperty("custom.addACES." + counter + ".direct")));
                ace.setPermission(AccessControlEntries.PermissionEnum.valueOf(documentProperties.getProperty("custom.addACES." + counter + ".permission")));
                aceList.add(ace);
                counter--;
            }
            if (aceSet)
                body.addACEs(aceList);

            //
            // Remove Access Control Entries
            //
            aceSet = false;
            List<AccessControlEntries> removeAceList = new ArrayList<>();
            counter = Integer.parseInt(documentProperties.getProperty("custom.removeACES.total", "0"));
            while (counter > 0) {
                aceSet = true;
                AccessControlEntries ace = new AccessControlEntries();
                ace.setPrincipalId(documentProperties.getProperty("custom.removeACES." + counter + ".principalId"));
                ace.setDirect(Boolean.parseBoolean(documentProperties.getProperty("custom.removeACES." + counter + ".direct")));
                ace.setPermission(AccessControlEntries.PermissionEnum.valueOf(documentProperties.getProperty("custom.removeACES." + counter + ".permission")));
                removeAceList.add(ace);
                counter--;
            }
            if (aceSet)
                body.removeACEs(removeAceList);

            //
            // header elements
            //
            body.setFolderId(folderId);
            body.setRepositoryId(repositoryId);
            body.setAuthUser(authUser);
            body.setVersioningState(DocumentsRequest.VersioningStateEnum.valueOf(versioningState.toUpperCase(Locale.ROOT)));

        } catch (Exception e) {
            logger.error("Exception thrown in uploadDocumentContents setting custom properties [" + e.getMessage() + "]");
            throw new DestinationException("Error in building document request [" + e.getMessage() + "]", ExceptionCodes.CNT0500900004, new Object[]{e.getMessage()});
        }
        //
        // log the request for debugging.
        //
        logger.debug("********* Request body Start ***********\n" + body.toString() +"\n********* Request body End ************");

        //
        // This code branch selects between using an HTTP client, if the debug.useHttp = true.
        // Otherwise, the OpenAPI client is used.
        //
        if (this.clientType == ClientType.HTTP) {
            try {
                ObjectWriter ow = new ObjectMapper().writer();
                String json = ow.writeValueAsString(body);
                byte[] utf8bytes = json.getBytes(StandardCharsets.UTF_8);
                URL url = new URL(endpoint);
                if (endpoint.startsWith("http:")) {
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setDoOutput(true);
                    conn.setRequestMethod("POST");
                    if (!this.authorizationHeaderValue.isEmpty()) {
                        conn.setRequestProperty("Authorization", this.authorizationHeaderValue);
                    }
                    conn.setRequestProperty("operator", operator);
                    conn.setRequestProperty("applicationName", applicationName);
                    conn.setRequestProperty("traceId", traceId);
                    conn.setRequestProperty("Content-Type", configurationData.getProperty("header.Content-Type", "application/json"));
                    conn.setRequestProperty("Accept", configurationData.getProperty("header.Accept", "application/json"));
                    for (String prop : this.configurationData.stringPropertyNames()) {
                        if (prop.toLowerCase().startsWith("header.")) {
                            switch (prop.toLowerCase()) {
                                case "header.accept":
                                case "header.content-type":
                                case "header.traceid":
                                case "header.operator":
                                case "header.applicationname":
                                    break;
                                default:
                                    logger.debug("Adding header [" + prop + "]=[" + configurationData.getProperty(prop));
                                    conn.setRequestProperty(prop.substring(prop.indexOf(".")), configurationData.getProperty(prop));
                                    break;
                            }
                        }
                    }
                    conn.setRequestProperty("Content-Length", String.valueOf(utf8bytes.length));
                    OutputStream os = conn.getOutputStream();
                    os.write(utf8bytes);
                    os.flush();

                    if ((conn.getResponseCode() != HttpURLConnection.HTTP_OK) & (conn.getResponseCode() != HttpURLConnection.HTTP_ACCEPTED)) {
                        StringBuilder error = new StringBuilder("{");
                        error.append("\"HttpStatusCode\":").append(conn.getResponseCode()).append(",");
                        error.append("\"HttpErrorMsg\":\"").append(conn.getResponseMessage()).append("\",");
                        error.append("\"ResponseData\":\"");
                        try {

                            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
                            String output;
                            while ((output = br.readLine()) != null) {
                                error.append(output);
                            }
                            error.append("\"}");
                            throw new DestinationException(error.toString(), ExceptionCodes.CNT0500900004, new Object[]{error.toString()});
                        }catch (Exception e){
                            if (error.charAt(error.length()-1)!='}'){
                                error.append("response body not available.\"}");
                            }
                            throw new DestinationException(error.toString(), ExceptionCodes.CNT0500900004, new Object[]{error.toString()});
                        }
                    } else {
                        conn.disconnect();
                    }
                } else {
                    HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
                    conn.setDoOutput(true);
                    conn.setRequestMethod("POST");
                    if (!this.authorizationHeaderValue.isEmpty()) {
                        conn.setRequestProperty("Authorization", this.authorizationHeaderValue);
                    }
                    if (!this.hostNameVerificationEnabled) {
                        conn.setHostnameVerifier(new HostnameVerifier() {
                            @Override
                            public boolean verify(String hostname, SSLSession session) {
                                //return HttpsURLConnection.getDefaultHostnameVerifier().verify("your_domain.com", session);
                                return true;
                            }
                        });
                    }

                    // set headers
                    conn.setRequestProperty("operator", operator);
                    conn.setRequestProperty("applicationName", applicationName);
                    conn.setRequestProperty("traceId", traceId);

                    // CAL 23JUN23 added support to obtain custom value from configuration for header elements with a default value.
                    conn.setRequestProperty("Content-Type", configurationData.getProperty("FileNet.header.Content-Type", "application/json"));
                    conn.setRequestProperty("Accept", configurationData.getProperty("FileNet.header.Accept", "application/json"));

                    for (String prop : this.configurationData.stringPropertyNames()) {
                        if (prop.toLowerCase().startsWith("filenet.header.")) {
                            switch (prop.toLowerCase()) {
                                // these are handled separately
                                case "filenet.header.accept":
                                case "filenet.header.content-type":
                                case "filenet.header.traceid":
                                case "filenet.header.operator":
                                case "filenet.header.applicationname":
                                    break;
                                default:
                                    String propName = prop.substring(prop.lastIndexOf(".")+1);
                                    logger.debug("Adding header [" + propName + "]=[" + configurationData.getProperty(prop));
                                    conn.setRequestProperty(propName, configurationData.getProperty(prop));
                                    break;
                            }
                        }

                    }
                    conn.setRequestProperty("Content-Length", String.valueOf(utf8bytes.length));

                    // write the body to the request > output stream
                    OutputStream os = conn.getOutputStream();
                    os.write(utf8bytes);
                    os.flush();

                    if ((conn.getResponseCode() != HttpURLConnection.HTTP_OK) & (conn.getResponseCode() != HttpURLConnection.HTTP_ACCEPTED)) {
                        StringBuilder error = new StringBuilder("{");
                        error.append("\"HttpStatusCode\":").append(conn.getResponseCode()).append(",");
                        error.append("\"HttpErrorMsg\":\"").append(conn.getResponseMessage()).append("\",");
                        error.append("\"ResponseData\":\"");
                        try {

                            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
                            String output;
                            while ((output = br.readLine()) != null) {
                                error.append(output);
                            }
                            error.append("\"}");
                            throw new DestinationException(error.toString(), ExceptionCodes.CNT0500900004, new Object[]{error.toString()});
                        }catch (Exception e){
                            if (error.charAt(error.length()-1)!='}'){
                                error.append("response body not available.\"}");
                            }
                            throw new DestinationException(error.toString(), ExceptionCodes.CNT0500900004, new Object[]{error.toString()});
                        }
                    } else {
                        conn.disconnect();
                    }
                }
            } catch (MalformedURLException e) {
                logger.error("Error in postDocuments API (malformed URL) [" + e.getMessage() + "]");
                throw new DestinationException("Error in postDocuments API (malformed URL) " + e.getMessage(), ExceptionCodes.CNT0500900004, new Object[]{e.getMessage()});
            } catch (IOException e) {
                logger.error("Error in postDocuments API (IO Exception) [" + e.getMessage() + "]");
                if (e.getMessage().contains("PKIX path building failed"))
                    logger.error("Is SSL certificate in the trust store?");
                throw new DestinationException("Error in postDocuments API (IO Exception) " + e.getMessage(), ExceptionCodes.CNT0500900004, new Object[]{e.getMessage()});
            }
        }
        //
        // if not using  HTTP(S) connection,
        // the Open API client is used.
        //
        else {
            logger.debug("Using Open API client.");
            try {
                //
                // Create API instance and post the request.
                //
                ApiClient defaultClient = Configuration.getDefaultApiClient();
                logger.debug("Open API client instantiated.");

                //
                // CAL 13JUN23
                // Set API endpoint; otherwise default from DGE client is used.
                //
                if (!this.endpoint.isEmpty()){
                    defaultClient.setBasePath(this.endpoint);
                    logger.debug("Open API endpoint overridden; new value is [" + this.endpoint + "]");
                }else{
                    logger.debug("Using default Open API endpoint [" + defaultClient.getBasePath()  + "]");
                }

                //
                // CAL 23JUN23
                // Disable SSL Certificate validation (optional)
                //
                if (this.configurationData.getProperty("FileNet.swagger.sslCertValidationEnabled","true").equalsIgnoreCase("false")) {
                    defaultClient.setVerifyingSsl(false);
                    logger.warn("Open API client will NOT validate SSL certificates. This behavior should not be used in Production environments. Set [swagger.sslCertValidationEnabled]=[True] or disable the setting.");
                }else{
                    logger.debug("Open API client will validate SSL certificates. To override this behavior for non-production environments, set [swagger.sslCertValidationEnabled]=[False]");
                }

                //
                // CAL 13JUN23 - set endpoint user/credential if both are provided.
                // Basic Authentication -- note that the YAML definition for the service
                // does not define basic auth as a supported model, so not sure why this
                // is even needed.
                //
                if (!authUsername.isEmpty() && !authPassword.isEmpty()){
                    // Create basic auth configuration.
                    logger.debug("Using Basic Authentication for Open API");
                    HttpBasicAuth httpBasicAuth = (HttpBasicAuth) defaultClient.getAuthentication(this.basicAuthName);
                    logger.debug("Open API BasicAuth created as [" + this.basicAuthName + "]");
                    httpBasicAuth.setUsername(authUsername);
                    logger.debug("Open API BasicAuth username set [" + authUsername + "]");
                    httpBasicAuth.setPassword(authPassword);
                    logger.debug("Open API BasicAuth password set [***]");
                }
                //
                // CAL 23JUN23 provide API Keys clientID/clientSecret (apiKey auth)
                // which *is* specified in the service definition...
                //
                ApiKeyAuth clientID = (ApiKeyAuth) defaultClient.getAuthentication("clientID");
                if (clientID == null) {
                    logger.error("OpenAPI Client not configured with authentication named [clientID]");
                    throw new DestinationException("ApiClient.defaultApiClient.getAuthentication failed for ClientID.");
                }
                clientID.setApiKey(this.clientId);
                logger.debug("Open API ApiKey clientId [" + this.clientId + "]");
                if (this.configurationData.getProperty("FileNet.auth.apiKey.clientId.prefix",null) != null) {
                    clientID.setApiKeyPrefix(this.configurationData.getProperty("FileNet.auth.apiKey.clientId.prefix"));
                    if (clientID.getApiKeyPrefix() != null)
                        logger.debug("Open API ApiKey clientID prefix [" + clientID.getApiKeyPrefix() + "]");
                    else
                        logger.debug("Open API ApiKey clientID prefix not set.");
                }

                ApiKeyAuth clientSecret = (ApiKeyAuth) defaultClient.getAuthentication("clientSecret");
                if (clientSecret == null){
                    logger.error("OpenAPI Client not configured with authentication named [clientSecret]");
                    throw new DestinationException("ApiClient.defaultApiClient.getAuthentication failed for clientSecret.");
                }
                clientSecret.setApiKey(this.clientSecret);
                logger.debug("Open API ApiKey clientSecret [" + this.clientSecret + "]");
                if (this.configurationData.getProperty("FileNet.auth.apiKey.clientSecret.prefix",null) != null) {
                    clientSecret.setApiKeyPrefix(this.configurationData.getProperty("FileNet.auth.apiKey.clientSecret.prefix"));
                    if (clientSecret.getApiKeyPrefix() != null)
                        logger.debug("Open API ApiKey ClientSecret prefix [" + clientSecret.getApiKeyPrefix() + "]");
                    else
                        logger.debug("Open API ApiKey ClientSecret prefix not set.");
                }

                DefaultApi apiInstance = new DefaultApi();
                DocumentsResponse result = apiInstance.postDocuments(body, applicationName, operator, traceId);
                logger.info(result.toString());
                documentData.setResultCode(DocumentData.IMPORTED);

            } catch (Exception e) {
                e.printStackTrace();
                logger.error("Error calling Open API endpoint [" + e.getMessage() + "]");
                throw new DestinationException("Error calling Swagger API [" + e.getMessage() + "]", ExceptionCodes.CNT0500900004, new Object[]{e.getMessage()});
            }
        }
    }
    private enum ClientType {
        OPENAPI,
        HTTP
    }
}
