<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,idx,intpg,gbnS,strsday,streday,strPart,strSearch,eday

idx = request("idx")
intpg = request("intpg")
gbnS = request("gbnS")
strsday = request("strsday")
streday = request("streday")
strPart = request("strPart")
strSearch = request("strSearch")
eday = request("eday")

sql = "update order_mast set eday = '"& eday &"' where idx=" & idx
db.execute(sql)

db.close
set db = nothing

Response.redirect "order_list.asp?intpg="& intpg &"&gbnS="& gbnS &"&strsday="& strsday &"&streday="& streday &"&strPart="& strPart &"&strSearch="& strSearch &""
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->