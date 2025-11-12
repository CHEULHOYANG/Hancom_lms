<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,idx,gbnS,strsday,streday,strPart,strSearch

idx = Request("idx")

gbnS = Request("gbnS")
strsday = Request("strsday")
streday = Request("streday")
strPart = Request("strPart")
strSearch = Request("strSearch")

sql = "update view_mast set end_check = 1 where idx=" & idx
db.execute(sql)

db.close
set db = nothing

response.redirect "view_list.asp?intpg="& request("intpg") &"&gbnS="& request("gbnS") &"&strsday="& request("strsday") &"&streday="& request("streday") &"&strPart="& request("strPart") &"&strSearch="& request("strSearch") &""
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->