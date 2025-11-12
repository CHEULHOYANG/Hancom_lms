<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,ip,gu

ip = trim(request("ip"))
gu = trim(request("gu"))

ip = TextChk(ip)
gu = TextChk(gu)

	sql = "insert into ip_mast (ip,gu)values"
	sql = sql & "('" & ip & "'"
	sql = sql & "," & gu
	sql = sql & ")"
	db.execute(sql)

	Function TextChk(strClmn)
		TextChk = Replace(strClmn,"'","''")
		TextChk = Replace(strClmn,"<","&lt;")
		TextChk = Replace(strClmn,">","&gt;")
	End Function

	Response.Redirect "ip_list.asp?gu="& gu
%>
<!-- #include file = "../authpg_2.asp" -->