package oracle.documaker.edt.custom;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import java.nio.charset.Charset;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import javax.annotation.Resource;
import javax.jws.WebService;
import javax.xml.ws.WebServiceContext;
import javax.xml.ws.handler.MessageContext;
import java.util.Map;

import java.util.stream.Stream;

import javax.jws.WebMethod;

import javax.servlet.ServletContext;

import javax.xml.ws.BindingType;
import javax.xml.ws.soap.MTOM;
import javax.xml.ws.soap.SOAPBinding;

import oracle.documaker.edt.ExternalDataTransactionBase;
import oracle.documaker.edt.VFResponse;

/**
 * This class implements the Web Service for the customer. Custom code should
 * be implemented in this class, including overrides of the ExternalDataTransactionBase class.
 */
@WebService(targetNamespace = "http://tempuri.org/", portName = "ExternalDataTransactionSoap12HttpPort")
@BindingType(SOAPBinding.SOAP12HTTP_BINDING)
@MTOM
public class ExternalDataTransaction extends ExternalDataTransactionBase {
    
    public ExternalDataTransaction() {
        super();
    }

    @Resource
    WebServiceContext wsCtx;
        
    /**
     * This method returns a transaction-gathering form that will be displayed
     * in Documaker Interactive. The calls to getBeforeForm and getAfterForm provide
     * boilerplate that is needed to display the customer's form properly in
     * Documaker Interactive and should only be overridden in special circumstances.
     * The customer should override the getForm method to build the customer-specific
     * form.
     * @return A HTML form to be displayed in Documaker Interactive.
     */
    @Override
    public byte[] getKeys() {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();

            baos.write(getBeforeForm());
            baos.write(getForm());
            baos.write(getAfterForm());

            byte[] returnValue =  baos.toByteArray();
            return returnValue;

        } catch (Exception ex) {
            ex.printStackTrace();
            return new byte[0];
        }
    }

    /**
     * Method to build a XML transaction from supplied key data from Documaker Interactive.
     * This method can be customized by the customer, but is usually customized by
     * overriding the getForm method.
     * @param buf Key data gathered from Documaker Interactive in XML format.
     * @return The customer-generated transaction in XML format.
     */
    @Override
    @SuppressWarnings("oracle.jdeveloper.java.nested-assignment")
    public byte[] getData(byte[] buf) {
        try {

                MessageContext msgCtx = wsCtx.getMessageContext();
                ServletContext srvCtx = ((javax.servlet.ServletContext) msgCtx.get(MessageContext.SERVLET_CONTEXT));
                
                InputStream something = srvCtx.getResourceAsStream("getData.xml");            
                ByteArrayOutputStream buffer = new ByteArrayOutputStream();

                int nRead;
                byte[] data = new byte[16384];
                
                while ((nRead = something.read(data,0,data.length)) != -1){
                    buffer.write(data, 0, nRead);
                }
                
                buffer.flush();
                return buffer.toByteArray();
                
                //return localpath.getBytes("ISO8859-1");
            
        } catch (Exception e) {
            return new byte[0];
        }
    }

    /**
     * Method that determines if the buffer, usually a file from the
     * user's local file system, is a valid transaction according to the
     * customer's business rules and specifications.
     * @param buf buffer to be verified, usually a file from user's local file system
     * @return structure with return code and explanatory message.
     */
    @Override
    public VFResponse validateFile(byte[] buf) {

        /* Do some preliminary checking of the buffer. */
        VFResponse returnValue = super.validateFile(buf);

        if (returnValue.getResponseCode() == VFResponse.RC_OK) {
            /* TODO: Add custom testing, put result in returnValue. */
        }
        return returnValue;
    }

    /**
     * Generate the form that is displayed in Documaker Interactive.
     * This method is usually overridden by the customer.
     * @return HTML form provided by customer.
     */
    @Override
    @SuppressWarnings("oracle.jdeveloper.java.nested-assignment")
    protected byte[] getForm() {
        /* TODO: Add custom form here. */
        
        try {

                MessageContext msgCtx = wsCtx.getMessageContext();
                ServletContext srvCtx = ((javax.servlet.ServletContext) msgCtx.get(MessageContext.SERVLET_CONTEXT));
                
                InputStream something = srvCtx.getResourceAsStream("getKeys.html");            
                ByteArrayOutputStream buffer = new ByteArrayOutputStream();

                int nRead;
                byte[] data = new byte[16384];
                
                while ((nRead = something.read(data,0,data.length)) != -1){
                    buffer.write(data, 0, nRead);
                }
                
                buffer.flush();
                return buffer.toByteArray();
                
                //return localpath.getBytes("ISO8859-1");
            
        } catch (Exception e) {
            return new byte[0];
        }
    }
}
