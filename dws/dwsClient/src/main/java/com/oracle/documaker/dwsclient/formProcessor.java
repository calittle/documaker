package com.oracle.documaker.dwsclient;
import javax.xml.soap.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ByteArrayOutputStream;
import java.util.Base64;
import org.json.JSONObject;
import javax.servlet.*;
import javax.servlet.http.*;

import java.util.Enumeration;

import org.json.JSONException;

/**
 * A servlet that takes POSTed data and forms a SOAP-based request to DWS.
 * This servlet may integrate to external data services to enrich POSTed data prior to submitting request to DWS.
 * Return JSON data to caller.
 */
public class formProcessor extends HttpServlet {
    @SuppressWarnings("compatibility:-1875377424503238991")
    private static final long serialVersionUID = 1L;
    private static final String CONTENT_TYPE = "application/json";
    private static final String EXTRACT_DATA = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + "<DocumentRequest> <PackageInfo> <Key1>CENTRAL</Key1> <Key2>ACCOUNT_STATUS</Key2> <KeyID>0000005</KeyID> <RunDate>20050830</RunDate> <TranCode>EN</TranCode> <Product>Foundation Life</Product> <PolicyNumber></PolicyNumber> <PolicyIssueDate>20050203</PolicyIssueDate> <RetroactiveDate>20050203</RetroactiveDate> <EffDate>20050501</EffDate> <ExpDate>20060501</ExpDate> <Createtime>06/30/2009 12:01:03</Createtime> <Modifytime>07/02/2009 12:55:09</Modifytime> <IssueStateCode>GA</IssueStateCode> <WipReason>MISSING SIG</WipReason> <UserGroup>3</UserGroup> <User>8</User> <Description>Welcome Packet</Description> <ApprovalState>40</ApprovalState> <Action>100011</Action> </PackageInfo> <PolicyData> <PlanCode>UL</PlanCode> <Payee>Bill M Smith</Payee> <PolicyForm>LI-450</PolicyForm> <PolicyRoleType> <Insured> <InsPrefix>Mr.</InsPrefix> <InsFName>Bill</InsFName> <InsMName>M</InsMName> <InsLName>Smith</InsLName> <InsSex>M</InsSex> <InsAddress1>5400 LBJ Expressway</InsAddress1> <InsAddress2>Suite 300</InsAddress2> <InsCity>Dallas</InsCity> <InsState>TX</InsState> <InsZip>75240</InsZip> <InsBirthdate>19800715</InsBirthdate> <InsSSN>123456789</InsSSN> <InsDayphone>2148762789778</InsDayphone> <InsNightPhone>2148974464</InsNightPhone> <InsBirthCity>Dallas</InsBirthCity> <InsBirthState>TX</InsBirthState> <InsDriverState>TX</InsDriverState> <InsDriverLicense>987654654A465</InsDriverLicense> </Insured> <Agent> <AgentPrefix>Mr.</AgentPrefix> <AgentFName>John</AgentFName> <AgentLName>Doe</AgentLName> <AgentAddress1>2727 Paces Ferry Road</AgentAddress1> <AgentCity>Atlanta</AgentCity> <AgentState>GA</AgentState> <AgentZip>30339</AgentZip> <AgentEmail>jdoe@amergen.com</AgentEmail> <AgentPhone>2148582200</AgentPhone> <AgentNo>R98798</AgentNo> <AgentCustServPhone>8882637436</AgentCustServPhone> <AgentCustServOpenTime>8:00</AgentCustServOpenTime> <AgentCustServCloseTime>5:00</AgentCustServCloseTime> <AgentCustServTimeZone>eastern</AgentCustServTimeZone> </Agent> <Owner> <OwnFName>Bill</OwnFName> <OwnMName>M</OwnMName> <OwnLName>Smith</OwnLName> <OwnCompany>Adventures Inc.</OwnCompany> <OwnAddress1>5910 North Central Expressway</OwnAddress1> <OwnAddress2>Suite 900</OwnAddress2> <OwnCity>Dallas</OwnCity> <OwnState>TX</OwnState> <OwnZipCode>75206</OwnZipCode> <OwnEin>896851098</OwnEin> <OwnSig>Added</OwnSig> </Owner> <Beneficiary1> <Ben1FName>Bill</Ben1FName> <Ben1MName>P</Ben1MName> <Ben1LName>Smith, Jr.</Ben1LName> <Ben1BirthDate>19840401</Ben1BirthDate> <Ben1Sex>M</Ben1Sex> <Ben1Relationship>Son</Ben1Relationship> <Ben1Address1>5910 North Central Expressway</Ben1Address1> <Ben1Address2>Suite 800</Ben1Address2> <Ben1City>Dallas</Ben1City> <Ben1State>TX</Ben1State> <Ben1ZipCode>75026</Ben1ZipCode> <Ben1SSN>123456780</Ben1SSN> </Beneficiary1> <Beneficiary2> <Ben2FName>Mary</Ben2FName> <Ben2MName>T</Ben2MName> <Ben2LName>Smith</Ben2LName> <Ben2BirthDate>19620320</Ben2BirthDate> <Ben2Sex>F</Ben2Sex> <Ben2Relationship>Cousin</Ben2Relationship> <Ben2Address1>5910 North Central Expressway</Ben2Address1> <Ben2Address2>Suite 800</Ben2Address2> <Ben2City>Dallas</Ben2City> <Ben2State>TX</Ben2State> <Ben2ZipCode>75026</Ben2ZipCode> <Ben2SSN>987654321</Ben2SSN> </Beneficiary2> <Adjuster> <ADJ.BRANCH>SYRACUSE</ADJ.BRANCH> <ADJ.CODE>SM3</ADJ.CODE> <ADJ.EMAIL>swellspring@testins.com</ADJ.EMAIL> <ADJ.MANAGER>Jerry Cook</ADJ.MANAGER> <ADJ.NAME>Shannon Wellspring</ADJ.NAME> <ADJ.TITLE>Manager</ADJ.TITLE> </Adjuster> <Branch> <BRANCH.ADDRESS.FULL>100 South Street New York, NY 23921</BRANCH.ADDRESS.FULL> <BRANCH.CSZ>New York, NY 23921</BRANCH.CSZ> <BRANCH.HDR.PHONE>(513) 870-2000</BRANCH.HDR.PHONE> <BRANCH.PO>PO Box 29283</BRANCH.PO> </Branch> </PolicyRoleType> <Life> <Application> <AppAproved>N</AppAproved> <PrimaryInsured>X</PrimaryInsured> <AppForm> <NAME>C:\\FAP\\FSDMS2\\FORMS\\app.tif</NAME> </AppForm> <InsHealthInfo> <Height>60</Height> <Weight>120</Weight> <BloodPress>N</BloodPress> <Cholestrol>N</Cholestrol> <Cancerrel>N</Cancerrel> <HeartDiseaseRel>N</HeartDiseaseRel> <Alcoholism>N</Alcoholism> <Anxiety>N</Anxiety> <Asthma>Y</Asthma> <Cancer>N</Cancer> <Depression>N</Depression> <Diabetes>N</Diabetes> <DrugAbuse>N</DrugAbuse> <Epilepsy>N</Epilepsy> <HeartDisease>N</HeartDisease> <Hepatitis>N</Hepatitis> <Kidney-Liver>N</Kidney-Liver> <MS>N</MS> <Respiratory>N</Respiratory> <Sleep>N</Sleep> <Stroke>N</Stroke> <Ulcer>N</Ulcer> <Vascular>N</Vascular> <Other>N</Other> <Explaination>Treated during childhood.  No adult incidents.</Explaination> <Continuation>N</Continuation> </InsHealthInfo> </Application> </Life> </PolicyData> <AddresseeData> </AddresseeData> </DocumentRequest>";
    private String soapEndpoint = "http://192.168.1.125:10001/DWSAL1/PublishingService?WSDL";
    private String soapAction = "http://192.168.1.125:10001/DWSAL1/PublishingService";
    private String baseTest = "false";
    private String editURL = "https://slc13pzl.us.oracle.com:9002/DocumakerCorrespondence/faces/load?docId=&lt;DOCID&gt;&amp;uniqueId=&lt;UNIQUEID&gt;&amp;taskflow=compose";
    private String debug = "false";
    private String locateNode = "<PackageInfo>";
    private String extractFile = "/WEB-INF/extract.xml";
    private String insertNodeText = "formprocessor";
    private transient JSONObject json;

    /**
     * Initialization routine. Receives settings from WEB-INF/web.xml to override defaults.
     *
     * @param config
     * @throws ServletException
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        soapEndpoint = ((getInitParameter("soapEndpoint") == null) || (getInitParameter("soapEndpoint").isEmpty())) ? soapEndpoint: getInitParameter("soapEndpoint") ;
        soapAction = ((getInitParameter("soapAction") == null) || (getInitParameter("soapAction").isEmpty())) ? soapAction:getInitParameter("soapAction") ;
        baseTest = ((getInitParameter("baseTest") == null) || (getInitParameter("baseTest").isEmpty())) ? baseTest:getInitParameter("baseTest") ;
        editURL = ((getInitParameter("editURL") == null) || (getInitParameter("editURL").isEmpty())) ? editURL:getInitParameter("editURL") ;
        debug = ((getInitParameter("debug") == null) || (getInitParameter("debug").isEmpty())) ? debug:getInitParameter("debug") ;
        locateNode = ((getInitParameter("locateNode") == null) || (getInitParameter("locateNode").isEmpty())) ? locateNode:getInitParameter("locateNode")  ;
        extractFile = ((getInitParameter("extractFile") == null) || (getInitParameter("extractFile").isEmpty())) ? extractFile: getInitParameter("extractFile")  ;
        insertNodeText = ((getInitParameter("insertNodeText") == null) || (getInitParameter("insertNodeText").isEmpty())) ? insertNodeText:getInitParameter("insertNodeText")  ;

        System.out.println("dwsClient using the following settings:");
        System.out.println("=======================================");
        System.out.println("    debug           =" + debug);
        System.out.println("    soapEndpoint    =" + soapEndpoint);
        System.out.println("    soapAction      ="+soapAction);
        System.out.println("    baseTest        ="+baseTest);
        System.out.println("    editURL         ="+editURL);
        System.out.println("    debug           ="+debug);
        System.out.println("    locateNode      ="+locateNode);
        System.out.println("    extractFile     ="+extractFile);
        System.out.println("    insertNodeText  ="+insertNodeText);

    }

    /**
     * Process HTTP GET request - this simply returns configuration information in JSON format and does not set any
     * parameters or perform any functions.
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    @SuppressWarnings("unchecked")
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType(CONTENT_TYPE);

        PrintWriter out = response.getWriter();

        json = new JSONObject();

        try {
            json.put("debug", debug);
            json.put("soapEndpoint", soapEndpoint);
            json.put("soapAction",soapAction);
            json.put("baseTest",baseTest);
            json.put("editURL",editURL);
            json.put("debug",debug);
            json.put("locateNode",locateNode.replace("<", "&lt;").replace(">","&gt;"));
            json.put("extractFile",extractFile);
            json.put("insertNodeText",insertNodeText);
            json.put("success","true");

        } catch (JSONException e) {
            System.err.println("Unable to insert JSON value: " + e.getMessage());
        }

        out.print(json);
        out.flush();
        out.close();

    }

    /**
     * Process HTTP POST request by grabbing POSTed data and placing into extract data (retrieved from external file).
     * Optionally perform data enrichment by obtaining additional data from external data source. Does not validate POST
     * data - client is expected to validate values of its parameters before passing to the servlet.
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     *
     */
    @SuppressWarnings({ "oracle.jdeveloper.java.nested-assignment", "unchecked" })
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType(CONTENT_TYPE);
        PrintWriter out = response.getWriter();

        json = new JSONObject();

        Enumeration en = request.getParameterNames();
        String encodedString="";

        if (baseTest.equalsIgnoreCase("true")){
            StringBuffer sb = new StringBuffer("");

            sb.append(locateNode);
            sb.append("<" + insertNodeText + ">");

            while (en.hasMoreElements()) {
                String parmName = (String) en.nextElement();
                String parmValue = (request.getParameter(parmName));
                sb.append("<" + parmName + ">" + parmValue + "</" + parmName + ">" );
            }

            sb.append("</" + insertNodeText + ">");
            encodedString = Base64.getEncoder().encodeToString(EXTRACT_DATA.replace(locateNode,sb.toString()).getBytes());

        } else {

            InputStream is = getServletContext().getResourceAsStream(extractFile);

            if (is != null) {

                InputStreamReader isr = new InputStreamReader(is);
                BufferedReader reader = new BufferedReader(isr);
                StringBuffer sb = new StringBuffer("");
                String text;

                while ((text = reader.readLine()) != null){
                    sb.append(text);
                    if (text.trim().contains(locateNode)){
                        sb.append("<" + insertNodeText + ">");
                        while (en.hasMoreElements()) {
                            String parmName = (String) en.nextElement();
                            String parmValue = (request.getParameter(parmName));
                            sb.append("<" + parmName + ">" + parmValue + "</" + parmName + ">" );
                        }
                        sb.append("</" + insertNodeText + ">");
                    }
                }

                encodedString = Base64.getEncoder().encodeToString(sb.toString().getBytes());

            } else {
                try {
                    json.put("message", "Unable to load extract sample.");
                    json.put("success","false");
                } catch (JSONException e) {
                    System.err.println("Unable to add JSON value: " + e.getMessage());
                }
            }
        }

        try {

            callSoapWebService(soapEndpoint, soapAction, encodedString);

        } catch (Exception e) {
            try{
                json.put("success","false");
                json.put("message","An error occurred processing your request." );
                json.put("debug",e.getLocalizedMessage());
            } catch (JSONException f) {
                System.err.println("Unable to add JSON value: " + f.getMessage());
            }
        }
        out.print(json);
        out.flush();
        out.close();
    }

    /**
     * Create the SOAP envelope part of the request.
     *
     * @param soapMessage
     * @param data
     * @throws SOAPException
     */
    private void createSoapEnvelope(SOAPMessage soapMessage, String data) throws SOAPException {
        SOAPPart soapPart = soapMessage.getSOAPPart();
        SOAPEnvelope envelope = soapPart.getEnvelope();
        envelope.addNamespaceDeclaration("pub", "oracle/documaker/schema/ws/publishing");
        envelope.addNamespaceDeclaration("v1", "oracle/documaker/schema/ws/publishing/doPublishFromImport/v1");
        envelope.addNamespaceDeclaration("com","oracle/documaker/schema/ws/publishing/common");
        envelope.addNamespaceDeclaration("com1", "oracle/documaker/schema/common");
        envelope.addNamespaceDeclaration("req", "oracle/documaker/schema/ws/publishing/doPublishFromImport/v1/request");

        // Add the extract data.
        SOAPBody soapBody = envelope.getBody();
        SOAPElement soapRequest = soapBody.addChildElement("DoPublishFromImportRequest","pub").addChildElement("DoPublishFromImportRequestV1", "pub");
        soapRequest
                .addChildElement("JobRequest","v1")
                .addChildElement("Payload","req")
                .addChildElement("Extract","req")
                .addChildElement("Content","com1")
                .addChildElement("Binary","com1")
                .addTextNode(data);

        // Add the response type
        soapRequest
                .addChildElement("ResponseProperties","v1")
                .addChildElement("ResponseType","com1")
                .addTextNode("Identifiers");

    }

    /**
     * Create and invoke a SOAP connection and send the SOAP message. Set JSON object with response
     * parameters that indicate the disposition of the document request.
     *
     * @param soapEndpointUrl - the endpoint to call. Must be doPublishFromImport
     * @param soapAction - the action to invoke. Must be doPublishFromImport.
     * @param encodedExtract - base64 encoded extract data to submit
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    private void callSoapWebService(String soapEndpointUrl, String soapAction, String encodedExtract) throws Exception {
        // Create SOAP Connection
        SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
        SOAPConnection soapConnection = soapConnectionFactory.createConnection();

        // Send SOAP Message to SOAP Server
        SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(soapAction, encodedExtract), soapEndpointUrl);

        // parse the response.
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        soapResponse.writeTo(stream);
        String response = new String(stream.toByteArray(), "utf-8");
        soapConnection.close();

        String uid = getValue(response,"ns8:Unique_Id");
        String docid = getValue(response,"ns8:KeyId");
        String trnStatus = getValue(response,"ns8:TrnStatus");
        String routedesc ="";
        if (trnStatus.equals("290")){
            routedesc = getValue(response,"ns8:RouteDesc");
            json.put("routedesc",routedesc);
        }
        if (debug.equalsIgnoreCase("true")){
            System.out.println("Response SOAP Message:");
            soapResponse.writeTo(System.out);
            System.out.println("\n");
        }

        json.put("success","true");
        json.put("trnstatus",trnStatus);
        json.put("docid", docid);
        json.put("uniqueid",uid);
        json.put("url",editURL.replace("<DOCID>", docid).replace("<UNIQUEID>",uid));

    }

    /**
     * String-based XML parser (light-weight, fast) that finds a node and returns its value. Does not do any XPATH-style
     * parsing.
     *
     * @param response - a string containing XML nodes.
     * @param find - a string containing a node name to find, without < > notation.
     * @return a string containing the node text
     */
    private String getValue(String response, String find) {

        String returnval = "";
        try {

            int i = response.indexOf("<"+find+">") + find.length() + 2;
            int j = response.indexOf("</"+find+">");

            if (i+j > 0 ){

                returnval = response.substring(i, j);

            }
        }
        catch (StringIndexOutOfBoundsException e){
            System.err.println("dwsClient : Unable find [" + find + "] in SOAP response, which follows.\nSOAP Response\n=============\n" + response);
        }

        return returnval;
    }

    /**
     * Create a SOAP request based on action and extract data.
     *
     * @param soapAction - the SOAP action for the request.
     * @param encodedExtract - the base64 encoded extract data.
     * @return SOAPMessage
     * @throws Exception
     */
    private SOAPMessage createSOAPRequest(String soapAction, String encodedExtract) throws Exception {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();

        createSoapEnvelope(soapMessage, encodedExtract);

        MimeHeaders headers = soapMessage.getMimeHeaders();
        headers.addHeader("SOAPAction", soapAction);

        soapMessage.saveChanges();

        /* Print the request message, just for debugging purposes */
        if (debug.equalsIgnoreCase("true")){
            System.out.println("Request SOAP Message:");
            soapMessage.writeTo(System.out);
            System.out.println("\n");
        }
        return soapMessage;
    }
}
