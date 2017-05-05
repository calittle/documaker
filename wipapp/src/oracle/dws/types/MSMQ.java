
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
 *         &lt;element name="msmq.server.name" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="msmq.inputqueue.name" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="msmq.outputqueue.name" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="msmq.timeout" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="msmq.expiry" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="msmq.Property" type="{oracle/documaker/schema/common}Property" maxOccurs="unbounded" minOccurs="0"/>
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
    "msmqServerName",
    "msmqInputqueueName",
    "msmqOutputqueueName",
    "msmqTimeout",
    "msmqExpiry",
    "msmqProperty"
})
@XmlRootElement(name = "MSMQ")
public class MSMQ {

    @XmlElement(name = "queuefactory.class", required = true)
    protected String queuefactoryClass;
    @XmlElement(name = "marshaller.class", required = true)
    protected MarshallerClass marshallerClass;
    @XmlElement(name = "msmq.server.name", defaultValue = "localhost")
    protected String msmqServerName;
    @XmlElement(name = "msmq.inputqueue.name", required = true, defaultValue = "DIRECT=OS:localhost\\PRIVATE$\\RESULTQ")
    protected String msmqInputqueueName;
    @XmlElement(name = "msmq.outputqueue.name", required = true, defaultValue = "DIRECT=OS:localhost\\PRIVATE$\\REQUESTQ")
    protected String msmqOutputqueueName;
    @XmlElement(name = "msmq.timeout", defaultValue = "30000")
    protected String msmqTimeout;
    @XmlElement(name = "msmq.expiry", defaultValue = "1800000")
    protected String msmqExpiry;
    @XmlElement(name = "msmq.Property")
    protected List<Property> msmqProperty;

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
     * Gets the value of the msmqServerName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMsmqServerName() {
        return msmqServerName;
    }

    /**
     * Sets the value of the msmqServerName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMsmqServerName(String value) {
        this.msmqServerName = value;
    }

    /**
     * Gets the value of the msmqInputqueueName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMsmqInputqueueName() {
        return msmqInputqueueName;
    }

    /**
     * Sets the value of the msmqInputqueueName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMsmqInputqueueName(String value) {
        this.msmqInputqueueName = value;
    }

    /**
     * Gets the value of the msmqOutputqueueName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMsmqOutputqueueName() {
        return msmqOutputqueueName;
    }

    /**
     * Sets the value of the msmqOutputqueueName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMsmqOutputqueueName(String value) {
        this.msmqOutputqueueName = value;
    }

    /**
     * Gets the value of the msmqTimeout property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMsmqTimeout() {
        return msmqTimeout;
    }

    /**
     * Sets the value of the msmqTimeout property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMsmqTimeout(String value) {
        this.msmqTimeout = value;
    }

    /**
     * Gets the value of the msmqExpiry property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMsmqExpiry() {
        return msmqExpiry;
    }

    /**
     * Sets the value of the msmqExpiry property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMsmqExpiry(String value) {
        this.msmqExpiry = value;
    }

    /**
     * Gets the value of the msmqProperty property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the msmqProperty property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getMsmqProperty().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Property }
     * 
     * 
     */
    public List<Property> getMsmqProperty() {
        if (msmqProperty == null) {
            msmqProperty = new ArrayList<Property>();
        }
        return this.msmqProperty;
    }

}
