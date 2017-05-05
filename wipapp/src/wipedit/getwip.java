package wipedit;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.security.auth.*;

import oracle.dws.CompositionServicePortClient;
import oracle.dws.types.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.*;

import java.security.AccessController;

import java.util.Enumeration;

import java.util.List;

public class getwip extends HttpServlet {
    private String className = this.getClass().getSimpleName();
    private Controller ws = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        ws = new Controller(config);
    }

    public void doPost(HttpServletRequest request,
                       HttpServletResponse response) throws IOException,
                                                            ServletException {        
        doGet(request, response);
    }

    public void doGet(HttpServletRequest request,
                      HttpServletResponse response) throws ServletException,
                                                           IOException {
        String uniqueId = "";
        String entityId = ws.getDocPrepGroupId();        
        Subject s = Subject.getSubject(AccessController.getContext());
        
        response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
		response.setHeader("Pragma","no-cache");        //HTTP 1.0
		response.setDateHeader ("Expires", 0);                 //prevents caching at the proxy server
		response.setHeader("Cache-Control","no-store"); //HTTP 1.1
        
        ws.logMessage("DEBUG",className,String.format("User <%s> DOC_PREP <%s>, DOC_VET <%s>, Groups <%s>.",ws.userName(s),ws.isUserDocPrep(s),ws.isUserDocVet(s),ws.userGroups(s)));
      
        // log some other stuff.

        Enumeration attrs = request.getAttributeNames();
        String attrName = "";
        while (attrs.hasMoreElements()) {
            attrName = (String)attrs.nextElement();
            ws.logMessage("DEBUG",className,
                       " Request Attribute: <" + attrName + ">=<" + request.getAttribute(attrName) +
                       ">");
        }

        attrs = request.getParameterNames();
        attrName = "";
        while (attrs.hasMoreElements()) {
            attrName = (String)attrs.nextElement();
            ws.logMessage("DEBUG",className,
                       " Request Parameter: <" + attrName + ">=<" + request.getParameter(attrName) +
                       ">");
        }

        attrs = request.getHeaderNames();
        attrName = "";
        while (attrs.hasMoreElements()) {
            attrName = (String)attrs.nextElement();
            ws.logMessage("DEBUG",className,
                       " Header Item: <" + attrName + ">=<" + request.getHeader(attrName) +
                       ">");
        }



        try {

            uniqueId = request.getParameter("uniqueid");

            if (uniqueId.equalsIgnoreCase("")) {
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                out.println("<h4>UNIQUE ID IS MISSING</h4>");
                out.close();
                ws.logMessage("ERROR",className, "UNIQUE ID not provided in request.");
                return;
            }
            CompositionServicePortClient cli = null;
            cli = new CompositionServicePortClient();

            DoCallIDSResponse res = null;
            Results results = null;
        
            res = cli.lockWIPentry(ws.getIdsConfig(), uniqueId, entityId, ws.getIdsRequestUID(), ws.getIdsRequestPWD(),
                  ws.getIdsRequestUpdateWip(), ws.userName(s));
            
            results = res.getResults();

            if (results.getResult() != 0) {
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                Errors errors = results.getErrors();
                out.println("<table><tr><td>Category</td><td>Code</td><td>Severity</td><td>Description</td></tr>");
                for (oracle.dws.types.Error e : errors.getError()) {
                    out.println("<tr><td>" + e.getCategory() + "</td><td>" +
                                e.getCode() + "</td><td>" + e.getSeverity() +
                                "</td><td>" + e.getDescription() +
                                "</td></tr>");
                    ws.logMessage("ERROR",className,
                               "Category <" + e.getCategory() + "> Code <" +
                               e.getCode() + "> Severity <" + e.getSeverity() +
                               "> Description <" + e.getDescription() +
                               "> Diagnoses follow.");

                    for (Diagnosis d : e.getDiagnosis()) {
                        out.println("<tr><td colspan='2'>" + d.getCause() +
                                    "</td><td colspan='2'>" + d.getRemedy() +
                                    "</td></tr>");
                        ws.logMessage("ERROR",className,
                                   "Diagnosis -- Cause <" + d.getCause() +
                                   "> Remedy <" + d.getRemedy() + ">");
                    }
                }
                out.println("</table>");
            }
            ws.logMessage("DEBUG",className,"Transaction locked.     UNIQUE_ID <" + uniqueId + ">, CURRGROUP <" + entityId +">");
            ws.logMessage("DEBUG",className,"Getting WIP Data.       UNIQUE_ID <" + uniqueId + ">");
            ws.logMessage("DEBUG",className,
                          String.format("IDS Request[<IdsConfig=%s>, <UniqueId=%s>, <IdsRequestUID=%s>, <IdsRequestPwd=%s>, <IdsWipPrtType=%s>, <HostUrlPrefix=%s>, <IdsReqGetWip=%s>, <IdsReqSave=%s>, <GetResSrv=%s>, <SaveSrv=%s>, <RefreshSrv=%s>, <HTTPUser=%s>, <HTTPPass=%s>]",
                           ws.getIdsConfig(), uniqueId, ws.getIdsRequestUID(), ws.getIdsRequestPWD(),
                           ws.getIdsgetWipPrintType(), ws.getHostUrlPrefix(), ws.getIdsRequestGetWip(),
                           ws.getIdsRequestSave(), ws.getGetResourceServlet(), ws.getSaveServlet(),
                           ws.getRefreshServlet(), ws.getHttpUser(), "*"));
            res =
                cli.getWIPentry(ws.getIdsConfig(), uniqueId, ws.getIdsRequestUID(), ws.getIdsRequestPWD(),
                 ws.getIdsgetWipPrintType(), ws.getHostUrlPrefix(), ws.getIdsRequestGetWip(),
                 ws.getIdsRequestSave(), ws.getGetResourceServlet(), ws.getSaveServlet(),
                 ws.getRefreshServlet(), ws.getHttpUser(), ws.getHttpUserPass());
            
            ws.logMessage("DEBUG",className,"Return from getting WIP Data; parse results.       UNIQUE_ID <" + uniqueId + ">");
            results = res.getResults();
            ws.logMessage("DEBUG",className,"Results = "+ results.getResult() + "       UNIQUE_ID <" + uniqueId + ">");

            if (results.getResult() != 0) {
                ws.logMessage("ERROR",className,
                           "Unable to get WIP Data UNIQUE_ID <" + uniqueId +
                           ">");
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                Errors errors = results.getErrors();
                out.println("<table><tr><td>Category</td><td>Code</td><td>Severity</td><td>Description</td></tr>");
                for (oracle.dws.types.Error e : errors.getError()) {
                    out.println("<tr><td>" + e.getCategory() + "</td><td>" +
                                e.getCode() + "</td><td>" + e.getSeverity() +
                                "</td><td>" + e.getDescription() +
                                "</td></tr>");
                    ws.logMessage("ERROR",className,
                               "Category <" + e.getCategory() + "> Code <" +
                               e.getCode() + "> Severity <" + e.getSeverity() +
                               "> Description <" + e.getDescription() +
                               "> Diagnoses follow.");

                    for (Diagnosis d : e.getDiagnosis()) {
                        out.println("<tr><td colspan='2'>" + d.getCause() +
                                    "</td><td colspan='2'>" + d.getRemedy() +
                                    "</td></tr>");
                        ws.logMessage("ERROR",className,
                                   "Diagnosis -- Cause <" + d.getCause() +
                                   "> Remedy <" + d.getRemedy() + ">");
                    }
                }
                out.println("</table>");
                out.close();
                return;
            }

			ws.logMessage("DEBUG",className,"Parsing response for DPW.       UNIQUE_ID <" + uniqueId + ">");
            OutputStream os = response.getOutputStream();

            List<oracle.dws.types.Attachment> attachList =
                res.getDSIMSG().getAttachment();
            if (attachList.size() < 1)
                throw new Exception("No attachments available in response.");

            Attachment att = attachList.get(attachList.size() - 1);

            Content c = att.getContent();
            javax.activation.DataHandler d = c.getBinary();
            InputStream is = d.getInputStream();

			ws.logMessage("DEBUG",className,"Writing headers.       UNIQUE_ID <" + uniqueId + ">");

            response.addHeader("content-disposition",
                               "inline; filename=" + att.getFileName());
            response.setContentType("application/x-dpwfile");

            byte[] buf = new byte[1000];
            int chunk;
            for (chunk = is.read(buf); chunk != -1; chunk = is.read(buf)) {
                os.write(buf, 0, chunk);
            }
            ws.logMessage("DEBUG",className,"Content-Length = " + Integer.toString(chunk) + ".       UNIQUE_ID <" + uniqueId + ">");
            response.setHeader("Content-Length", Integer.toString(chunk));

            os.flush();
            os.close();
            return;

        } catch (Throwable t) {
            ws.logMessage("ERROR",className, t.getMessage());
            t.printStackTrace();
        }
    }
}