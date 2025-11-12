<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

Dim sql,rs
Dim title,gu,sid,s_type,m_level,idx,page,bun

idx = request.form("idx")
page = request.form("page")
gu = request.form("gu")
s_type = request.form("s_type")
m_level = 0
title = request.form("title")
bun = request.form("bun")

sql = "update cal_mast set title ='"& title & "'"
sql = sql & ",s_type = '"& s_type & "'"
sql = sql & ",m_level = '"& m_level & "'"
sql = sql & ",gu = '"& gu & "'"
sql = sql & ",bun = '"& bun & "'"
sql = sql & " where idx= '"& idx &"'"
db.execute sql,,adexecutenorecords

Response.write "<script>"
Response.write "alert('수정되었습니다');"
Response.write "self.location.href='list.asp?page="& page &"';"
Response.write "</script>"
Response.end
%> 
<!-- #include file = "../authpg_2.asp" -->