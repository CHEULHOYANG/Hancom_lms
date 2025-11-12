<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,dr
%>
<!--#include file="../main/top.asp"-->

<script>
function bbsDel(idx){

	var delok = confirm("삭제하시겠습니까?");	
	if(delok){
		self.location.href="deleteb.asp?idx="+idx+"";
	}
	
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>게시판목록</h2>

		<div class="tbl_top">
			<a href="creatb.asp" class="fbtn1">게시판 만들기</a>	
		</div>

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:10%" />
			<col style="width:15%" />
			<col />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>구분</th>	
					<th>형태</th>
					<th>제목</th>
					<th>보기권한</th>	
					<th>작성권한</th>								
					<th>기능</th>								
				</tr>				
			</thead>
			<tbody>
<%
Dim board_count1,board_count2,i,j

sql="select count(idx) from board_mast where ygbn=1"
set rs=db.execute(sql)
		
board_count1 = rs(0)
rs.close

sql="select count(idx) from board_mast where (ygbn=2 or ygbn=3) "
set rs=db.execute(sql)
		
board_count2 = rs(0)
rs.close

sql = "select idx,jemok,logincheck,pgbn,ygbn,ordnum from board_mast A order by ygbn asc, ordnum asc"
set rs = db.execute(sql)

if rs.eof or rs.bof then
Else
	i=1
	j=1
	do until rs.eof
%>    
	<tr>
				<td bgcolor="#<%If rs(4) = 1 Then response.write"E7FCED" Else response.write"f6f6f6" End if%>"><%if rs(4) = 1 then%><%if i > 1 then%><a href="bup.asp?idx=<%=rs(0)%>"><img src="../rad_img/a_up.gif" width="8" height="8" border="0"></a>&nbsp;<%end if%><%if board_count1 <> i then%><a href="bdown.asp?idx=<%=rs(0)%>"><img src="../rad_img/a_down.gif" width="8" height="8" border="0"></a><%end if%><%else%><%if j > 1 then%><a href="bup.asp?idx=<%=rs(0)%>"><img src="../rad_img/a_up.gif" width="8" height="8" border="0"></a>&nbsp;<%end if%><%if board_count2 <> j then%><a href="bdown.asp?idx=<%=rs(0)%>"><img src="../rad_img/a_down.gif" width="8" height="8" border="0"></a><%end if%><%End if%></td>
				<td class="tl" bgcolor="#<%If rs(4) = 1 Then response.write"E7FCED" Else response.write"f6f6f6" End if%>"><%if rs(4) = 1 then response.write"자료실" end if%><%if rs(4) = 2 then response.write"커뮤니티(갤러리)" end if%><%if rs(4) = 3 then response.write"커뮤니티(일반)" end if%></td>
                <td class="tl" bgcolor="#<%If rs(4) = 1 Then response.write"E7FCED" Else response.write"f6f6f6" End if%>"><%=rs(1)%></td>
                <td bgcolor="#<%If rs(4) = 1 Then response.write"E7FCED" Else response.write"f6f6f6" End if%>"><%if rs(2) = 0 then response.write"없음" end if%><%if rs(2) = 1 then response.write"회원만" end if%><%if rs(2) = 2 then response.write"수강회원만" end if%></td>
                <td bgcolor="#<%If rs(4) = 1 Then response.write"E7FCED" Else response.write"f6f6f6" End if%>"><%if rs(3) = 0 then response.write"관리자전용" end if%><%if rs(3) = 1 then response.write"회원전용" end if%></td>
                
                <td bgcolor="#<%If rs(4) = 1 Then response.write"E7FCED" Else response.write"f6f6f6" End if%>"><a href='editb.asp?idx=<%=rs(0)%>'  class="btns">수정</a> <a href="javascript:bbsDel(<%=rs(0)%>);" class="btns trans">삭제</a></td>
	</tr>
<%
	if rs(4) = 1 then
		i=i+1
	else
		j=j+1
	End if
	rs.movenext
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