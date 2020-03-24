# What Is This?
It's a very simple demonstration of using [Maven](https://maven.apache.org) and JAX-WS ``wsimport`` to build a dynamic DWS client from a WSDL. Maven is a tool for software project management. It helps with managing build, reporting, and documentation. This project isn't meant to demonstrate Documaker compatibility with Maven, it's just a tiny benefit of this particular project. The goal of this project is to illustrate how to consume a DWS method, in this case ``doPublishFromImport`` using the dynamic class generation capability of the JAX-WS specification, namely, ``wsimport``. Also, it demostrates how you might write a web service client that uses SSL. In this particular case, since the ODEE domain is deployed with "demo" certificates, there is code here that will blindly bypass all hostname validation, so this should be your caveat emptor: this is not production-ready code! To use the SSL hostname validation bypass means that you could compromise your SSL connections by leaving them open to a MITM (man in the middle) attack. Consider yourself warned! ;-)

# What Does This "Do"?
Simply put, you can execute a few different commands:
1) ``mvn clean`` - this will remove all compiled artifacts and rebuild them, including dynamically generated classes based on the WSDL from DWS. Normally you won't need to do this too often, because you're not going to be changing the classes generated from the WSDL. Maven will automagically determing if your client classes have changed and will recompile those.
1) ``mvn test`` - this will execute the test case, which runs _doPublishFromImport_ using the provided extract file against the WSDL endpoint in the test case. This assumes you have the base domain and reference implementation MRL.
1) ``mvn package`` - this will compile all the artifacts into a single JAR that you can deploy somewhere..

You can also mix and match these commands, like ``mvn test package``.

# What Do I Need?
1) [JDK 1.8](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
1) An ODEE domain, up an running
1) A extract file that works with your MRL deployed to ODEE, running in an Assembly Line
1) Document Factory up and running for the aforementioned Assembly Line
1) The endpoint for your DWS PublishingService and assembly line, e.g. http://some_server:some_port/DWSAL1/PublishingService
1) [Maven](https://maven.apache.org)

# How Do I Use It?
1) Fulfill the prerequisites listed above.
1) Clone the repo.
1) Drop in your extract file to replace the existing ``extract.xml``. Use the same filename so the test case works out of the box, or change the test case.
1) Modify the test case: drill down into ``test/java/com/oracle/documaker/dws/client/AppTest.java`` and look for these two lines:
    ```
         private String EXTRACT = "extract.xml";
         private String ENDPOINT = "https://deepthought:10002/DWSAL1/PublishingServiceSoap12";     
    ```
    Replace them with the filename of your extract, and with your service endpoint.
1) Execute the test by running ``mvn test`` on the command line in the ``dws-test-client`` directory. You should see output similar to this:

```
[INFO] Scanning for projects...
[INFO]
[INFO] ----------< com.oracle.documaker.dws.client:dws-test-client >-----------
[INFO] Building dws-test-client 1.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO]
[INFO] --- jaxws-maven-plugin:2.5:wsimport (default) @ dws-test-client ---
[INFO] Processing: http://192.168.1.125:10001/DWSAL1/PublishingServiceSoap12?wsdl
[INFO] jaxws:wsimport args: [-d, 'dws-test-client/target/classes', -encoding, UTF-8, -extension, "http://192.168.1.125:10001/DWSAL1/PublishingServiceSoap12?wsdl"]
parsing WSDL... [WARNING] SOAP port "PublishingServiceSoap12Port": uses a non-standard SOAP 1.2 binding.
  line 241 of http://192.168.1.125:10001/DWSAL1/PublishingServiceSoap12?wsdl
Generating code...
Compiling code...

[INFO]
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ dws-test-client ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory dws-test-client/src/main/resources
[INFO]
[INFO] --- maven-compiler-plugin:3.3:compile (default-compile) @ dws-test-client ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 1 source file to dws-test-client/target/classes
[INFO]
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ dws-test-client ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory dws-test-client/src/test/resources
[INFO]
[INFO] --- maven-compiler-plugin:3.3:testCompile (default-testCompile) @ dws-test-client ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 1 source file to dws-test-client/target/test-classes
[INFO]
[INFO] --- maven-surefire-plugin:3.0.0-M3:test (default-test) @ dws-test-client ---
[INFO]
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.oracle.documaker.dws.client.AppTest
Endpoint: http://deepthought:10001/DWSAL1/PublishingServiceSoap12
Extract: extract.xml
Timeout: 30000
Calling endpoint...response received
  Job ID: 1141
  Tran ID: 1275
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 4.12 s - in com.oracle.documaker.dws.client.AppTest
[INFO]
[INFO] Results:
[INFO]
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  11.402 s
[INFO] Finished at: 2019-06-26T11:06:42-04:00
[INFO] ------------------------------------------------------------------------
```
The key here is that we see the ``Job ID: nnnn`` and ``Tran ID: nnnn`` outputs. Those are from the test case and signify that the transaction processed successfully.

# Other Things You Can Do
If you run ``mvn package`` you can get a JAR file out of this project, which you can find by inspecting the Maven output:
```
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ dws-test-client ---
[INFO] Building jar: dws-test-client/target/dws-test-client-1.0-SNAPSHOT.jar
[INFO]
[INFO] --- maven-shade-plugin:3.2.0:shade (default) @ dws-test-client ---
[INFO] Skipping pom dependency com.sun.xml.ws:jaxws-rt:pom:2.3.2 in the shaded jar.
[INFO] Including jakarta.xml.bind:jakarta.xml.bind-api:jar:2.3.2 in the shaded jar.
[INFO] Including jakarta.xml.ws:jakarta.xml.ws-api:jar:2.3.2 in the shaded jar.
[INFO] Including jakarta.xml.soap:jakarta.xml.soap-api:jar:1.4.1 in the shaded jar.
[INFO] Including jakarta.annotation:jakarta.annotation-api:jar:1.3.4 in the shaded jar.
[INFO] Including jakarta.jws:jakarta.jws-api:jar:1.1.1 in the shaded jar.
[INFO] Including org.glassfish.jaxb:jaxb-runtime:jar:2.3.2 in the shaded jar.
[INFO] Including org.glassfish.jaxb:txw2:jar:2.3.2 in the shaded jar.
[INFO] Including com.sun.istack:istack-commons-runtime:jar:3.0.8 in the shaded jar.
[INFO] Including com.sun.xml.ws:policy:jar:2.7.6 in the shaded jar.
[INFO] Including org.glassfish.gmbal:gmbal:jar:4.0.0 in the shaded jar.
[INFO] Including org.glassfish.external:management-api:jar:3.2.1 in the shaded jar.
[INFO] Including org.glassfish.pfl:pfl-basic:jar:4.0.1 in the shaded jar.
[INFO] Including org.glassfish.pfl:pfl-tf:jar:4.0.1 in the shaded jar.
[INFO] Including org.glassfish.pfl:pfl-asm:jar:4.0.1 in the shaded jar.
[INFO] Including org.glassfish.pfl:pfl-dynamic:jar:4.0.1 in the shaded jar.
[INFO] Including org.glassfish.pfl:pfl-basic-tools:jar:4.0.1 in the shaded jar.
[INFO] Including org.glassfish.pfl:pfl-tf-tools:jar:4.0.1 in the shaded jar.
[INFO] Including org.jvnet.staxex:stax-ex:jar:1.8.1 in the shaded jar.
[INFO] Including com.sun.xml.stream.buffer:streambuffer:jar:1.5.7 in the shaded jar.
[INFO] Including org.jvnet.mimepull:mimepull:jar:1.9.11 in the shaded jar.
[INFO] Including com.sun.xml.fastinfoset:FastInfoset:jar:1.2.16 in the shaded jar.
[INFO] Including org.glassfish.ha:ha-api:jar:3.1.12 in the shaded jar.
[INFO] Including com.sun.xml.messaging.saaj:saaj-impl:jar:1.5.1 in the shaded jar.
[INFO] Including com.fasterxml.woodstox:woodstox-core:jar:5.1.0 in the shaded jar.
[INFO] Including org.codehaus.woodstox:stax2-api:jar:4.1 in the shaded jar.
[INFO] Including jakarta.activation:jakarta.activation-api:jar:1.2.1 in the shaded jar.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[INFO] Replacing original artifact with shaded artifact.
[INFO] Replacing dws-test-client/target/dws-test-client-1.0-SNAPSHOT.jar with dws-test-client/target/dws-test-client-1.0-SNAPSHOT-shaded.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  13.688 s
[INFO] Finished at: 2019-06-26T11:15:21-04:00
[INFO] ------------------------------------------------------------------------
```

You can take this _shaded_ JAR file, which includes all the components necessary to execute the class, and run it, passing the required arguments (endpoint, extract file, and timeout):
```
$ java -cp target/dws-test-client-1.0-SNAPSHOT.jar com.oracle.documaker.dws.client.App http://deepthought:10001/DWSAL1/PublishingService extract.xml 30000
Endpoint: http://deepthought:10001/DWSAL1/PublishingService
Extract: extract.xml
Timeout: 30000
Calling endpoint...response received
  Job ID: 1146
  Tran ID: 1280
Job ID:1146
Tran ID:1280
```

And there you have it!