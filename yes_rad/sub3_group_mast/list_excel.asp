<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Response.Buffer = True      
Response.ContentType = "application/vnd.ms-excel"
Response.CacheControl = "public"
Response.AddHeader "Content-Disposition","attachment;filename="& left(now(),10) &"[회원목록].xls"
%>
<html>
<head>
<title>영수증인쇄하기</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<STYLE>BODY {
	SCROLLBAR-FACE-COLOR: #dfdfdf; FONT-SIZE: 9pt; COLOR: #333333; SCROLLBAR-3DLIGHT-COLOR: #595959; LINE-HEIGHT: 14px; SCROLLBAR-ARROW-COLOR: #7f7f7f; FONT-FAMILY: "굴림", "Seoul", "arial", "Verdana", "helvetica"; SCROLLBAR-DARKSHADOW-COLOR: #ffffff
}
TABLE {
	SCROLLBAR-FACE-COLOR: #dfdfdf; FONT-SIZE: 9pt; COLOR: #333333; SCROLLBAR-3DLIGHT-COLOR: #595959; LINE-HEIGHT: 14px; SCROLLBAR-ARROW-COLOR: #7f7f7f; FONT-FAMILY: "굴림", "Seoul", "arial", "Verdana", "helvetica"; SCROLLBAR-DARKSHADOW-COLOR: #ffffff
}
TR {
	SCROLLBAR-FACE-COLOR: #dfdfdf; FONT-SIZE: 9pt; COLOR: #333333; SCROLLBAR-3DLIGHT-COLOR: #595959; LINE-HEIGHT: 14px; SCROLLBAR-ARROW-COLOR: #7f7f7f; FONT-FAMILY: "굴림", "Seoul", "arial", "Verdana", "helvetica"; SCROLLBAR-DARKSHADOW-COLOR: #ffffff
}
TD {
	SCROLLBAR-FACE-COLOR: #dfdfdf; FONT-SIZE: 9pt; COLOR: #333333; SCROLLBAR-3DLIGHT-COLOR: #595959; LINE-HEIGHT: 14px; SCROLLBAR-ARROW-COLOR: #7f7f7f; FONT-FAMILY: "굴림", "Seoul", "arial", "Verdana", "helvetica"; SCROLLBAR-DARKSHADOW-COLOR: #ffffff
}
.m_a {
	FONT-SIZE: 8pt; FONT-FAMILY: "돋움"; LETTER-SPACING: -1px
}
.01 {
	FONT-SIZE: 9pt; PADDING-TOP: 2pt
}
.02 {
	FONT-SIZE: 9pt; COLOR: #333333; PADDING-TOP: 2pt
}
.03 {
	FONT-SIZE: 9pt; COLOR: #ff4633; PADDING-TOP: 2pt
}
.xx {
	BORDER-RIGHT: #a2a2a2 1px solid; BORDER-TOP: #a2a2a2 1px solid; FONT-SIZE: 9pt; BORDER-LEFT: #a2a2a2 1px solid; BORDER-BOTTOM: #a2a2a2 1px solid; BACKGROUND-COLOR: #f0f0f0
}
.yy {
	BORDER-RIGHT: #a2a2a2 1px solid; BORDER-TOP: #a2a2a2 1px solid; FONT-SIZE: 9pt; BORDER-LEFT: #a2a2a2 1px solid; BORDER-BOTTOM: #a2a2a2 1px solid; ffffff: 
}
A:link {
	COLOR: #585858; TEXT-DECORATION: none
}
A:visited {
	COLOR: #585858; TEXT-DECORATION: none
}
A:active {
	COLOR: #585858; TEXT-DECORATION: none
}
A:hover {
	COLOR: #585858; TEXT-DECORATION: none
}
</STYLE>

</head>
<body bgcolor="#FFFFFF" text="#000000">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="4%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">번호</td>
    <td width="6%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">이름</td>
    <td width="6%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">아이디</td>
    <td width="11%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">일반전화번호</td>
    <td width="11%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">휴대폰번호</td>
    <td width="10%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">생년월일</td>
    <td width="16%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">이메일주소</td>
    <td width="28%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">주소</td>
    <td width="8%" height="30" align="center" style="BORDER-RIGHT: #000 1px solid; BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">가입일</td>
  </tr>
<%
Dim sql,rs,i

If request("gu") = 0 then
sql = "select idx,id,pwd,name,juminno1,juminno2,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,mileage,regdate,state,login_count,b_year,b_month,b_day,b_type,sms_res,email_res,sp1,sp2,sp3,memo from member where sp1 = "& request("gm") &" order by idx desc"
elseif request("gu") = 1 Then
sql = "select idx,id,pwd,name,juminno1,juminno2,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,mileage,regdate,state,login_count,b_year,b_month,b_day,b_type,sms_res,email_res,sp1,sp2,sp3,memo from member where sp2 = "& request("gm") &" order by idx desc"
elseif request("gu")= 2 Then
sql = "select idx,id,pwd,name,juminno1,juminno2,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,mileage,regdate,state,login_count,b_year,b_month,b_day,b_type,sms_res,email_res,sp1,sp2,sp3,memo from member where sp3 = "& request("gm") &" order by idx desc"
End if

Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
i=1
Do Until rs.eof
%>
  <tr>
    <td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid"><%=i%></td>
    <td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid"><%=rs(3)%></td>
    <td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid"><%=rs(1)%></td>
    <td align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid"><%=rs(6)%></td>
    <td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid"><%=rs(7)%></td>
    <td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid"><%=rs(17)%>-<%=rs(18)%>-<%=rs(19)%></td>
    <td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid"><%=rs(8)%></td>
    <td align="left" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid">&nbsp;&nbsp;[<%=rs(9)%>]&nbsp;<%=rs(11)%>&nbsp;<%=rs(12)%></td>
    <td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid; BORDER-right: #cccccc 1px solid;"><%=Left(rs(14),10)%></td>
  </tr>
<%
rs.movenext
i=i+1
Loop
rs.close
End if
%>
</table>
</body>
</html>
<!-- #include file = "../authpg_2.asp" -->