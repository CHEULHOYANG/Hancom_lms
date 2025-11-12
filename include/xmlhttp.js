function getXMLHttpRequest(){
        if(window.ActiveXObject){
                try{
                        return new ActiveXObject("Msxml2.XMLHTTP");
                }catch(e){
                        try{
                                return new ActiveXObject("Microsoft.XMLHTTP");
                        }catch(e1){
                                return null;
                        }
                }
        }else if(window.XMLHttpRequest){
                return new XMLHttpRequest();
        }else{
                return null;
        }
}

var objXmlhttp = null;
function sndReq(url,params,callback,method){
	objXmlhttp = getXMLHttpRequest();
	
	var httpMethod = method ? method : 'GET';
	if(httpMethod != 'GET' && httpMethod != 'POST'){
		httpMethod = 'GET';
	}
	
	var httpParams = (params == null || params == '') ? null : params;
	var httpUrl = url;
	if(httpMethod == 'GET' && httpParams != null){
		httpUrl = httpUrl + "?" + httpParams;
	}
	
	objXmlhttp.open(httpMethod, httpUrl, true);
	objXmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	objXmlhttp.onreadystatechange = callback;
	objXmlhttp.send(httpMethod == 'POST' ? httpParams : null);
}