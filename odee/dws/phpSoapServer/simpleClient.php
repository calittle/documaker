<?php

#
# This is an example of how you might create a SOAP service client to call Documaker Web Service.
# The actual web service provided in this example is non-functional as it only returns a static response
# however the important part is that you can see how you might take some user-entered data and create base-64 encoded XML
# which is then placed into a SOAP request and sent to the dummy web service. 
# Of minor importance is how we parse the response from the dummy web service and grab the necessary elements to invoke 
# Documaker Interactive.
#

function createXml($parm1, $parm2, $parm3){
	# receive input variables. Place into Extract schema.
	# NOTE WELL::::::::::
	# This is the most important part of the integration layer: the XML layout here is what 
	# your Documaker implementation must be configured to accept.
	$extractXml = base64_encode("<xml><parm1>$parm1</parm1><parm2>$parm2</parm2><parm3>$parm3</parm3>");

	#create soap request and insert base64 Encoded XML.
	return "<soapenv:Header/><soapenv:Body><pub:DoPublishFromImportRequest><pub:DoPublishFromImportRequestV1><com:timeoutMillis>9000000</com:timeoutMillis><v1:JobRequest><req:Payload><req:Transaction><req:Data><com1:Content><com1:Binary>$extractXml</com1:Binary></com1:Content></req:Data></req:Transaction></req:Payload></v1:JobRequest><v1:ResponseProperties><com1:ResponseType>Attachments</com1:ResponseType></v1:ResponseProperties></pub:DoPublishFromImportRequestV1></pub:DoPublishFromImportRequest></soapenv:Body></soapenv:Envelope>";
 
}
	
$parm1 = $_GET['parm1'];
$parm2 = $_GET['parm2'];	
$parm3 = $_GET['parm3'];	
 
print "<h1>Simple Web Service Client</h1>";

print "<h2>Request</h2>";
print "<form action='simpleClient.php' method='GET'/>";
print "<input name='parm1' value='$parm1'/><br/>";
print "<input name='parm2' value='$parm2'/><br/>";
print "<input name='parm3' value='$parm3'/><br/>";
print "<input type='Submit' name='submit' value='GO'/>";
print "</form>";

 
if($parm1 != ''& $parm2 != '' & $parm3 != ''){
	
	
	
    $dwsClient = new SoapClient(null, array('location' => "https://fenbranklin.ddns.net/phpSoapServer/simpleServer.php",'uri'=>"urn://documaker/dws"));
	
	$dwsResult = $dwsClient->__soapCall("doPublishFromImport",array(createXml($parm1,$parm2,$parm3)));

    print "<h2>Response</h2><textarea cols=50 rows=10>$dwsResult</textarea><br/>";
    print "Parse the XML response for the document Identifiers to create Documaker Interactive URL.<br/>";
    
    $start = strpos($dwsResult,"<ns6:Unique_Id>");
    $length = strpos($dwsResult,"</ns6:Unique_Id>") - $start;
    
    $uniqueId = substr($dwsResult,$start,$length);

    $start =strpos($dwsResult,"<ns6:KeyId>");
    $length = strpos($dwsResult,"</ns6:KeyId>") - $start;
    $docId = substr($dwsResult,$start,$length);
           
    print "<a href='#'>https://servername:port/DocumakerCorrespondence/faces/load?taskflow=edit&uniqueId=$uniqueId&docId=$docId</a>";
 
    
}
?>
