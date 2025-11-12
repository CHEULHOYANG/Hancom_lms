<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs
dim sid,gu,title,content,date1,date2,cid,i

sid = request("sid")
gu = request("gu")
title = request("title")
content = request("content")
date1 = request("sdate")
date2 = request("edate")
cid = request("cid")

for i = 0 to DateDiff("d", date1,date2)

	sql = "insert into cal_content (sid,gu,title,content,date1,date2,cid)values"
	sql = sql & "('" & sid & "'"
	sql = sql & ","& gu
	sql = sql & ",'" & title & "'"	
	sql = sql & ",'" & content & "'"	
	sql = sql & ",'" & DateAdd("d", i, date1) & "'"	
	sql = sql & ",'" & DateAdd("d", i, date1) & "'"	
	sql = sql & ",'" & cid & "'"	
	sql = sql & ")"
	db.execute sql,,adexecutenorecords
	
next

response.write"<script language='javascript'>"
response.write"alert('등록되었습니다.');"
response.write"opener.location.reload();"
response.write"self.close();"
response.write"</script>"
response.end	
%>
<!-- #include file = "../authpg_2.asp" -->