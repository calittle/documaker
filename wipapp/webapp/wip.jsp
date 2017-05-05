<!DOCTYPE html>
<html>
<head>       
        <!--meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
        <meta http-equiv='X-UA-Compatible' content='IE=edge'>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <meta name='description' content='copyright 2016,2017 Oracle Corporation'>
        <meta name='keywords' content='ODEE,Documaker,WIPedit,WIPapp'>
        <meta name='author' content='Andy Little andy.little@oracle.com'-->        
    <script>
        var navObj = new navClass(); 
        if (/IE[^\]]*/.test(getBrowserInfo())){
            navObj.browser = "ie";
        }
        else{
            navObj.browser = "other";                 
        }                
        
        function getBrowserInfo()
        {
         Browser = "na";
         if (/Firefox[\/\s](\d+\.\d+)/.test(navigator.userAgent)){ //test for Firefox/x.x or Firefox x.x (ignoring remaining digits);
          var ffversion=new Number(RegExp.$1) // capture x.x portion and store as a number
          Browser = "FF" + ffversion;
         } else if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)){ //test for MSIE x.x;
          var ieversion=new Number(RegExp.$1) // capture x.x portion and store as a number
          Browser = "IE" + ieversion;
         }else if (/Opera[\/\s](\d+\.\d+)/.test(navigator.userAgent)){ //test for Opera/x.x or Opera x.x (ignoring remaining decimal places);
          var oprversion=new Number(RegExp.$1) // capture x.x portion and store as a number
          Browser = "OP" + oprversion;
         }else Browser = "na";         
         return Browser;
        } 
        
        function initialize(event){                    
                    try{
                        var plugin = (navObj.browser == "other" ) ? document.getElementById("plugin"): document.getElementById("plugin");
                        if( plugin ){                       
                            navObj.plugin = plugin;                            
                            plugin.focus();
                                var height = "innerHeight" in window 
                                          ? window.innerHeight
                                          : document.documentElement.offsetHeight;                             
                            plugin.style.height = (height - 25) + 'px';
                                if(navObj.browser == "other" ){
    
                                    plugin.setAttribute('classid','clsid:F894A210-B1E8-44D2-A3DB-5C2E86C7408D');
                                    plugin.setAttribute('src','wipedit?uniqueid=<%=request.getParameter("uniqueid")%>');
                                    
                                    var pluginparm = document.createElement("param");
                                    pluginparm.setAttribute('name', 'src');
                                    pluginparm.setAttribute('value', 'wipedit?uniqueid=<%=request.getParameter("uniqueid")%>');
                                    plugin.appendChild(pluginparm);                                    
                                    
                                    pluginparm = document.createElement("param");
                                    pluginparm.setAttribute('name', 'dpr_wip_mode');
                                    pluginparm.setAttribute('value', 'ENTRY');
                                    plugin.appendChild(pluginparm);                                    
                                    
                                    pluginparm = document.createElement("param");
                                    pluginparm.setAttribute('name', 'cookie');                                    
                                    pluginparm.setAttribute('value','<% String cookieName = "username";
                                                  Cookie cookies [] = request.getCookies ();
                                                  if (cookies != null)
                                                  {
                                                    for (int i = 0; i < cookies.length; i++) {
                                                      out.write(cookies[i].getName() + "=" + cookies[i].getValue() +"; "); }
                                                  }
                                                  %>');                                            
                                    plugin.appendChild(pluginparm);      
                                    
                                    pluginparm = document.createElement("param");
                                    pluginparm.setAttribute('name', 'dpr_wip_mode');
                                    pluginparm.setAttribute('value', 'ENTRY');
                                    plugin.appendChild(pluginparm);  
                                    
                                    pluginparm = document.createElement("param");
                                    pluginparm.setAttribute('name', 'puturl');
                                    pluginparm.setAttribute('value', '<%=request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()%>');
                                    plugin.appendChild(pluginparm);  
                                    
                                    pluginparm = document.createElement("param");
                                    pluginparm.setAttribute('name', 'plugin_time_out');
                                    pluginparm.setAttribute('value', '180000');
                                    plugin.appendChild(pluginparm);  
                                    
                                    pluginparm = document.createElement("param");
                                    pluginparm.setAttribute('name', 'type');
                                    pluginparm.setAttribute('value', 'application/x-dpwfile');
                                    plugin.appendChild(pluginparm);  
                                    
                                    pluginparm = document.createElement("param");
                                    pluginparm.setAttribute('name', 'docsavescript');
                                    pluginparm.setAttribute('value', 'wipedit/savewip');
                                    plugin.appendChild(pluginparm); 
                                    
                                    pluginparm = document.createElement("param");
                                    pluginparm.setAttribute('name', 'getscript');
                                    pluginparm.setAttribute('value', 'wipedit/getresource');
                                    plugin.appendChild(pluginparm);                                    
                                 
                                }
                        }
                        window.onresize=function(e){                        
                            var plugin = (navObj.browser == "other" ) ? document.getElementById("plugin"): document.getElementById("plugin");                            
                            var height = "innerHeight" in window 
                                          ? window.innerHeight
                                          : document.documentElement.offsetHeight;                             
                            plugin.style.height = (height - 25) + 'px';
                        }
                    }
                    catch(e){
                        alert('Exception: ' + e);
                    }
        }
                    
                function navClass(){ 
                        function zoomOut(){
                                this.plugin.ZoomOut();
                        } 
                        function zoomIn(){
                    
                                this.plugin.ZoomIn();
                        } 
                
                        function zoomNormal(){
                                this.plugin.ZoomNormal();
                        } 
                
                        function nextForm(){
                                this.plugin.FormNext();
                        } 
                
                        function previousForm(){
                                this.plugin.FormPrevious();
                        }
                
                        function nextPage(){
                                this.plugin.PageNext();
                        } 
                
                        function previousPage(){
                                this.plugin.PagePrevious();
                        }
                
                        function hideNavBar(){
                                this.plugin.hideNavBar();
                        }
                
                        function showNavBar(){
                                this.plugin.showNavBar();
                        }
                
                        function toggleNavBar() {
                            this.plugin.toggleNavBar();
                        }
                        
                        function save(){
                                return this.plugin.cmdGetResponse(260);
                        }
                
                        function complete(){
                                return String(this.plugin.cmdGetResponse(262));
                        }
                        
                        function printProof(){
                                var rsp = this.plugin.cmdGetResponse(260);
                                return rsp;
                        }
                        this.zoomOut = zoomOut;
                        this.zoomIn = zoomIn;
                        this.zoomNormal = zoomNormal;
                        this.nextForm = nextForm; 
                        this.previousForm = previousForm;
                        this.nextPage = nextPage; 
                        this.previousPage = previousPage;
                        this.save = save;
                        
                        this.complete = complete;
                        this.printProof = printProof;
                        this.showNavBar = showNavBar;
                        this.hideNavBar = hideNavBar;
                        this.toggleNavBar = toggleNavBar;
                        
                        this.plugin = null;
                        this.browser = null;
                } 
                
                function closeBrowser() {
                    var pluginId;
                    var plugin;
                    var dirty = '1';
                    
                    if ((pluginId = parent.searchWIPPluginId()) != null)
                        if ((plugin = parent.document.getElementById(pluginId)) != null) {
                        try {
                            dirty = plugin.contentWindow.navObj.plugin.isdirty();    
                        } catch (err) {
                            dirty = '1';
                        }                
                        if (/^1$/.test(dirty))
                            plugin.contentWindow.navObj.save();        
                  } 
              }
    </script>
    </head>
  <body onload="initialize()">    
  <object id="plugin"></object>
  </body>
</html>