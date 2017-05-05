
package oracle.dws.types;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for AttachmentReturnType.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="AttachmentReturnType">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="URI"/>
 *     &lt;enumeration value="Binary"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "AttachmentReturnType", namespace = "oracle/documaker/schema/common")
@XmlEnum
public enum AttachmentReturnType {

    URI("URI"),
    @XmlEnumValue("Binary")
    BINARY("Binary");
    private final String value;

    AttachmentReturnType(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static AttachmentReturnType fromValue(String v) {
        for (AttachmentReturnType c: AttachmentReturnType.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
