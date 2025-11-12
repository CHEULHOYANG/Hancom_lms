<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim dr,rownum,isRecod,isRows,isCols
dim idx,id,regdate,result
dim sql,rs,sql1,rs1
dim page,recordcount,pagecount,totalpage,i,blockpage,pagesize,index
dim searchstr,searchpart

if request("page")="" then
   page=1
   else 
   page=request("page")
end if

If request("gm1") = 0 then

	pagesize = 50
	response.cookies("gm1") = 50

Else

	pagesize = request("gm1")
	response.cookies("gm1") = request("gm1")

End if

If Len(request("p_idx")) = 0 Then

	if request("searchstr")="" Then
		
		sql = "select count(idx) as reccount from question_result"
		set rs=db.execute(sql)
		recordcount =rs(0)
		pagecount=int((recordcount-1)/pagesize)+1
		sql = "SELECT top " & pagesize & " idx,id,regdate,result,(select title from question_list where idx = A.p_idx) from question_result A where idx not in"
		sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from question_result order by idx desc) order by idx desc"
		set rs=db.execute(sql)

	else

		searchstr=request("searchstr")
		searchpart=request("searchpart")

		sql = "select count(idx) as reccount from question_result where "& searchpart &" like '%"& searchstr &"%'"
		set rs=db.execute(sql)
		recordcount =rs(0)
		pagecount=int((recordcount-1)/pagesize)+1
		sql = "SELECT top " & pagesize & " idx,id,regdate,result,(select title from question_list where idx = A.p_idx) from question_result A where "& searchpart &" like '%"& searchstr &"%' and idx not in"
		sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from question_result where "& searchpart &" like '%"& searchstr &"%' order by idx desc) order by idx desc"
		set rs=db.execute(sql)

	end If

Else

	if request("searchstr")="" Then
		
		sql = "select count(idx) as reccount from question_result where p_idx= "& request("p_idx") &""
		set rs=db.execute(sql)
		recordcount =rs(0)
		pagecount=int((recordcount-1)/pagesize)+1
		sql = "SELECT top " & pagesize & " idx,id,regdate,result,(select title from question_list where idx = A.p_idx) from question_result A where p_idx= "& request("p_idx") &" and idx not in"
		sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from question_result where p_idx= "& request("p_idx") &" order by idx desc) order by idx desc"
		set rs=db.execute(sql)

	else

		searchstr=request("searchstr")
		searchpart=request("searchpart")

		sql = "select count(idx) as reccount from question_result where p_idx= "& request("p_idx") &" and "& searchpart &" like '%"& searchstr &"%'"
		set rs=db.execute(sql)
		recordcount =rs(0)
		pagecount=int((recordcount-1)/pagesize)+1
		sql = "SELECT top " & pagesize & " idx,id,regdate,result,(select title from question_list where idx = A.p_idx) from question_result A where p_idx= "& request("p_idx") &" and "& searchpart &" like '%"& searchstr &"%' and idx not in"
		sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from question_result where p_idx= "& request("p_idx") &" and "& searchpart &" like '%"& searchstr &"%' order by idx desc) order by idx desc"
		set rs=db.execute(sql)

	end If


End if

%>
<!--#include file="../main/top.asp"-->
<script>
function quiz_del(idx,page,searchpart,searchstr){
		var bool = confirm("삭제하시겠습니까?");
		if (bool){
			location.href = "result_del.asp?idx="+idx+"&page="+page+"&searchpart="+searchpart+"&searchstr="+searchstr;
		}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>설문지참여결과</h2>

<form name="form1" method="post" action="result.asp">
<input type="hidden" name="p_idx" value="<%=request("p_idx")%>">
		<div class="schWrap1">
			<h3>검색</h3>
			<div class="sch_area1">
				<select id="searchpart" name="searchpart" class="seltxt">
					<option value="id" <%If request("searchpart") = "id" Then Response.write"selected" End if%>>아이디</option>
				</select>
				<input type="text" name="searchstr" id="searchstr" class="inptxt" value="<%=request("searchstr")%>" /></div>
			<a href="javascript:document.form1.submit();" class="btn_search1">검색</a>		
		</div>
</form>

		<div class="tbl_top">
			<form name="form2" method="post" action="?">
			<input type="hidden" name="searchpart" value="<%=request("searchpart")%>">
			<input type="hidden" name="searchstr" value="<%=request("searchstr")%>">
			<select name="p_idx" id="p_idx" class="seltxt" onChange="document.form2.submit();">
                <option<% if Len(request("p_idx")) = 0 then response.write " selected" %> value="">전체</option>
                <%
sql1 = "select idx,title,date1,date2 from question_list order by idx desc "
set rs1=db.execute(sql1)

if rs1.eof or rs1.bof then
else
do until rs1.eof
%>
                <option<% if request("p_idx") = ""& rs1(0) &"" then response.write " selected" %> value="<%=rs1(0)%>">[<%=rs1(2)%>~<%=rs1(3)%>] <%=rs1(1)%></option>
                <%
rs1.movenext
loop
rs1.close
end if
%>
            </select>
			</form>

<form name="gm_form1" method="post" action="?">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="searchpart" value="<%=request("searchpart")%>">
<input type="hidden" name="searchstr" value="<%=request("searchstr")%>">
<input type="hidden" name="p_idx" value="<%=request("p_idx")%>">
				<select name="gm1" id="gm1" onChange="document.gm_form1.submit();" style="margin:0 0 0 10px">
                <option<% if request("gm1") = "20" then response.write " selected" %> value="20">20</option>
				<option<% if request("gm1") = "50" then response.write " selected" %> value="50">50</option>
				<option<% if request("gm1") = "70" then response.write " selected" %> value="70">70</option>
				<option<% if request("gm1") = "100" then response.write " selected" %> value="100">100</option>
              </select>
</form>
			<span class="tbl_total">전체 <%=recordcount%>건 (<%=page%>page/<%=pagecount%>pages)</span>
		</div>

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col style="width:20%" />
			<col />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:8%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>참여설문</th>
					<th>설문작성내용</th>
					<th>아이디</th>	
					<th>등록일시</th>
					<th>기능</th>
				</tr>				
			</thead>
			<tbody>
<%
if rs.eof or rs.bof then
Else

Index = (pagesize + recordcount) - (page * pagesize) + 1		
do until rs.eof
Index = Index - 1

idx = rs(0)
id = rs(1)
regdate = rs(2)
result = rs(3)
%>
				<tr>
					<td><%=index%></td>
					<td><strong class="fb"><%=rs(4)%></strong></td>
					<td class="tl"><%=result%></td>
					<td><%=id%></td>
					<td><%=right(FormatDateTime(regdate,2),10)%>&nbsp;<%=FormatDateTime(regdate,4)%></td>
					<td><a href="javascript:quiz_del('<%=idx%>','<%=page%>','<%=request("searchpart")%>','<%=request("searchstr")%>');" class="btns trans">삭제</a></td>
				</tr>
<%
rs.movenext
Loop
rs.close
end if
%>
			</tbody>
		</table>

		<div class="cbtn mb80">
			<div class="paging">
				<a href="?page=1&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>&p_idx=<%=request("p_idx")%>"><img src="/yes_rad/rad_img/img/a_prev2.gif" alt="처음페이지"></a>
<%
blockPage=Int((page-1)/10)*10+1
if blockPage = 1 Then
Else
%>
<a href="?page=<%=blockPage-10%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>&p_idx=<%=request("p_idx")%>"><img src="/yes_rad/rad_img/img/a_prev1.gif" alt="이전페이지" /></a>
<%
End If
   i=1
   Do Until i > 10 or blockPage > pagecount
      If blockPage=int(page) Then
%>
<strong><%=blockPage%></strong>
<%Else%>
<a href="?page=<%=blockPage%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>&p_idx=<%=request("p_idx")%>" class="num"><%=blockPage%></a>
<%
End If    
blockPage=blockPage+1
i = i + 1
Loop

if blockPage > pagecount Then
Else
%>
<a href="?page=<%=blockPage%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>&p_idx=<%=request("p_idx")%>"><img src="/yes_rad/rad_img/img/a_next1.gif" alt="다음페이지"></a>
<%
End If
%>	
				<a href="?page=<%=pagecount%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>&p_idx=<%=request("p_idx")%>"><img src="/yes_rad/rad_img/img/a_next2.gif" alt="마지막페이지"></a>			
			</div>
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->