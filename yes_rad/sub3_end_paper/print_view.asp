<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim info1,info2,info3,info4,info5,info6,info7,info8,info9,info10
Dim sql,rs

sql="select info1,info2,info3,info4,info5,info6,info7,info8,info9,info10 from end_paper_config"
set rs=db.execute(sql)

if rs.eof or rs.bof Then

	info1 = "타이틀1"
	info2 = "타이틀2"
	info3 = "타이틀3"
	info4 = "타이틀4"
	info5 = "타이틀5"
	info6 = "타이틀6"
	info7 = "타이틀7"
	info8 = "타이틀8"
	info9 = "타이틀9"
	info10 = "타이틀10"

Else

	info1 = rs(0)
	info2 = rs(1)
	info3 = rs(2)
	info4 = rs(3)
	info5 = rs(4)
	info6 = rs(5)
	info7 = rs(6)
	info8 = rs(7)
	If Len(info8) > 0 Then info8 = replace(info8,chr(13) & chr(10),"<br>")
	info9 = rs(8)
	info10 = rs(9)

rs.close
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>수료증출력</title>
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

.license{background:url(../sub3_end_paper/paper.jpg) no-repeat center -20px;width:618px;height:960px;padding:130px 190px 180px 190px; font-family:'Nanum Gothic','Malgun Gothic',dotum,sans-serif;color:#111;font-size:21px;letter-spacing:3px;line-height:30px}
.license h3{font-size:66px;text-align:center;line-height:66px;letter-spacing:4px}
.license ul{margin:130px 0}
.license li{padding:4px 0}
.license em{padding:0 10px 0 5px}
.lc_txt{font-size:24px;line-height:36px}
.lc_date{margin:70px 0 70px 0;text-align:center}
.fw{color:#fff}
.lc_sign{text-align:center;position:relative}
.name{position:absolute;display:block;font-size:36px;line-height:46px;text-align:center;top:30px;z-index:10;width:618px}
.sign{position:absolute;display:block;top:10px;right:10px}
em{font-style:normal}
</STYLE>
</head>

<body>
<div class="container">
	<div class="license">
		<p style="font-size:14px">발급번호(개별수정으로입력)</p>
		<h3><%=info1%></h3>
		<ul>
			<%If Len(info2) > 0 then%><li><%=info2%><em>:</em></li><%End if%>
			<%If Len(info3) > 0 then%><li><%=info3%><em>:</em></li><%End if%>
			<%If Len(info4) > 0 then%><li><%=info4%><em>:</em></li><%End if%>
			<%If Len(info5) > 0 then%><li><%=info5%><em>:</em></li><%End if%>
			<%If Len(info6) > 0 then%><li><%=info6%><em>:</em></li><%End if%>
			<%If Len(info7) > 0 then%><li><%=info7%><em>:</em></li><%End if%>
		</ul>
		<p class="lc_txt"><%=info8%></p>
		<p class="lc_date"><%=Year(Date())%>년 <%=month(Date())%>월 <%=day(Date())%>일</p>
		<div class="lc_sign">
			<span class="name"><%=info10%></span><%If Len(info9) > 0 then%><span class="sign"><img src="../../ahdma/<%=info9%>" width='100px'></span><%End if%>
		</div>
	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->