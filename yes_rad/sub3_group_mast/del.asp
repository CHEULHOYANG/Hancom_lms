<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs,idx,gu

idx = request("idx")
gu = request("gu")

sql = " delete from group_mast where idx = " & idx
db.execute sql,,adexecutenorecords

If gu = 0 then
	sql = " update member set sp1 = 0 where sp1 = '" & idx &"'"
	db.execute sql,,adexecutenorecords
End If

If gu = 1 then
	sql = " update member set sp2 = 0 where sp2 = '" & idx &"'"
	db.execute sql,,adexecutenorecords
End if

response.write"<script language='javascript'>"
response.write"self.location.href='list.asp?gu="& gu &"';"
response.write"</script>"
response.end
%>
<!-- #include file = "../authpg_2.asp" -->