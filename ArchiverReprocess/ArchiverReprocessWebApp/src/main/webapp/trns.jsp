<%-- Select Page  --%>
<%@ page contentType="text/html; charset=iso-8859-1" pageEncoding="UTF-8"%>
<%@ page import="com.oracle.documaker.custom.archiverreprocesswebapp.servlets.DataService" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="com.oracle.documaker.custom.archiverreprocesswebapp.models.Trns" %>

<!doctype html>
<html lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link type="text/css" rel="stylesheet" href="bootstrap-5.2.3-dist/css/bootstrap.min.css">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
  <title>Archiver Reprocess</title>
</head>
<body>
<div class="container">
  <div class="row">
    <div class="col">
      <h2>Documaker Reprocessing</h2>
      <p>Select one or more records displayed below, then click <em>Reprocess Selected</em> to submit the transactions for reprocessing by Assembler.</p>
    </div>
  </div> <!-- header -->
  <div class="row">
    <div class="col-lg-3">
      <form accept-charset=utf-8 name="queryDate" action="app" method="POST">
        <input type="hidden" name="doAction" value="queryTrns">
        <label for="objectType">Object Type</label>
        <select class="form-control" id="objectType" name="objectType">
          <option value="bchsrcps">Archiver Reprocess</option>
          <option value="trns" selected>Assembler Reprocess</option>
        </select>
<br/>
        <label for="dateLowerLimit">Start Date Time</label>
      <input id="dateLowerLimit" class="form-control" type="datetime-local" name="dateLowerLimit"/>
<br/>
        <label for="dateUpperLimit">End Date Time</label>
      <input id="dateUpperLimit" class="form-control" type="datetime-local" name="dateUpperLimit" />
<br/>
        <input class="btn btn-primary" type="submit" value="Search">
      </form>
    </div><!-- search div -->

    <div class="col-lg-6">
        <form accept-charset=utf-8 name="selectItem" action="app" method="POST">
          <input type="hidden" name="doAction" value="reprocessTrns">
          <table class="table table-striped">
            <thead>
            <tr>
              <td class="table-warning text-center">
                <div class="form-check">
                  <label for="checkAll"></label><input class="form-check-input" type="checkbox" onClick="toggle(this);" value="" id="checkAll" name="checkAll"/>
                </div>
              </td>
              <td>Job ID</td>
              <td>Trn ID</td>
              <td>Status Date</td>
            </tr>
            </thead>

<%
  List<String> errorList = new ArrayList<>();
  List<Trns> resultList = null;

  DataService dataService;

  String JNDI_NAME_DS = "jdbc/dmkrasline";

  try {

    InitialContext ctx = new InitialContext();
    String jndiName = request.getServletContext().getInitParameter("asline-jndi-name");
    if (jndiName == null)
      jndiName = JNDI_NAME_DS;
    if (jndiName.equalsIgnoreCase(""))
      jndiName = JNDI_NAME_DS;

    DataSource dataSource = (DataSource) ctx.lookup(jndiName);
    dataService = new DataService(dataSource);

    String lowerLimit = request.getParameter("dateLowerLimit");
    String upperLimit = request.getParameter("dateUpperLimit");

    resultList = dataService.getAssemblerFailedTrns(lowerLimit,upperLimit);

  }catch (NamingException e){
    e.printStackTrace();
    errorList.add("JNDI Name not found (" + JNDI_NAME_DS + "); check configuration of domain and application.");

  }catch (Exception e) {
    e.printStackTrace();
    errorList.add(e.getMessage());
  }
  int count = 0;
  if (resultList != null){
    count = resultList.size();
    for (Trns t : resultList ){
%>
            <tr>
              <td>
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" name="trnids" value="<%=t.getTrnId()%>"/>
                </div>

              </td>
              <td><%=t.getJobId()%></td>
              <td><%=t.getTrnId()%></td>
              <td><%=t.getTrnModifyTime()%></td>
            </tr>
<%
     }
    }
%>
            <tr>
              <td colspan="5" class="text-bg-info text-center text-capitalize">
                <%=count%> rows found.
              </td>
            </tr>
            <tr>
              <td colspan="4" class="text-center"><input class="btn btn-primary" type="submit" value="Reprocess Selected Record(s)"></td>
              <td><a href="logout" class="btn btn-secondary" tabindex="-1" role="button">Logout</a>
                </td>
            </tr>
          </table>

        </form>
    </div> <!-- table div -->
  </div> <!-- main row -->
<%

  String recordsProcess = request.getParameter("r");
  if (recordsProcess!=null){
  %>
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
  <div id="recordsToast" class="toast hide" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="toast-header">
      <img src="favicon.ico" class="rounded me-2" alt="Oracle Favicon">
      <strong class="me-auto">Results</strong>
      <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
    <div class="toast-body">
      <%=(recordsProcess.equalsIgnoreCase("1")) ? "Record submitted for processing." : recordsProcess + " records submitted for processing."%>
    </div>
  </div>
</div>

<%}
  String errorMessage = request.getParameter("e");
  if (errorMessage!=null){
%>
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
  <div id="postErrorToast" class="toast hide" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="toast-header">
      <img src="favicon.ico" class="rounded me-2" alt="Oracle Favicon">
      <strong class="me-auto">Error Processing Your Request!</strong>
      <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
    <div class="toast-body">
      <%=errorMessage%>
    </div>
  </div>
<%
  }
  for (String error : errorList){
%>
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
  <div id="errorToast" class="toast hide" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="toast-header">
      <img src="favicon.ico" class="rounded me-2" alt="Oracle Favicon">
      <strong class="me-auto">An error occurred:</strong>
      <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
    <div class="toast-body">
      <%=error%>
    </div>
  </div>
</div>
<%
  };
%>
</div> <!-- main container -->
<script type="text/javascript" src="bootstrap-5.2.3-dist/js/bootstrap.bundle.min.js"></script>
<script>
  window.addEventListener("load", function() {
    let now = new Date();
    let year = now.getFullYear();
    let month = now.getMonth() + 1;
    let day = now.getDate();
    let nextDay = now.getDate()+1;
    let localDatetimeLowerLimit = year + "-" +
            (month < 10 ? "0" + month.toString() : month) + "-" +
            (day < 10 ? "0" + day.toString() : day) + "T00:00:00"
    let localDatetimeUpperLimit = year + "-" +
            (month < 10 ? "0" + month.toString() : month) + "-" +
            (day < 10 ? "0" + nextDay.toString() : nextDay) + "T00:00:00"
    let datetimeField = document.getElementById("dateLowerLimit");
    datetimeField.value = localDatetimeLowerLimit;

    datetimeField = document.getElementById("dateUpperLimit");
    datetimeField.value = localDatetimeUpperLimit;
  });
  let toastElList = [].slice.call(document.querySelectorAll('.toast'))
  let toastList = toastElList.map(function (toastEl) {return new bootstrap.Toast(toastEl) })
  toastList.forEach(toast => toast.show());

  function toggle(source) {
    let checkboxes = document.getElementsByName('bchids');
    for(let i=0, n=checkboxes.length;i<n;i++) {
      checkboxes[i].checked = source.checked;
    }
  }
  document.getElementById('objectType').onchange = function () {
    let e = document.getElementById('objectType').value
    if (e === "bchsrcps"){
      window.location.href="index.jsp";
    }else if( e === "trns"){
      window.location.href="trns.jsp";
    }
  };
</script>
</body>
</html>