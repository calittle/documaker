package com.oracle.documaker.ids.customrule;

import com.docucorp.ids.data.*;

import java.sql.*;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.InputStream;
/**
 * Sample Template for a Custom IDS Rule
 * IDS Rules have 4 modes: Initialize(1), Run Forward(2), Run Reverse(3), and Terminate(4). When an IDS request is
 * executed, each rule in the request is executed 4 times and receives a flag indicating the mode:
 *  Pass 1 is the Initialize Pass, and rules are executed in order from first to last.
 *  Pass 2 is the Run Forward, and rules are executed in order from first to last.
 *  Pass 3 is the Run Reverse, and rules are executed in order from last to first.
 *  Pass 4 is the Terminate, and rules are executed in order from last to first.
 *
 * This allows your rule to have an initialize routine and a terminate routine to setup and teardown anything needed
 * to perform its work, e.g. a database connection, temporary file, etc.
 *
 * The run forward and run reverse modes allow your rule to execute with respect to other rules, e.g. your rule might
 * be dependent on another rule's output which may not be generated until run reverse, so your code would need to
 * run on the reverse mode.
 *
 * Modify this template as needed, then compile and test. The tests simulate the 4 modes that a rule will receive, and
 * you may need to simulate the expected data inputs and outputs your rule receives and generates, or modify the test
 * assertions.
 *
 * To deploy a custom rule, simply drop the JAR file and any dependency JAR files in the docserv/rules folder.
 * You will also need to add the rule into the request type(s) that will call it, using this pattern:
 *
 *  <entry name="function">java;RuleClassName;ScopeObject;Scope;Method;Arguments</entry>
 *  Where:
 *      RuleClassName
 *          is the class name of your rule, e.g. com.oracle.documaker.ids.customrules.MyCustomRule
 *
 *      ScopeObject
 *          is a unique name to maintain the state of your rule according to your designated scope; note that if
 *          multiple IDS request types use your rule and they have need to share data, then the ScopeObject can be the
 *          same. Use with caution!
 *
 *      Scope
 *          is one of the following which determines how your rule is created as a Java object:
 *              global – The object will remain until IDS is restarted.
 *       		transaction – The object will be created during the MSG_INIT message and will remain until the request
 *       	   	    has processed all the MSG_INIT, MSG_RUNF, MSG_RUNR and MSG_TERM messages.
 *       		local – The object is created and destroyed for every message run during the request.
 *       		static – No object is created; the method is a static method of the class and will be run as such
 *
 *      Arguments
 *          is a string that contains any arguments you want to pass to your rule. Format is up to you; the example
 *          herein uses comma-delimited name-value pairs which are parsed into a Properties object.
 *
 *  Example (lines are split for readability):
 *
 *      <entry name="function">
 *          java;com.oracle.documaker.ids.customrules.MyCustomRule;RuleObj;transaction;getEmployees;arguments
 *      </entry>
 *
 */
public class MyCustomRule {
    private Properties props = new Properties();
    private final int DEFAULT_RETRIES = 3;
    private final int DEFAULT_TIMEOUT = 5;  //seconds
    private final String PROPFILE = "config.properties";
    private final String JVMPROPFILE = "MyCustomRulePropFile";

    Connection conn = null;

    public MyCustomRule(){
        // this constructor is required to be no-argument.
        // you could, in theory, do initial setup here
        // but is recommended to do so in the INIT phase.
    }

    private void parseArguments(String idsArgs){
        // First, we load the config.properties file,
        // then we parse and load any name/value pairs passed from
        // the IDS configuration. These will override the properties file
        // if they have the same name.
        ClassLoader loader = Thread.currentThread().getContextClassLoader();

        try {
            InputStream propFile = loader.getResourceAsStream(PROPFILE);
            props.load(propFile);
            //System.out.println("Default properties loaded from MyCustomRule JAR");
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Then, we attempt to load any specified properties from the JVM System property.
        if (System.getProperty(JVMPROPFILE) != null) {
            try {
                InputStream propFile = loader.getResourceAsStream(System.getProperty(JVMPROPFILE));
                props.load(propFile);
//                System.out.println("Effective Properties:");
//                props.forEach((k, v) -> {
//                    System.out.println("\t" + k + "=" + v);
//                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // this assumes the string passed in is comma-delimited name-value pairs, e.g.
        // "db.user=abc,db.pass=123"
        // it should NOT have a trailing ; or , nor should any properties have spaces. if they do,
        // the value should be enclosed in "
        try {
            if (!idsArgs.isEmpty()) {
                String[] args = idsArgs.split(",");
                // parse the name/value pairs
                for (String strTemp : args) {
                    String[] nvp = strTemp.split("=");
                    props.put(nvp[0], nvp[1]);
                }
            }
        }catch (Exception e){
            System.err.println("Error processing IDS arguments. Check formatting as comma-separated name-value pairs.");
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws Exception {
        String clazzName = null;
        try{
            // first, make sure our required properties are present.
            if (props.getProperty("db.url") == null){
                throw new Exception ("Missing required property [config.properties] db.url=");
            }
            if (props.getProperty("db.user") == null){
                throw new Exception ("Missing required property [config.properties] db.user=");
            }
            if (props.getProperty("db.password")==null){
                throw new Exception ("Missing required property [config.properties] db.password=");
            }

            if (props.getProperty("db.driver") != null ){
                // Set the class name for the driver, if specified.
                // First, we check to see if we have configured a specific driver.
                clazzName = props.getProperty("db.driver");

            }else{
                // if a driver name wasn't specified, we can infer it from the
                // connection URL.
                if (props.getProperty("db.url").contains("db2")) {
                    clazzName = "com.ibm.db2.jcc.DB2Driver";
                }
            }
            // Load the selected driver. If it's blank, then we won't load
            // and we'll assume the JDBC framework will do this.
            if (clazzName != null){
                Class.forName(clazzName);
                System.out.println("\tLoaded class: " + clazzName);
            }

            // Set a login timeout, either from properties or from our default.
            if (props.getProperty("db.timeout")!= null){
                try{
                    DriverManager.setLoginTimeout(Integer.parseInt(props.getProperty("db.timeout")));
                }catch(Exception e){
                    DriverManager.setLoginTimeout(DEFAULT_TIMEOUT);
                }
            }else{
                DriverManager.setLoginTimeout(DEFAULT_TIMEOUT);
            }

            // set the number of retries.
            int retries=1;
            int retryCount=0;
            try {
                retries = Integer.parseInt(props.getProperty("db.retries"));
            }catch (Exception e){
                retries = DEFAULT_RETRIES;
            }
            while (conn == null & retryCount <= retries){
                conn = DriverManager.getConnection(
                        props.getProperty("db.url"),
                        props.getProperty("db.user"),
                        props.getProperty("db.password")
                );
                retryCount++;
            }

        }catch(SQLException e){
            System.err.println("SQL Exception [SQLSTATE=" + e.getSQLState() + "] [MSG=" + e.getMessage() + "] [ERRORCODE=" + e.getErrorCode() + "]");
            e.printStackTrace();

        }catch(ClassNotFoundException e){
            System.err.println(">>> Class could not be found! " + clazzName);
            e.printStackTrace();

        }catch(Exception e){
            e.printStackTrace();
        }
//        System.out.println(">>>>> DBURL="+ props.getProperty("db.url") +
//                "\nDbUser=" + props.getProperty("db.user") +
//                "\nDBPass=" + props.getProperty("db.password"));

        return conn;
    }

    private ResultSet doQuery(String query) throws Exception {
        ResultSet rs=null;
        try {

            Statement stmt = conn.createStatement();
            rs = stmt.executeQuery(query);

        }catch (Exception e){
            throw new Exception(e);
        }
        return rs;
    }

    public int myCustomMethod(RequestState requestState, String idsArgs, int msg)
    {
        parseArguments(idsArgs);

        if (msg == IDSConstants.MSG_INIT) {
            try{
                conn = getConnection();
                if (conn == null)
                    return IDSConstants.RET_FAIL;
                else if (conn.isClosed())
                    return IDSConstants.RET_FAIL;
                else
                    return IDSConstants.RET_SUCCESS;
            }catch(Exception e){
                e.printStackTrace();
                return IDSConstants.RET_FAIL;
            }

        }else if (msg == IDSConstants.MSG_RUNF) {
            try{
                ResultSet rs = doQuery("SELECT id, first, last, age FROM Employees");
                while (rs.next()) {
                    System.out.print("\tID: " + rs.getInt("id"));
                    System.out.print(", Age: " + rs.getInt("age"));
                    System.out.print(", First: " + rs.getString("first"));
                    System.out.println(", Last: " + rs.getString("last"));
                }
                return IDSConstants.RET_SUCCESS;
            }catch(Exception e){
                e.printStackTrace();
                return IDSConstants.RET_FAIL;
            }

        }else if (msg == IDSConstants.MSG_RUNR) {
            // do something
            return IDSConstants.RET_SUCCESS;

        }else if (msg == IDSConstants.MSG_TERM){
            try {
                conn.close();
            }catch (Exception e){
                //e.printStackTrace();
                // We don't really want to fail just because we can't
                // close the connection.
                //return IDSConstants.RET_FAIL;
            }
            return IDSConstants.RET_SUCCESS;
        }else{
            return IDSConstants.ERR_MSGNOTSUPPORTED;
        }

    }
}
