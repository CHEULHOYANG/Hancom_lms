<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs,idx
dim sid,gu,title,content,date1,date2,cid,i

sid = request("sid")
idx = request("idx")
gu = request("gu")
title = request("title")
content = request("content")
date1 = request("sdate")
date2 = request("edate")
cid = request("cid")


for i = 0 to DateDiff("d", date1,date2)


	sql = "select idx from cal_content where cid = '"& cid &"' and date1 = '"& DateAdd("d", i, date1) &"' and date2 = '"& DateAdd("d", i, date1) &"' order by idx desc"
	set rs=db.execute(sql)
	
	if rs.eof or rs.bof then	

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
	
	else

		sql = "update cal_content set gu = '"& gu & "'"
		sql = sql & ",title = '"& title & "'"
		sql = sql & ",content = '"& content & "'"
		sql = sql & ",date1 = '"& DateAdd("d", i, date1) & "'"
		sql = sql & ",date2 = '"& DateAdd("d", i, date1) & "'"
		sql = sql & ",cid = '"& cid & "'"
		sql = sql & " where idx= '"& idx &"'"
		db.execute sql,,adexecutenorecords

		
	end if
	
	
next

response.write"<script language='javascript'>"
response.write"alert('수정되었습니다.');"
response.write"opener.location.reload();"
response.write"self.close();"
response.write"</script>"
response.end	
%>
<!-- #include file = "../authpg_2.asp" -->