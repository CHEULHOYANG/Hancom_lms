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
if isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<% dim plidx

plidx = request("plidx")

Dim flshlink,movlink,strnm
dim filnm,exg

sql = "select top 1 strnm,movlink2 from SectionTab where idx=" & plidx
set dr = db.execute(sql)
strnm = dr(0)
filnm = dr(1)
dr.close
set dr = nothing
db.close
set db = Nothing

If right(filnm,3) = "mp4" Then
	exg = "mp4"
End If
If right(filnm,3) = "wmv" Then
	exg = "wmv"
End If
If right(filnm,3) = "swf" Then
	exg = "swf"
End if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=strnm%></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta name="viewport" id="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=10.0,initial-scale=1.0" />
<link rel='stylesheet' id='styles-css'  href='../viwer/styles.css?ver=1.0' type='text/css' media='all' />


<script language="javascript">
<!--
Test = function () {
	// 시간 변환
	this.ParseTime = function (time) {
		var d;
		var h;
		var m;
		var s;

		if (time < 0) {
			s = 0;
			m = 0;
			h = 0;
		} else if (time >= 3600) {
			s = time % 60;
			m = parseInt(time / 60) % 60;
			h = parseInt(parseInt(time / 60) / 60);
		} else if (time >= 60) {
			s = time % 60;
			m = parseInt(time / 60);
			h = 0;
		} else {
			s = time;
			m = 0;
			h = 0;
		}

		if (h >= 24) {
			d = parseInt(h / 24);
			h = h % 24;
		} else {
			d = 0;
		}

		d = (d < 10) ? "0" + d : d;
		h = (h < 10) ? "0" + h : h;
		m = (m < 10) ? "0" + m : m;
		s = (s < 10) ? "0" + s : s;

		return (d == "00" ? "" : d + "일 ") + (h == "00" ? "" : h + ":") + m + ":" + s;
	}
}
var Test = new Test();


function click() {
	if ((event.button==2) || (event.button==3) || (event.keyCode == 93)) {

		return false;
	}
	else {
		if((event.ctrlKey) && (event.keyCode == 67)) {
			return false;
		}
	}
}

cho = 420;
function openMsg(){

}
function  closeView(){
	self.close();
}
//-->
</script>
</head>
<body onload="openMsg();" oncontextmenu="return false" onselectstart="return false" ondragstart="return false">
<%If exg = "mp4" then%>
<header class="slides">
	 <div class="slider">
		  <iframe webkitAllowFullScreen mozallowfullscreen allowFullScreen src="sample_projekktor.asp?idx=<%=plidx%>" width="656" height="460" scrolling="no" style="border: none; background-color:#000;"></iframe>
	 </div>
	 <div class="shadow"></div>
</header>
<%else%>
<table width="656" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="10" bgcolor="#000000">&nbsp;</td>
    <td height="30" colspan="2" bgcolor="#000000"><strong><font color=ffffff><%=strnm%> 샘플동영상</font></strong></td>
  </tr>
  <tr>
    <td bgcolor="#000000">&nbsp;</td>
    <td bgcolor="#000000"><% if exg = "swf" then %>
		<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" WIDTH="100%" HEIGHT="100%">
		<param name="movie" value="<%=filnm%>">
		<param name="quality" value="high">
		<param name="wmode" value="transparent">
		</object>
		<% End If
		
		If exg = "wmv" then
		%>
		<object codebase="http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701 type=application/x-oleobject" width="640" height="415" standby="Microsoft Windows Media Player 구성 요소를 읽어들이는 중..." classid="CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95">
		<param name="Filename" value="<%=filnm%>">
		<param name="ShowTracker" value="0">
		<param name="ShowPositionControls" value="0">
		<param name="EnableContextMenu" value="0">
	</object><% end if %></td>
    <td bgcolor="#000000">&nbsp;</td>
  </tr>
  <tr>
    <td bgcolor="#000000">&nbsp;</td>
    <td width="640" bgcolor="#000000">&nbsp;</td>
    <td width="6" bgcolor="#000000">&nbsp;</td>
  </tr>
</table>

<%End if%>
</body>
</html><% else %>
<!-- #include file = "../include/false_pg.asp" --><% end if

''*******************************************************************************************
else %><!-- #include file = "../include/false_pg.asp" --><%
end if %>