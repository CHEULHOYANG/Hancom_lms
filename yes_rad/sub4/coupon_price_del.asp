<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx
Dim intpg : intpg = Request("intpg")
Dim strPart : strPart = Request("strPart")
Dim strSearch : strSearch = Request("strSearch")
Dim gbnS : gbnS = Request("gbnS")
Dim sql,dr

for each idx in request("idx")

	db.execute("delete coupon_price_mast where idx=" & idx)

Next

db.close
set db = nothing

Response.redirect "coupon_price_list.asp?gbnS="& gbnS &"&intpg="& intpg &"&strPart="& strPart &"&strSearch="& strSearch &""
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->