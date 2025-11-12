<!-- #include file = "../include/set_loginfo.asp" -->
<%
Dim isViewpg
Dim plidx,vtype
Dim secidx,gn
Dim freelink,movlink

vtype = Request("vtype")
plidx = Request("plidx")

if vtype = "dan" then %>
<!-- #include file = "../include/dbcon.asp" -->
<% sql = "select top 1 idx,freelink,movlink from sectionTab where l_idx=" & plidx & " and freegbn=1"
	set dr = db.execute(sql)
	
	if dr.eof or dr.bof then
		isViewpg = False
	else
		secidx = dr(0)
		freelink = dr(1)
		movlink = dr(2)
	end If
	
	dr.close
	set dr = nothing
	db.close
	set db = Nothing
	
else
	secidx = plidx
end if	

if secidx = "" then
	isViewpg = False
else
	isViewpg = True
	Session("mpermission") = now
 end if

if isViewpg then %>

<%If Len(movlink) > 0 then%>
<script language="javascript">
location.href="../yplayer/index_sample.asp?plidx=<%=secidx%>";
</script>
<%End if%>
<%If Len(freelink) > 0 then%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>미리보기</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link rel="stylesheet" href="../include/style.css" type="text/css">
<script src="../include/jquery-1.11.2.min.js"></script>
<script language="javascript" src="../include/xmlhttp.js"></script>
<script language="javascript">
window.resizeTo(950,600);
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false">
<%=freelink%>
</body>
</html>
<%End if%>
<%If Len(movlink) = 0 And Len(freelink) = 0 then%>
<script language="javascript">
 alert("미리보기가 없습니다.");
 window.close();
</script>
<%End if%>

<% else %>
<script language="javascript">
 alert("미리보기가 없습니다.");
 window.close();
</script><% end if %>