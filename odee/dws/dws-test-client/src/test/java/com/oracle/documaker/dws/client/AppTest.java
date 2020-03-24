package com.oracle.documaker.dws.client;
import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class AppTest 
{
     private String EXTRACT = "extract.xml";
     private String ENDPOINT = "http://deepthought:10001/DWSAL1/PublishingServiceSoap12";
     //private String ENDPOINT = "https://deepthought:10002/DWSAL1/PublishingServiceSoap12";
     private int TIMEOUT = 30000;

    @Test
    public void testApp() throws Exception
    {
        App dws = new App();
       
        assertEquals(0, dws.callService(ENDPOINT, EXTRACT, TIMEOUT));
    }
}
