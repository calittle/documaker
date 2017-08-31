<?php
 

function doPublishFromImport($xmlInput){
	
	#this simulates the response from DWS.
	$response = "<?xml version=''1.0''encoding=''UTF-8''?><S:Envelope xmlns:S=''http://schemas.xmlsoap.org/soap/envelope/''><S:Body><ns5:doPublishFromImportResponse xmlns:ns6=''oracle/documaker/schema/ws/publishing/doPublishFromImport/v1/response''    xmlns:ns5=''oracle/documaker/schema/ws/publishing''    xmlns:ns4=''oracle/documaker/schema/ws/publishing/doPublishFromImport/v1/request''   xmlns:ns3=''oracle/documaker/schema/ws/publishing/doPublishFromImport/v1''   xmlns:ns2=''oracle/documaker/schema/common''    xmlns=''oracle/documaker/schema/ws/publishing/common''>
      <ns5:doPublishFromImportResponseV1>
        <Result>0</Result>
        <ServiceTimeMillis>21969</ServiceTimeMillis>
        <ns3:JobResponse><ns6:JobBchErr>0</ns6:JobBchErr>
          <ns6:JobBchProc>6</ns6:JobBchProc>
          <ns6:JobBchSch>12</ns6:JobBchSch>
          <ns6:JobBchTotal>18</ns6:JobBchTotal>
          <ns6:JobHistorical>0</ns6:JobHistorical>
          <ns6:JobHistory>1</ns6:JobHistory>
          <ns6:JobPayloadType>0</ns6:JobPayloadType>
          <ns6:JobPriority>10</ns6:JobPriority>
          <ns6:JobRcpErr>0</ns6:JobRcpErr>
          <ns6:JobRcpProc>6</ns6:JobRcpProc>
          <ns6:JobRcpSch>12</ns6:JobRcpSch>
          <ns6:JobRcpTotal>18</ns6:JobRcpTotal>
          <ns6:JobStartTime>2011-04-12T15:53:03.806Z</ns6:JobStartTime>
          <ns6:JobStatus>290</ns6:JobStatus>
          <ns6:JobTrnErr>0</ns6:JobTrnErr>
          <ns6:JobTrnProc>0</ns6:JobTrnProc>
          <ns6:JobTrnSch>6</ns6:JobTrnSch>
          <ns6:JobTrnStartTime>2011-04-12T15:53:04.400Z</ns6:JobTrnStartTime>
          <ns6:JobTrnTotal>12</ns6:JobTrnTotal>
          <ns6:JobTrnWip>6</ns6:JobTrnWip>
          <ns6:JobUnique_Id>9110e261-c40a-4cd2-ac5c-aee54e09d656</ns6:JobUnique_Id>
          <ns6:Job_Id>14</ns6:Job_Id>
          <ns6:Payload>
            <ns6:Transaction>
              <ns6:Action>100011</ns6:Action>
              <ns6:ApprovalState>40</ns6:ApprovalState>
              <ns6:CreateTime>2011-04-12T15:53:04.000Z</ns6:CreateTime><ns6:CurrGroup>3</ns6:CurrGroup>
				<ns6:CurrUser>8</ns6:CurrUser>
				<ns6:Customized>0</ns6:Customized>
				<ns6:Descr>Welcome Packet</ns6:Descr>
				<ns6:FormsetId>0a503761-599e-42ca-b4b5-abf34f699eb7</<ns6:Job_Id>14</ns6:Job_Id>
				<ns6:Key1>Central</ns6:Key1>
				<ns6:Key2>Account_Status</ns6:Key2>
				<ns6:KeyId>0000001</ns6:KeyId>
				<ns6:ModifyTime>2011-04-12T15:53:05.000Z</ns6:ModifyTime>
              <ns6:OrigUser>8</ns6:OrigUser>
              <ns6:ProcessName>Identifier</ns6:ProcessName>
              <ns6:RecType>00</ns6:RecType>
              <ns6:RouteDesc>DM20030:   the following required fields are missing data: AGENTCITYSTATEZIP.</ns6:RouteDesc>
              <ns6:SecLevel>0</ns6:SecLevel>
              <ns6:StatusCode>W</ns6:StatusCode>
              <ns6:TranCode>NB</ns6:TranCode>
              <ns6:TrnBchErr>0</ns6:TrnBchErr>
              <ns6:TrnBchProc>0</ns6:TrnBchProc>
              <ns6:TrnBchSch>0</ns6:TrnBchSch>
              <ns6:TrnBchTotal>0</ns6:TrnBchTotal>
              <ns6:TrnDoLog>0</ns6:TrnDoLog>
              <ns6:TrnHistorical>0</ns6:TrnHistorical>
              <ns6:TrnHistory>1</ns6:TrnHistory>
              <ns6:TrnRcpErr>0</ns6:TrnRcpErr>
              <ns6:TrnRcpProc>0</ns6:TrnRcpProc>
              <ns6:TrnRcpSch>0</ns6:TrnRcpSch>
              <ns6:TrnRcpTotal>0</ns6:TrnRcpTotal>
              <ns6:TrnStartTime>2011-04-12T15:53:04.197Z</ns6:TrnStartTime>
               <ns6:TrnStatus>290</ns6:TrnStatus>
              <ns6:Trn_Id>15</ns6:Trn_Id>
              <ns6:Unique_Id>0a503761-599e-42ca-b4b5-abf34f699eb7</ns6:Unique_Id>
            </ns6:Transaction>
        </ns6:Payload>
        </ns3:JobResponse>
        <ns3:ServiceInfo>
          <ns2:Operation>doPublishFromImport</ns2:Operation>
          <ns2:Version>
            <ns2:Number>1</ns2:Number>
            <ns2:Used>true</ns2:Used>
          </ns2:Version>
        </ns3:ServiceInfo>
      </ns5:doPublishFromImportResponseV1>
    </ns5:doPublishFromImportResponse>
  </S:Body>
</S:Envelope>";
return $response;
        
}
 
$server = new SoapServer(null,array('uri' => 'urn://documaker/dws'));

$server->addFunction('doPublishFromImport');
$server->handle();

 
?>
