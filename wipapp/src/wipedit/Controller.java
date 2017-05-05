package wipedit;

import java.security.AccessController;
import java.security.Principal;

import java.text.SimpleDateFormat;

import javax.security.auth.Subject;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;

import weblogic.security.spi.WLSGroup;
import weblogic.security.spi.WLSUser;

public class Controller {

    private String className = this.getClass().getSimpleName();

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
    private String docPrepGroupId;
    private String docVetGroupId;
    private String docPrepGroupName;
    private String docVetGroupName;
    private String httpUser;
    private String httpUserPass;
    private String pegaEndpoint;
    private String idsProofPrintType;
    private String idsRequestProof;
  
    private int logLevel = LOG_ERROR;

    private static final int LOG_DEBUG = 0;
    private static final int LOG_WARN = 1;
    private static final int LOG_ERROR = 2;
    
    private static final String CONTROLLER_VERSION="1.0";

    public Controller(ServletConfig config) {
        super();
        try {
            ServletContext ctx = config.getServletContext();

            check(ctx.getInitParameter("wipEditVersion"),"Web Application: WipEdit Version ");
            pegaEndpoint = ctx.getInitParameter("pegaEndpoint");
            check(pegaEndpoint,"pegaEndpoint");
            
            logMessage("DEBUG",className,"Version " + CONTROLLER_VERSION);
            
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

            docPrepGroupId = ctx.getInitParameter("docPrepGroupId");
            check(docPrepGroupId, "docPrepGroupId");

            docVetGroupId = ctx.getInitParameter("docVetGroupId");
            check(docVetGroupId, "docVetGroupId");

            docPrepGroupName = ctx.getInitParameter("docPrepGroupName");
            check(docPrepGroupName, "docPrepGroupName");

            docVetGroupName = ctx.getInitParameter("docVetGroupName");
            check(docVetGroupName, "docVetGroupName");
            
            httpUser = ctx.getInitParameter("httpUser");
            check(httpUser,"httpUser");
            
            httpUserPass = ctx.getInitParameter("httpUserPass");
            check("*","httpUserPass");
            
          idsRequestProof = ctx.getInitParameter("idsRequestProof");
          check(idsRequestProof, "idsRequestProof");

          idsProofPrintType= ctx.getInitParameter("idsProofPrintType");
          check(idsProofPrintType, "idsProofPrintType");


        } catch (Throwable t) {
            logMessage("ERROR", className, t.getMessage());
        }

    }

    public void logMessage(String logType, String className, String message) {
        int curLevel = 2;
        if (logType.equalsIgnoreCase("DEBUG"))
            curLevel = 0;
        else if (logType.equalsIgnoreCase("WARN"))
            curLevel = 1;
        else
            curLevel = 2;

        if (curLevel >= logLevel)
            System.out.println(String.format("<%s> <%s> <wipedit> <%s> %s",
                                             new SimpleDateFormat("MMM d, yyyy HH:mm:ss").format(new java.util.Date()),
                                             logType, className, message));
    }

    private void setLogLevel(String level) {

        if (level == null) {
            logLevel = LOG_ERROR;
            logMessage("WARN", className,
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
        logMessage("DEBUG", className,
                   "Log Level = <" + logLevel + "> <0=DEBUG,1=WARN,2=ERROR>");
    }

    private void check(String s, String n) throws Exception {
        if (s == null | s.length() < 1) {
            logMessage("ERROR", className,
                       "Setting '" + n + "' was not configured in web.xml and has no default.");
            throw new Exception("Setting '" + n +
                                "' was not configured in web.xml and has no default.");
        }
        logMessage("DEBUG", className,
                   "<INIT> Setting <" + n + "> = <" + s + ">");
    }

    public String userName(Subject subject){
      if (subject != null && subject.getPrincipals() != null) {
          for (Principal p : subject.getPrincipals()) {
                if (p instanceof WLSUser) {
                        return p.getName();
            }
        }
      }
      return "";      
    }  
    public String userGroups(Subject subject){
        StringBuilder sb = new StringBuilder();
        Boolean first=true;
          if (subject != null && subject.getPrincipals() != null) {
              for (Principal p : subject.getPrincipals()) {
                  if (p instanceof WLSGroup) {
                      if (first){
                        sb.append(p.getName());
                        first=false;
                      }else
                      {
                          sb.append("," +p.getName());                          
                      }
                  }
              }
          }
          return sb.toString();
        }
    
    public Boolean isUserDocVet(Subject subject){           
      if (subject != null && subject.getPrincipals() != null) {
          for (Principal p : subject.getPrincipals()) {
              if (p instanceof WLSGroup) {
                  if (p.getName().equalsIgnoreCase(docVetGroupName))
                    return true;
              }
          }
      }
      return false;
    }
    public Boolean isUserDocPrep(Subject subject){           
      if (subject != null && subject.getPrincipals() != null) {
          for (Principal p : subject.getPrincipals()) {
              if (p instanceof WLSGroup) {
                  if (p.getName().equalsIgnoreCase(docPrepGroupName))
                    return true;
              }
          }
      }
      return false;
    }

    public final synchronized int getLogLevel() {
        return logLevel;
    }

    public final synchronized void setLogLevel(int s) {
        this.logLevel = s;
    }

    public final synchronized String getSaveServlet() {
        return saveServlet;
    }

    public final synchronized void setSaveServlet(String s) {
        this.saveServlet = s;
    }

    public final synchronized void setGetResourceServlet(String getResourceServlet) {
        this.getResourceServlet = getResourceServlet;
    }

    public final synchronized String getGetResourceServlet() {
        return getResourceServlet;
    }

    public final synchronized void setRefreshServlet(String refreshServlet) {
        this.refreshServlet = refreshServlet;
    }

    public final synchronized String getRefreshServlet() {
        return refreshServlet;
    }

    public final synchronized void setIdsConfig(String idsConfig) {
        this.idsConfig = idsConfig;
    }

    public final synchronized String getIdsConfig() {
        return idsConfig;
    }

    public final synchronized void setIdsgetWipPrintType(String idsgetWipPrintType) {
        this.idsgetWipPrintType = idsgetWipPrintType;
    }
    
  public final synchronized void setIdsProofPrintType(String idsProofPrintType) {
      this.idsProofPrintType = idsProofPrintType;
  }
  public final synchronized String getIdsProofPrintType() {
      return idsProofPrintType;
  } 
  

    public final synchronized String getIdsgetWipPrintType() {
        return idsgetWipPrintType;
    }

    public final synchronized void setHostUrlPrefix(String hostUrlPrefix) {
        this.hostUrlPrefix = hostUrlPrefix;
    }

    public final synchronized String getHostUrlPrefix() {
        return hostUrlPrefix;
    }

    public final synchronized void setIdsRequestSave(String idsRequestSave) {
        this.idsRequestSave = idsRequestSave;
    }

    public final synchronized String getIdsRequestSave() {
        return idsRequestSave;
    }

    public final synchronized void setIdsRequestGetWip(String idsRequestGetWip) {
        this.idsRequestGetWip = idsRequestGetWip;
    }

    public final synchronized String getIdsRequestGetWip() {
        return idsRequestGetWip;
    }
    
    
  public final synchronized void setIdsRequestProof(String idsRequestProof) {
      this.idsRequestProof = idsRequestProof;
  }

  public final synchronized String getIdsRequestProof() {
      return idsRequestProof;
  }

    

    public final synchronized void setIdsRequestUpdateWip(String idsRequestUpdateWip) {
        this.idsRequestUpdateWip = idsRequestUpdateWip;
    }

    public final synchronized String getIdsRequestUpdateWip() {
        return idsRequestUpdateWip;
    }

    public final synchronized void setIdsRequestGetResource(String idsRequestGetResource) {
        this.idsRequestGetResource = idsRequestGetResource;
    }

    public final synchronized String getIdsRequestGetResource() {
        return idsRequestGetResource;
    }

    public final synchronized void setIdsRequestUID(String idsRequestUID) {
        this.idsRequestUID = idsRequestUID;
    }

    public final synchronized String getIdsRequestUID() {
        return idsRequestUID;
    }

    public final synchronized void setIdsRequestPWD(String idsRequestPWD) {
        this.idsRequestPWD = idsRequestPWD;
    }

    public final synchronized String getIdsRequestPWD() {
        return idsRequestPWD;
    }

    public final synchronized void setDocPrepGroupId(String docPrepGroupId) {
        this.docPrepGroupId = docPrepGroupId;
    }

    public final synchronized String getDocPrepGroupId() {
        return docPrepGroupId;
    }

    public final synchronized void setDocVetGroupId(String docVetGroupId) {
        this.docVetGroupId = docVetGroupId;
    }

    public final synchronized String getDocVetGroupId() {
        return docVetGroupId;
    }

    public final synchronized void setDocPrepGroupName(String docPrepGroupName) {
        this.docPrepGroupName = docPrepGroupName;
    }

    public final synchronized String getDocPrepGroupName() {
        return docPrepGroupName;
    }

    public final synchronized void setDocVetGroupName(String docVetGroupName) {
        this.docVetGroupName = docVetGroupName;
    }

    public final synchronized String getDocVetGroupName() {
        return docVetGroupName;
    }
    public final synchronized String getHttpUser(){
      return httpUser;
    }
  public final synchronized String getHttpUserPass(){
    return httpUserPass;
  }
  public final synchronized void setHttpUser(String httpUser){
    this.httpUser = httpUser;
  }
  public final synchronized void setHttpUserPass(String httpUserPass){
    this.httpUserPass = httpUserPass;
  }
  

    public static final synchronized int getLOG_DEBUG() {
        return LOG_DEBUG;
    }

    public static final synchronized int getLOG_WARN() {
        return LOG_WARN;
    }

    public static final synchronized int getLOG_ERROR() {
        return LOG_ERROR;
    }
}
