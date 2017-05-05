
package oracle.dws.types;

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
 *       &lt;choice>
 *         &lt;element ref="{oracle/documaker/schema/ws/composition}HTTP"/>
 *         &lt;element ref="{oracle/documaker/schema/ws/composition}MQ"/>
 *         &lt;element ref="{oracle/documaker/schema/ws/composition}MSMQ"/>
 *         &lt;element ref="{oracle/documaker/schema/ws/composition}JMS"/>
 *       &lt;/choice>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "http",
    "mq",
    "msmq",
    "jms"
})
@XmlRootElement(name = "Properties")
public class Properties {

    @XmlElement(name = "HTTP")
    protected HTTP http;
    @XmlElement(name = "MQ")
    protected MQ mq;
    @XmlElement(name = "MSMQ")
    protected MSMQ msmq;
    @XmlElement(name = "JMS")
    protected JMS jms;

    /**
     * Gets the value of the http property.
     * 
     * @return
     *     possible object is
     *     {@link HTTP }
     *     
     */
    public HTTP getHTTP() {
        return http;
    }

    /**
     * Sets the value of the http property.
     * 
     * @param value
     *     allowed object is
     *     {@link HTTP }
     *     
     */
    public void setHTTP(HTTP value) {
        this.http = value;
    }

    /**
     * Gets the value of the mq property.
     * 
     * @return
     *     possible object is
     *     {@link MQ }
     *     
     */
    public MQ getMQ() {
        return mq;
    }

    /**
     * Sets the value of the mq property.
     * 
     * @param value
     *     allowed object is
     *     {@link MQ }
     *     
     */
    public void setMQ(MQ value) {
        this.mq = value;
    }

    /**
     * Gets the value of the msmq property.
     * 
     * @return
     *     possible object is
     *     {@link MSMQ }
     *     
     */
    public MSMQ getMSMQ() {
        return msmq;
    }

    /**
     * Sets the value of the msmq property.
     * 
     * @param value
     *     allowed object is
     *     {@link MSMQ }
     *     
     */
    public void setMSMQ(MSMQ value) {
        this.msmq = value;
    }

    /**
     * Gets the value of the jms property.
     * 
     * @return
     *     possible object is
     *     {@link JMS }
     *     
     */
    public JMS getJMS() {
        return jms;
    }

    /**
     * Sets the value of the jms property.
     * 
     * @param value
     *     allowed object is
     *     {@link JMS }
     *     
     */
    public void setJMS(JMS value) {
        this.jms = value;
    }

}
