<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim jemok,neyong,idx,intpg,notice,strPart,strSearch

strPart = Request.Form("strPart")
strSearch = Request.Form("strSearch")
jemok = Request.Form("jemok")
neyong = Request.Form("neyong")
notice = Request.Form("notice")
If Len(notice) = 0 Then notice = 0

jemok = Tag2Txt(jemok)
neyong = Replace(neyong,"'","''")

idx = request.Form("idx")
intpg = request.Form("intpg")

dim sql

sql = "update notice set notice=" & notice & ",jemok='" & jemok & "',neyong='" & neyong & "' where idx=" & idx
db.execute(sql)
db.close
set db = nothing

response.redirect "nneyong.asp?idx=" & idx & "&intpg=" & intpg &"&strPart="& strPart &"&strSearch="& strSearch &""
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