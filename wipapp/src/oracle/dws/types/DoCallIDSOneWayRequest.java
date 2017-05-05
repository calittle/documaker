
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
 *     &lt;extension base="{oracle/documaker/schema/ws/composition}doComposeRequestOneWayBase">
 *       &lt;sequence>
 *         &lt;element ref="{oracle/documaker/schema/ws/composition}DSIMSG"/>
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
    "dsimsg"
})
@XmlRootElement(name = "DoCallIDSOneWayRequest")
public class DoCallIDSOneWayRequest
    extends DoComposeRequestOneWayBase
{

    @XmlElement(name = "DSIMSG", required = true)
    protected DSIMSG dsimsg;

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

}
