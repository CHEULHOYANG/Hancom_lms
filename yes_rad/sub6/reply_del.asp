<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim tabnm,tabidx,idx
tabnm = Request("tabnm")
tabidx = Request("tabidx")
idx = Request("idx")

Dim intpg,gbnS,strPart,strSearch

intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")


''******************************************

Dim sql
sql = "delete replyTab where idx=" & idx
db.execute(sql)

db.close
set db = nothing

response.redirect "content.asp?intpg="& intpg &"&gbnS="& gbnS &"&strPart="& strPart &"&strSearch="& strSearch &"&tabnm=" & tabnm & "&idx=" & tabidx
Response.end

''****************************************** %>
<!-- #include file = "../authpg_2.asp" -->