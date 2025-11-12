<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,id,price,page,UpdateSQL,idx,searchstr,gu

idx = request("idx")
gu = request("gu")

sql = " delete from ip_mast where idx = " & idx
db.execute sql,,adexecutenorecords

	Response.Redirect "ip_list.asp?gu="& gu
%>
<!-- #include file = "../authpg_2.asp" -->