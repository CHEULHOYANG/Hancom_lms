<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx
Dim intpg : intpg = Request("intpg")
Dim strPart : strPart = Request("strPart")
Dim strSearch : strSearch = Request("strSearch")
Dim gu : gu = Request("gu")
Dim sql,dr

for each idx in request("idx")

	db.execute("delete coupon_mast where idx=" & idx)

next

db.close
set db = nothing

Response.redirect "coupon_list.asp?intpg="& intpg &"&strPart="& strPart &"&strSearch="& strSearch &"&gu="& gu
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->