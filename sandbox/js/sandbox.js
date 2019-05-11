var html_editor = document.querySelector('#html textarea'),
    css_editor = document.querySelector('#css textarea'),
    js_editor = document.querySelector('#js textarea'),
	renderButton = document.querySelector('#renderbutton');
function prepareSource(){	
	var base_tpl = "<!doctype html><html><head><meta charset=\"utf-8\"><title>Test</title></head><body></body></html>";
 	var html = html_editor.value,
       	css = css_editor.value,
	    js = js_editor.value,
	
	src = '';
	src = base_tpl.replace('</body>', html + '</body>');
	css = '<style>' + css + '</style>';
	src = src.replace('</head>', css + '</head>');
	js = '<script>' + js + '</script>';
	src = src.replace('</body>', js + '</body>');                             
	return src;
}

function render(){
	var source = prepareSource();
    var iframe = document.querySelector('#output iframe');
	var iframe_doc = iframe.contentDocument;
	
    iframe_doc.open();
    iframe_doc.write(source);
    iframe_doc.close();
}

function toggleRenderListener(){
	if (document.querySelector('#autorender').checked){
			html_editor.addEventListener('keyup',render,false);
			css_editor.addEventListener('keyup',render,false);
			js_editor.addEventListener('keyup',render,false)
			renderButton.enabled = false;
		 }else{
			html_editor.removeEventListener('keyup',render,false);
			css_editor.removeEventListener('keyup',render,false);
			js_editor.removeEventListener('keyup',render,false)
			renderButton.enabled = true;
		 }
	
}