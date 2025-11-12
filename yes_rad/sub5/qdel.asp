<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim idx,sql
idx = Request("idx")
sql = "delete oneone where qidx=" & idx
db.execute(sql)

db.close
set db = Nothing

response.redirect "qlist.asp"
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->