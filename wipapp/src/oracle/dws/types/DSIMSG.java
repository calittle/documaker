
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
 *         &lt;element ref="{oracle/documaker/schema/ws/composition}MSGVARS"/>
 *         &lt;element ref="{oracle/documaker/schema/common}Attachment" maxOccurs="unbounded" minOccurs="0"/>
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
    "msgvars",
    "attachment"
})
@XmlRootElement(name = "DSIMSG")
public class DSIMSG {

    @XmlElement(name = "MSGVARS", required = true)
    protected MSGVARS msgvars;
    @XmlElement(name = "Attachment", namespace = "oracle/documaker/schema/common")
    protected List<Attachment> attachment;

    /**
     * Gets the value of the msgvars property.
     * 
     * @return
     *     possible object is
     *     {@link MSGVARS }
     *     
     */
    public MSGVARS getMSGVARS() {
        return msgvars;
    }

    /**
     * Sets the value of the msgvars property.
     * 
     * @param value
     *     allowed object is
     *     {@link MSGVARS }
     *     
     */
    public void setMSGVARS(MSGVARS value) {
        this.msgvars = value;
    }

    /**
     * Gets the value of the attachment property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the attachment property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAttachment().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Attachment }
     * 
     * 
     */
    public List<Attachment> getAttachment() {
        if (attachment == null) {
            attachment = new ArrayList<Attachment>();
        }
        return this.attachment;
    }

}
