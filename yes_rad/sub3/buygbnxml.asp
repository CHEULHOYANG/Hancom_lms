<?xml version="1.0" encoding="euc-kr"?><%  Response.ContentType = "text/xml" %>
<!DOCTYPE RootXml[
	<!ELEMENT isrows ANY>
	<!ATTLIST isrows
	idxnum CDATA #REQUIRED
	strvalue CDATA #REQUIRED>
]><% Dim key
key = Request.Form("key") %>
<RootXml><% if key = "" then %>
	<isrows idxnum="0" strvalue="선택" /><% else
	if int(key) < 1 then %>
	<isrows idxnum="0" strvalue="선택" /><% else %><!-- #include file = "../../include/dbcon.asp" -->
	<isrows idxnum="0" strvalue="선택" /><%dim sql,dr,isRows,isCols,ii
	sql = "select "

	select case int(key)
		case 1
			sql = sql & "idx,strnm from premTab order by idx"
		case 2
			sql = sql & "idx,bname from mscate order by ordnum"
		case 3
			sql = sql & "idx,bname from dancate order by ordnum"
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