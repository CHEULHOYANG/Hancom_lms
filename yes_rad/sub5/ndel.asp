<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim idx,sql,strPart,strSearch,intpg

intpg = Request.Form("intpg")
strPart = Request.Form("strPart")
strSearch = Request.Form("strSearch")
idx = Request("idx")

sql = "delete notice where idx=" & idx
db.execute(sql)
db.close
set db = Nothing

response.redirect "nlist.asp?intpg="& intpg &"&strPart="& strPart &"&strSearch="& strSearch &""
Response.End
%>
<!-- #include file = "../authpg_2.asp" -->