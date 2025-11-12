<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,id,gbnS,strsday,streday,strPart,strSearch,v_idx

id = Request("id")
v_idx = request("v_idx")
gbnS = Request("gbnS")
strsday = Request("strsday")
streday = Request("streday")
strPart = Request("strPart")
strSearch = Request("strSearch")

sql = "delete view_mast where v_idx = "& v_idx &" and id = '" & id &"'"
db.execute(sql)

db.close
set db = nothing

response.redirect "view_list.asp?intpg="& request("intpg") &"&gbnS="& request("gbnS") &"&strsday="& request("strsday") &"&streday="& request("streday") &"&strPart="& request("strPart") &"&strSearch="& request("strSearch") &""
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->