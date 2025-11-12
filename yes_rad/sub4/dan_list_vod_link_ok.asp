<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs
Dim link1,link2

link1 = request("link1")
link2 = request("link2")

sql = "update sectionTab set movlink = Replace(movlink,'"& link1 &"','"& link2 &"'),movlink1 = Replace(movlink1,'"& link1 &"','"& link2 &"'),video1 = Replace(video1,'"& link1 &"','"& link2 &"'),video2 = Replace(video2,'"& link1 &"','"& link2 &"'),video3 = Replace(video3,'"& link1 &"','"& link2 &"'),video4 = Replace(video4,'"& link1 &"','"& link2 &"'),video5 = Replace(video5,'"& link1 &"','"& link2 &"'),freelink = Replace(freelink,'"& link1 &"','"& link2 &"'),freelink1 = Replace(freelink1,'"& link1 &"','"& link2 &"') "
db.execute(sql)

db.close
set db = nothing

Response.write "<script>"
Response.write "alert('"& link1 &" -> "& link2 &" 변경되었습니다.');"
Response.write "self.location.href='dan_list.asp';"
Response.write "</script>"
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->