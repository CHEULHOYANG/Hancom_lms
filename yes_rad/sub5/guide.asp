<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim isRecod1,isRecod2,isRecod3
dim sql,dr,board_count,i
Dim isRows,isCols

Dim t_menu1

sql = "select t_menu1 from site_info"
Set dr=db.execute(sql)

If dr.eof Or dr.bof Then
	t_menu1 = "학원소개"
Else
	t_menu1 = dr(0)
dr.close
End if
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function viewFaq(idx){
	window.open("guidepreivew.asp?idx=" + idx,"preview","width=870,height=600,scrollbars=yes,top=0,left=0");
}
function delGuid(idx){
	var delok = confirm("정말로  삭제하시겠습니까?");
	if(delok){
		location.href="delguide.asp?idx=" + idx;
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>안내문관리</h2>

		<div class="tbl_top">
			<a href="guidewrite.asp" class="fbtn1">안내문 등록하기</a>	
		</div>

<%		
sql="select count(idx) from guideTab where gbn = 0"
set dr=db.execute(sql)
		
board_count = dr(0)

sql = "select idx,jemok,gbn from guideTab where gbn = 0 order by ordnum asc,idx desc"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
	isRecod1 = True
	isRows = Split(dr.Getstring(2),chr(13))
end if
dr.close				
					
					if isRecod1 then %>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:10%" />
			<col />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>노출순서</th>	
					<th>하단링크 제목</th>
					<th>미리보기</th>
					<th>수정</th>	
					<th>삭제</th>								
				</tr>				
			</thead>
			<tbody>
	<% for ii = 0 to Ubound(isRows) - 1
										isCols = Split(isRows(ii),chr(9) )%>
				<tr>
					<td><%if ii+1 > 1 then%><a href="gup.asp?idx=<%=isCols(0)%>"><img src="/yes_rad/rad_img/a_up.gif" width="8" height="8" border="0"></a>&nbsp;<%end if%><%if board_count <> ii+1 then%><a href="gdown.asp?idx=<%=isCols(0)%>"><img src="/yes_rad/rad_img/a_down.gif" width="8" height="8" border="0"></a><%end if%></td>
					<td class="tl"><%=isCols(1)%></td>
					<td><a href="javascript:viewFaq('<%=isCols(0)%>');" class="btns">미리보기</a></td>
					<td><a href="guidewrite.asp?idx=<%=isCols(0)%>" class="btns trans">수정</a></td>
					<td><a href="javascript:delGuid('<%=isCols(0)%>');" class="btns trans">삭제</a></td>
				</tr>
	<% Next %>
			</tbody>
		</table>
<% end if %>

<%					
sql="select count(idx) from guideTab where gbn = 1"
set dr=db.execute(sql)
		
board_count = dr(0)

sql = "select idx,jemok,gbn from guideTab where gbn = 1 order by ordnum asc,idx desc"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
	isRecod2 = True
	isRows = Split(dr.Getstring(2),chr(13))
end if
dr.close				
					
					if isRecod2 then %>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:10%" />
			<col />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>노출순서</th>	
					<th>고객센터 제목</th>
					<th>미리보기</th>
					<th>수정</th>	
					<th>삭제</th>								
				</tr>				
			</thead>
			<tbody>
	<% for ii = 0 to Ubound(isRows) - 1
										isCols = Split(isRows(ii),chr(9) )%>
				<tr>
					<td><%if ii+1 > 1 then%><a href="gup.asp?idx=<%=isCols(0)%>"><img src="/yes_rad/rad_img/a_up.gif" width="8" height="8" border="0"></a>&nbsp;<%end if%><%if board_count <> ii+1 then%><a href="gdown.asp?idx=<%=isCols(0)%>"><img src="/yes_rad/rad_img/a_down.gif" width="8" height="8" border="0"></a><%end if%></td>
					<td class="tl"><%=isCols(1)%></td>
					<td><a href="javascript:viewFaq('<%=isCols(0)%>');" class="btns">미리보기</a></td>
					<td><a href="guidewrite.asp?idx=<%=isCols(0)%>" class="btns trans">수정</a></td>
					<td><a href="javascript:delGuid('<%=isCols(0)%>');" class="btns trans">삭제</a></td>
				</tr>
	<% Next %>
			</tbody>
		</table>
<% end if %>

<%					
sql="select count(idx) from guideTab where gbn = 2"
set dr=db.execute(sql)
		
board_count = dr(0)

sql = "select idx,jemok,gbn from guideTab where gbn = 2 order by ordnum asc,idx desc"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
	isRecod3 = True
	isRows = Split(dr.Getstring(2),chr(13))
end if
dr.close				
					
					if isRecod3 then %>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:10%" />
			<col />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>노출순서</th>	
					<th><%=t_menu1%> 제목</th>
					<th>미리보기</th>
					<th>수정</th>	
					<th>삭제</th>								
				</tr>				
			</thead>
			<tbody>
	<% for ii = 0 to Ubound(isRows) - 1
										isCols = Split(isRows(ii),chr(9) )%>
				<tr>
					<td><%if ii+1 > 1 then%><a href="gup.asp?idx=<%=isCols(0)%>"><img src="/yes_rad/rad_img/a_up.gif" width="8" height="8" border="0"></a>&nbsp;<%end if%><%if board_count <> ii+1 then%><a href="gdown.asp?idx=<%=isCols(0)%>"><img src="/yes_rad/rad_img/a_down.gif" width="8" height="8" border="0"></a><%end if%></td>
					<td class="tl"><%=isCols(1)%></td>
					<td><a href="javascript:viewFaq('<%=isCols(0)%>');" class="btns">미리보기</a></td>
					<td><a href="guidewrite.asp?idx=<%=isCols(0)%>" class="btns trans">수정</a></td>
					<td><a href="javascript:delGuid('<%=isCols(0)%>');" class="btns trans">삭제</a></td>
				</tr>
	<% Next %>
			</tbody>
		</table>
<% end if %>


	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->