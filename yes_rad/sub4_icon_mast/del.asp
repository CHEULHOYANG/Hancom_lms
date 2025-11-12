<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs,idx,file

idx=request("idx")

sql = " delete from icon_mast where idx = " & idx
db.execute sql,,adexecutenorecords

response.redirect"list.asp"

%>
<!-- #include file = "../authpg_2.asp" -->