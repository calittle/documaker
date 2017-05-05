package wipedit;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oracle.dws.CompositionServicePortClient;
import oracle.dws.types.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.*;

import java.util.List;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;

import javax.servlet.ServletContext;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;


public class savewip extends HttpServlet {

    private String className = this.getClass().getSimpleName();
    private Controller ws = null;

    // upload settings
    private static final String UPLOAD_DIRECTORY = "upload";
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 50; // 5MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 50; // 50MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB
    private static final String SERVLET_VERSION="1.0";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        ws = new Controller(config);
    }

    public void doPost(HttpServletRequest request,
                       HttpServletResponse response) throws IOException,
                                                            ServletException {
        // do the same thing as HTTP GET request
        doGet(request, response);
    }

    public void doGet(HttpServletRequest request,
                      HttpServletResponse response) throws ServletException,
                                                           IOException {
        response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
		response.setHeader("Pragma","no-cache");        //HTTP 1.0
		response.setDateHeader ("Expires", 0);                 //prevents caching at the proxy server
		response.setHeader("Cache-Control","no-store"); //HTTP 1.1
        
        String currentUser = "2";
        String uniqueId = null;

        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(MEMORY_THRESHOLD);
       
        ServletContext servletContext = this.getServletConfig().getServletContext();
        File repository = (File) servletContext.getAttribute("javax.servlet.context.tempdir");
        factory.setRepository(repository);
      
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setFileSizeMax(MAX_FILE_SIZE);
        upload.setSizeMax(MAX_REQUEST_SIZE);
        
        ws.logMessage("DEBUG",className,"Processing save request Servlet Version " + SERVLET_VERSION);
        
        try {
            ws.logMessage("DEBUG",className,"Parse request from POST...");
            List<FileItem> items = upload.parseRequest(request);

            // create attachment for IDS Request.
            Attachment attach = new Attachment();

            for (FileItem item : items) {
                ws.logMessage("DEBUG",className,"... Request Item parsed; form/non-form content parsing follows.");
                if (item.isFormField()) {                    
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString();
                    ws.logMessage("DEBUG", className,
                                  fieldName + "=" + fieldValue);

                    if (fieldName.equalsIgnoreCase("DPWRECNUM"))
                        uniqueId = fieldValue;
                } else {
                    
                    // handle non-form items.
                    File f = new File(repository,item.getName());
                    String fileName = f.getName();
                    item.write(f);
                    
                    ws.logMessage("DEBUG", className,
                                String.format("Attachment <Name=%s> <ContentType=%s>",
                                fileName,
                                item.getContentType()));

                    DataSource fds = new FileDataSource(f);
                    DataHandler handler = new DataHandler(fds);                  
                    Content c = new Content();
                    c.setBinary(handler);
                                    
                    attach.setFileName("XMLIMPORT");
                    attach.setName("XMLIMPORT");
                    attach.setContent(c);
                }
            }

            ws.logMessage("DEBUG",className,"...Completed POST parsing. Calling DWS...");

            CompositionServicePortClient cli =
                new CompositionServicePortClient();

            DoCallIDSResponse res =
                cli.saveWIPEntry(attach, ws.getIdsRequestSave(),
                                 ws.getIdsConfig(), uniqueId, currentUser,
                                 ws.getIdsRequestUID(), ws.getIdsRequestPWD(),
                                 ws.getIdsgetWipPrintType());

            ws.logMessage("DEBUG",className,"...DWS call complete. Parsing results.");

            Results results = res.getResults();

            if (results.getResult() != 0) {
                ws.logMessage("DEBUG",className,"...DWS call complete. Parsing results.");
                
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                out.println("There was a problem processing the request. <h1>Diagnostics:</h1>");
                Errors errors = results.getErrors();
                out.println("<table><tr><td>Category</td><td>Code</td><td>Severity</td><td>Description</td></tr>");
                ws.logMessage("ERROR",className,"DWS Save Error:");
                for (oracle.dws.types.Error e : errors.getError()) {
                  
                  ws.logMessage("ERROR",className,String.format("<Category=%s> <Severity=%s> <Desc=%s>",e.getCategory(),e.getSeverity(),e.getDescription()));
                   
                    out.println("<tr><td>" + e.getCategory() + "</td><td>" +
                                e.getCode() + "</td><td>" + e.getSeverity() +
                                "</td><td>" + e.getDescription() +
                                "</td></tr>");
                    
                    for (Diagnosis d : e.getDiagnosis()) {
                        out.println("<tr><td colspan='2'>" + d.getCause() +
                                    "</td><td colspan='2'>" + d.getRemedy() +
                                    "</td></tr>");
                    }
                }
                out.println("</table>");
                out.close();
                return;
            } else {
                ws.logMessage("DEBUG",className,"DWS call completed successfully.");
                PrintWriter out = response.getWriter();
                out.println("Document saved.");
                out.flush();
                out.close();
                return;
            }
        } catch (Throwable t) {
            ws.logMessage("ERROR", className, t.getMessage());
            t.printStackTrace();
        }

    }
}
