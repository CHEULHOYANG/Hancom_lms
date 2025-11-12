<?xml version="1.0" encoding="euc-kr"?><%  Response.ContentType = "text/xml" %>
<!DOCTYPE Rootcooki[
	<!ELEMENT isrows  (#PCDATA)>
]><%
Dim key : key = Request("key")
Dim isPrg
Dim str_ReturnValue

if key = "" then
	isPrg = False
else
	Dim theTable : theTable = key & "_Counter"

	if Replace(Request.Cookies("strInfo")," ","") = "" then
		isPrg = False
	else

		Dim int_Cookies : int_Cookies = Request.Cookies("strInfo")
		if Cstr(int_Cookies) = "0" then
			isPrg = True
		else
			isPrg = False
		end if

	end if
end if

if isPrg then %>
<!-- #include file = "../../include/dbcon.asp" -->
<%
	Dim maxIDX,sql
	sql = "select isNull(Max(vNum),0) from " & theTable

	dim rs
	set rs = db.execute(sql)
	maxIDX = rs(0)
	rs.close
	set rs = nothing

	if int(MaxIDX) > 0 then
		sql = "delete " & theTable & " where vNum < " & maxIDX
		db.execute(sql)
	end if

	db.close
	set db = Nothing

	str_ReturnValue = maxIDX
else
	str_ReturnValue = 0
end if
%>
<Rootcooki>
	<isrows><%=str_ReturnValue%></isrows>
</Rootcooki>