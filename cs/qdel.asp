<!-- #include file = "../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim idx
idx = Request("idx")
sql = "select quserid from oneone where qidx=" & idx
set dr = db.execute(sql)
Dim quserid
quserid = dr(0)
dr.close

if quserid = str_User_ID then

	sql = "delete oneone where qidx=" & idx
	db.execute(sql)
	response.redirect "qlist.asp"



else %>
<!-- #include file="../include/false_pg.asp" --><% end if
else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>
