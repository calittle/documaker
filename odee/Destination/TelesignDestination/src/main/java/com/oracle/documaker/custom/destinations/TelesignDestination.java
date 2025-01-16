package com.oracle.documaker.custom.destinations;
import oracle.documaker.ecmconnector.connectorapi.Destination;
import oracle.documaker.ecmconnector.connectorapi.data.ConfigurationData;
import oracle.documaker.ecmconnector.connectorapi.data.DocumentData;
import oracle.documaker.ecmconnector.connectorapi.exceptions.DestinationException;
import org.apache.log4j.Logger;
public class TelesignDestination extends Destination {
    private static final Logger logger = Logger.getLogger(TelesignDestination.class.getName());
    private final Telesign ts;

    public TelesignDestination(ConfigurationData configurationData, String destinationId) throws DestinationException {
        super(configurationData, destinationId);
        logger.debug("Executing destination constructor");
        this.ts = Telesign.getInstance(destinationId);
        this.ts.configure(configurationData);
    }

    @Override
    public void importDocument(DocumentData documentData) throws DestinationException {
        long start = 0L;
        start = System.currentTimeMillis();
        this.ts.sendNotification(documentData);
        logger.info("Batch " + documentData.getBatchId() + " took " + (System.currentTimeMillis() - start) + " ms");
    }

    @Override
    public boolean repair() {
        return false;
    }

    @Override
    public void cleanUp() {

    }
}
