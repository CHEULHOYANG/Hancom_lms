<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition","attachment;filename="& left(now(),10) &"[마일리지내역].xls"

dim selYear1,selMonth1,selDay1,selYear2,selMonth2,selDay2,SearchDate1,SearchDate2,SearchPart,SearchStr,rs1
dim search_check1,search_check2,search_check3,search_check4,search_check5,search_check6,search_check7
dim price,gu,g_title,regdate
dim page,recordcount,pagecount,totalpage,i,blockpage,pagesize
dim gu_price1,gu_price2,id,rest_price,sql,rs,sp6,sp1,t_price1,t_price2

sql = "SELECT price,gu,g_title,regdate,id FROM mileage order by idx desc"
set rs=db.execute(sql)
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
<table width="750" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td bgcolor="dedfde"><table width="750" border="0" cellspacing="1" cellpadding="0">
      <tr bgcolor="fffbf7" align="center" class=p11>
        <td height="30" width="95"><font color="#000000">아이디</font></td>
        <td height="30" width="98"><font color="#000000">발행일시</font></td>
        <td height="30" width="309"><font color="#000000">상세내역</font></td>
        <td height="30" width="120"><font color="#000000">적립금액(+)</font></td>
        <td height="30" width="127"><font color="#000000">사용금액(-)</font></td>
      </tr>
      <%
if rs.eof or rs.bof then
else
t_price1 = 0
t_price2 = 0
do until rs.eof 
price=rs(0)
gu=rs(1)
if gu=1 then
gu_price1=price
gu_price2=0
elseif gu=2 then
gu_price1=0
gu_price2=price
end if
g_title=rs(2)
regdate=rs(3)
id=rs(4)
%>
      <tr bgcolor="#FFFFFF">
        <td height="25" width="95" align="center"><%=id%></td>
        <td height="25" width="98" align="center"><%=right(FormatDateTime(regdate,2),5)%>&nbsp;<%=FormatDateTime(regdate,4)%></td>
        <td height="25" width="309">&nbsp;&nbsp;<%=g_title%></td>
        <td height="25" width="120" align="center"><font color="#993333"><%=formatnumber(gu_price2,0)%>원</font></td>
        <td height="25" width="127" align="center"><font color="#663366"><%=formatnumber(gu_price1,0)%>원</font></td>
      </tr>
      <%
rs.movenext
t_price1 = t_price1 + gu_price2
t_price2 = t_price2 + gu_price1
loop
end if
rs.close
%>
      <tr bgcolor="#FFFFFF">
        <td height="30" colspan="5" align="center">총적립금액 : <span class="style2"><%=formatnumber(t_price1,0)%>원</span> / 총사용금액 : <span class="style1"><%=formatnumber(t_price2,0)%>원</span></td>
      </tr>
    </table></td>
  </tr>
</table>
</body>
</html>
<!-- #include file = "../authpg_2.asp" -->