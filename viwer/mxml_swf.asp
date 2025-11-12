<?xml version="1.0" encoding="euc-kr"?><% Response.ContentType = "text/xml" %>
<!DOCTYPE RootXml[
	<!ELEMENT isrows (#PCDATA)>
]><% Dim key : key = Request.Form("key")
Dim strming

if key = "" then
	strming = "0"

else %><!-- #include file = "../include/dbcon.asp" --><%

	Dim sql,dr
	sql = "select flshlink from SectionTab where idx=" & key

	set dr = db.execute(sql)
	strming = dr(0)
	dr.close
	set dr = nothing
	db.close
	set db = nothing

end if %>
<RootXml>
	<isrows>
	<![CDATA[
 <embed src="<%=strming%>" WIDTH="100%" HEIGHT="100%"></embed>
]]>
	</isrows>
</RootXml>
