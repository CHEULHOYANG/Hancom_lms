<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim jemok,neyong
jemok = Request.Form("jemok")
neyong = Request.Form("neyong")
jemok = Tag2Txt(jemok)
neyong = Replace(neyong,"'","''")

dim sql

sql = "insert  into faqTab (jemok,neyong) values ('" & jemok & "','" & neyong & "')"
db.execute(sql)
db.close
set db = nothing

response.redirect "flist.asp"
Response.End


Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function
%>
<!-- #include file = "../authpg_2.asp" -->