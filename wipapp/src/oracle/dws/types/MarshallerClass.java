
package oracle.dws.types;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for MarshallerClass.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="MarshallerClass">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="com.docucorp.messaging.data.marshaller.SerializationDSIMessageMarshaller"/>
 *     &lt;enumeration value="com.docucorp.messaging.data.marshaller.SOAPMIMEDSIMessageMarshaller"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "MarshallerClass")
@XmlEnum
public enum MarshallerClass {

    @XmlEnumValue("com.docucorp.messaging.data.marshaller.SerializationDSIMessageMarshaller")
    COM_DOCUCORP_MESSAGING_DATA_MARSHALLER_SERIALIZATION_DSI_MESSAGE_MARSHALLER("com.docucorp.messaging.data.marshaller.SerializationDSIMessageMarshaller"),
    @XmlEnumValue("com.docucorp.messaging.data.marshaller.SOAPMIMEDSIMessageMarshaller")
    COM_DOCUCORP_MESSAGING_DATA_MARSHALLER_SOAPMIMEDSI_MESSAGE_MARSHALLER("com.docucorp.messaging.data.marshaller.SOAPMIMEDSIMessageMarshaller");
    private final String value;

    MarshallerClass(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static MarshallerClass fromValue(String v) {
        for (MarshallerClass c: MarshallerClass.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
