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
Dim num,ndr

Dim keyary : keyary = split(key,",")
dim cnt
for ii = 0 to Ubound(keyary) - 1
	sql = "update TempAry set idx=idx where idx=" & keyary(ii)
	db.execute sql,cnt

	if int(cnt) < 1 then
		set ndr = db.execute("select isNull(Max(num),0) + 1 from TempAry")
		num = ndr(0)
		ndr.close

		sql = "insert into TempAry (idx,num) values (" & keyary(ii) & "," & num & ")"
		db.execute(sql)
	end if

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