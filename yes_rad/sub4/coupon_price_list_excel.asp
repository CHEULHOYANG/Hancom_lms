<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Response.Buffer = True
Response.ContentType = "application/vnd.ms-excel"
Response.CacheControl = "public"
Response.AddHeader "Content-Disposition","attachment;filename="& left(now(),10) &"[할인쿠폰번호].xls"
%>
<html>
<head>
<title>쿠폰저장</title>
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
    <td width="5%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">번호</td>
    <td width="30%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">쿠폰번호</td>
    <td width="25%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">할인금액</td>
	<td width="25%" height="30" align="center" style="BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">유효기간</td>
    <td width="15%" height="30" align="center" style="BORDER-RIGHT: #000 1px solid; BORDER-BOTTOM: #000 1px solid; BORDER-TOP: #000 1px solid; BORDER-LEFT: #000 1px solid">사용여부</td>
  </tr>
<%
Dim sql,rs,i,dr
Dim intpg,gbnS,recordcount,isRecod,pagecount,lyno,strPart,strSearch

intpg = Request("intpg")

if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 100

Dim strClmn : strClmn = " idx,cnumber,state,id,use_date,price,end_date "

gbnS = Request("gbnS")

if gbnS = "" then

	sql = "select Count(idx) from coupon_price_mast"
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		sql = "select  top " & pagesize & strClmn & "from coupon_price_mast where idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from coupon_price_mast order by idx desc) order by idx desc"
	end if

else

	strPart = Request("strPart")
	strSearch = Request("strSearch")

	dim query
	query = " "& strPart & " like '%" & Replace(strSearch,"'","''") & "%' "
	sql = "select count(idx) from coupon_price_mast where " & query
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		sql = "select  top " & pagesize & strClmn & "from coupon_price_mast where " & query & " and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from coupon_price_mast where " & query & " order by idx desc) order by idx desc"
	end if

end If

Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
Do Until rs.eof
%>
  <tr>
    <td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid"><%=lyno%></td>
    <td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid"><%=rs(1)%></td>
    <td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid"><%=formatnumber(rs(5),0)%></td>
	<td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid"><%=rs(6)%></td>
    <td height="25" align="center" style="BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid; BORDER-right: #cccccc 1px solid;"><%if rs(2) = 1 then
	response.write ""& rs(3) &"("& left(rs(4),10) &")"
else
	response.write"미사용"
end if%></td>
  </tr>
<%
rs.movenext
lyno = lyno - 1
Loop
rs.close
End if
%>
</table>
</body>
</html>
<!-- #include file = "../authpg_2.asp" -->