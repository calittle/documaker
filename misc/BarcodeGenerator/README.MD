# What Is This?
BarcodeGenerator uses the Spring Boot framework to standup an HTTP server that accepts requests with data and generates/returns a barcode, using a REST API.

# Install Notes
1. Clone the project. You're going to get a lot of stuff; do this once.
1. Move into misc/BarcodeGenerator/barcode-service
1. Perform Maven install.
1. Run Spring Boot. Note: you must have `JAVA_HOME` environment variable set that points to your JDK.
```
git clone git://github.com/calittle/documaker.git
cd documaker/misc/BarcodeGenerator/barcode-service
maven install
./mvnw spring-boot:run
```
# Run Notes
1. Use the Maven Spring Boot tool to run the server from `misc/BarcodeGenerator/barcode-service`
```
./mvnw spring-boot:run
```
2. Access the server at [http://localhost:8080/barcodes](http://localhost:8080/barcodes)
3. To listen on a different interface, modify `main/resources/application.properties` to reflect the hostname or IP address interface desired.

# Test Notes
Use the Postman collection to exercise the various requests using different barcode generators. Some methods use POST, others use GET (query string).
* Barbecue Library
* Barcode4J
* ZXing
* QRGen
