<!-- #include file = "../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim repage,dntGbn,idx,intpg,lidx,categbn,star,content,vcat,vidx
Dim rs

intpg = request("intpg")
dntGbn = request("dntGbn")
categbn = request("categbn")
repage = request.form("repage")
idx = request.form("idx")
lidx = request.form("lidx")
star = request.form("star")
vcat = 0

If Len(lidx) > 0 then
	vidx = lidx
Else
	vidx = idx
End If

content = request.form("content")
content = Tag2Txt(content)

sql = "select count(idx) from lec_reply where vidx = "& vidx &" and id = '"& str_User_ID &"'"
Set rs=db.execute(sql)

If rs(0) > 0 then

	response.write"<script>"
	response.write"alert('이미 수강후기를 작성하셨습니다.');"
	response.write"self.location.href='"& repage &".asp?idx="& idx &"&lidx="& lidx &"';"
	response.write"</script>"
	response.End

rs.close
End if

	sql = "insert into lec_reply (id,name,vidx,vcat,content,star)values"
	sql = sql & "('" & str_User_ID & "'"
	sql = sql & ",'" & str_User_Nm & "'"
	sql = sql & "," & vidx
	sql = sql & "," & vcat
	sql = sql & ",'" & content & "'"
	sql = sql & "," & star
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

	response.write"<script>"
	response.write"alert('수강후기가 작성되었습니다.');"
	response.write"self.location.href='"& repage &".asp?idx="& idx &"&lidx="& lidx &"&dntGbn="& dntGbn&"&categbn="& categbn&"&intpg="& intpg &"';"
	response.write"</script>"
	response.End

db.close
set db = Nothing

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function

ELSE %>
<!-- #include file = "../include/false_pg.asp" -->
<% End IF %>