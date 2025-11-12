<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,idx,requn,strnm,intgigan,intprice

idx = Request.Form("idx")
requn = Request.Form("requn")

idx = Tag2Txt(idx)
requn = Tag2Txt(requn)

strnm = Request.Form("strnm" & requn)
intgigan = Request.Form("intgigan" & requn)
intprice = Request.Form("intprice" & requn)

strnm = Tag2Txt(strnm)
intgigan = Tag2Txt(intgigan)
intprice = Tag2Txt(intprice)

sql = "update premTab set "
sql = sql & "strnm='" & strnm & "',"
sql = sql & "intgigan=" & intgigan & ","
sql = sql & "intprice=" & intprice
sql = sql & " where idx=" & idx
db.execute(sql)

db.close
set db = nothing

response.redirect "prium.asp"

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function %>
<!-- #include file = "../authpg_2.asp" -->