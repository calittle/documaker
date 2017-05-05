
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
 *       &lt;sequence>
 *         &lt;element name="Cause" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="Remedy" type="{http://www.w3.org/2001/XMLSchema}string"/>
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
    "cause",
    "remedy"
})
@XmlRootElement(name = "Diagnosis")
public class Diagnosis {

    @XmlElement(name = "Cause", required = true)
    protected String cause;
    @XmlElement(name = "Remedy", required = true)
    protected String remedy;

    /**
     * Gets the value of the cause property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCause() {
        return cause;
    }

    /**
     * Sets the value of the cause property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCause(String value) {
        this.cause = value;
    }

    /**
     * Gets the value of the remedy property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRemedy() {
        return remedy;
    }

    /**
     * Sets the value of the remedy property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRemedy(String value) {
        this.remedy = value;
    }

}
