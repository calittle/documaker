package client;

import java.net.MalformedURLException;
import java.net.URL;

import java.util.List;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;

import oracle.documaker.schema.common.Content2;
import oracle.documaker.schema.common.Data2;
import oracle.documaker.schema.common.ResponseProperties;
import oracle.documaker.schema.common.ResponseType;
import oracle.documaker.schema.ws.publishing.DoPublishFromImportRequest;
import oracle.documaker.schema.ws.publishing.DoPublishFromImportResponse;
import oracle.documaker.schema.ws.publishing.PublishingFault_Exception;
import oracle.documaker.schema.ws.publishing.PublishingService;
import oracle.documaker.schema.ws.publishing.PublishingServicePortType;
import oracle.documaker.schema.ws.publishing.dopublishfromimport.v1.DoPublishFromImportRequestV1;
import oracle.documaker.schema.ws.publishing.dopublishfromimport.v1.DoPublishFromImportResponseV1;
import oracle.documaker.schema.ws.publishing.dopublishfromimport.v1.request.JobRequest;
import oracle.documaker.schema.ws.publishing.dopublishfromimport.v1.response.JobResponse;

public class TestClient {
    public TestClient() {
        super();
    }

    public static void main(String[] args) throws MalformedURLException {
                
        String myUrl = "http://192.168.1.125:10001/DWSAL1/PublishingServiceSoap12";        
        String myFile = "/Users/calittle/Library/Mobile Documents/com~apple~CloudDocs/Work/DEV/documaker/dws-test-client-nomaven/Client/src/client/extract.xml";        
        int myTimeout = 60000;
        
        /*
        try {
                myUrl = args[0];
                myFile = args[1];
                myTimeout = Integer.parseInt(args[2]);
            }
        catch(Exception e){
            System.out.println("Usage: TestClient <URL> <Extract> <Timeout>");
            System.out.println("\tURL: endpoint of service");
            System.out.println("\tExtract: path/filename of input file");
            System.out.println("\tTimeout: timeout in ms");
            System.exit(1);
        }*/
        System.out.print("Endpoint: ");        
        System.out.println(myUrl);
        
        System.out.print("Extract: ");
        System.out.println(myFile);
        
        System.out.print("Timeout: ");
        System.out.println(myTimeout);
        
        PublishingService  _pubService = new PublishingService(new URL(myUrl));
        PublishingServicePortType _pubServicePortType = _pubService.getPublishingServicePort();

        DoPublishFromImportRequest _doPublishFromImportReq = new DoPublishFromImportRequest();
        DoPublishFromImportRequestV1 _doPublishFromImportReqV1 = new DoPublishFromImportRequestV1();

        _doPublishFromImportReqV1.setTimeoutMillis(myTimeout);

        FileDataSource fds = new FileDataSource(myFile);

        JobRequest _JobRequest = new JobRequest();
        oracle.documaker.schema.ws.publishing.dopublishfromimport.v1.request.Payload _Payload =
            new oracle.documaker.schema.ws.publishing.dopublishfromimport.v1.request.Payload();
        Data2 _DataExtract = new Data2();
        Content2 _Content2 = new Content2();

        DataHandler _handler = new DataHandler(fds);
        _Content2.setBinary(_handler);
        _DataExtract.setContent(_Content2);
        _Payload.setExtract(_DataExtract);
        _JobRequest.setPayload(_Payload);
        _doPublishFromImportReqV1.setJobRequest(_JobRequest);

        ResponseProperties _ResponseProperties = new ResponseProperties();

        // ResponseType.JOB_ID
        // ResponseType.ATTACHMENTS
        // ResponseType.IDENTIFIERS
        _ResponseProperties.setResponseType(ResponseType.IDENTIFIERS);

        _doPublishFromImportReqV1.setResponseProperties(_ResponseProperties);
        _doPublishFromImportReq.setDoPublishFromImportRequestV1(_doPublishFromImportReqV1);

        // _pubServicePortType.
        try {
            System.out.print("Calling endpoint");
            DoPublishFromImportResponse _DoPublishFromImportResponse =
                (DoPublishFromImportResponse) _pubServicePortType.doPublishFromImport(_doPublishFromImportReq);
            DoPublishFromImportResponseV1 _DoPublishFromImportResponseV1 =
                _DoPublishFromImportResponse.getDoPublishFromImportResponseV1();

            JobResponse _JobResponse = _DoPublishFromImportResponseV1.getJobResponse();
            System.out.println("...response received");

            System.out.print("\tJOB_ID: ");
            System.out.println(_JobResponse.getJobId());

            oracle.documaker.schema.ws.publishing.dopublishfromimport.v1.response.Payload _respPayLoad =
                _JobResponse.getPayload();
            List<oracle.documaker.schema.ws.publishing.dopublishfromimport.v1.response.Transaction> _Transaction =
                _respPayLoad.getTransaction();

            System.out.print("\tTRN_ID: ");
            System.out.println(_Transaction.get(0).getTrnId());

        } catch (PublishingFault_Exception Ex) {

            System.out.println(Ex.getStackTrace());
        }

        System.exit(0);

    }
}

