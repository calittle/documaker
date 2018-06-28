package oracle.documaker.edt;

public class VFResponse {
    
    public static final int RC_OK = 0;
    public static final int RC_ERR = 1;
        
    private int responseCode;
    
    private String responseMessage;
    
    
    public VFResponse() {
        super();
    }

    public synchronized void setResponseCode(int responseCode) {
        this.responseCode = responseCode;
    }

    public synchronized int getResponseCode() {
        return responseCode;
    }

    public synchronized void setResponseMessage(String responseMessage) {
        this.responseMessage = responseMessage;
    }

    public synchronized String getResponseMessage() {
        return responseMessage;
    }
}
