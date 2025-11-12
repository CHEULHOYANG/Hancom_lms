<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition","attachment;filename="& left(now(),10) &"[결제내역].xls"

Dim sql,dr,isRecod,isRows,isCols,pagesize
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim gbnS,strsday,streday,strPart,strSearch
Dim tabnm : tabnm = "order_mast"
Dim varPage

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

If request("gm1") = 0 then

	pagesize = 50
	response.cookies("gm1") = 50

Else

	pagesize = request("gm1")
	response.cookies("gm1") = request("gm1")

End if

Dim strClmn : strClmn = " idx,id + '(' + dbo.MemberNm(id) + ')',titlen = title + dbo.LectuTitle(tabidx,buygbn),sday,dbo.PayTypeStr(paytype),payday,state,intprice-cprice,cash,cprice,bookidx,(select title from book_mast where idx=A.tabidx),order_id,send_price,return_state "

gbnS = Request("gbnS")
strsday = Request("strsday")
streday = Request("streday")
strPart = Request("strPart")
strSearch = Request("strSearch")

if strsday = "" then
	strsday = DateAdd("m",-1,date)
	streday = date
end if

if gbnS = "" then
	varPage = "gbnS=&strsday=&streday=&strPart=&strSearch="

	sql = "select Count(idx) from " & tabnm & " "
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		sql = "select  top " & pagesize & strClmn & "from " & tabnm & " A where idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " order by idx desc) order by idx desc"
	end if

else
	varPage = "gbnS=" & gbnS & "&strsday=" & strsday & "&streday=" & streday & "&strPart=" & strPart & "&strSearch=" & strSearch

	dim query
	query = ""
	query = query & " payday between convert(smalldatetime,'" & strsday & " 00:00')" & " and convert(smalldatetime,'" & streday & " 23:59')"

	If strPart = "id" then

		if Not strSearch = "" then
			query = query & " and " & strPart & " like '%" & Replace(strSearch,"'","''") & "%' "
		end If
	
	Else

		if Not strSearch = "" then
			query = query & " and dbo.MemberNm(id) like '%" & Replace(strSearch,"'","''") & "%' "
		end If

	End if

	sql = "select count(idx) from " & tabnm & " where " & query
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		sql = "select  top " & pagesize & strClmn & "from " & tabnm & " A where " & query & " and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " where " & query & " order by idx desc) order by idx desc"
	end if
end if
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<title>예스소프트솔루션관리자모드</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style>
   <!--
   A:link {color:black; text-decoration: none}
    A:visited {color:black; text-decoration: none}
    A:hover {color:black; text-decoration: none}
    td {font-family:굴림;font-size:9pt;}
    .akross {font-family:굴림 ; font-size:9pt;line-height:140%}
    .justify {font-family:굴림 ; font-size:9pt;text-align:justify;line-height:140%}
    .big {font-family:굴림 ; font-size:11pt; line-height:140%}
    .form {font: 9pt 굴림; BACKGROUND-COLOR:#FFFFFF; COLOR:#222222; BORDER:1x solid #778899}
    .input{border-bottom: black 1px solid; border-left: black 1px solid; border-right: black 1px solid; border-top: black 1px solid; font-family:돋움; font-size:9pt;}
   .file {background-color:white; color:navy; border:solid 1 navy; height:18px;font-family:돋움; font-size:9pt;}
    .select {font: 9pt 굴림; BACKGROUND-COLOR:#FFFFFF; COLOR:#222222; BORDER:0x solid #778899}
    //
   -->
   </style>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#DEDFDE">
						<tr bgcolor="#EEEEEE" height="30" align="center">
							<td width="7%" height="30" ><strong><font color="#000000">No.</font></strong></td>
							<td height="30" ><strong><font color="#000000">상품명</font></strong></td>
							<td width="15%" height="30" ><strong><font color="#000000">아이디(이름)</font></strong></td>

							<td width="7%" height="30" ><strong><font color="#000000">상품금액</font></strong></td>
							<td width="7%" height="30" ><strong><font color="#000000">적립금(-)</font></strong></td>
							<td width="7%" height="30" ><strong><font color="#000000">실제금액</font></strong></td>

							<td width="15%" height="30" ><strong><font color="#000000">결제방법</font></strong></td>
							<td><strong><font color="#000000">결제일</font></strong></td>
						  </tr><% 
						  if isRecod then
				set dr = db.execute(sql)
				isRows = split(dr.GetString(2),chr(13))
						  
						  for ii = 0 to UBound(isRows) - 1
						isCols = split(isRows(ii),chr(9)) %>
						<tr height="25" bgcolor="#FFFFFF" align="left">
							<td align="center" height="25"><%=lyno%></td>
<%If isCols(10) = 0 then%>
							<td height="25" style="padding:10px"><span style="font-size:12px;color:#cc0000">주문번호 : <%=isCols(12)%></span><br /><%=isCols(2)%><%If isCols(9) > 0 Then Response.write " ("& FormatNumber(isCols(9),0) &" 할인)" End if%></td>
<%else%>
							<td height="25" style="padding:10px"><span style="font-size:12px;color:#cc0000">주문번호 : <%=isCols(12)%></span><br />교재 : <%=isCols(11)%><%If isCols(9) > 0 Then Response.write " ("& FormatNumber(isCols(9),0) &" 할인)" End if%><%If isCols(13) > 0 Then Response.write " (배송비 +"& FormatNumber(isCols(13),0) &"원)" End if%></td>
<%End if%>
							<td align="center" height="25"><%=isCols(1)%></td>

<td align="center"><%=formatnumber(isCols(7),0)%></td>
<td align="center"><%=formatnumber(isCols(8),0)%></td>
<%If isCols(10) = 0 then%>
							<td align="center"><strong><%=formatnumber(isCols(7)-isCols(8),0)%></strong></td>
<%else%>
							<td align="center"><strong><%=formatnumber(isCols(7)-isCols(8)+isCols(13),0)%></strong></td>
<%End if%>

							<td align="center" height="25"><%=isCols(4)%>

							<%if isCols(6)=0 or isCols(6)=2 then%>
							(결제완료)
							<%else%>
								<%if isCols(14)=0 then%>
								<font color='#cc0000'>(미결제)</font>
								<%End if%>
								<%if isCols(14)=1 then%>
								<font color='#cc0000'>(환불접수)</font>
								<%End if%>
								<%if isCols(14)=2 then%>
								<font color='#cc0000'>(환불완료)</font>
								<%End if%>
							<%end if%>							
							
							</td>
							<td align="center" height="25"><%=formatdatetime(isCols(5),2)%></td>
						  </tr><% lyno = lyno - 1
						Next 
						
						else
						end if%>
					</table>

</body>
</html><%
Function cutStr(str, cutLen)
	Dim strLen, strByte, strCut, strRes, char, i
	strLen = 0
	strByte = 0
	strLen = Len(str)
	for i = 1 to strLen
		char = ""
		strCut = Mid(str, i, 1)
		char = Asc(strCut)
		char = Left(char, 1)
		if char = "-" then
			strByte = strByte + 2
		else
			strByte = strByte + 1
		end if
		if cutLen < strByte then
			strRes = strRes & ".."
			exit for
		else
			strRes = strRes & strCut
		end if
	next
	cutStr = strRes
End Function
%>
<!-- #include file = "../authpg_2.asp" -->