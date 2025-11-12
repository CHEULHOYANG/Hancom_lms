<?xml version="1.0" encoding="euc-kr"?><%  Response.ContentType = "text/xml" %>
<!DOCTYPE cate_root[
	<!ELEMENT isrows (iscols+)>
		<!ELEMENT iscols (#PCDATA)>
]><% Dim key
key = Request.Form("key")
if key = "" then %>
<cate_root>
	<isrows>
		<iscols>nothing</iscols>
	</isrows>
</cate_root><% else %><!-- #include file="../../include/dbcon.asp" --><%
Dim sql,dr,isRecod,isRows,isCols

if int(key) > 0 then
	sql = "select idx,strnm from LecturTab where ca1=" & key & " order by strnm"
else
	sql = "select idx,strnm from LecturTab where order by strnm"
end if
set dr = db.execute(sql)
if not dr.Bof or Not dr.Eof then
	isRecod = True
	isRows = split(dr.GetString(2),chr(13))
end if
dr.close
set dr = Nothing
db.close
set db = nothing %>
<cate_root>
	<isrows>
		<iscols><![CDATA[
<select name="lectureList" id="lectureList" size="15" multiple class="seltxt" style="width:100%;height:400px" ondblclick="addItem(this.form);"><% if isRecod then
for ii = 0 to UBound(isRows) - 1
isCols = split(isRows(ii),chr(9)) %>
	<option value="<%=isCols(0)%>">AA<%=isCols(1)%></option><% Next
end if %>
</select>
		 ]]></iscols>
	</isrows>
</cate_root>
<% end if %>