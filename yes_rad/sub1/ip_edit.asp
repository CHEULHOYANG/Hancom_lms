<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,idx,ip,gu

idx = trim(request("idx"))
ip = trim(request("ip"))
gu = trim(request("gu"))

idx = TextChk(idx)
ip = TextChk(ip)
gu = TextChk(gu)

sql = "update ip_mast set ip ='"& ip & "'"
sql = sql & " where idx = '"& idx &"'"
db.execute sql,,adexecutenorecords

Function TextChk(strClmn)
	TextChk = Replace(strClmn,"'","''")
	TextChk = Replace(strClmn,"<","&lt;")
	TextChk = Replace(strClmn,">","&gt;")
End Function

Response.Redirect "ip_list.asp?gu="& gu
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->