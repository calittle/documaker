
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
 *         &lt;element name="queuefactory.class" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="marshaller.class" type="{oracle/documaker/schema/ws/composition}MarshallerClass"/>
 *         &lt;element name="mq.queue.manager" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="mq.tcpip.host" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.tcpip.port" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.inputqueue.name" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="mq.outputqueue.name" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="mq.queue.channel" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.outputqueue.expiry" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mqseries.exception.logging" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mqseries.tracing" type="{oracle/documaker/schema/ws/composition}MQSeriesTracing" minOccurs="0"/>
 *         &lt;element name="mqseries.tracing.log" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ccdt.url" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.cipherspec" type="{oracle/documaker/schema/ws/composition}MQSSLCipherspec" minOccurs="0"/>
 *         &lt;element name="mq.ssl.peername" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.socketFactory.class" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.protocol" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.keystore" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.keystore.type" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.keystore.manager.type" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.keystore.pwd" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.truststore" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.truststore.type" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.truststore.manager.type" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.truststore.pwd" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.ssl.debug" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="mq.Property" type="{oracle/documaker/schema/common}Property" maxOccurs="unbounded" minOccurs="0"/>
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
    "queuefactoryClass",
    "marshallerClass",
    "mqQueueManager",
    "mqTcpipHost",
    "mqTcpipPort",
    "mqInputqueueName",
    "mqOutputqueueName",
    "mqQueueChannel",
    "mqOutputqueueExpiry",
    "mqseriesExceptionLogging",
    "mqseriesTracing",
    "mqseriesTracingLog",
    "mqCcdtUrl",
    "mqSslCipherspec",
    "mqSslPeername",
    "mqSslSocketFactoryClass",
    "mqSslProtocol",
    "mqSslKeystore",
    "mqSslKeystoreType",
    "mqSslKeystoreManagerType",
    "mqSslKeystorePwd",
    "mqSslTruststore",
    "mqSslTruststoreType",
    "mqSslTruststoreManagerType",
    "mqSslTruststorePwd",
    "mqSslDebug",
    "mqProperty"
})
@XmlRootElement(name = "MQ")
public class MQ {

    @XmlElement(name = "queuefactory.class", required = true)
    protected String queuefactoryClass;
    @XmlElement(name = "marshaller.class", required = true)
    protected MarshallerClass marshallerClass;
    @XmlElement(name = "mq.queue.manager", required = true, defaultValue = "queue_manager")
    protected String mqQueueManager;
    @XmlElement(name = "mq.tcpip.host", defaultValue = "127.0.0.1")
    protected String mqTcpipHost;
    @XmlElement(name = "mq.tcpip.port", defaultValue = "1414")
    protected String mqTcpipPort;
    @XmlElement(name = "mq.inputqueue.name", required = true, defaultValue = "RESULTQ")
    protected String mqInputqueueName;
    @XmlElement(name = "mq.outputqueue.name", required = true, defaultValue = "REQUESTQ")
    protected String mqOutputqueueName;
    @XmlElement(name = "mq.queue.channel", defaultValue = "SYSTEM.DEF.SVRCONN")
    protected String mqQueueChannel;
    @XmlElement(name = "mq.outputqueue.expiry", defaultValue = "")
    protected String mqOutputqueueExpiry;
    @XmlElement(name = "mqseries.exception.logging", defaultValue = "N")
    protected String mqseriesExceptionLogging;
    @XmlElement(name = "mqseries.tracing", defaultValue = "1")
    protected Integer mqseriesTracing;
    @XmlElement(name = "mqseries.tracing.log", defaultValue = "mqseries.log")
    protected String mqseriesTracingLog;
    @XmlElement(name = "mq.ccdt.url", defaultValue = "file:///c:/mq/ccdt/AMQCLCHL.TAB")
    protected String mqCcdtUrl;
    @XmlElement(name = "mq.ssl.cipherspec")
    protected MQSSLCipherspec mqSslCipherspec;
    @XmlElement(name = "mq.ssl.peername")
    protected String mqSslPeername;
    @XmlElement(name = "mq.ssl.socketFactory.class", defaultValue = "com.docucorp.messaging.mqseries.DSIMQSSLSocketFactory")
    protected String mqSslSocketFactoryClass;
    @XmlElement(name = "mq.ssl.protocol", defaultValue = "SSLv3")
    protected String mqSslProtocol;
    @XmlElement(name = "mq.ssl.keystore")
    protected String mqSslKeystore;
    @XmlElement(name = "mq.ssl.keystore.type", defaultValue = "JKS")
    protected String mqSslKeystoreType;
    @XmlElement(name = "mq.ssl.keystore.manager.type", defaultValue = "SunX509")
    protected String mqSslKeystoreManagerType;
    @XmlElement(name = "mq.ssl.keystore.pwd")
    protected String mqSslKeystorePwd;
    @XmlElement(name = "mq.ssl.truststore")
    protected String mqSslTruststore;
    @XmlElement(name = "mq.ssl.truststore.type", defaultValue = "JKS")
    protected String mqSslTruststoreType;
    @XmlElement(name = "mq.ssl.truststore.manager.type", defaultValue = "SunX509")
    protected String mqSslTruststoreManagerType;
    @XmlElement(name = "mq.ssl.truststore.pwd")
    protected String mqSslTruststorePwd;
    @XmlElement(name = "mq.ssl.debug", defaultValue = "true")
    protected String mqSslDebug;
    @XmlElement(name = "mq.Property")
    protected List<Property> mqProperty;

    /**
     * Gets the value of the queuefactoryClass property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getQueuefactoryClass() {
        return queuefactoryClass;
    }

    /**
     * Sets the value of the queuefactoryClass property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setQueuefactoryClass(String value) {
        this.queuefactoryClass = value;
    }

    /**
     * Gets the value of the marshallerClass property.
     * 
     * @return
     *     possible object is
     *     {@link MarshallerClass }
     *     
     */
    public MarshallerClass getMarshallerClass() {
        return marshallerClass;
    }

    /**
     * Sets the value of the marshallerClass property.
     * 
     * @param value
     *     allowed object is
     *     {@link MarshallerClass }
     *     
     */
    public void setMarshallerClass(MarshallerClass value) {
        this.marshallerClass = value;
    }

    /**
     * Gets the value of the mqQueueManager property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqQueueManager() {
        return mqQueueManager;
    }

    /**
     * Sets the value of the mqQueueManager property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqQueueManager(String value) {
        this.mqQueueManager = value;
    }

    /**
     * Gets the value of the mqTcpipHost property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqTcpipHost() {
        return mqTcpipHost;
    }

    /**
     * Sets the value of the mqTcpipHost property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqTcpipHost(String value) {
        this.mqTcpipHost = value;
    }

    /**
     * Gets the value of the mqTcpipPort property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqTcpipPort() {
        return mqTcpipPort;
    }

    /**
     * Sets the value of the mqTcpipPort property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqTcpipPort(String value) {
        this.mqTcpipPort = value;
    }

    /**
     * Gets the value of the mqInputqueueName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqInputqueueName() {
        return mqInputqueueName;
    }

    /**
     * Sets the value of the mqInputqueueName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqInputqueueName(String value) {
        this.mqInputqueueName = value;
    }

    /**
     * Gets the value of the mqOutputqueueName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqOutputqueueName() {
        return mqOutputqueueName;
    }

    /**
     * Sets the value of the mqOutputqueueName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqOutputqueueName(String value) {
        this.mqOutputqueueName = value;
    }

    /**
     * Gets the value of the mqQueueChannel property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqQueueChannel() {
        return mqQueueChannel;
    }

    /**
     * Sets the value of the mqQueueChannel property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqQueueChannel(String value) {
        this.mqQueueChannel = value;
    }

    /**
     * Gets the value of the mqOutputqueueExpiry property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqOutputqueueExpiry() {
        return mqOutputqueueExpiry;
    }

    /**
     * Sets the value of the mqOutputqueueExpiry property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqOutputqueueExpiry(String value) {
        this.mqOutputqueueExpiry = value;
    }

    /**
     * Gets the value of the mqseriesExceptionLogging property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqseriesExceptionLogging() {
        return mqseriesExceptionLogging;
    }

    /**
     * Sets the value of the mqseriesExceptionLogging property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqseriesExceptionLogging(String value) {
        this.mqseriesExceptionLogging = value;
    }

    /**
     * Gets the value of the mqseriesTracing property.
     * 
     * @return
     *     possible object is
     *     {@link Integer }
     *     
     */
    public Integer getMqseriesTracing() {
        return mqseriesTracing;
    }

    /**
     * Sets the value of the mqseriesTracing property.
     * 
     * @param value
     *     allowed object is
     *     {@link Integer }
     *     
     */
    public void setMqseriesTracing(Integer value) {
        this.mqseriesTracing = value;
    }

    /**
     * Gets the value of the mqseriesTracingLog property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqseriesTracingLog() {
        return mqseriesTracingLog;
    }

    /**
     * Sets the value of the mqseriesTracingLog property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqseriesTracingLog(String value) {
        this.mqseriesTracingLog = value;
    }

    /**
     * Gets the value of the mqCcdtUrl property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqCcdtUrl() {
        return mqCcdtUrl;
    }

    /**
     * Sets the value of the mqCcdtUrl property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqCcdtUrl(String value) {
        this.mqCcdtUrl = value;
    }

    /**
     * Gets the value of the mqSslCipherspec property.
     * 
     * @return
     *     possible object is
     *     {@link MQSSLCipherspec }
     *     
     */
    public MQSSLCipherspec getMqSslCipherspec() {
        return mqSslCipherspec;
    }

    /**
     * Sets the value of the mqSslCipherspec property.
     * 
     * @param value
     *     allowed object is
     *     {@link MQSSLCipherspec }
     *     
     */
    public void setMqSslCipherspec(MQSSLCipherspec value) {
        this.mqSslCipherspec = value;
    }

    /**
     * Gets the value of the mqSslPeername property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslPeername() {
        return mqSslPeername;
    }

    /**
     * Sets the value of the mqSslPeername property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslPeername(String value) {
        this.mqSslPeername = value;
    }

    /**
     * Gets the value of the mqSslSocketFactoryClass property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslSocketFactoryClass() {
        return mqSslSocketFactoryClass;
    }

    /**
     * Sets the value of the mqSslSocketFactoryClass property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslSocketFactoryClass(String value) {
        this.mqSslSocketFactoryClass = value;
    }

    /**
     * Gets the value of the mqSslProtocol property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslProtocol() {
        return mqSslProtocol;
    }

    /**
     * Sets the value of the mqSslProtocol property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslProtocol(String value) {
        this.mqSslProtocol = value;
    }

    /**
     * Gets the value of the mqSslKeystore property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslKeystore() {
        return mqSslKeystore;
    }

    /**
     * Sets the value of the mqSslKeystore property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslKeystore(String value) {
        this.mqSslKeystore = value;
    }

    /**
     * Gets the value of the mqSslKeystoreType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslKeystoreType() {
        return mqSslKeystoreType;
    }

    /**
     * Sets the value of the mqSslKeystoreType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslKeystoreType(String value) {
        this.mqSslKeystoreType = value;
    }

    /**
     * Gets the value of the mqSslKeystoreManagerType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslKeystoreManagerType() {
        return mqSslKeystoreManagerType;
    }

    /**
     * Sets the value of the mqSslKeystoreManagerType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslKeystoreManagerType(String value) {
        this.mqSslKeystoreManagerType = value;
    }

    /**
     * Gets the value of the mqSslKeystorePwd property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslKeystorePwd() {
        return mqSslKeystorePwd;
    }

    /**
     * Sets the value of the mqSslKeystorePwd property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslKeystorePwd(String value) {
        this.mqSslKeystorePwd = value;
    }

    /**
     * Gets the value of the mqSslTruststore property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslTruststore() {
        return mqSslTruststore;
    }

    /**
     * Sets the value of the mqSslTruststore property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslTruststore(String value) {
        this.mqSslTruststore = value;
    }

    /**
     * Gets the value of the mqSslTruststoreType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslTruststoreType() {
        return mqSslTruststoreType;
    }

    /**
     * Sets the value of the mqSslTruststoreType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslTruststoreType(String value) {
        this.mqSslTruststoreType = value;
    }

    /**
     * Gets the value of the mqSslTruststoreManagerType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslTruststoreManagerType() {
        return mqSslTruststoreManagerType;
    }

    /**
     * Sets the value of the mqSslTruststoreManagerType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslTruststoreManagerType(String value) {
        this.mqSslTruststoreManagerType = value;
    }

    /**
     * Gets the value of the mqSslTruststorePwd property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslTruststorePwd() {
        return mqSslTruststorePwd;
    }

    /**
     * Sets the value of the mqSslTruststorePwd property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslTruststorePwd(String value) {
        this.mqSslTruststorePwd = value;
    }

    /**
     * Gets the value of the mqSslDebug property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMqSslDebug() {
        return mqSslDebug;
    }

    /**
     * Sets the value of the mqSslDebug property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMqSslDebug(String value) {
        this.mqSslDebug = value;
    }

    /**
     * Gets the value of the mqProperty property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the mqProperty property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getMqProperty().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Property }
     * 
     * 
     */
    public List<Property> getMqProperty() {
        if (mqProperty == null) {
            mqProperty = new ArrayList<Property>();
        }
        return this.mqProperty;
    }

}
