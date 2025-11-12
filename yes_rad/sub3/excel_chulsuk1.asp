<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition","attachment;filename=["& request("syear") &"년"& request("smonth") &"월 일반회원출석].xls"

Function Get_Lastday(nYear, nMonth)

    Get_Lastday = Day(DateSerial(nYear, nMonth + 1, 1 - 1))

End Function

Dim sql,dr,isRecod,isRows,isCols,i,j
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim gbnS,strPart,strSearch
Dim tabnm : tabnm = "member"
Dim varPage
Dim check1,check2,check3,check4,check5,check6,check7,check8,check9,check10
Dim check11,check12,check13,check14,check15,check16,check17,check18,check19,check20
Dim check21,check22,check23,check24,check25,check26,check27,check28,check29,check30,check31
dim s_year,s_month,s_day,rs

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 30

Dim strClmn : strClmn = " idx,id,name,juminno2,email,regdate,login_count "


	sql = "select Count(idx) from " & tabnm
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " order by idx desc) order by idx desc"
	end if

if request("syear")="" then
	s_year = left(date(),4)
else
	s_year = request("syear")	
end if
if request("smonth")="" then
	s_month = mid(date(),6,2)
else
	s_month = request("smonth")	
end If

Dim lastDate,kkk,chck_valu(31)

lastDate = Get_Lastday(""& s_year &"", ""& s_month &"")

varPage = "gbnS=" & gbnS & "&syear=" & s_year & "&smonth=" & s_month
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
<table width="100%" border="0" cellpadding="0" cellspacing="0" >
				<tr>
					<td align="center"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td height="30"><%=s_year%>년<%=s_month%>월 출석결과입니다.</td>
                      </tr>
                    </table></td>
				</tr><% if isRecod then
				Dim sex
				set dr = db.execute(sql)
				isRows = split(dr.GetString(2),chr(13)) %>
				<tr>
					<td align="center">
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#DEDFDE">
						<tr bgcolor="#EEEEEE" height="30" align="center">
							<td width="3%"><strong><font color="#000000">번호</font></strong></td>
							<td width="3%"><strong><font color="#000000">성명</font></strong></td>
							<%For kkk = 1 To lastDate%>
							<td width="3%"><strong><font color="#000000"><%=kkk%></font></strong></td>
							<%next%>
						</tr><% for ii = 0 to UBound(isRows) - 1
						isCols = split(isRows(ii),chr(9))				

sql = "select count(idx)"
For kkk = 2 To lastDate
	If Len(kkk) = 1 then
		sql = ""& sql &",(select count(idx) from user_ip_check where DateDiff(dd, '"& s_year &"-"& s_month &"-0"& kkk &"',regdate) =0 and uid = '"& isCols(1) &"')"
	Else
		sql = ""& sql &",(select count(idx) from user_ip_check where DateDiff(dd, '"& s_year &"-"& s_month &"-"& kkk &"',regdate) =0 and uid = '"& isCols(1) &"')"
	End if
next
sql = ""& sql &" from user_ip_check where DateDiff(dd, '"& s_year &"-"& s_month &"-01',regdate) =0 and uid = '"& isCols(1) &"'"
set rs=db.execute(sql)

For kkk = 0 To lastDate-1
chck_valu(kkk) = rs(kkk)	
next					
%>
						<tr bgcolor="#FFFFFF" align="center" height="25">
							<td><%=lyno%></td>
							<td><%=isCols(2)%></td>
							<%For kkk = 0 To lastDate-1%>
						  <td width="3%"><%if chck_valu(kkk) > 0 then response.write"O" end if%></td>
						    <%next%>
						</tr><% lyno = lyno - 1
						Next %>
					</table></td>
				</tr>				
<% else %>
				<tr>
					<td align="center">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr height="50" align="center">
							<td>등록된 내용이 없습니다!</td>
						</tr>
					</table>					</td>
				</tr><% end if %>
			</table>
</body>
</html>
<!-- #include file = "../authpg_2.asp" -->