<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,sql,dr,isRows,isCols
Dim sql1,rs1
Dim strnm,intprice,intgigan,strheader,totalnum,sub_title,username

idx = request("idx")

sql = "select name from member where id = '"& request("id") &"'"
Set rs1=db.execute(sql)

If rs1.eof Or rs1.bof Then
Else
	username = rs1(0)
rs1.close
End if

sql = "select strnm,intprice,intgigan,strheader,sub_title from LectMast where idx=" & idx
set dr = db.execute(sql)

strnm = dr(0)
intprice = dr(1)
intgigan = dr(2)
strheader = dr(3)
sub_title = dr(4)
dr.close
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="/yes_rad/rad_img/default.css" type="text/css">

<script language="javascript">
function go2Detail(){
	var args = go2Detail.arguments;
	location.href="view_class_detail.asp?idx=<%=idx%>&id=<%=request("id")%>&lidx=" + args[0] + "&categbn=" + args[1];
}
</script>

<style>
.data-lgraph{display:inline-block; height:18px; line-height:18px; background:#333; font-weight:bold; font-size:12px; text-align:center; color:#fff; max-width:500px}
.data-lgraph1{display:inline-block; height:18px; line-height:18px; background:#cc0000; font-weight:bold; font-size:12px; text-align:center; color:#fff; max-width:500px}
</style>

</head>
<body>

<body style="background:#fff">
<div class="content1">

		<h2 class="cTit"><span class="bullet"></span>[<%=strnm%>] (<%=username%>)진도현황</h2>

		<table class="tbl" style="width:920px">
			<colgroup>
			<col />
			<col style="width:15%" />
			<col style="width:15%" />
			<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th>강의명</th>	
					<th>강의수</th>
					<th>완료수</th>
					<th>강의시간</th>					
				</tr>				
			</thead>
			<tbody>
<%
Dim timechk,tt,tt1,tt2,tt3,tt4,tt5,kk

tt3 = 0
tt4 = 0
tt5 = 0

sql = "select A.idx,A.strnm,A.strteach,A.intprice,(select count(idx) from sectionTab where l_idx=A.idx),A.intgigan,sjin=case A.sajin"
sql = sql & " when 'noimg.gif' then 'noimage.gif' else A.sajin end,datediff(day,A.regdate,getdate()) from LecturTab A join  LectAry B"
sql = sql & " on A.idx=B.lectidx where B.mastidx=" & idx & "   order by B.ordn"
set dr = db.execute(sql)

if not dr.bof or not dr.eof then
isRows = split(dr.getString(2),chr(13))

	for ii = 0 to UBound(isRows) - 1
	isCols = split(isRows(ii),chr(9))

	timechk = 0
	kk = 1
	tt1 = 0
	tt2 = 0


	sql1 = "select dbo.function_view_mast_check4('"& request("id") &"',idx),strtime from sectionTab where l_idx="& isCols(0)
	Set rs1 = db.execute(sql1)

	If rs1.eof Or rs1.bof Then
	Else
	do until rs1.eof
		If rs1(0) > 0 then
		timechk = timechk + 1
		tt5 = tt5 + 1
		End If

		tt = Split(rs1(1),":")
		tt1 = tt1 + int(tt(0))
		tt2 = tt2 + int(tt(1))
	
	rs1.movenext
	loop
	rs1.close
	End If
	
	tt3 = tt3 + isCols(4)
	tt4 = tt4 + ((tt1*60)+tt2)
	
%>
				<tr>
					<td class="tl" style="padding:15px 0"><a href="javascript:go2Detail('<%=isCols(0)%>','');"><%=isCols(1)%></a>
					<br><p style="margin:5px 0 0 0"></p><span class="data-lgraph" style="width:<%if timechk=0 then response.write"0" else response.write cint((int(timechk)/isCols(4))*100) end if%>%;"><font color='#fff'><%if timechk=0 then response.write"0" else response.write cint((int(timechk)/isCols(4))*100) end if%>%</font></span>
					</td>
					<td><%=isCols(4)%>강</td>
					<td><%=timechk%>강</td>
					<td><%=getTimeStringFromSeconds((tt1*60)+tt2)%></td>
					
				</tr>
<%
	kk = kk + 1
	Next
Else
End if
%>
				<tr>
					<th class="tl" style="padding:15px 0 15px 15px"><strong>전체</strong><br>
<p style="margin:5px 0 0 0"></p><span class="data-lgraph1" style="width:<%if tt5=0 then response.write"0" else response.write cint((int(tt5)/tt3)*100) end if%>%;"><font color='<%If tt5=0 Then Response.write"#000" Else Response.write"#fff" End if%>'><%if tt5=0 then response.write"0" else response.write cint((int(tt5)/tt3)*100) end if%>%</font></span>
					</th>
					<th><%=tt3%>강</th>
					<th><%=tt5%>강</th>
					<th><%=getTimeStringFromSeconds(tt4)%></th>
					
				</tr>
			</tbody>
		</table>

			<div class="caution" style="margin:0 0 30px 0"><p>강의명을 클릭하시면 상세진도현황을 보실수 있습니다.</p></div>
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