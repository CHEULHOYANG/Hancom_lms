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

Dim keyary : keyary = split(key,",")

dim cnt
for ii = 0 to Ubound(keyary) - 1
	sql = "delete TempAry where idx=" & keyary(ii)
	db.execute(sql)
Next

sql = "select A.idx,B.strnm from TempAry A join LecturTab B on A.idx = B.idx"
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
<select name="projectLectures" id="projectLectures" size="15" multiple class="seltxt" style="width:100%;height:400px" ondblclick="removeItem(this.form);"><% if isRecod then
for ii = 0 to UBound(isRows) - 1
isCols = split(isRows(ii),chr(9)) %>
	<option value="<%=isCols(0)%>"><%=isCols(1)%></option><% Next
end if %>
</select>
		 ]]></iscols>
	</isrows>
</cate_root>
<% end if %>