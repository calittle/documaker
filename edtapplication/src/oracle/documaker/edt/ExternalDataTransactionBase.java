package oracle.documaker.edt;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.UnsupportedEncodingException;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

/**
 * This class is mainly utility methods that will can be changed by Oracle 
 * as the business case changes. Methods here can be used as-is or overridden in the 
 * ExternalDataTransaction class.
 */
public class ExternalDataTransactionBase {

  protected static final String sampleTransaction = 
  "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
  "<DOCUMENT xmlns=\"http://xmlns.oracle.com/documaker/ids/jaxb/formset\">" +
  "    <DOCSET NAME=\"\">" +
  "        <LIBRARY CONFIG=\"CORRESPONDENCE\" NAME=\"CORRESPONDENCE\">CORRESPONDENCE</LIBRARY>" +
  "        <ARCEFFECTIVEDATE>20110520</ARCEFFECTIVEDATE>" +
  "        <WIPKEYS>" +
  "            <KEY1>Central</KEY1>" +
  "            <KEY2>Account_Status</KEY2>" +
  "            <KEYID>rrc0520a</KEYID>" +
  "            <TRANCODE>TRANCODE</TRANCODE>" +
  "            <STATUSCODE>W</STATUSCODE>" +
  "            <DESC>rrc0520a</DESC>" +
  "        </WIPKEYS>" +
  "        <RECIPIENT COPYCOUNT=\"1\" NAME=\"Recipient\">" +
  "            <ADDRESSEE>" +
  "                <TYPE>0</TYPE>" +
  "                <ROLE>INSURED</ROLE>" +
  "                <NAME>Richard abcde</NAME>" +
  "                <ADDRESS1>1234 abcde street</ADDRESS1>" +
  "                <ADDRESS2>Suite abcde</ADDRESS2>" +
  "                <CITY>abcde City</CITY>" +
  "                <STATE>GA</STATE>" +
  "                <POSTALCODE>33333</POSTALCODE>" +
  "                <COUNTRY>US</COUNTRY>" +
  "                <PHONE>555-555-5555</PHONE>" +
  "                <FAX>777-777-7777</FAX>" +
  "                <EMAIL>r.a@gmail.com</EMAIL>" +
  "                <DISTRIBUTION>" +
  "                    <PREFERRED>2</PREFERRED>" +
  "                </DISTRIBUTION>" +
  "                <ENCLOSURES>1</ENCLOSURES>" +
  "                <LANGUAGE>en_US</LANGUAGE>" +
  "            </ADDRESSEE>" +
  "            <ADDRESSEE>" +
  "                <TYPE>0</TYPE>" +
  "                <ROLE>INSURED</ROLE>" +
  "                <NAME>Richard abcde</NAME>" +
  "                <ADDRESS1>1234 abcde street</ADDRESS1>" +
  "                <ADDRESS2>Suite abcde</ADDRESS2>" +
  "                <CITY>abcde City</CITY>" +
  "                <STATE>GA</STATE>" +
  "                <POSTALCODE>33333</POSTALCODE>" +
  "                <COUNTRY>US</COUNTRY>" +
  "                <PHONE>555-555-5555</PHONE>" +
  "                <FAX>777-777-7777</FAX>" +
  "                <EMAIL>r.a@gmail.com</EMAIL>" +
  "                <DISTRIBUTION>" +
  "                    <PREFERRED>2</PREFERRED>" +
  "                    <SELECTED>2</SELECTED>" +
  "                </DISTRIBUTION>" +
  "                <ENCLOSURES>1</ENCLOSURES>" +
  "                <LANGUAGE>en_US</LANGUAGE>" +
  "            </ADDRESSEE>" +
  "        </RECIPIENT>"+
  "        <GROUP NAME=\"\" NAME1=\"Central\" NAME2=\"Account_Status\">" +
  "            <FORM ID=\"100300\" NAME=\"AM-GBL\" OPTIONS=\"R\">" +
  "                <DESCRIPTION>Privacy Notice - Gramm Leach Bliley</DESCRIPTION>" +
  "                <CATEGORY/>" +
  "                <RECIPIENT COPYCOUNT=\"1\" NAME=\"Recipient\"/>" +
  "            </FORM>" +
  "        </GROUP>" +
  "    </DOCSET>" +
  "</DOCUMENT>";
  
  /* Used for simple XML testing. */
    private XMLInputFactory _if;


    public ExternalDataTransactionBase() {
        super();

        _if = XMLInputFactory.newInstance();
    }

    /**
     * This method returns a transaction-gathering form that will be displayed
     * in Documaker Interactive. The calls to getBeforeForm and getAfterForm provide
     * boilerplate that is needed to display the customer's form properly in
     * Documaker Interactive and should only be overridden in special circumstances.
     * The customer should override the getForm method to build the customer-specific
     * form.
     * @return A HTML form to be displayed in Documaker Interactive.
     */
    public byte[] getKeys() {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();

            baos.write(getBeforeForm());
            baos.write(getForm());
            baos.write(getAfterForm());

            return baos.toByteArray();

        } catch (Exception ex) {
            ex.printStackTrace();
            return new byte[0];
        }
    }

    /**
     * Method to build a XML transaction from supplied key data from Documaker Interactive.
     * This method should be overridden by the customer
     * @param buf Key data gathered from Documaker Interactive in XML format.
     * @return The customer-generated transaction in XML format.
     */
    public byte[] getData(byte[] buf) {
        byte[] returnValue = new byte[0];
        try {
            returnValue = sampleTransaction.getBytes("ISO8859-1");
            return returnValue;
        } catch (Exception ex) {
            ex.printStackTrace();
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
    public VFResponse validateFile(byte[] buf) {
        VFResponse response = new VFResponse();
        if (isXML(buf)) {
            response.setResponseCode(VFResponse.RC_OK);
            response.setResponseMessage("OK");
        } else {
            response.setResponseCode(VFResponse.RC_ERR);
            response.setResponseMessage("File is not well-formed XML");
        }


        try {
            String xmlText = new String(buf, "ISO8859-1");
            System.out.println(xmlText);

        } catch (Exception ex) {
            ex.printStackTrace();
            response.setResponseCode(VFResponse.RC_ERR);
            response.setResponseMessage(ex.getMessage());
        }
        return response;
    }

    /**
     * Generate the boilerplate that Documaker Interactive requires before the
     * customer's form data.
     * This method usually isn't overridden by the customer.
     * @return Boilerplate required before the form.
     */
    protected byte[] getBeforeForm() {
        try {
            String text = "<body>";
            return text.getBytes("ISO8859-1");
        } catch (UnsupportedEncodingException uee) {
            return new byte[0];
        }
    }

    /**
     * Generate the boilerplate that Documaker Interactive requires after the
     * customer's form data.
     * This method usually isn't overridden by the customer.
     * @return Boilerplate required after the form.
     */
    protected byte[] getAfterForm() {
        try {
            String text = "</body>";
            return text.getBytes("ISO8859-1");
        } catch (UnsupportedEncodingException uee) {
            return new byte[0];
        }
    }

    /**
     * Generate the form that is displayed in Documaker Interactive.
     * This method is usually overridden by the customer.
     * @return HTML form provided by customer.
     */
    protected byte[] getForm() {
        try {
            String text = "Please input the SRF number and click submit to obtain CCP data and generate the document. <form><input name='SRF' value='730339090'/><input name='Submit' value='Submit'/></form>";
            return text.getBytes("ISO8859-1");
        } catch (UnsupportedEncodingException uee) {
            return new byte[0];
        }

    }

    /**
     * Is the byte buffer well-formed XML?
     *
     * @parameter buf XML candidate buffer
     * @return    is it XML?
     */
    protected boolean isXML(byte[] buf) {
        boolean returnValue = false;
        XMLStreamReader reader = null;

        try {
            reader = _if.createXMLStreamReader(new ByteArrayInputStream(buf));

            /*
             * Simple test for XML, run it through a stax parser. If we hit a DOCUMENT
             * or ELEMENT before we hit regular text, we assume it's XML.
             */
            forloop:
            for (int event = reader.next(); event != XMLStreamConstants.END_ELEMENT; event = reader.next()) {
                switch (event) {
                case XMLStreamConstants.START_DOCUMENT:
                case XMLStreamConstants.START_ELEMENT:
                    returnValue = true;
                    break forloop;
                case XMLStreamConstants.CHARACTERS:
                    returnValue = false;
                    break forloop;
                default:
                    break;
                }

            }
            return returnValue;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (XMLStreamException e) {
                }
            }
            reader = null;
        }
    }
}

