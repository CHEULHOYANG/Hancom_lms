<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,idx,intpg,gbnS,strsday,streday,strPart,strSearch,return_price

idx = request("idx")
intpg = request("intpg")
gbnS = request("gbnS")
strsday = request("strsday")
streday = request("streday")
strPart = request("strPart")
strSearch = request("strSearch")
return_price = request("return_price")

sql = "update order_mast set return_price = "& return_price &" where idx=" & idx
db.execute(sql)

db.close
set db = nothing

Response.write"<script>"
Response.write"alert('환불금액이 변경되었습니다.');"
Response.write"self.location.href='return_list.asp?intpg="& intpg &"&gbnS="& gbnS &"&strsday="& strsday &"&streday="& streday &"&strPart="& strPart &"&strSearch="& strSearch &"';"
Response.write"</script>"
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->