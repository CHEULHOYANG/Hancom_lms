<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim idx,intpg,gbnS,strPart,strSearch,oidx,gm

oidx = Request("oidx")
idx = Request("idx")
intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")
gm = Request("gm")
	
	db.execute("delete order_mast where idx=" & oidx)
	db.close
	Set db = Nothing

	Response.Redirect "view.asp?gm="& gm &"&idx="& idx &"&intpg="& intpg &"&gbnS="& gbnS &"&strPart="& strPart &"&strSearch="& strSearch &""
	Response.end
%>
<!-- #include file = "../authpg_2.asp" -->