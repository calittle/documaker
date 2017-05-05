
package oracle.dws.types;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the oracle.dws.types package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _Result_QNAME = new QName("oracle/documaker/schema/common", "Result");
    private final static QName _ServiceTimeMillis_QNAME = new QName("oracle/documaker/schema/common", "ServiceTimeMillis");
    private final static QName _CompositionFault_QNAME = new QName("oracle/documaker/schema/ws/composition", "CompositionFault");
    private final static QName _Password_QNAME = new QName("oracle/documaker/schema/common", "Password");
    private final static QName _UniqueId_QNAME = new QName("oracle/documaker/schema/common", "UniqueId");
    private final static QName _UserId_QNAME = new QName("oracle/documaker/schema/common", "UserId");
    private final static QName _Priority_QNAME = new QName("oracle/documaker/schema/common", "Priority");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: oracle.dws.types
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link HTTP }
     * 
     */
    public HTTP createHTTP() {
        return new HTTP();
    }

    /**
     * Create an instance of {@link Property }
     * 
     */
    public Property createProperty() {
        return new Property();
    }

    /**
     * Create an instance of {@link ROW }
     * 
     */
    public ROW createROW() {
        return new ROW();
    }

    /**
     * Create an instance of {@link VAR }
     * 
     */
    public VAR createVAR() {
        return new VAR();
    }

    /**
     * Create an instance of {@link JMS }
     * 
     */
    public JMS createJMS() {
        return new JMS();
    }

    /**
     * Create an instance of {@link Errors }
     * 
     */
    public Errors createErrors() {
        return new Errors();
    }

    /**
     * Create an instance of {@link Error }
     * 
     */
    public Error createError() {
        return new Error();
    }

    /**
     * Create an instance of {@link Diagnosis }
     * 
     */
    public Diagnosis createDiagnosis() {
        return new Diagnosis();
    }

    /**
     * Create an instance of {@link DoCallIDSRequest }
     * 
     */
    public DoCallIDSRequest createDoCallIDSRequest() {
        return new DoCallIDSRequest();
    }

    /**
     * Create an instance of {@link Properties }
     * 
     */
    public Properties createProperties() {
        return new Properties();
    }

    /**
     * Create an instance of {@link MQ }
     * 
     */
    public MQ createMQ() {
        return new MQ();
    }

    /**
     * Create an instance of {@link MSMQ }
     * 
     */
    public MSMQ createMSMQ() {
        return new MSMQ();
    }

    /**
     * Create an instance of {@link DSIMSG }
     * 
     */
    public DSIMSG createDSIMSG() {
        return new DSIMSG();
    }

    /**
     * Create an instance of {@link MSGVARS }
     * 
     */
    public MSGVARS createMSGVARS() {
        return new MSGVARS();
    }

    /**
     * Create an instance of {@link ROWSET }
     * 
     */
    public ROWSET createROWSET() {
        return new ROWSET();
    }

    /**
     * Create an instance of {@link Attachment }
     * 
     */
    public Attachment createAttachment() {
        return new Attachment();
    }

    /**
     * Create an instance of {@link Content }
     * 
     */
    public Content createContent() {
        return new Content();
    }

    /**
     * Create an instance of {@link ResponseProperties }
     * 
     */
    public ResponseProperties createResponseProperties() {
        return new ResponseProperties();
    }

    /**
     * Create an instance of {@link CompositionFault }
     * 
     */
    public CompositionFault createCompositionFault() {
        return new CompositionFault();
    }

    /**
     * Create an instance of {@link DoCallIDSResponse }
     * 
     */
    public DoCallIDSResponse createDoCallIDSResponse() {
        return new DoCallIDSResponse();
    }

    /**
     * Create an instance of {@link Results }
     * 
     */
    public Results createResults() {
        return new Results();
    }

    /**
     * Create an instance of {@link DoCallIDSOneWayRequest }
     * 
     */
    public DoCallIDSOneWayRequest createDoCallIDSOneWayRequest() {
        return new DoCallIDSOneWayRequest();
    }

    /**
     * Create an instance of {@link ResponseAttachment }
     * 
     */
    public ResponseAttachment createResponseAttachment() {
        return new ResponseAttachment();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Integer }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "oracle/documaker/schema/common", name = "Result")
    public JAXBElement<Integer> createResult(Integer value) {
        return new JAXBElement<Integer>(_Result_QNAME, Integer.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Long }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "oracle/documaker/schema/common", name = "ServiceTimeMillis")
    public JAXBElement<Long> createServiceTimeMillis(Long value) {
        return new JAXBElement<Long>(_ServiceTimeMillis_QNAME, Long.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CompositionFault }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "oracle/documaker/schema/ws/composition", name = "CompositionFault")
    public JAXBElement<CompositionFault> createCompositionFault(CompositionFault value) {
        return new JAXBElement<CompositionFault>(_CompositionFault_QNAME, CompositionFault.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "oracle/documaker/schema/common", name = "Password")
    public JAXBElement<String> createPassword(String value) {
        return new JAXBElement<String>(_Password_QNAME, String.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "oracle/documaker/schema/common", name = "UniqueId")
    public JAXBElement<String> createUniqueId(String value) {
        return new JAXBElement<String>(_UniqueId_QNAME, String.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "oracle/documaker/schema/common", name = "UserId")
    public JAXBElement<String> createUserId(String value) {
        return new JAXBElement<String>(_UserId_QNAME, String.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Integer }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "oracle/documaker/schema/common", name = "Priority")
    public JAXBElement<Integer> createPriority(Integer value) {
        return new JAXBElement<Integer>(_Priority_QNAME, Integer.class, null, value);
    }

}
