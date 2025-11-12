<!-- #include file = "../authpg_1.asp" -->
<!-- #include file="../../include/dbcon.asp" -->
<%
Dim sql,rs

sql = "update site_info set favicon = ''"
db.execute(sql)

response.redirect "favicon.asp"
response.end
%>
<!-- #include file = "../authpg_2.asp" -->