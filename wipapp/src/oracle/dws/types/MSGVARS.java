
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
 *         &lt;element ref="{oracle/documaker/schema/ws/composition}VAR" maxOccurs="unbounded" minOccurs="0"/>
 *         &lt;element ref="{oracle/documaker/schema/ws/composition}ROWSET" maxOccurs="unbounded" minOccurs="0"/>
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
    "var",
    "rowset"
})
@XmlRootElement(name = "MSGVARS")
public class MSGVARS {

    @XmlElement(name = "VAR")
    protected List<VAR> var;
    @XmlElement(name = "ROWSET")
    protected List<ROWSET> rowset;

    /**
     * Gets the value of the var property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the var property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getVAR().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link VAR }
     * 
     * 
     */
    public List<VAR> getVAR() {
        if (var == null) {
            var = new ArrayList<VAR>();
        }
        return this.var;
    }

    /**
     * Gets the value of the rowset property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the rowset property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getROWSET().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link ROWSET }
     * 
     * 
     */
    public List<ROWSET> getROWSET() {
        if (rowset == null) {
            rowset = new ArrayList<ROWSET>();
        }
        return this.rowset;
    }

}
