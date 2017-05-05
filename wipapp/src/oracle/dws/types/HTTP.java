
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
 *         &lt;element name="marshaller.class" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="http.url" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="http.reuse.ports" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="http.putmessage.tries" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="http.Property" type="{oracle/documaker/schema/common}Property" maxOccurs="unbounded" minOccurs="0"/>
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
    "httpUrl",
    "httpReusePorts",
    "httpPutmessageTries",
    "httpProperty"
})
@XmlRootElement(name = "HTTP")
public class HTTP {

    @XmlElement(name = "queuefactory.class", required = true)
    protected String queuefactoryClass;
    @XmlElement(name = "marshaller.class", required = true)
    protected String marshallerClass;
    @XmlElement(name = "http.url", required = true, defaultValue = "http://localhost:49152")
    protected String httpUrl;
    @XmlElement(name = "http.reuse.ports", defaultValue = "true")
    protected String httpReusePorts;
    @XmlElement(name = "http.putmessage.tries", defaultValue = "3")
    protected String httpPutmessageTries;
    @XmlElement(name = "http.Property")
    protected List<Property> httpProperty;

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
     *     {@link String }
     *     
     */
    public String getMarshallerClass() {
        return marshallerClass;
    }

    /**
     * Sets the value of the marshallerClass property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMarshallerClass(String value) {
        this.marshallerClass = value;
    }

    /**
     * Gets the value of the httpUrl property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHttpUrl() {
        return httpUrl;
    }

    /**
     * Sets the value of the httpUrl property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHttpUrl(String value) {
        this.httpUrl = value;
    }

    /**
     * Gets the value of the httpReusePorts property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHttpReusePorts() {
        return httpReusePorts;
    }

    /**
     * Sets the value of the httpReusePorts property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHttpReusePorts(String value) {
        this.httpReusePorts = value;
    }

    /**
     * Gets the value of the httpPutmessageTries property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHttpPutmessageTries() {
        return httpPutmessageTries;
    }

    /**
     * Sets the value of the httpPutmessageTries property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHttpPutmessageTries(String value) {
        this.httpPutmessageTries = value;
    }

    /**
     * Gets the value of the httpProperty property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the httpProperty property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getHttpProperty().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Property }
     * 
     * 
     */
    public List<Property> getHttpProperty() {
        if (httpProperty == null) {
            httpProperty = new ArrayList<Property>();
        }
        return this.httpProperty;
    }

}
