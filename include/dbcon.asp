<%
Session.Codepage = 949
Response.CharSet = "EUC-KR"

Dim db
Dim strDB_ComputerName,strDB_ID,strDB_PWD,strDB_Name,strConnect

strDB_ComputerName="HANCOMELEARNING\HANCOM_DEFENSE"
strDB_ID="hancomsqladmin"
strDB_PWD="zoavjtm!23"
strDB_Name="hancom_defense"
strConnect="Provider=SQLOLEDB.1;Password=" & strDB_PWD & ";User ID=" & strDB_ID & ";Initial Catalog=" & strDB_Name & ";Data Source=" & strDB_ComputerName
set db=server.createobject("adodb.connection")
db.open strconnect

Dim ssql9,rss9,s_favicon

ssql9 = "select favicon from site_info"
Set rss9=db.execute(ssql9)

If rss9.eof Or rss9.bof Then
	s_favicon = ""
Else
	s_favicon = rss9(0)
rss9.close
End If

Dim check_shop_url

If Request.ServerVariables("HTTPS") = "off" Then
	check_shop_url = "http://"& request.ServerVariables("HTTP_HOST") &""
else
	check_shop_url = "https://"& request.ServerVariables("HTTP_HOST") &""
End If
%>