<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs,page,searchpart,searchstr
Dim idx,title,date1,date2,price

page = request("page")
searchpart = request("searchpart")
searchstr = request("searchstr")
idx = request("idx")

title = request("title")
date1 = request("date1")
date2 = request("date2")
price = 0

title = Tag2Txt(title)
date1 = Tag2Txt(date1)
date2 = Tag2Txt(date2)

sql = "update question_list set title = '"& title &"' , date1 = '"& date1 &"', date2 = '"& date2 &"', price = "& price &" where idx= "& idx
db.execute sql,,adexecutenorecords

Response.write "<script>"
Response.write "alert('수정되었습니다');"
Response.write "self.location.href='question_list.asp?page="& page &"&searchpart="& searchpart &"&searchstr="& searchstr &"';"
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