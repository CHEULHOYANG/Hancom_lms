<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,idx,title,gu

idx = request.form("idx")
title = request("title")
title = ReplaceTag2Text(title)
gu = request("gu")

sql = "update group_mast set title = '"& title &"' where idx= '"& idx &"'"
db.execute sql,,adexecutenorecords
	
response.write"<script language='javascript'>"
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