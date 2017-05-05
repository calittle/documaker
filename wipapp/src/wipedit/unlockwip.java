package wipedit;

import java.io.IOException;
import java.io.PrintWriter;

import java.security.AccessController;
import java.security.Principal;

import javax.security.auth.Subject;

import javax.servlet.*;
import javax.servlet.http.*;

import oracle.dws.CompositionServicePortClient;
import oracle.dws.types.Diagnosis;
import oracle.dws.types.DoCallIDSResponse;
import oracle.dws.types.Errors;
import oracle.dws.types.Results;

import weblogic.security.spi.WLSGroup;
import weblogic.security.spi.WLSUser;

public class unlockwip extends HttpServlet {
  private String className = this.getClass().getSimpleName();
  private Controller ws = null;

  public void init(ServletConfig config) throws ServletException {
        super.init(config);
      ws = new Controller(config);
    }

    public void doGet(HttpServletRequest request,
                      HttpServletResponse response) throws ServletException,
                                                           IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String uniqueId = request.getParameter("uniqueid");

        if (uniqueId.equalsIgnoreCase("") || uniqueId.equalsIgnoreCase("null")) {

            out.println("<h4>UNIQUE ID IS MISSING</h4>");
            out.close();
            ws.logMessage("ERROR",className, "UNIQUE ID not provided in request.");
            return;
            
        } else {

            String entityId = ws.getDocPrepGroupId();
            Subject subject =
                Subject.getSubject(AccessController.getContext());
            StringBuffer groups = new StringBuffer();
            String user = null;
            String gname = null;
            boolean first = true;

            if (subject != null && subject.getPrincipals() != null) {
                for (Principal p : subject.getPrincipals()) {
                    if (p instanceof WLSGroup) {
                        if (first) {
                            first = false;
                        } else {
                            groups.append(", ");
                        }
                        gname = p.getName();
                        groups.append(gname);
                        if (gname.equalsIgnoreCase(ws.getDocPrepGroupName()))
                            entityId = ws.getDocPrepGroupId();
                        else if (gname.equalsIgnoreCase(ws.getDocVetGroupName()))
                            entityId = ws.getDocVetGroupId();
                    } else if (p instanceof WLSUser) {
                        user = p.getName();
                    }
                }
            }
            try {
                CompositionServicePortClient cli = null;
                cli = new CompositionServicePortClient();

                DoCallIDSResponse res = null;
                Results results = null;

                res = cli.unlockWIPentry(ws.getIdsConfig(), uniqueId, entityId, ws.getIdsRequestUID(), ws.getIdsRequestPWD(), ws.getIdsRequestUpdateWip());
                results = res.getResults();

                if (results.getResult() != 0) {
                    Errors errors = results.getErrors();
                    out.println("<table><tr><td>Category</td><td>Code</td><td>Severity</td><td>Description</td></tr>");
                    for (oracle.dws.types.Error e : errors.getError()) {
                        out.println("<tr><td>" + e.getCategory() +
                                    "</td><td>" + e.getCode() + "</td><td>" +
                                    e.getSeverity() + "</td><td>" +
                                    e.getDescription() + "</td></tr>");
                        ws.logMessage("ERROR",className,
                                   "Category <" + e.getCategory() + "> Code <" +
                                   e.getCode() + "> Severity <" +
                                   e.getSeverity() + "> Description <" +
                                   e.getDescription() + "> Diagnoses follow.");

                        for (Diagnosis d : e.getDiagnosis()) {
                            out.println("<tr><td colspan='2'>" + d.getCause() +
                                        "</td><td colspan='2'>" +
                                        d.getRemedy() + "</td></tr>");
                            ws.logMessage("ERROR",className,
                                       "Diagnosis -- Cause <" + d.getCause() +
                                       "> Remedy <" + d.getRemedy() + ">");
                        }
                    }
                    out.println("</table>");
                    out.close();
                    return;

                } else {
                    ws.logMessage("DEBUG",className,
                               "Transaction unlocked.     UNIQUE_ID <" +
                               uniqueId + ">");                    
                    
                }
            } catch (Throwable t) {
                ws.logMessage("ERROR",className, t.getMessage());
                t.printStackTrace();            
              
            }
          
          out.close();
          return;
        }
    }

    public void doPost(HttpServletRequest request,
                       HttpServletResponse response) throws ServletException,
                                                            IOException {
        doGet(request, response);
    }
}
