<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs

sql="select A.crdate,A.name,max(B.rowcnt),sum(case when B.indid <= 1 then B.dpages*8 else 0  end),sum(case when B.indid > 1 and B.indid < 255 then B.dpages*8 else 0 end ) from sysobjects A join sysindexes B on A.id = B.id where A.xtype = 'U' group by A.name,A.crdate order by A.name"
set rs=db.execute(sql)
%>
<!--#include file="../main/top.asp"-->

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>DB사용현황</h2>

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:31%" />
			<col style="width:23%" />
			<col style="width:23%" />
			<col style="width:23%" />
			</colgroup>
			<thead>
				<tr>
					<th>테이블명</th>	
					<th>레코드수</th>
					<th>데이터크기</th>
					<th>생성일</th>	
				</tr>				
			</thead>
			<tbody>
<%
if rs.eof or rs.bof then
else
do until rs.eof
%>
				<tr>
					<td class="tl"><%=rs(1)%></td>
					<td><%=rs(2)%></td>
					<td><%=rs(3)%>KB</td>
					<td><%=replace(FormatDateTime(rs(0),2),"-","/")%></td>
				</tr>
<%
rs.movenext
Loop
rs.close
end if
%>
			</tbody>
		</table>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->