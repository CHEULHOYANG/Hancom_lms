<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,idx,requn,strnm,intgigan,intprice

idx = Request("idx")

db.execute("delete premTab where idx=" & idx)

response.redirect "prium.asp"
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->