package com.oracle.documaker.custom.odee;

import com.oracle.documaker.custom.odee.dwsClient.*;
import oracle.documaker.JDCLib;
import org.apache.commons.cli.*;
import javax.naming.*;
import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import static java.lang.System.exit;

public class ArchiverReprocess {
    static final String PROGRAM_NAME = "ArchiverReprocess";
    static final double PROGRAM_VERSION = 1.0;
    static final String USAGE_STRING = "\nPlace jar file in <ODEE_HOME>/docfactory/\njava -jar " + PROGRAM_NAME + "-" + PROGRAM_VERSION + ".jar [-opt | --option] <value>... -cp <path-to-docfactory-lib>";

    static final String GET_BCH_IDS = "SELECT DISTINCT BCH_ID FROM BCHS WHERE BCHSTATUS=541";

    private Connection connection;

    private boolean loadFromContext = false;
    private String contextName = "DMKRFactory";
    private String contextLocation = "file:config/context";
    private boolean doQueryOnly = false;
    private boolean doProcessOnly = false;

    private URL dwsEndpoint;
    private String connectionString;
    private String credential;
    private String user;

    private List<Long> bchIds;

    private String configName = "Correspondence";
    private String requestType = "Factory_ReprocessArchive";

    public ArchiverReprocess(String[] args) throws Exception {
        Options options = new Options();
        Option option = new Option("c", "connectionString", true, "Database connection string");
        option.setRequired(false);
        options.addOption(option);

        option = new Option("j", "useJndi", false, "Use JNDI context for database connection");
        option.setRequired(false);
        options.addOption(option);

        option = new Option("n", "jndiName", true, "Name for JNDI context (default: DMKRFactory");
        option.setRequired(false);
        options.addOption(option);

        option = new Option("x", "jndiContext", true, "JNDI context file location (default: file:config/context");
        option.setRequired(false);
        options.addOption(option);

        option = new Option("e", "dwsEndpoint", true, "DWS Composition Service Endpoint");
        option.setRequired(false);
        options.addOption(option);

        option = new Option("i", "bchIds", true, "BCH_ID(s) to reprocess, space-delimited");
        option.setRequired(false);
        options.addOption(option);

        option = new Option("m", "mrlConfig", true, "MRL Configuration Name (default:Correspondence)");
        option.setRequired(false);
        options.addOption(option);

        option = new Option("q", "query", false, "Perform a query only; do not modify. Results returned.");
        option.setRequired(false);
        options.addOption(option);

        option = new Option("r", "requestType", true, "IDS Request Type (default:Factory_ReprocessArchive)");
        option.setRequired(false);
        options.addOption(option);

        option = new Option("h", "help", false, "Get help using this program");
        option.setRequired(false);
        options.addOption(option);

        CommandLineParser parser = new DefaultParser();
        HelpFormatter formatter = new HelpFormatter();
        //
        // Parse arguments from the command-line.
        //
        CommandLine cmd = parser.parse(options, args);
        if (cmd.hasOption("h")) {
            formatter.printHelp(USAGE_STRING, options);
            System.exit(0);
        }

        if (!cmd.hasOption("c") & !cmd.hasOption("j")){
            formatter.printHelp(USAGE_STRING, options);
            throw new Exception("Must specify one of either -c or -j option.");
        }

        if (cmd.hasOption("c") & cmd.hasOption("j")){
            formatter.printHelp(USAGE_STRING, options);
            throw new Exception("Must specify ONLY one of either -c or -j option.");
        }

        if (!cmd.hasOption("e") & !cmd.hasOption("q")){
            // e option required if no option q specified
            formatter.printHelp(USAGE_STRING, options);
            throw new Exception("Must specify option -e.");
        }else if (cmd.hasOption("q")){
            this.doQueryOnly = true;
        }else{
            try {
                this.dwsEndpoint = new URL(cmd.getOptionValue("e"));
            } catch (MalformedURLException e) {
                e.printStackTrace();
                throw new Exception("Option -e must be specified with a valid endpoint for DWS Composition service.");
            }
        }
        if (cmd.hasOption("j")) {
            this.loadFromContext = true;
            if (cmd.hasOption("x"))
                this.contextLocation = cmd.getOptionValue("x");
            if (cmd.hasOption("n"))
                this.contextName = cmd.getOptionValue("n");
        }
        if (cmd.hasOption("i")) {
            this.bchIds = new ArrayList<>();
            for (String id : cmd.getOptionValues("i")) {
                bchIds.add(Long.parseLong(id));
            }
            this.doProcessOnly = true;
        }
        if (cmd.hasOption("j"))
            this.loadFromContext = true;
        if (cmd.hasOption("c"))
            this.connectionString = cmd.getOptionValue("c");
        if (cmd.hasOption("r"))
            this.requestType = cmd.getOptionValue("r");
        if (cmd.hasOption("m"))
            this.configName = cmd.getOptionValue("m");
        if (cmd.hasOption("q"))
            this.doQueryOnly = true;

    }

    private void disconnectDatabase() {
        try {
            this.connection.close();
        } catch (Exception e) {
            // nothing.
        }
    }

    private void connectToDatabase() throws Exception {
        long startConnection = System.currentTimeMillis();

        if (this.loadFromContext){
            int ptr =  this.connectionString.indexOf("@");
            this.connectionString = this.connectionString.substring(0,ptr) + this.user + "/" + this.credential + this.connectionString.substring(ptr);
        }
        if (this.connectionString != null && !this.connectionString.isEmpty()) {

            // dynamically load the driver based on the connection string.
            if (this.connectionString.contains("oracle")) {
                Class.forName("oracle.jdbc.driver.OracleDriver");
            }

            if (this.connectionString.contains("microsoft")) {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            }

            this.connection = DriverManager.getConnection(this.connectionString);
            if (this.connection.isValid(30)) {
                System.out.printf("Connected to datasource in %,d ms%n", System.currentTimeMillis() - startConnection);
            } else {
                throw new Exception("Unable to connect to database; connection invalid.");
            }
            if (this.connection.isClosed()) {
                throw new Exception("Unable to connect to database; connection is closed.");
            }

        } else {
            throw new Exception("Unable to connect to database; invalid configuration string.");
        }

    }

    private void invokeDocupresentment(long bchId) throws Exception {
        com.oracle.documaker.custom.odee.dwsClient.CompositionService compositionService = new CompositionService(this.dwsEndpoint);
        CompositionServicePortType compositionServicePortType = compositionService.getCompositionServicePort();
        DoCallIDSRequest req = new DoCallIDSRequest();
        DoCallIDSRequestV1 reqV1 = new DoCallIDSRequestV1();
        IDSRequest idsRequest = new IDSRequest();
        DSIMSG dsimsg = new DSIMSG();
        MSGVARS msgvars = new MSGVARS();

        VAR var = new VAR();
        List<VAR> varList = new ArrayList<VAR>();
        List<ROWSET> rowSetList = new ArrayList<ROWSET>();
        List<ROW> rowList = new ArrayList<ROW>();

        var.setNAME("CONFIG");
        var.setValue(this.configName);
        varList.add(var);

        var = new VAR();
        var.setNAME("REQTYPE");
        var.setValue(this.requestType);
        varList.add(var);

        ROWSET rowset = new ROWSET();
        rowset.setNAME("BCHS");
        ROW row = new ROW();
        var = new VAR();
        var.setNAME("BCH_ID");
        var.setValue(String.valueOf(bchId));
        List<VAR> rowVarList = new ArrayList<VAR>();
        rowVarList.add(var);
        row.setNUM(1);
        row.setVARS(rowVarList);
        rowList.add(row);
        rowset.setROWS(rowList);
        rowSetList.add(rowset);
        msgvars.setVARS(varList);
        msgvars.setROWSETS(rowSetList);
        dsimsg.setMSGVARS(msgvars);
        idsRequest.setDSIMSG(dsimsg);
        reqV1.setIDSRequest(idsRequest);
        req.setDoCallIDSRequestV1(reqV1);

        compositionServicePortType.doCallIDS(req);
        System.out.print("request submitted\n");

    }

    private void doReprocess(List<Long> bchIds) throws Exception {
        System.out.println("BCH_IDs provided: " + bchIds.size());
        int counter = 0;
        for (long bchId : bchIds) {
            System.out.print("Processing BCH_ID " + bchId + "...");
            invokeDocupresentment(bchId);
            counter++;
        }
        System.out.println("Total BCH_IDs processed:" + counter);
    }

    private List<Long> doQuery() throws Exception {
        List<Long> bchIds = new ArrayList<>();

        Statement s = this.connection.createStatement();
        ResultSet bchResults = s.executeQuery(GET_BCH_IDS);
        int rowCount = 0;
        while (bchResults.next()) {
            rowCount++;
            bchIds.add(bchResults.getLong("BCH_ID"));
        }
        System.out.println("Query completed; total results:" + rowCount);

        bchResults.close();
        s.close();

        return bchIds;

    }

    private void setContext(String PROVIDER_URL, String JNDI_NAME) throws Exception {
        Hashtable<String, String> env = new Hashtable<>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.fscontext.RefFSContextFactory");
        env.put(Context.PROVIDER_URL, PROVIDER_URL);
        Context ctx = new InitialContext(env);
        Reference ref = (Reference) ctx.lookup(JNDI_NAME);

        URL fileUrl = new URL(env.get("java.naming.provider.url"));
        String fileName = fileUrl.toURI().getSchemeSpecificPart();
        fileName = fileName + "/.bindings";
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader(fileName));
        } catch (FileNotFoundException e) {
            System.err.println("Cannot open .bindings file in " + fileName);
            exit(1);
        }

        try {
            String nextLine;
            while ((nextLine = reader.readLine()) != null) {
                if (nextLine.startsWith(JNDI_NAME + "/" +"RefAddr") && nextLine.contains("Content")) {

                    String[] content = nextLine.split("/");

                    int position = (int) Long.parseLong(content[2]);
                    RefAddr ra = ref.get(position);
                    /* not currently used
                    if (ra.getType().equals("driverClassName")) {
                        String driver = ra.getContent().toString();
                    }*/
                    if (ra.getType().equalsIgnoreCase("url")){
                        this.connectionString = ra.getContent().toString();
                    }
                    if (ra.getType().equalsIgnoreCase("password")){
                        this.credential =decryptString(ra.getContent().toString());
                    }
                    if (ra.getType().equalsIgnoreCase("username")){
                        this.user = ra.getContent().toString();
                    }
                }
            }
        } catch (IOException e) {
            throw new Exception("Error in reading .bindings file" + e.getMessage());
        } catch (NumberFormatException e) {
            throw new Exception("Error in format of .bindings file" + e.getMessage());
        }
        reader.close();
    }

    private String decryptString(String encrypted) {
        String decrypted = null;
        JDCLib crypt = new JDCLib();
        crypt.setJavaLogging(false);
        byte[] dataIn; // = new byte[0];
        byte[] dataOut; // = new byte[0];
        dataIn = encrypted.getBytes(StandardCharsets.US_ASCII);
        if (dataIn.length > 0) {
            dataOut = crypt.decryptTextData(dataIn);
            if (dataOut.length > 0) {
                decrypted = new String(dataOut);
            } else {
                System.err.println("EncryptedBasicDataSourceFactory: Error decrypting value: " + crypt.getLastError());
            }
        }
        return decrypted;
    }

    /**
     * Query BCHS table for BCH_ID values where BCHSTATUS=541, and submit transaction
     * to Docupresentment (REQTYPE:Factory_ReprocessArchiver) via DWS>CompositionService
     * call to have Archiver reprocess the identified BCHS row.
     *
     * Can connect to database using JNDI context from ODEE or using connection string.
     *
     * Deploy to docfactory/ directory and run from there.
     *
     * @param args - argument array; use -h to list available options.
     * @throws Exception - various
     */
    public static void main(String[] args) throws Exception {
        System.out.printf("%s version %2.1f%n", PROGRAM_NAME, PROGRAM_VERSION);

        ArchiverReprocess o = new ArchiverReprocess(args);
        if (o.loadFromContext) {
            o.setContext(o.contextLocation, o.contextName);
        }

        if (o.doQueryOnly) {
            o.connectToDatabase();
            o.bchIds = o.doQuery();
            System.out.println("BCH_IDs meeting criteria (BCHSTATUS 541):");
            StringBuilder sb = new StringBuilder();
            for (long bchId : o.bchIds) {
                sb.append(bchId).append(" ");
            }
            System.out.println(sb);
            o.disconnectDatabase();
        } else if (o.doProcessOnly) {
            o.doReprocess(o.bchIds);
        } else {

            o.connectToDatabase();
            o.doReprocess(o.doQuery());
            o.disconnectDatabase();
        }


    }
}
