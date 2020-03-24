# External Data Transaction (EDT)

## Use Case
Document generation must support the ability to retrieve data from an external source, either a system or file, to augment or enrich data provided by the user.

## Requirements
To satisfy the use case, Documaker Interactive (DI) consumes a web service that implements three specific methods. This web service, which is a **_custom integration component_**, is not part of base product and is expected to be developed and implemented by the customer or integrator. The methods are:
1. **getKeys**: This method provides an HTML form to facilitate key data entry. The form should supply all key data inputs necessary to facilitate integration and data retrieval from the customer system(s). DI uses this method to present a form to the user for collecting the data. 
1. **getData**: This method performs the actual integration to customer system(s). DI invokes this method and sents a byte buffer containing the user-entered key data. This method must be customized to perform the necessary functions required to use the key data for the purpose of collecting additional data from external systems, form that data into an acceptable XML document that conforms to the Documaker extract file schema for the resource library, and return the XML data as a byte array.
1. **validateFile**: This method is invoked when the external source is a file, and provides a mechanism to validate that the file conforms to any requirements stipulated by the customer. This method is used only for validation and not for enrichment.

## Reference Implementation
The reference implementation of _EDTApplication_ can be used as a stub that can be changed during implementation, or to demonstrate capability of Documaker Interactive's external data transaction features. The reference implementation provides the three required methods with the following characteristics:
1. **getKeys**: This method returns a static HTML file from within the web service WAR file (_public-html/getKeys.html_). This file can be changed within the deployment file for easy customization, or for demonstration purposes. 
1. **getData**: This method returns a static XML file from within the web service WAR File (_public-html/getData.xml_). This file can be changed within the deployment file for demonstration purposes.
1. **validateFile**: This method performs a perfunctory validation that the file passed to it can be parsed by an XML parser. 

## Integration
To reuse the reference implementation for integration at a customer site, there are two activities that must occur:
1. Perform requisite error catching and handling; and,
1. Override the following methods in _oracle.documaker.edt.custom.**ExternalDataTransaction**_. You can, of course, use the base 
classes in _oracle.documaker.edt_ but this is not recommended as you will have to modify the annotations to properly generate the web service and methods:
    
* **getKeys**: This method should be changed to dynamically build an HTML form or dynamically select an external HTML file to return as dictated by requirements.   
* **getData**: This method should be changed to integrate with customer system(s) to gather the necessary data and collate into a single data stream that conforms to the Documaker resource library schema of the implementation.
* **validateFile**: This method should be changed to perform validations as stipulated by customer requirements.
    
Once the methods are prepared, you can build the project using the configured deployment profile, or use a new one. You may deploy to a WAR file which you can then import and deploy in WebLogic, or you may deploy directly to WebLogic server through the deployment profile. 
