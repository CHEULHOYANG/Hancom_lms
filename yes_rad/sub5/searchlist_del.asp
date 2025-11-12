<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim idx,sql,dr,filepath

idx = request("idx")

db.execute("delete SearchTab where idx=" & idx)

db.close
set db = Nothing

response.redirect "searchlist.asp"
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->