
package oracle.dws.types;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for doComposeResponseBase complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="doComposeResponseBase">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{oracle/documaker/schema/ws/composition}Results"/>
 *         &lt;element ref="{oracle/documaker/schema/common}ServiceTimeMillis"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "doComposeResponseBase", propOrder = {
    "results",
    "serviceTimeMillis"
})
@XmlSeeAlso({
    DoCallIDSResponse.class
})
public abstract class DoComposeResponseBase {

    @XmlElement(name = "Results", required = true)
    protected Results results;
    @XmlElement(name = "ServiceTimeMillis", namespace = "oracle/documaker/schema/common")
    protected long serviceTimeMillis;

    /**
     * Gets the value of the results property.
     * 
     * @return
     *     possible object is
     *     {@link Results }
     *     
     */
    public Results getResults() {
        return results;
    }

    /**
     * Sets the value of the results property.
     * 
     * @param value
     *     allowed object is
     *     {@link Results }
     *     
     */
    public void setResults(Results value) {
        this.results = value;
    }

    /**
     * Gets the value of the serviceTimeMillis property.
     * 
     */
    public long getServiceTimeMillis() {
        return serviceTimeMillis;
    }

    /**
     * Sets the value of the serviceTimeMillis property.
     * 
     */
    public void setServiceTimeMillis(long value) {
        this.serviceTimeMillis = value;
    }

}
