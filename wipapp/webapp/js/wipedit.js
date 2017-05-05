var log = [];
var logi = 0;
function logit(s){
  log[logi] = s;
  logi++;
}
function showlog(){
  var s = '';
  for (i=0;i<logi;i++){
	  s = s + log[i] + '<br/>';
  }
  window.open().document.write(s);
}
function updateBar(s){
  var today = new Date();
  $("#statusbar").text(today + " - " + s);
  logit(today + " - " + s);
  //window.setTimeout(function () {$("#statusbar").text('Copyright (C) 2016-2017 Oracle Corporation.');}, 1000);
}
function checkRequired(){
  updateBar('Checking required fields...');                      
  var plugin = document.getElementById('plugin');
  var rs = false;
  if(plugin!=null){
      rs = plugin.checkRequiredField();
  }
  updateBar('Required field check done ('+rs+')');
  return rs;
}
function saveDocument(){
  updateBar('Saving...');
  var rs='not saved';
  var plugin = document.getElementById('plugin');  
  if(plugin!=null){
    var tries = 1;
    do {
      logit(new Date + ' - trying plugin.cmdGetResponse(260) - ' + tries);
      rs = plugin.cmdGetResponse(260);
      logit(new Date + ' - returned (' + rs + ')');
      tries++;
    }while (rs != 'success' && tries < 10)
  }
  updateBar('Document save result:'+rs);                      
  if (rs=='success')
    return true;
  else
    return false;
}
function pageFormNav(i){
  var plugin = document.getElementById('plugin');  
  if(plugin!=null){
    switch(i){
        case -2:
          plugin.FormPrevious();
          break;
        case -1:
          plugin.PagePrevious();
          break;
        case 1:
          plugin.PageNext();
          break;
        case 2:
          plugin.FormNext();
          break;
      }
  }
}
function navBar(i){
  var plugin = document.getElementById('plugin');  
  if(plugin!=null){
    switch(i){
      case -1:
        plugin.hideNavBar();
        break;
      case 1:
        plugin.showNavBar(); 
        break;
      case 0:
        plugin.toggleNavBar();
        break;      
    }
  }    
}
function zoom(i){
    var plugin = document.getElementById('plugin');
    if(plugin!=null){
      switch(i){
        case -1:
          plugin.zoomOut();
          break;
        case 0:
          plugin.zoomNormal();
          break;
        case 1:
          plugin.zoomIn();
          break;
        default:
          plugin.zoomNormal();        
      }
    } 
}
function positionContainer(){
  var height = "innerHeight" in window 
    ? window.innerHeight
    : document.documentElement.offsetHeight;                             
  plugin.style.height = (height - 145) + 'px';
}
$(window).resize(positionContainer());    
$(document).ready(function () {              
    logit(new Date() + ' - WIPapp loaded; plugin may still be loading.');
    positionContainer();             
    if (isUserDocPrep) { 
      $("#saveButton").prop('disabled',false);
      logit(new Date() + ' - save button enabled (user is DocPrep)');
    }                        
      $("#saveButton").click(function () {                
            $("#saveButton").prop('disabled',true);
            $("#submitButton").prop('disabled', true)                  
            
            saveDocument();            
            
            $("#saveButton").prop('disabled',false);              
            $("#submitButton").prop('disabled', false)
            
      });
      $("#zoomNormal").click(function(){
        zoom(0);
      }); 
      $("#zoomOut").click(function(){
        zoom(-1);
      }); 
      $("#zoomIn").click(function(){
        zoom(1);
      });
      $("#formprev").click(function(){
        pageFormNav(-2);
      });
      $("#formnext").click(function(){
        pageFormNav(2);
      });
      $("#pageprev").click(function(){
        pageFormNav(-1);
      });
      $("#pagenext").click(function(){
        pageFormNav(1);
      });
      $("#navon").click(function(){
        navBar(1);
      });
      $("#navoff").click(function(){
        navBar(-1);
      });
      $("#navtoggle").click(function(){
        navBar(0);
      });
      $("#helpButton").click(function (){                            
            window.open('doc/index.html');
      }); 
      $("#proof").click(function (){                            
          if (saveDocument()){          
            updateBar('Generating PDF...');
            window.open('printwip?uniqueid='+uniqueid);
            updateBar('PDF generated and opened.');
          }
      });       
      $("#checkRequired").click(function (){
          if(checkRequired()=='true'){            
            alert('All required fields are completed. Nice job!');
          }
      }); 
      $("#submitButton").click(function (){
            if(checkRequired()=='true'){            
              if (saveDocument()){
                updateBar('Submitting...');                                      
                window.location.replace('submitwip?uniqueid='+uniqueid+'&taskid=' + taskid);
              }
            }  
      });       
      $("#closeButton").click(function () { 
        var plugin = document.getElementById('plugin');
        if (plugin != null){
          var dirty = '1';
          try {
            dirty = plugin.isdirty();                    
          }catch (err){
            dirty = '1';
          }
          if (/^1$/.test(dirty)){
            if(confirm('You may have unsaved data. Do you wish to close?')){
              window.close();
            }
          }
        }
      });
      if (pluginDetect()==false){
        $("#saveButton").prop('disabled',true);
        $("#submitButton").prop('disabled', true)
      }
  });
function browserDetect(){return(navigator.userAgent.indexOf("Opera")||navigator.userAgent.indexOf("OPR"))!=-1?"Opera":navigator.userAgent.indexOf("Chrome")!=-1?"Chrome":navigator.userAgent.indexOf("Safari")!=-1?"Safari":navigator.userAgent.indexOf("Firefox")!=-1?"Firefox":navigator.userAgent.indexOf("MSIE")!=-1||1==!!document.documentMode?"IE":"unknown"}function pluginDetect(){var a=browserDetect(),b=false;if("Firefox"==a)for(var c=0;navigator.plugins[c];++c)"DocuMaker plugin"==navigator.plugins[c].name&&(b=true);else if("IE"==a)try{new ActiveXObject("WIPED01.WipEd01Ctrl.1"),b=true}catch(a){b=false;}return(b);}
if(pluginDetect()==false){updateBar('No plugin installed! - Copyright (C) 2016-2017 Oracle Corporation.');alert("The Documaker plugin does not appear to be installed!");}
