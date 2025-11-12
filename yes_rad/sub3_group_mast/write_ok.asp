<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim title,sql,gu

title = request("title")
gu = request("gu")
title = ReplaceTag2Text(title)

	sql = "insert into group_mast (title,gu)values"
	sql = sql & "('" & title & "'"
	sql = sql & "," & gu
	sql = sql & ")"
	db.execute sql,,adexecutenorecords
	
response.write"<script language='javascript'>"
response.write"alert('그룹이 생성되었습니다.');"
response.write"self.location.href='list.asp?gu="& gu &"';"
response.write"</script>"
response.End

Function ReplaceTag2Text(str)
	str = replace(str, "'", "''")
	str = replace(str, "&", "&amp;")
	str = replace(str, "<", "&lt;")
	str = replace(str, ">", "&gt;")
	ReplaceTag2Text = str
End Function
%>
<!-- #include file = "../authpg_2.asp" -->