package com.oracle.documaker.custom.destinations;
import oracle.documaker.ecmconnector.connectorapi.Destination;
import oracle.documaker.ecmconnector.connectorapi.data.ConfigurationData;
import oracle.documaker.ecmconnector.connectorapi.data.DocumentData;
import oracle.documaker.ecmconnector.connectorapi.exceptions.DestinationException;

import org.apache.log4j.Logger;
public class HttpApiDestination extends Destination {

    private static final Logger logger = Logger.getLogger(HttpApiDestination.class.getName());
    private final HttpApiDestinationSystem fnSystem;

    public HttpApiDestination(ConfigurationData configurationData, String destinationId) throws DestinationException {
        super(configurationData, destinationId);
        logger.debug("Executing fileNetDestination constructor");
        this.fnSystem = HttpApiDestinationSystem.getInstance(destinationId);
        this.fnSystem.configure(configurationData);
    }

    @Override
    public void importDocument(DocumentData documentData) throws DestinationException {
        long start = 0L;
        start = System.currentTimeMillis();
        this.fnSystem.uploadDocumentContents(documentData);
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
