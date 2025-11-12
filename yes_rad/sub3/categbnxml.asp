<?xml version="1.0" encoding="euc-kr"?><%  Response.ContentType = "text/xml" %>
<!DOCTYPE RootXml[
	<!ELEMENT isrows ANY>
	<!ATTLIST isrows
	idxnum CDATA #REQUIRED
	strvalue CDATA #REQUIRED>
]><% Dim key,keygbn
key = Request.Form("key")
keygbn = Request.Form("keygbn")%>
<RootXml><% if key = ""  or keygbn = "" then %>
	<isrows idxnum="0" strvalue="선택" /><% else
	if int(key) < 1 then %>
	<isrows idxnum="0" strvalue="선택" /><% else %><!-- #include file = "../../include/dbcon.asp" -->
	<isrows idxnum="0" strvalue="선택" /><%dim sql,dr,isRows,isCols,ii

	select case int(keygbn)
		case 2
			sql = sql & "select idx,strnm from Lectmast where gbn=" & key & " order by ordn"
		case 3
			sql = sql & "select idx,strnm from LecturTab where categbn=" & key & " order by strnm"
	end select

	set dr = db.execute(sql)
	if Not dr.Bof or Not dr.Eof then
		isRows = split(dr.getstring(2),chr(13))
		for ii = 0 to UBound(isRows) - 1
		isCols = split(isRows(ii),chr(9)) %>
	<isrows idxnum="<%=isCols(0)%>" strvalue="<%=isCols(1)%>" /><% Next
	end if
		dr.close
		set dr = nothing
		db.close
		set db = nothing
	end if
end if %>
</RootXml>