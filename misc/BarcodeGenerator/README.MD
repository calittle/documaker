# Install Notes
1. Clone the project. You're going to get a lot of stuff; do this once and then proceed from `misc/BarcodeGenerator`
```
git clone git://github.com/calittle/documaker.git
```
1. Build your project.
```
mvn clean compile assembly:single
```
1. Run the project. You should see an output file.
```
java -cp target/barcode-generator-1.0-SNAPSHOT-jar-with-dependencies.jar: com.oracle.documaker.external.BarcodeGenerator
```
