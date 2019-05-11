var documakerWindow, documakerFrame;

function openDocumaker(sUrl,sAlert){
        if (documakerWindow == null | documakerFrame == null){
	        documakerWindow = window.open("","Documaker","resizable=yes,toolbar=no,status=yes");
			documakerWindow.document.open();
			documakerWindow.document.write("<script>function autoResize(){var f=document.getElementById('diframe');var nw,nh;if(f){nh=f.contentWindow.document.body.scrollHeight;nw=f.contentWindow.document.body.scrollWidth;}f.height=(nh)+'px';f.width=(nw)+'px'; }<\/script><iframe src='"+sUrl+"' width=100% height=100% id=diframe marginheight=0 frameborder=0 onLoad='autoResize();document.getElementById('diframe').parent.addEventListener('resize',autoResize);'><\/iframe>");
			documakerWindow.document.close();
			documakerFrame = documakerWindow.document.getElementById('diframe');
        } else {
	        documakerFrame.src = sUrl;
       }
       documakerWindow.focus();
       documakerWindow.onbeforeunload = function(){
		   if (sAlert){alert("You should only close this window if you are logging out of the system entirely. If you wish to edit another document, you will need to close all IE browser windows and start again.");}
		   documakerWindow.close();
	       documakerWindow = null;
	   };
}

function browserDetect() { 
    if((navigator.userAgent.indexOf("Opera") || navigator.userAgent.indexOf('OPR')) != -1 ) 
    {
        return('Opera');
    }
    else if(navigator.userAgent.indexOf("Chrome") != -1 )
    {
        return('Chrome');
    }
    else if(navigator.userAgent.indexOf("Safari") != -1)
    {
        return('Safari');
    }
    else if(navigator.userAgent.indexOf("Firefox") != -1 ) 
    {
         return('Firefox');
    }
    else if((navigator.userAgent.indexOf("MSIE") != -1 ) || (!!document.documentMode == true )) //IF IE > 10
    {
       return('IE'); 
    }  
    else 
    {
       return('unknown');
    }
}
function pluginDetect(){
	var t = browserDetect();
	var p = false;
	if (t=='Firefox')
	{
		for( var i = 0; navigator.plugins[ i ]; ++i ) {
	        	 if( navigator.plugins[ i ].name == 'DocuMaker plugin')
	            		p = true;
	         }	
	}
	else if (t=='IE'){
		try {
			new ActiveXObject("WIPED01.WipEd01Ctrl.1");
			p = true;
		}
		catch(e){p = false;}	
	}
	else{
		document.write("You may be using an unsupported browser ("+t+ "). ");
	}
	if (p){
	document.write("Documaker WIPedit Plugin detected.");
	}else{
	document.write("Plugin not detected.");
	}
}