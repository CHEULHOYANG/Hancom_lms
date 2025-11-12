<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
 Dim dntGbn : dntGbn = request("dntGbn")
 Dim dntNm
 Dim idx,intpg,lidx
 Dim v_time,rs,v_date,time1,time2
 Dim v1,h,m,s
 Dim check_time,check_time1,quiz_count,end_check,id,sql,dr

 idx = request("idx")
 id = request("id")
 lidx = request("lidx")
 sql = "select strnm,strteach,intprice,intgigan,totalnum,sjin=case sajin when 'noimg.gif' then 'noimage.gif' else sajin end,categbn,step_check from LecturTab where idx=" & lidx
set dr = db.execute(sql)
dim strnm,strteach,tinfo,intprice,intgigan,totalnum,sajin,bcod,step_check_gu
strnm = dr(0)
strteach = dr(1)
intprice = dr(2)
intgigan = dr(3)
totalnum = dr(4)
sajin = dr(5)
bcod = dr(6)
step_check_gu = dr(7)
dr.close

sql = "select count(idx) from sectionTab where l_idx=" & lidx
set dr = db.execute(sql)

totalnum = dr(0)
dr.close

Dim step_check(10000)

step_check(0) = 1
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="/yes_rad/rad_img/default.css" type="text/css">
</head>
<body>

<body style="background:#fff">
<div class="content1">

		<h2 class="cTit"><span class="bullet"></span>[<%=strnm%>] 진도현황</h2>

		<table class="tbl" style="width:920px">
			<colgroup>
			<col style="width:10%" />
			<col />
			<col style="width:25%" />
			<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th>회차</th>	
					<th>강의명</th>
					<th>진도현황</th>
					<th>강의시간</th>							
				</tr>				
			</thead>
			<tbody>
<%
sql = "select idx,strnm,ordnum,strtime,lecsum,lecsrc,freegbn,flshlink,movlink,movlink1,freelink,isnull(dbo.function_quiz_munje_count(idx),0),dbo.function_view_mast_check1('"& id &"',idx),dbo.function_view_mast_check2('"& id &"',idx),dbo.function_view_mast_check3('"& id &"',idx),dbo.function_view_mast_check4('"& id &"',idx) from sectionTab where l_idx=" & lidx & " order by ordnum"
set dr = db.execute(sql)

If dr.eof Or dr.bof Then
Else
ii = 0
Do Until dr.eof

check_time1 = 0
step_check(ii+1) = 0

If step_check_gu = 0 Then step_check(ii) = 1

quiz_count = dr(11)
v_time = dr(12)
v_date = dr(13)
end_check = dr(15)

If end_check = 0 then

	If v_time > 0 then		  

	v1 = v_time 
	h = (int)(v1 / 3600)
	if len(h) = 1 then	h = "0"& h &""
	v1 = v1 mod 3600
	m = (int)(v1 / 60)

	if len(m) = 1 then	m = "0"& m &""
	s = v1 mod 60  

	if len(s) = 1 then	s = "0"& s &""
			
	check_time  = split(dr(3),":")
	check_time1 = (int(check_time(0)) * 60) + int(check_time(1))

	End If

End If
%>
				<tr>
					<td style="padding:15px 0"><%=ii+1%>회</td>
					<td class="tl"><%=dr(1)%></td>
					<td><%If end_check > 0 then%><font color='#cc0000'>수강완료</font><%else%><%if v_time > 0 then response.write ""& replace(v_date,"-",".") &" ("& h &":"& m &":"& s &")" else response.write"미수강" end if%><%End if%></td>
					<td><%=dr(3)%></td>
					
				</tr>
<%

	dr.movenext
	ii = ii + 1
	Loop
	dr.close

End if
%>
			</tbody>
		</table>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->