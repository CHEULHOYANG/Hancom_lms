<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,intpg,gbnS,strPart,strSearch,sql,dr
Dim oidx,gigan,gm

oidx = Request("oidx")
gigan = Request("gigan")
gm = Request("gm")
idx = Request("idx")
intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")
	
sql = "select id,eday from order_mast where idx=" & oidx
set dr = db.execute(sql)

dim id,strday,strtime
id = dr(0)
strday = formatdatetime(dr(1),2)
strtime = formatdatetime(dr(1),4)
dr.close

Dim dayYY : dayYY = DateAdd("d",gigan,strday)
Dim neday : neday = Cstr(dayYY) & " " & strtime & ":00"

db.execute("update order_mast set eday=Convert(smalldatetime,'" & neday & "'),state=0 where idx=" & oidx)

Response.Redirect "view.asp?gm="& gm &"&idx="& idx &"&intpg="& intpg &"&gbnS="& gbnS &"&strPart="& strPart &"&strSearch="& strSearch &""
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->