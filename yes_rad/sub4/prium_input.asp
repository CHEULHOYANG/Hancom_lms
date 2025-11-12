<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,idx,requn,strnm,intgigan,intprice,rs

strnm = Request.Form("strnm" & requn)
intgigan = Request.Form("intgigan" & requn)
intprice = Request.Form("intprice" & requn)

strnm = Tag2Txt(strnm)
intgigan = Tag2Txt(intgigan)
intprice = Tag2Txt(intprice)

sql = "select idx from premTab order by idx desc"
set rs=db.execute(sql)

if rs.eof or rs.bof then
idx = 1
else
idx = rs(0) + 1
rs.close
end if

	sql = "insert into premTab (idx,strnm,intgigan,intprice)values"
	sql = sql & "('" & idx & "'"
	sql = sql & ",'" & strnm & "'"
	sql = sql & ","& intgigan
	sql = sql & ","& intprice
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

response.redirect "prium.asp"

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function %>
<!-- #include file = "../authpg_2.asp" -->