<!-- #include file = "../include/set_loginfo.asp" -->
<%
''인증키 확인

Dim viewPerm

if Session("mpermission") = "" then

	viewPerm = False

else

	Dim thChk : thChk = DateDiff("s",Session("mpermission"),now)
	Session.Abandon

	if int(thChk) < 25 then
		viewPerm = True
	else
		viewPerm = False
	end if

end if
if viewPerm then

''*************************************************************************************************
if isUsr then%><!-- #include file = "../include/dbcon.asp" --><%
	Dim plidx
	plidx = Request("plidx")

	Dim lecturidx,strnm
	Dim flshlink,movlink,view_count,view_time,strtime
	sql = "select strnm,movlink1,view_count,view_time,strtime from SectionTab where idx=" & plidx
	set dr = db.execute(sql)

	strnm = dr(0)
	flshlink = dr(1)
	view_count = dr(2)
	view_time = dr(3)
	strtime = dr(4)
	dr.close

	dim se_check : se_check = session.sessionID	

	Dim check_time,check_time1
	
	check_time  = split(strtime,":")
	check_time1 = (int(check_time(0)) * 60) + int(check_time(1))

	If Int(view_count) > 0 then

		sql = "select count(idx) from view_mast where id='"& str_User_ID &"' and v_idx = "& plidx &" and v_time >= "& check_time1 &""
		Set dr = db.execute(sql)	

		If Int(dr(0)) > Int(view_count) Then
			
			response.write"<script>"
			response.write"alert('제한횟수 초과로 재생이 불가능합니다.');"
			response.write"self.close();"
			response.write"</script>"
			response.End
			
		dr.close
		End If
	
	End If
	
	If Int(view_time) > 0 Then

		sql = "select isnull(sum(v_time),0) from view_mast where id='"& str_User_ID &"' and v_idx = "& plidx &""
		Set dr = db.execute(sql)
		
		If Int(dr(0)) > 0 then

			If Int(dr(0)/60) > Int(view_time) Then
				
				response.write"<script>"
				response.write"alert('제한시간 초과로 재생이 불가능합니다.');"
				response.write"self.close();"
				response.write"</script>"
				response.End

			End if
			
		dr.close
		End If

	End if

	set dr = nothing
	db.close
	set db = nothing
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=strnm%></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta name="viewport" id="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=10.0,initial-scale=1.0" />
<link rel='stylesheet' id='styles-css'  href='../viwer/styles.css?ver=1.0' type='text/css' media='all' />
<script language="javascript" src="../jsrc/xmlhttp.js"></script>

<script>
resizeTo(850,675);

function time_save(){

	var params = "key=<%=plidx%>|<%=str_User_ID%>|<%=se_check%>|1";	
	sndReq("../xml/view_check.asp",params,function(){
		if(objXmlhttp.readyState == 4){
			if(objXmlhttp.status == 200){
				var xmltxt = objXmlhttp.responseText;
				//alert(xmltxt);
			}else{
				//alert("error");
			}
		}
	},"POST");
	self.setTimeout("time_save()",10000);
}
time_save();


//여기부터 키보드 마우스 막기시작
function nocontextmenu() 
{
   event.cancelBubble = true
   event.returnValue = false;

   return false;
}

function norightclick(e) 
{
   if (window.Event)   
   {
	  if (e.which == 2 || e.which == 3)
		 return false;
   }
   else
	  if (event.button == 2 || event.button == 3)
	  {
		 event.cancelBubble = true
		 event.returnValue = false;
		 return false;
	  }
   
}
function keypressed() {
	self.close();
}

function enterkey() {
                if(event.keyCode == 93) {
self.close();
                }
}

document.onkeydown=keypressed;
document.oncontextmenu = nocontextmenu;	 
document.onmousedown = norightclick;	 

	document.onkeydown = CheckKeyPress;
	document.onkeyup = CheckKeyPress;
	function CheckKeyPress()
	{
		//키입력
		ekey = event.keyCode;

		//리턴
		if(ekey == 38 || ekey == 40 || ekey == 112 ) { alert("사용불가능한키입니다."); return false; }
	}
	function click() {
    if ((event.button==2) || (event.button==3) || (event.keyCode == 93) || (event.keyCode == 17) ) {
      self.close();
    }
    else {
      if((event.ctrlKey) && (event.keyCode == 67)) {
        alert('내용을 무단복제하실 수 없습니다.');
      }
    }
  }
  document.onmousedown=click
  document.onkeydown=click


function noEvent() {
    if (event.keyCode == 116) {
        event.keyCode= 2;
        return false;
    }
    else if(event.ctrlKey && (event.keyCode==78 || event.keyCode == 82))
    {
        return false;
    }
}
document.onkeydown = noEvent;  

function click() {
if((event.button==2) || (event.button==3)) {
  alert("오른쪽 버튼은 사용하실 수 없습니다");
  return false;
}
}
function keypressed() {
var key=event.keyCode;
if(key==8) { self.close(); return false; }
if(key==16) { self.close(); return false; }
if(key==18) { self.close(); return false; }
if(key==9) { self.close(); return false; }
if(key==91) { self.close(); return false; }
if(key==17) { self.close(); return false; }
if(key==18) { self.close(); return false; }
if(key==93) { self.close(); return false; }
if(key==41) { self.close(); return false; }
if(key==116) { self.close(); return false; }
}


document.onmousedown=click;
document.onkeydown=keypressed;

document.onkeydown = function () {
     var backspace = 8;
     var t = document.activeElement;

     if (event.keyCode == backspace) {
     	
     	self.close();
         if (t.tagName == "SELECT")
             return false;

         if ((t.tagName == "INPUT" || t.tagName == "TEXTAREA") && $(t).attr("readonly") == "readonly"){
             return false;
     }
 }

}
document.onkeydown = function () {
     var backspace = 116;
     var t = document.activeElement;

     if (event.keyCode == backspace) {

     	 self.close();
         if (t.tagName == "SELECT")
             return false;

         if ((t.tagName == "INPUT" || t.tagName == "TEXTAREA") && $(t).attr("readonly") == "readonly"){
             return false;
     }
 }

}
//여기부터 키보드 마우스 막기끝
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<header class="slides">
	 <div class="slider">
		  <iframe webkitAllowFullScreen mozallowfullscreen allowFullScreen src="projekktor.asp?idx=<%=plidx%>" width="890" height="630" scrolling="no" style="border: none; background-color:#000;"></iframe>
	 </div>
	 <div class="shadow"></div>
</header>
</body>
</html><% else %>
<!-- #include file = "../include/false_pg.asp" --><% end if

''*******************************************************************************************
else %><!-- #include file = "../include/false_pg.asp" --><%
end if %>