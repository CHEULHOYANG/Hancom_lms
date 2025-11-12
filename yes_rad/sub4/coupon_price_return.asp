<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx
Dim intpg : intpg = Request("intpg")
Dim strPart : strPart = Request("strPart")
Dim strSearch : strSearch = Request("strSearch")
Dim sql,dr

for each idx in request("idx")

	db.execute("update coupon_price_mast set state=0 ,id='',use_date='' where idx=" & idx)

next

db.close
set db = nothing

Response.redirect "coupon_price_list.asp?intpg="& intpg &"&strPart="& strPart &"&strSearch="& strSearch
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->