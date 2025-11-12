<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<% Dim sql,idx

idx = Request("idx")
sql = "delete guideTab where idx=" & idx
db.execute(sql)
db.close
Set db = Nothing

Response.Redirect "guide.asp"
%>
<!-- #include file = "../authpg_2.asp" -->