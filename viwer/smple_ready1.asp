<!-- #include file = "../include/set_loginfo.asp" -->
<%
Dim isViewpg
Dim plidx,vtype
Dim freelink,movlink
Dim secidx,gn

plidx = Request("plidx")
%>
<!-- #include file = "../include/dbcon.asp" -->
<%
sql = "select top 1 idx,freelink,movlink from sectionTab where l_idx=" & plidx & " and freegbn=1"
set dr = db.execute(sql)

if dr.eof or dr.eof then%>
<script language="javascript">
 alert("미리보기가 없습니다.");
 window.close();
</script>
<%else
Session("mpermission") = now
%>

	<%If Len(dr(2)) > 0 then%>
	<script language="javascript">
	location.href="../yplayer/index_sample.asp?plidx=<%=dr(0)%>";
	</script>
	<%End if%>

	<%If Len(dr(1)) > 0 then%>
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
	<%=dr(1)%>
	</body>
	</html>
	<%End if%>

	<%If Len(dr(1)) = 0 And Len(dr(2)) = 0 then%>
	<script language="javascript">
	 alert("미리보기가 없습니다.");
	 window.close();
	</script>
	<%End if%>


<%end if%>