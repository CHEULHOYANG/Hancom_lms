<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,idx,page,vidx

idx = Request("idx")
page = Request("page")
vidx = Request("vidx")

sql = "delete lec_reply where idx=" & idx
db.execute(sql)

db.close
set db = nothing

response.redirect "reply_list.asp?page="& page &"&vidx="& vidx
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->