<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs
Dim idx,title,date1,date2,price

title = request("title")
date1 = request("date1")
date2 = request("date2")
price = 0

title = Tag2Txt(title)
date1 = Tag2Txt(date1)
date2 = Tag2Txt(date2)

sql = "insert into question_list (title,date1,date2,price)values"
sql = sql & "('" & title & "'"
sql = sql & ",'" & date1 & "'"
sql = sql & ",'" & date2 & "'"
sql = sql & "," & price
sql = sql & ")"
db.execute sql,,adexecutenorecords

Response.write "<script>"
Response.write "alert('등록되었습니다');"
Response.write "self.location.href='question_list.asp';"
Response.write "</script>"
response.end

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function
%> 
<!-- #include file = "../authpg_2.asp" -->