<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,backpg,idAry
Dim intpg,gm,gbnS,strPart,strSearch
Dim retunPage

backpg = Request("backpg")
intpg = Request("intpg")
gm = Request("gm")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")

if backpg = "" then

	retunPage = "list.asp?intpg="& intpg &"&gm="& gm &"&gbnS="& gbnS &"&strPart="& strPart &"&strSearch="& strSearch

	for each idx in request("idx")

		db.execute("delete from member where idx =" & idx)

	Next

else

	retunPage = "memout.asp?intpg="& intpg &"&gm="& gm &"&gbnS="& gbnS &"&strPart="& strPart &"&strSearch="& strSearch

	for each idx in request("idx")

		idAry = split(idx,"|")

		db.execute("delete mem_out where idx=" & idAry(0))
		db.execute("delete member where id='" & idAry(1) & "'")

	Next

end if

db.close
set db = nothing

response.redirect retunPage
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->