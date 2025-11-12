<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim tabnm,tabidx,neyong,strsearch,strpart,gbnS,intpg
tabnm = Request.Form("tabnm")
tabidx = Request.Form("tabidx")
neyong = Request.Form("neyong")

strsearch = Request.Form("strsearch")
strpart = Request.Form("strpart")
gbnS = Request.Form("gbnS")
intpg = Request.Form("intpg")

tabnm = Tag2Txt(tabnm)
tabidx = Tag2Txt(tabidx)
neyong = Tag2Txt(neyong)

sql = "insert into replyTab (tabnm,tabidx,usrid,neyong) values ("
sql = sql & tabnm & ","
sql = sql & tabidx & ",'"
sql = sql & str_User_ID & "','"
sql = sql & neyong & "'"
sql = sql & ")"
db.execute(sql)
db.close
set db = nothing

response.redirect "content.asp?tabnm=" & tabnm & "&idx=" & tabidx &"&intpg="& intpg &"&gbnS="& gbnS &"&strpart="& strpart &"&strsearch="& strsearch

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function
''******************************************
	else %>
<!-- #include file = "../include/false_pg.asp" -->
<% end if %>