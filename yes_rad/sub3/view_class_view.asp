<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,sql,dr,isRows,isCols
Dim strnm,intprice,intgigan,strheader,totalnum,sub_title

idx = request("idx")

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
</head>
<body>

<body style="background:#fff">
<div class="content1">

		<h2 class="cTit"><span class="bullet"></span>[<%=strnm%>] 진도현황</h2>

		<table class="tbl" style="width:920px">
			<colgroup>
			<col />
			<col style="width:20%" />
			</colgroup>
			<thead>
				<tr>
					<th>강의명</th>	
					<th>구성</th>
					
				</tr>				
			</thead>
			<tbody>
<%
sql = "select A.idx,A.strnm,A.strteach,A.intprice,(select count(idx) from sectionTab where l_idx=A.idx),A.intgigan,sjin=case A.sajin"
sql = sql & " when 'noimg.gif' then 'noimage.gif' else A.sajin end,datediff(day,A.regdate,getdate()) from LecturTab A join  LectAry B"
sql = sql & " on A.idx=B.lectidx where B.mastidx=" & idx & "   order by B.ordn"
set dr = db.execute(sql)

if not dr.bof or not dr.eof then
isRows = split(dr.getString(2),chr(13))

	for ii = 0 to UBound(isRows) - 1
	isCols = split(isRows(ii),chr(9))
%>
				<tr>
					<td class="tl" style="padding:15px 0"><a href="javascript:go2Detail('<%=isCols(0)%>','');"><%=isCols(1)%></a></td>
					<td><%=isCols(4)%>강</td>
					
				</tr>
<%
	Next
Else
End if
%>
			</tbody>
		</table>

			<div class="caution"><p>강의명을 클릭하시면 진도현황을 보실수 있습니다.</p></div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->