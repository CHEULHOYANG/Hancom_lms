<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim isRecod1,isRecod2,isRecod3
dim sql,dr,board_count,i
Dim isRows,isCols
%>
<!--#include file="../main/top.asp"-->
<script language="javascript">
function viewFaq(idx){
	window.open("guidepreivew.asp?idx=" + idx,"preview","width=870,height=600,scrollbars=yes,top=0,left=0");
}
function delGuid(idx){
	var delok = confirm("삭제하시겠습니까?");
	if(delok){
		location.href="searchlist_del.asp?idx=" + idx;
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>인기검색어관리</h2>

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:10%" />
			<col />
			<col style="width:10%" />
			<col style="width:8%" />
			</colgroup>
			<thead>
				<tr>
					<th>순위</th>	
					<th>검색어</th>
					<th>조회수</th>
					<th>삭제</th>	
				</tr>				
			</thead>
			<tbody>
<%
dim rs

sql = "select idx,kwd,num from SearchTab order by num desc"
set rs=db.execute(sql)

if rs.eof or rs.bof then
else
i = 1
do until rs.eof
%> 
				<tr>
					<td><%=i%></td>
					<td><%=rs(1)%></td>
					<td><%=rs(2)%></td>
					<td><a href="javascript:delGuid('<%=rs(0)%>');" class="btns trans">삭제</a></td>
				</tr>
<%
rs.movenext
i=i+1
loop
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