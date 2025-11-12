<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim tabnm,tabidx,idx,strsearch,strpart,gbnS,intpg

tabnm = Request("tabnm")
tabidx = Request("tabidx")
idx = Request("idx")

strsearch = Request.Form("strsearch")
strpart = Request.Form("strpart")
gbnS = Request.Form("gbnS")
intpg = Request.Form("intpg")

dim writeid
sql = "select Count(idx) from replyTab where idx=" & idx & " and usrid='" & str_User_ID & "'"
set dr = db.execute(sql)
writeid = dr(0)
dr.close

if int(writeid) > 0 then
	sql = "delete replyTab where idx=" & idx
	db.execute(sql)
else %><!-- #include file = "../include/false_pg.asp" --><% end if 

db.close
set db = nothing

response.redirect "content.asp?tabnm=" & tabnm & "&idx=" & tabidx &"&intpg="& intpg &"&gbnS="& gbnS &"&strpart="& strpart &"&strsearch="& strsearch

''******************************************
else %>
<!-- #include file = "../include/false_pg.asp" -->
<% end if %>