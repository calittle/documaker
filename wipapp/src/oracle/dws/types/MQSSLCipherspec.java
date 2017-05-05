
package oracle.dws.types;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for MQSSLCipherspec.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="MQSSLCipherspec">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="DES_SHA_EXPORT"/>
 *     &lt;enumeration value="DES_SHA_EXPORT1024"/>
 *     &lt;enumeration value="NULL_MD5"/>
 *     &lt;enumeration value="NULL_SHA"/>
 *     &lt;enumeration value="RC2_MD5_EXPORT"/>
 *     &lt;enumeration value="RC4_56_SHA_EXPORT1024"/>
 *     &lt;enumeration value="RC4_MD5_US"/>
 *     &lt;enumeration value="RC4_MD5_EXPORT"/>
 *     &lt;enumeration value="RC4_SHA_US"/>
 *     &lt;enumeration value="TRIPLE_DES_SHA_US"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "MQSSLCipherspec")
@XmlEnum
public enum MQSSLCipherspec {

    DES_SHA_EXPORT("DES_SHA_EXPORT"),
    @XmlEnumValue("DES_SHA_EXPORT1024")
    DES_SHA_EXPORT_1024("DES_SHA_EXPORT1024"),
    @XmlEnumValue("NULL_MD5")
    NULL_MD_5("NULL_MD5"),
    NULL_SHA("NULL_SHA"),
    @XmlEnumValue("RC2_MD5_EXPORT")
    RC_2_MD_5_EXPORT("RC2_MD5_EXPORT"),
    @XmlEnumValue("RC4_56_SHA_EXPORT1024")
    RC_4_56_SHA_EXPORT_1024("RC4_56_SHA_EXPORT1024"),
    @XmlEnumValue("RC4_MD5_US")
    RC_4_MD_5_US("RC4_MD5_US"),
    @XmlEnumValue("RC4_MD5_EXPORT")
    RC_4_MD_5_EXPORT("RC4_MD5_EXPORT"),
    @XmlEnumValue("RC4_SHA_US")
    RC_4_SHA_US("RC4_SHA_US"),
    TRIPLE_DES_SHA_US("TRIPLE_DES_SHA_US");
    private final String value;

    MQSSLCipherspec(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static MQSSLCipherspec fromValue(String v) {
        for (MQSSLCipherspec c: MQSSLCipherspec.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
