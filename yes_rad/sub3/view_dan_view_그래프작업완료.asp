<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim nowPage : nowPage = Request("URL")
Dim dntGbn : dntGbn = request("dntGbn")
Dim dntNm
Dim idx
Dim v_time,rs,v_date,time1,time2
Dim v1,h,m,s
Dim check_time,check_time1,quiz_count,end_check
Dim id,sql,dr

id = request("id")
idx = request("idx")

sql = "select strnm,strteach,intprice,intgigan,(select count(idx) from sectionTab where l_idx="& idx &"),sjin=case sajin when 'noimg.gif' then 'noimage.gif' else sajin end,categbn,tinfo,step_check from LecturTab where idx=" & idx
set dr = db.execute(sql)
dim strnm,strteach,tinfo,intprice,intgigan,totalnum,sajin,bcod,dbcate,step_check_gu
strnm = dr(0)
strteach = dr(1)
intprice = dr(2)
intgigan = dr(3)
totalnum = dr(4)
sajin = dr(5)
dbcate = dr(6)
tinfo = dr(7)
step_check_gu = dr(8)
dr.close

Dim step_check(10000)

step_check(0) = 1

Dim echeck

echeck = 0
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="/yes_rad/rad_img/default.css" type="text/css">
<style>
.data-lgraph{display:inline-block; height:18px; line-height:18px; background:#333; font-weight:bold; font-size:12px; text-align:center; color:#fff; max-width:500px}
.data-lgraph1{display:inline-block; height:18px; line-height:18px; background:#cc0000; font-weight:bold; font-size:12px; text-align:center; color:#fff; max-width:500px}
</style>
</head>

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
Dim tt1,tt2,tt

tt1 = 0
tt2 = 0

sql = "select idx,strnm,ordnum,strtime,lecsum,lecsrc,freegbn,flshlink,movlink,movlink1,freelink,isnull(dbo.function_quiz_munje_count(idx),0),dbo.function_view_mast_check1('"& id &"',idx),dbo.function_view_mast_check2('"& id &"',idx),dbo.function_view_mast_check3('"& id &"',idx),dbo.function_view_mast_check4('"& id &"',idx) from sectionTab where l_idx=" & idx & " order by ordnum"
set dr = db.execute(sql)

If dr.eof Or dr.bof Then
Else
ii = 0
Do Until dr.eof

		tt = Split(dr(3),":")
		tt1 = tt1 + int(tt(0))
		tt2 = tt2 + int(tt(1))

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

If end_check > 0 Then	echeck = echeck + 1
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
				<tr>
					<td colspan="2" class="tl"><strong>전체</strong><br>
<p style="margin:5px 0 0 0"></p><span class="data-lgraph1" style="width:<%if echeck=0 then response.write"0" else response.write cint((int(echeck)/ii)*100) end if%>%;"><font color='<%If echeck=0 Then Response.write"#000" Else Response.write"#fff" End if%>'><%if echeck=0 then response.write"0" else response.write cint((int(echeck)/ii)*100) end if%>%</font></span></td>
					<td>전체 <%=ii%>강 / 완료 <%=echeck%>강</td>	
					<td><%=getTimeStringFromSeconds(tt2+(tt1*60))%></td>
				</tr>
			</tbody>
		</table>
</div>

</body>
</html>
<%
Function getTimeStringFromSeconds(seconds) 

	Dim returnText 

	If seconds > 0 Then
 
		If fix(seconds / 3600) > 0 Then
			If Len(fix(seconds / 3600)) = 1 Then
				returnText = "0"& fix(seconds / 3600) & ":" 
			else
				returnText = fix(seconds / 3600) & ":" 
			End if
		End If 
	
	End If 

	If fix((seconds MOD 3600) / 60) > 0 Then 
		If Len(fix((seconds MOD 3600) / 60)) = 1 Then
			returnText = returnText & "0"& fix(((seconds) MOD 3600) / 60) & ":" 
		else
			returnText = returnText & fix(((seconds) MOD 3600) / 60) & ":" 
		End if
	End If 

	If fix(seconds MOD 60) > 0 Then 
		If Len(fix(seconds MOD 60)) = 1 Then
			returnText = returnText & "0"& (seconds MOD 60) & "" 
		else
			returnText = returnText & (seconds MOD 60) & "" 
		End if
	End If 

	getTimeStringFromSeconds = returnText 

End Function
%>
<!-- #include file = "../authpg_2.asp" -->