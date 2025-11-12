<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs
Dim sns_id1,sns_id2,sns_id3,sns_id4,sns_id5,sns_link1,sns_link2,sns_link3,sns_link4,sns_link5

sns_id1 = Request.Form("sns_id1")
sns_id2 = Request.Form("sns_id2")
sns_id3 = Request.Form("sns_id3")
sns_id4 = Request.Form("sns_id4")
sns_id5 = Request.Form("sns_id5")

sns_link1 = Request.Form("sns_link1")
sns_link2 = Request.Form("sns_link2")
sns_link3 = Request.Form("sns_link3")
sns_link4 = Request.Form("sns_link4")
sns_link5 = Request.Form("sns_link5")

sns_id1 = tag2Txt(sns_id1)
sns_id2 = tag2Txt(sns_id2)
sns_id3 = tag2Txt(sns_id3)
sns_id4 = tag2Txt(sns_id4)
sns_id5 = tag2Txt(sns_id5)

sns_link1 = tag2Txt(sns_link1)
sns_link2 = tag2Txt(sns_link2)
sns_link3 = tag2Txt(sns_link3)
sns_link4 = tag2Txt(sns_link4)
sns_link5 = tag2Txt(sns_link5)

sql = "select count(*) from site_info"
set rs=db.execute(sql)

if rs(0) = 0 then

	sql = "insert into site_info (sns_id1,sns_id2,sns_id3,sns_id4,sns_id5,sns_link1,sns_link2,sns_link3,sns_link4,sns_link5)values"
	sql = sql & "('" & sns_id1 & "'"
	sql = sql & ",'" & sns_id2 & "'"
	sql = sql & ",'" & sns_id3 & "'"
	sql = sql & ",'" & sns_id4 & "'"
	sql = sql & ",'" & sns_id5 & "'"
	sql = sql & ",'" & sns_link1 & "'"
	sql = sql & ",'" & sns_link2 & "'"
	sql = sql & ",'" & sns_link3 & "'"
	sql = sql & ",'" & sns_link4 & "'"
	sql = sql & ",'" & sns_link5 & "'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

	
Else

	sql = "update site_info set sns_id1 = '"& sns_id1 & "',sns_id2 = '"& sns_id2 & "',sns_id3 = '"& sns_id3 & "',sns_id4 = '"& sns_id4 & "',sns_id5 = '"& sns_id5 & "',sns_link1 = '"& sns_link1 & "',sns_link2 = '"& sns_link2 & "',sns_link3 = '"& sns_link3 & "',sns_link4 = '"& sns_link4 & "',sns_link5 = '"& sns_link5 & "' "
	db.execute sql,,adexecutenorecords

End if

Response.write"<script>"
Response.write"alert('적용되었습니다.');"
Response.write"self.location.href='sns_link.asp';"
Response.write"</script>"
Response.end

Function tag2Txt(str)
	str = Replace(str,"'","''")
	str = Replace(str,"<","&lt;")
	str = Replace(str,">","&gt;")
	tag2Txt = str
End Function

%>
<!-- #include file = "../authpg_2.asp" -->