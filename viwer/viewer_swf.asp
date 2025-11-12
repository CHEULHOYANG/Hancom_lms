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
	Dim flshlink,movlink
	sql = "select strnm,flshlink,l_idx from SectionTab where idx=" & plidx
	set dr = db.execute(sql)

	strnm = dr(0)
	flshlink = dr(1)
	lecturidx = dr(2)
	dr.close
	
	dim se_check : se_check = session.sessionID	

	set dr = nothing
	db.close
	set db = nothing
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=strnm%></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link rel="stylesheet" href="../include/style.css" type="text/css">
<script language="javascript" src="../include/xmlhttp.js"></script>

<script>
function time_save(){

	var params = "key=<%=plidx%>|<%=str_User_ID%>|<%=se_check%>|1|<%=lecturidx%>";	
	sndReq("../xml/view_check.asp",params,function(){
		if(objXmlhttp.readyState == 4){
			if(objXmlhttp.status == 200){
				var xmltxt = objXmlhttp.responseText;
				//alert(xmltxt);
				if (xmltxt=="종료")
				{
											//alert('수강완료되었습니다.');
											//window.opener.document.location.href=window.opener.document.URL;
				}
			}else{
				//alert("error");
			}
		}
	},"POST");
	self.setTimeout("time_save()",10000);
}
time_save();
</script>

<script language="javascript">
function loadingM(intUnm){
	thisTab.style.height = document.body.offsetHeight;
	params = "key=" + encodeURIComponent(intUnm);
	sndReq("mxml_swf.asp",params,setWritein,"POST");
}

function setWritein(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var obj = xmlDoc.getElementsByTagName("isrows").item(0);
			var strinHm = obj.firstChild.nodeValue;
			//alert(strinHm);
			document.getElementById("playArea").innerHTML = strinHm;
			//document.write(strinHm);
		}
	}
}
</script>
</head>
<body onload="loadingM('<%=plidx%>');" oncontextmenu="return false" onselectstart="return false" ondragstart="return false">
<table width="100%" cellpadding="0" cellspacing="0" border="0" ID="thisTab">
	<tr>
		<td width="980" height="560" ID="playArea"></td>
	</tr>
</table>
</body>
</html><% else %>
<!-- #include file = "../include/false_pg.asp" --><% end if

''*******************************************************************************************
else %><!-- #include file = "../include/false_pg.asp" --><%
end if %>