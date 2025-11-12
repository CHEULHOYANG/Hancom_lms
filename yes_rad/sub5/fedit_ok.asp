<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim jemok,neyong,idx,intpg
jemok = Request.Form("jemok")
neyong = Request.Form("neyong")
jemok = Tag2Txt(jemok)
neyong = Replace(neyong,"'","''")

idx = request.Form("idx")
intpg = request.Form("intpg")

Dim gbnS,strSearch,varPage
gbnS = Request.Form("gbnS")
strSearch = Request.Form("strSearch")
varPage = "gbnS=" & gbnS & "&strSearch=" & strSearch

dim sql

sql = "update faqTab set jemok='" & jemok & "',neyong='" & neyong & "' where idx=" & idx
db.execute(sql)
db.close
set db = nothing

response.redirect "fneyong.asp?idx=" & idx & "&intpg=" & intpg & "&" & varPage
Response.end

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function
%>
<!-- #include file = "../authpg_2.asp" -->