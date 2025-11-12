<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,id,price,page,UpdateSQL,idx,searchstr

idx=request("idx")

sql = " delete from bank where idx = " & idx
db.execute sql,,adexecutenorecords

	Response.Redirect "bank_list.asp"
%>
<!-- #include file = "../authpg_2.asp" -->