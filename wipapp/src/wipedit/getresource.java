package wipedit;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;

import java.text.SimpleDateFormat;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.servlet.*;
import org.apache.commons.fileupload.disk.*;

import java.util.List;

import oracle.dws.CompositionServicePortClient;
import oracle.dws.types.Attachment;
import oracle.dws.types.Content;
import oracle.dws.types.Diagnosis;
import oracle.dws.types.DoCallIDSResponse;
import oracle.dws.types.Errors;
import oracle.dws.types.Results;

public class getresource extends HttpServlet {

    private String saveServlet;
    private String getResourceServlet;
    private String refreshServlet;
    private String idsConfig;
    private String idsgetWipPrintType;
    private String hostUrlPrefix;
    private String idsRequestSave;
    private String idsRequestGetWip;
    private String idsRequestUpdateWip;
    private String idsRequestGetResource;
    private String idsRequestUID;
    private String idsRequestPWD;
    private static final int LOG_DEBUG = 0;
    private static final int LOG_WARN = 1;
    private static final int LOG_ERROR = 2;

    private int logLevel = LOG_ERROR;


    private void logMessage(String logType, String message) {
        int curLevel = 2;
        if (logType.equalsIgnoreCase("DEBUG"))
            curLevel = 0;
        else if (logType.equalsIgnoreCase("WARN"))
            curLevel = 1;
        else
            curLevel = 2;

        if (curLevel >= logLevel)
            System.out.println(String.format("<%s> <%s> <wipedit> <getresource> %s",
                                             new SimpleDateFormat("MMM d, yyyy HH:mm:ss").format(new java.util.Date()),
                                             logType, message));
    }

    private void setLogLevel(String level) {
        if (level == null) {
            logLevel = LOG_ERROR;
            logMessage("WARN",
                       "Setting <logLevel> missing from web.xml, using default <ERROR>");
        } else {
            if (level.equalsIgnoreCase("ERROR"))
                logLevel = LOG_ERROR;
            else if (level.equalsIgnoreCase("DEBUG"))
                logLevel = LOG_DEBUG;
            else if (level.equalsIgnoreCase("WARN"))
                logLevel = LOG_WARN;
            else
                logLevel = LOG_ERROR;
        }
        logMessage("DEBUG", "Log Level = <" + logLevel + "> <0=DEBUG,1=WARN,2=ERROR>");
    }

    private void check(String s, String n) throws Exception {
        if (s == null | s.length() < 1) {
            logMessage("ERROR",
                       "Setting '" + n + "' was not configured in web.xml and has no default.");
            throw new Exception("Setting '" + n +
                                "' was not configured in web.xml and has no default.");
        }
        logMessage("DEBUG","<INIT> Setting <" + n + "> = <" + s + ">");
    }

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        try {
            ServletContext ctx = config.getServletContext();

            saveServlet = ctx.getInitParameter("saveServlet");
            check(saveServlet, "saveServlet");

            idsConfig = ctx.getInitParameter("idsConfig");
            check(idsConfig, "idsConfig");

            setLogLevel(ctx.getInitParameter("logLevel"));

            getResourceServlet = ctx.getInitParameter("getResourceServlet");
            check(getResourceServlet, "getResourceServlet");

            idsConfig = ctx.getInitParameter("idsConfig");
            check(idsConfig, "idsConfig");

            idsgetWipPrintType = ctx.getInitParameter("idsgetWipPrintType");
            check(idsgetWipPrintType, "idsgetWipPrintType");

            hostUrlPrefix = ctx.getInitParameter("hostUrlPrefix");
            check(hostUrlPrefix, "hostUrlPrefix");

            idsRequestSave = ctx.getInitParameter("idsRequestSave");
            check(idsRequestSave, "idsRequestSave");

            idsRequestGetWip = ctx.getInitParameter("idsRequestGetWip");
            check(idsRequestGetWip, "idsRequestGetWip");

            idsRequestUpdateWip = ctx.getInitParameter("idsRequestUpdateWip");
            check(idsRequestUpdateWip, "idsRequestUpdateWip");

            idsRequestGetResource =
                    ctx.getInitParameter("idsRequestGetResource");
            check(idsRequestGetResource, "idsRequestGetResource");

            idsRequestUID = ctx.getInitParameter("idsRequestUID");
            check(idsRequestUID, "idsRequestUID");

            idsRequestPWD = ctx.getInitParameter("idsRequestPWD");
            check(idsRequestPWD, "idsRequestPWD");

            refreshServlet = ctx.getInitParameter("refreshServlet");
            check(refreshServlet, "refreshServlet");

        } catch (Throwable t) {
            logMessage("ERROR", t.getMessage());
        }
    }


    /**Process the HTTP doGet request.
     */
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response) throws ServletException,
                                                           IOException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request,
                       HttpServletResponse response) throws ServletException,
                                                            IOException {

        String resourceName = "";
        String requestType = "";
        String config = "";
        String resourceType = "";
        String resourceExtension = "";
        String effectiveDate = "";
        Boolean okToSend = false;

        try {
            List<FileItem> items =
                new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
            for (FileItem item : items) {
                if (item.isFormField()) {

                    // Process regular form field (input type="text|radio|checkbox|etc", select, etc).
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString();

                    logMessage("DEBUG", fieldName + "=" + fieldValue);

                    if (fieldName.equalsIgnoreCase("resourcename")) {
                        resourceName = fieldValue;
                        okToSend = true;
                    }

                    if (fieldName.equalsIgnoreCase("requesttype")) {
                        requestType = fieldValue;
                        okToSend = true;
                    }

                    if (fieldName.equalsIgnoreCase("config")) {
                        config = fieldValue;
                        okToSend = true;
                    }

                    if (fieldName.equalsIgnoreCase("resourcetype")) {
                        resourceType = fieldValue;
                        okToSend = true;
                    }

                    if (fieldName.equalsIgnoreCase("resourceext")) {
                        resourceExtension = fieldValue;
                        okToSend = true;
                    }

                    if (fieldName.equalsIgnoreCase("effectivedate")) {
                        effectiveDate = fieldValue;
                        okToSend = true;
                    }
                }
            }
            if (okToSend) {
                CompositionServicePortClient cli =
                    new CompositionServicePortClient();
                DoCallIDSResponse res =
                    cli.getResource(config, effectiveDate, "2", resourceName,
                                    resourceType, idsRequestUID, idsRequestPWD,
                                    idsRequestGetResource);

                Results results = res.getResults();

                if (results.getResult() != 0) {
                    response.setContentType("text/html");
                    PrintWriter out = response.getWriter();
                    out.println("There was a problem processing the request. <h1>Diagnostics:</h1>");
                    Errors errors = results.getErrors();
                    out.println("<table><tr><td>Category</td><td>Code</td><td>Severity</td><td>Description</td></tr>");
                    for (oracle.dws.types.Error e : errors.getError()) {
                        out.println("<tr><td>" + e.getCategory() +
                                    "</td><td>" + e.getCode() + "</td><td>" +
                                    e.getSeverity() + "</td><td>" +
                                    e.getDescription() + "</td></tr>");

                        for (Diagnosis d : e.getDiagnosis()) {
                            out.println("<tr><td colspan='2'>" + d.getCause() +
                                        "</td><td colspan='2'>" +
                                        d.getRemedy() + "</td></tr>");
                        }
                    }
                    out.println("</table>");
                    out.close();
                    return;
                }
                
                OutputStream os = response.getOutputStream();

                List<oracle.dws.types.Attachment> attachList =
                    res.getDSIMSG().getAttachment();
                if (attachList.size() < 1)
                    throw new Exception("No attachments available in response.");

                Attachment att = attachList.get(attachList.size() - 1);

                Content c = att.getContent();
                javax.activation.DataHandler d = c.getBinary();
                InputStream is = d.getInputStream();

                response.addHeader("content-disposition",
                                   "attachment; filename=" +
                                   att.getFileName());
                response.addHeader("content-transfer-encoding", "base64");
                response.addHeader("content-id", "DOCUMENTSTREAM");
                response.setContentType("application/ids");

                byte[] buf = new byte[1000];
                int chunk;
                for (chunk = is.read(buf); chunk != -1; chunk = is.read(buf)) {
                    os.write(buf, 0, chunk);
                }
                response.setHeader("Content-Length", Integer.toString(chunk));

                os.flush();
                os.close();
                return;
            }
        } catch (Throwable t) {
            logMessage("ERROR", t.getMessage());
        }

    }
}
