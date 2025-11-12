<?xml version="1.0" encoding="euc-kr"?><%  Response.ContentType = "text/xml" %>
<!DOCTYPE RootXml[
	<!ELEMENT isrows ANY>
	<!ATTLIST isrows
	flg CDATA #REQUIRED>
]><% Dim key,keygbn
key = Request.Form("key")
keygbn = Request.Form("keygbn") %>
<RootXml><% if key = "" or keygbn = "" then %>
	<isrows flg="0" /><% else %><!-- #include file = "../../include/dbcon.asp" --><% Dim sql,dr,cnt
	sql = "select count(idx) from banner where bangbn=" & key & " and areagbn='" & keygbn & "'"
	set dr = db.execute(sql)
	cnt = dr(0)
	dr.close
	set dr = nothing
	db.close
	set db = nothing

	if int(cnt) > 0 then
		remsg = 1
	else
		remsg = 2
	end if  %>
	<isrows flg="<%=remsg%>" /><% end if %>
</RootXml>