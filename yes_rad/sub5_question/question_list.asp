<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs
dim page,recordcount,pagecount,totalpage,i,blockpage,pagesize
dim idx,title,date1,date2,price
dim searchstr,searchpart,m_id,rs1,tca1,tca2,index

if request("page")="" then
   page=1
else 
   page=request("page")
end If

pagesize=10

if request("searchstr")="" Then

	sql = "select count(idx) as reccount from question_list"
	set rs=db.execute(sql)
	recordcount =rs(0)
	pagecount=int((recordcount-1)/pagesize)+1
	sql = "SELECT top " & pagesize & " idx,title,date1,date2,price from question_list where idx not in"
	sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from question_list) order by idx desc"
	set rs=db.execute(sql)

else

	searchstr=request("searchstr")
	searchpart=request("searchpart")

	sql = "select count(idx) as reccount from question_list where "& searchpart &" like '%"& searchstr &"%'"
	set rs=db.execute(sql)
	recordcount =rs(0)
	pagecount=int((recordcount-1)/pagesize)+1
	sql = "SELECT top " & pagesize & " idx,title,date1,date2,price from question_list where "& searchpart &" like '%"& searchstr &"%' and idx not in"
	sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from question_list where "& searchpart &" like '%"& searchstr &"%') order by idx desc"
	set rs=db.execute(sql)

end if
%>

<!--#include file="../main/top.asp"-->

<script>
function quiz_del(idx,page,searchpart,searchstr){
		var bool = confirm("삭제하시겠습니까?");
		if (bool){
			location.href = "question_del.asp?idx="+idx+"&page="+page+"&searchpart="+searchpart+"&searchstr="+searchstr;
		}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>설문지관리</h2>

<form name="form1" method="get" action="question_list.asp">
		<div class="schWrap1">
			<h3>검색</h3>
			<div class="sch_area1">
				<select id="searchpart" name="searchpart" class="seltxt">
                <option value="title" <%If request("searchpart") = "title" Then Response.write"selected" End if%>>제목</option>
				</select>
				<input type="text" name="searchstr" id="search_input" class="inptxt" value="<%=request("searchstr")%>" /></div>
			<a href="javascript:document.form1.submit();" class="btn_search1">검색</a>		
		</div>
</form>

		<div class="tbl_top">
			<a href="question_input.asp" class="fbtn1">설문등록</a>	
		</div>

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col />
			<col style="width:15%" />
			<col style="width:25%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>제목</th>
					<th>기간</th>
					<th>기능</th>	
				</tr>				
			</thead>
			<tbody>
<%
if rs.eof or rs.bof Then
else
Index = (pagesize + recordcount) - (page * pagesize) + 1		
do until rs.eof
Index = Index - 1
%>
				<tr>
					<td><%=index%></td>
					<td class="tl"><%=rs(1)%></td>
					<td><%=rs(2)%> ~ <%=rs(3)%></td>
					<td><a href="question_edit.asp?idx=<%=rs(0)%>&page=<%=page%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>" class="btns">수정</a> <a href="javascript:quiz_del('<%=rs(0)%>','<%=page%>','<%=request("searchpart")%>','<%=request("searchstr")%>');" class="btns">삭제</a> <a href="result1.asp?p_idx=<%=rs(0)%>" class="btns trans">항목결과</a> <a href="result.asp?p_idx=<%=rs(0)%>" class="btns trans">전체결과</a></td>					
				</tr>
<%
			  rs.movenext
			  loop
			  rs.close
			  end if
%>
			</tbody>
		</table>

		<div class="cbtn">
			<div class="paging">
				<a href="?page=1&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>"><img src="/yes_rad/rad_img/img/a_prev2.gif" alt="처음페이지"></a>
<%
blockPage=Int((page-1)/10)*10+1
if blockPage = 1 Then
Else
%>
<a href="?page=<%=blockPage-10%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>"><img src="/yes_rad/rad_img/img/a_prev1.gif" alt="이전페이지" /></a>
<%
End If
   i=1
   Do Until i > 10 or blockPage > pagecount
      If blockPage=int(page) Then
%>
<strong><%=blockPage%></strong>
<%Else%>
<a href="?page=<%=blockPage%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>" class="num"><%=blockPage%></a>
<%
End If    
blockPage=blockPage+1
i = i + 1
Loop

if blockPage > pagecount Then
Else
%>
<a href="?page=<%=blockPage%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>"><img src="/yes_rad/rad_img/img/a_next1.gif" alt="다음페이지"></a>
<%
End If
%>	
				<a href="?page=<%=pagecount%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>"><img src="/yes_rad/rad_img/img/a_next2.gif" alt="마지막페이지"></a>			
			</div>
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->