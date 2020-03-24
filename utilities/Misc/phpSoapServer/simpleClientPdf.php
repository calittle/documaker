<?php

#
# This is an example of how you might create a SOAP service client to call Documaker Web Service.
# The actual web service provided in this example is non-functional as it only returns a static response
# however the important part is that you can see how you might take some user-entered data and create base-64 encoded XML
# which is then placed into a SOAP request and sent to the dummy web service. 
# Of minor importance is how we parse the response from the dummy web service and grab the necessary elements to display
# the resulting PDF from the call (which is attached to the response).
#

function createXml($parm1, $parm2, $parm3){
	# receive input variables. Place into Extract schema.
	# NOTE WELL::::::::::
	# This is the most important part of the integration layer: the XML layout here is what 
	# your Documaker implementation must be configured to accept.
	$extractXml = base64_encode("<xml><parm1>$parm1</parm1><parm2>$parm2</parm2><parm3>$parm3</parm3>");

	#create soap request and insert base64 Encoded XML.
  # this is a bit of a hack as you would normally want to generate the XML procedurally rather than
  # this rather than this inelegant brute force string manipulation, but for the purposes of this example
  # it serves its purpose.
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
    # here we make the call to the DWS web service. You can also use
    # the dummy response generator in simpleServerPdf.php"
    $dwsClient = new SoapClient(null, array('location' => "https://server:port/DWSAL1/PublishingService,'uri'=>"urn://documaker/dws"));
	
    # here we make the call.
    $dwsResult = $dwsClient->__soapCall("doPublishFromImport",array(createXml($parm1,$parm2,$parm3)));
    #
    # Replace "__NAME OF RESPOSNE ELEMENT__" with the name of the XML element that contains your PDF.
    # Why yes, this is inelegant, but we do what we must.
    $start = strpos($dwsResult,"<__NAME OF RESPONSE ELEMENT__>");
    $length = strpos($dwsResult,"</__NAME OF RESPONSE ELEMENT__>") - $start;    
    $encdata = substr($dwsResult,$start,$length);

$pdfContent = base64_decode($encdata)

    header('Content-type: application/pdf');
    header("Cache-Control: no-cache");
    header("Pragma: no-cache");
    header("Content-Disposition: inline;filename='[_put_some_name_here_from_result]'");
    header("Content-length: ".strlen($pdfContent));					    

    die($pdfContent);

}
?>
