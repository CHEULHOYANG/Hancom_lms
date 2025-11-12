<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<% Dim sql,idx,rs,ordnum

idx = Request("idx")

Dim jemok,neyong,gbn
jemok = Request.Form("jemok")
neyong = Request.Form("neyong")
gbn = Request.Form("gbn")

jemok = ReplaceTag2Text(jemok)
neyong = PadSingleQuote(neyong)

Function PadSingleQuote(str)
	PadSingleQuote = replace(str, "'", "''")
End Function

sql = "select top 1 ordnum from guideTab where gbn = "& gbn &" order by ordnum desc"
set rs=db.execute(sql)

if rs.eof or rs.bof then
	ordnum = 0
else
	ordnum = rs(0) + 1
rs.close
end If

If Len(ordnum) = 0 Then ordnum = 0

if idx = "" then
	sql = "insert into guideTab (jemok,neyong,gbn,ordnum) values ('" & jemok & "','" & neyong & "',"& gbn &","& ordnum &")"
else
	sql = "update guideTab set jemok='" & jemok & "',neyong='" & neyong & "',gbn=" & gbn & " where idx=" & idx
end if

db.execute(sql)
db.close
Set db = Nothing

Response.Redirect "guide.asp"
Response.End

Function ReplaceTag2Text(str)
	str = replace(str, "'", "''")
	str = replace(str, "&", "&amp;")
	str = replace(str, "<", "&lt;")
	str = replace(str, ">", "&gt;")
	ReplaceTag2Text = str
End Function
%>
<!-- #include file = "../authpg_2.asp" -->