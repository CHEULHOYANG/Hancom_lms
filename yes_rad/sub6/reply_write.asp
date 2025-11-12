<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim tabnm,tabidx,neyong
tabnm = Request.Form("tabnm")
tabidx = Request.Form("tabidx")
neyong = Request.Form("neyong")

tabnm = Tag2Txt(tabnm)
tabidx = Tag2Txt(tabidx)
neyong = Tag2Txt(neyong)

Dim intpg,gbnS,strPart,strSearch

intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")

Dim sql
sql = "insert into replyTab (tabnm,tabidx,usrid,neyong) values ('"
sql = sql & tabnm & "',"
sql = sql & tabidx & ",'"
sql = sql & "°ü¸®ÀÚ','"
sql = sql & neyong & "'"
sql = sql & ")"
db.execute(sql)
db.close
set db = nothing

response.redirect "content.asp?intpg="& intpg &"&gbnS="& gbnS &"&strPart="& strPart &"&strSearch="& strSearch &"&tabnm=" & tabnm & "&idx=" & tabidx
Response.End

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function %>
<!-- #include file = "../authpg_2.asp" -->