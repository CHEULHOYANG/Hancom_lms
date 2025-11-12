<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,Dr,jemok,neyong
Dim idx

idx = Request("idx")

sql = "select jemok,neyong from guideTab where idx=" & idx
Set Dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('데이터에러!!');"
	response.write"history.back();"
	response.write"</script>"
	response.end

Else

	jemok = Dr(0)
	neyong = Dr(1)
		
Dr.Close
End if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<style type="text/css">
body
	{
	font-family: "돋움체";
	font-size: 9pt;
	scrollbar-face-color: #D7D7D7;
	scrollbar-shadow-color: #ffffff;
	scrollbar-highlight-color: #ffffff;
	scrollbar-3dlight-color: #ffffff;
	scrollbar-darkshadow-color: #ffffff;
	scrollbar-track-color: #F8F8F8;
	scrollbar-arrow-color: #ffffff;
	letter-spacing: -0.5px;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	}
td
	{
		font-family: "돋움체";
		font-size: 9pt;
	   	 color: #777777;
	}
table	{word-wrap:break-word; word-break:break-all}
</style>
</head>
<body>
<table width="850" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="30" align="right"><img src="../ad_img/bt/bt_close.gif" style="cursor:pointer;" onclick="window.close();"></td>
				</tr>
				<tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center">
			<table width="100%" border="0" cellspacing="1" cellpadding="0"  bgcolor="#c2c2c2">
				<tr bgcolor="#f2f2f2">
					<td align="center">
						<table border="0" width="100%">
							<tr>
								<td  bgcolor="#ffffff" style="padding:10px;"><b><%=jemok%></b></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr height="10">
		<td></td>
	</tr>
	<tr>
		<td align="center">
			<table width="100%" border="0" cellspacing="1" cellpadding="0"  bgcolor="#c2c2c2">
				<tr bgcolor="#f2f2f2">
					<td align="center">
						<table border="0" width="100%">
							<tr>
								<td  bgcolor="#ffffff" style="padding:10px;"><%=neyong%></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="30" align="right"><img src="../ad_img/bt/bt_close.gif" style="cursor:pointer;" onclick="window.close();"></td>
				</tr>
				<tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
<!-- #include file = "../authpg_2.asp" -->