<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

Dim sql,rs
Dim title,gu,sid,s_type,m_level,bun

title = request.form("title")
gu = request.form("gu")
sid = request.form("sid")
s_type = request.form("s_type")
m_level = 0
bun = request.form("bun")

sql = "insert into cal_mast (title,gu,sid,s_type,m_level,bun)values"
sql = sql & "('" & title & "'"
sql = sql & "," & gu
sql = sql & ",'" & sid & "'"
sql = sql & "," & s_type
sql = sql & "," & m_level
sql = sql & "," & bun
sql = sql & ")"
db.execute sql,,adexecutenorecords

Response.write "<script>"
Response.write "alert('등록되었습니다');"
Response.write "self.location.href='list.asp';"
Response.write "</script>"
Response.end
%> 
<!-- #include file = "../authpg_2.asp" -->