<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition","attachment;filename="& left(now(),10) &"[진도현황].xls"

Dim sql,dr,isRecod,isRows,isCols,rs1,pagesize
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim gbnS,strsday,streday,strPart,strSearch
Dim tabnm : tabnm = "view_mast"
Dim varPage
Dim v_time,v_date,time1,time2,v_title
dim v1,h,m,s

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

Dim strClmn : strClmn = " idx,id + '(' + dbo.MemberNm(id) + ')',v_idx,v_time,v_date,regdate,ip,id,end_check "

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

	sql = "select Count(idx) from " & tabnm & ""
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " order by idx desc) order by idx desc"
	end if

else
	varPage = "gbnS=" & gbnS & "&strsday=" & strsday & "&streday=" & streday & "&strPart=" & strPart & "&strSearch=" & strSearch

	dim query
	query = ""
	query = query & " v_date between convert(smalldatetime,'" & strsday & " 00:00')" & " and convert(smalldatetime,'" & streday & " 23:59')"

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
		sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where " & query & " and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " where " & query & " order by idx desc) order by idx desc"
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
							<td width="4%" height="30" ><strong><font color="#000000">No.</font></strong></td>
                            <td width="44%" height="30" ><strong><font color="#000000">강좌명</font></strong></td>
							<td width="16%" height="30" ><strong><font color="#000000">구매자ID(이름)</font></strong></td>
							<td width="12%" height="30" ><strong><font color="#000000">아이피</font></strong></td>
							<td width="14%" height="30" ><strong><font color="#000000">재생시간</font></strong></td>
							<td width="10%" height="30" ><strong><font color="#000000">진도구분</font></strong></td>
							</tr><% 
							if isRecod then
				set dr = db.execute(sql)
				isRows = split(dr.GetString(2),chr(13))
							
							for ii = 0 to UBound(isRows) - 1
						isCols = split(isRows(ii),chr(9)) 
						
		  v_time = isCols(3)
		  v_date = isCols(4)

v1 = v_time 
h = (int)(v1 / 3600)
if len(h) = 1 then
	h = "0"& h &""
end if
v1 = v1 mod 3600
m = (int)(v1 / 60)
if len(m) = 1 then
	m = "0"& m &""
end if
s = v1 mod 60  
if len(s) = 1 then
	s = "0"& s &""
end if
		
		sql = "select strnm from sectionTab where idx=" & isCols(2)
		set rs1 = db.execute(sql)
		
		if rs1.eof or rs1.bof then
			v_title = ""
		else
			v_title = rs1(0)		
		rs1.close
		end if
						
%>
						<tr height="25" bgcolor="#FFFFFF" align="left">
							<td align="center" height="25"><%=lyno%></td>
							<td height="25">&nbsp; <%=v_title%></td>
							<td align="center" height="25"><%=isCols(1)%></td>
							<td align="center" height="25"><%=isCols(6)%></td>
							<td align="center" height="25"><%=right(FormatDateTime(isCols(5),2),8)%>&nbsp;<%=FormatDateTime(isCols(5),4)%></td>
							<td align="center" height="25"><%If isCols(8) = 0 then%><%=h%>:<%=m%>:<%=s%><%else%>수강완료<%End if%></td>
							</tr><% lyno = lyno - 1
						Next 
						
						Else
						End if
						%>
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