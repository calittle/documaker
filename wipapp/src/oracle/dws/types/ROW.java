
package oracle.dws.types;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
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
 *         &lt;element ref="{oracle/documaker/schema/ws/composition}VAR" maxOccurs="unbounded"/>
 *       &lt;/sequence>
 *       &lt;attribute name="NUM" use="required" type="{http://www.w3.org/2001/XMLSchema}int" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "var"
})
@XmlRootElement(name = "ROW")
public class ROW {

    @XmlElement(name = "VAR", required = true)
    protected List<VAR> var;
    @XmlAttribute(name = "NUM", required = true)
    protected int num;

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
     * Gets the value of the num property.
     * 
     */
    public int getNUM() {
        return num;
    }

    /**
     * Sets the value of the num property.
     * 
     */
    public void setNUM(int value) {
        this.num = value;
    }

}
