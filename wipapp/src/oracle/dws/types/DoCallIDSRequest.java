
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
 *     &lt;extension base="{oracle/documaker/schema/ws/composition}doComposeRequestBase">
 *       &lt;sequence>
 *         &lt;element ref="{oracle/documaker/schema/ws/composition}DSIMSG"/>
 *         &lt;element name="ResponseProperties" type="{oracle/documaker/schema/ws/composition}ResponseProperties" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/extension>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "dsimsg",
    "responseProperties"
})
@XmlRootElement(name = "DoCallIDSRequest")
public class DoCallIDSRequest
    extends DoComposeRequestBase
{

    @XmlElement(name = "DSIMSG", required = true)
    protected DSIMSG dsimsg;
    @XmlElement(name = "ResponseProperties")
    protected ResponseProperties responseProperties;

    /**
     * Gets the value of the dsimsg property.
     * 
     * @return
     *     possible object is
     *     {@link DSIMSG }
     *     
     */
    public DSIMSG getDSIMSG() {
        return dsimsg;
    }

    /**
     * Sets the value of the dsimsg property.
     * 
     * @param value
     *     allowed object is
     *     {@link DSIMSG }
     *     
     */
    public void setDSIMSG(DSIMSG value) {
        this.dsimsg = value;
    }

    /**
     * Gets the value of the responseProperties property.
     * 
     * @return
     *     possible object is
     *     {@link ResponseProperties }
     *     
     */
    public ResponseProperties getResponseProperties() {
        return responseProperties;
    }

    /**
     * Sets the value of the responseProperties property.
     * 
     * @param value
     *     allowed object is
     *     {@link ResponseProperties }
     *     
     */
    public void setResponseProperties(ResponseProperties value) {
        this.responseProperties = value;
    }

}
