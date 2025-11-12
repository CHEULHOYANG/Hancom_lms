<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,backpg,idAry
Dim intpg,gm,gbnS,strPart,strSearch
Dim retunPage,ssp1,ssp2

ssp1 = Request("ssp1")
ssp2 = Request("ssp2")
intpg = Request("intpg")
gm = Request("gm")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")

If Len(ssp1) = 0 Then ssp1 = 0
If Len(ssp2) = 0 Then ssp2 = 0

If ssp1 > 0 then

	for each idx in request("idx")

		db.execute("update member set sp1 = "& ssp1 &" where idx = "& idx)

	Next

End If

If ssp2 > 0 then

	for each idx in request("idx")

		db.execute("update member set sp2 = "& ssp2 &" where idx = "& idx)

	Next

End if

db.close
set db = nothing

Response.redirect "list.asp?intpg="& intpg &"&gm="& gm &"&gbnS="& gbnS &"&strPart="& strPart &"&strSearch="& strSearch
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->