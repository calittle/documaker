package com.oracle.documaker.dws.client;

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

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.X509Certificate;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLEngine;
import javax.net.ssl.SSLHandshakeException;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.net.ssl.X509ExtendedTrustManager;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;


public class App {
    public App() {
        super();
    }

    long jobid = 0;
    long trnid = 0;
    
    // This is not for production. Basically bypasses the hostname verification of your SSL cert, 
    // which makes you vulnerable for MITM attack.
    static {
        disableSSLVerification18();
    }
   public static void disableSSLVerification18() {

      TrustManager [] trustAllCerts = new TrustManager [] {new X509ExtendedTrustManager () {
         @Override
         public void checkClientTrusted (X509Certificate [] chain, String authType, Socket socket) {         }

         @Override
         public void checkServerTrusted (X509Certificate [] chain, String authType, Socket socket) {         }

         @Override
         public void checkClientTrusted (X509Certificate [] chain, String authType, SSLEngine engine) {         }

         @Override
         public void checkServerTrusted (X509Certificate [] chain, String authType, SSLEngine engine) {         }

         @Override
         public java.security.cert.X509Certificate [] getAcceptedIssuers () {
            return null;
         }

         @Override
         public void checkClientTrusted (X509Certificate [] certs, String authType) {         }

         @Override
         public void checkServerTrusted (X509Certificate [] certs, String authType) {         }

        }
    };

      SSLContext sc = null;
      try {
         sc = SSLContext.getInstance ("SSL");
         sc.init (null, trustAllCerts, new java.security.SecureRandom ());
      } catch (KeyManagementException | NoSuchAlgorithmException e) {
         e.printStackTrace ();
      }
      HttpsURLConnection.setDefaultSSLSocketFactory (sc.getSocketFactory ());
   }
   public static void disableSSLVerification17() {

        TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                return null;
            }

            public void checkClientTrusted(X509Certificate[] certs, String authType) {
            }

            public void checkServerTrusted(X509Certificate[] certs, String authType) {
            }

        } };

        SSLContext sc = null;
        try {
            sc = SSLContext.getInstance("SSL");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
        } catch (KeyManagementException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

        HostnameVerifier allHostsValid = new HostnameVerifier() {
            public boolean verify(String hostname, SSLSession session) {
                return true;
            }
        };      
        HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);           
    }

    public int callService(String url, String file, int timeout) throws MalformedURLException{
       
       	System.out.print("Endpoint: ");        
        System.out.println(url);
        
        System.out.print("Extract: ");
        System.out.println(file);
        
        System.out.print("Timeout: ");
        System.out.println(timeout);

        PublishingService  _pubService = new PublishingService(new URL(url));
        PublishingServicePortType _pubServicePortType = _pubService.getPublishingServicePort();

        DoPublishFromImportRequest _doPublishFromImportReq = new DoPublishFromImportRequest();
        DoPublishFromImportRequestV1 _doPublishFromImportReqV1 = new DoPublishFromImportRequestV1();

        _doPublishFromImportReqV1.setTimeoutMillis(timeout);

        FileDataSource fds = new FileDataSource(file);

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

            jobid = _JobResponse.getJobId();

            System.out.print("\tJob ID: ");
            System.out.println(String.valueOf(jobid));
            oracle.documaker.schema.ws.publishing.dopublishfromimport.v1.response.Payload _respPayLoad =
                _JobResponse.getPayload();
            List<oracle.documaker.schema.ws.publishing.dopublishfromimport.v1.response.Transaction> _Transaction =
                _respPayLoad.getTransaction();

            trnid = _Transaction.get(0).getTrnId();
			System.out.print("\tTran ID: ");
            System.out.println(String.valueOf(trnid));

        } catch (PublishingFault_Exception Ex) {

            System.out.println(Ex.getStackTrace());         
        }        
        if (trnid > 0 && jobid > 0){
        	return(0);
        }else{
        	return (1);
    	}
    }

    public static void main(String[] args) throws MalformedURLException {
        
    	App dws = new App();
    	int ret = -1;

        try {
        	ret = dws.callService(
        		args[0],  /// URL 
        		args[1],  /// FILE
        		Integer.parseInt(args[2]) /// TIMEOUT
        	);
	    }
        catch(Exception e){
            System.out.println("Usage: TestClient <URL> <Extract> <Timeout>");
            System.out.println("\tURL: endpoint of service");
            System.out.println("\tExtract: path/filename of input file");
            System.out.println("\tTimeout: timeout in ms");
            System.out.println("------------------------Exception Details--------------");
            System.out.println(e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        
        if (ret == 0){
        	System.out.print("Job ID:");
        	System.out.println(String.valueOf(dws.jobid));
        	System.out.print("Tran ID:");
        	System.out.println(String.valueOf(dws.trnid));
        	System.exit(0);
        }else{
        	System.out.println("Hmmm JOB and/or TRN not created.");
        	System.exit(1);
        }       
    }
}