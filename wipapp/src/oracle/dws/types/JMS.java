
package oracle.dws.types;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="queuefactory.class" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="marshaller.class" type="{oracle/documaker/schema/ws/composition}MarshallerClass"/>
 *         &lt;element name="jms.initial.context.factory" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="jms.provider.URL" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="jms.security.principal" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="jms.security.credentials" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="jms.qcf.name" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="jms.inputqueue.connectstring" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="jms.outputqueue.connectstring" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="jms.env.Property" type="{oracle/documaker/schema/common}Property" maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "queuefactoryClass",
    "marshallerClass",
    "jmsInitialContextFactory",
    "jmsProviderURL",
    "jmsSecurityPrincipal",
    "jmsSecurityCredentials",
    "jmsQcfName",
    "jmsInputqueueConnectstring",
    "jmsOutputqueueConnectstring",
    "jmsEnvProperty"
})
@XmlRootElement(name = "JMS")
public class JMS {

    @XmlElement(name = "queuefactory.class", required = true)
    protected String queuefactoryClass;
    @XmlElement(name = "marshaller.class", required = true)
    protected MarshallerClass marshallerClass;
    @XmlElement(name = "jms.initial.context.factory", required = true, defaultValue = "weblogic.jndi.WLInitialContextFactory")
    protected String jmsInitialContextFactory;
    @XmlElement(name = "jms.provider.URL", required = true, defaultValue = "t3://localhost:7001")
    protected String jmsProviderURL;
    @XmlElement(name = "jms.security.principal", defaultValue = "")
    protected String jmsSecurityPrincipal;
    @XmlElement(name = "jms.security.credentials", defaultValue = "")
    protected String jmsSecurityCredentials;
    @XmlElement(name = "jms.qcf.name", required = true, defaultValue = "qcf")
    protected String jmsQcfName;
    @XmlElement(name = "jms.inputqueue.connectstring", required = true, defaultValue = "resultq")
    protected String jmsInputqueueConnectstring;
    @XmlElement(name = "jms.outputqueue.connectstring", required = true, defaultValue = "requestq")
    protected String jmsOutputqueueConnectstring;
    @XmlElement(name = "jms.env.Property")
    protected List<Property> jmsEnvProperty;

    /**
     * Gets the value of the queuefactoryClass property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getQueuefactoryClass() {
        return queuefactoryClass;
    }

    /**
     * Sets the value of the queuefactoryClass property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setQueuefactoryClass(String value) {
        this.queuefactoryClass = value;
    }

    /**
     * Gets the value of the marshallerClass property.
     * 
     * @return
     *     possible object is
     *     {@link MarshallerClass }
     *     
     */
    public MarshallerClass getMarshallerClass() {
        return marshallerClass;
    }

    /**
     * Sets the value of the marshallerClass property.
     * 
     * @param value
     *     allowed object is
     *     {@link MarshallerClass }
     *     
     */
    public void setMarshallerClass(MarshallerClass value) {
        this.marshallerClass = value;
    }

    /**
     * Gets the value of the jmsInitialContextFactory property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getJmsInitialContextFactory() {
        return jmsInitialContextFactory;
    }

    /**
     * Sets the value of the jmsInitialContextFactory property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setJmsInitialContextFactory(String value) {
        this.jmsInitialContextFactory = value;
    }

    /**
     * Gets the value of the jmsProviderURL property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getJmsProviderURL() {
        return jmsProviderURL;
    }

    /**
     * Sets the value of the jmsProviderURL property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setJmsProviderURL(String value) {
        this.jmsProviderURL = value;
    }

    /**
     * Gets the value of the jmsSecurityPrincipal property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getJmsSecurityPrincipal() {
        return jmsSecurityPrincipal;
    }

    /**
     * Sets the value of the jmsSecurityPrincipal property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setJmsSecurityPrincipal(String value) {
        this.jmsSecurityPrincipal = value;
    }

    /**
     * Gets the value of the jmsSecurityCredentials property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getJmsSecurityCredentials() {
        return jmsSecurityCredentials;
    }

    /**
     * Sets the value of the jmsSecurityCredentials property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setJmsSecurityCredentials(String value) {
        this.jmsSecurityCredentials = value;
    }

    /**
     * Gets the value of the jmsQcfName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getJmsQcfName() {
        return jmsQcfName;
    }

    /**
     * Sets the value of the jmsQcfName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setJmsQcfName(String value) {
        this.jmsQcfName = value;
    }

    /**
     * Gets the value of the jmsInputqueueConnectstring property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getJmsInputqueueConnectstring() {
        return jmsInputqueueConnectstring;
    }

    /**
     * Sets the value of the jmsInputqueueConnectstring property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setJmsInputqueueConnectstring(String value) {
        this.jmsInputqueueConnectstring = value;
    }

    /**
     * Gets the value of the jmsOutputqueueConnectstring property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getJmsOutputqueueConnectstring() {
        return jmsOutputqueueConnectstring;
    }

    /**
     * Sets the value of the jmsOutputqueueConnectstring property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setJmsOutputqueueConnectstring(String value) {
        this.jmsOutputqueueConnectstring = value;
    }

    /**
     * Gets the value of the jmsEnvProperty property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the jmsEnvProperty property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getJmsEnvProperty().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Property }
     * 
     * 
     */
    public List<Property> getJmsEnvProperty() {
        if (jmsEnvProperty == null) {
            jmsEnvProperty = new ArrayList<Property>();
        }
        return this.jmsEnvProperty;
    }

}
