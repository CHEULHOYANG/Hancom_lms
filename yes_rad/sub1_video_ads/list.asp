<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim dr,rownum,isRecod,isRows,isCols,munje_count
dim idx,ca1,ca2,title,price,admin_gu,readnum,costnum,regdate,sql,rs
dim page,recordcount,pagecount,totalpage,i,blockpage,pagesize
dim munje_time1,munje_time2,munje_bang1,munje_bang2,munje_date1,munje_date2,munje_repeat,sec
dim searchstr,searchpart,m_id,rs1,tca1,tca2,index
dim gu

if request("page")="" then
   page=1
   else 
   page=request("page")
end if
pagesize=10

if request("searchstr")="" Then

	sql = "select count(idx) as reccount from quiz_munje"
	set rs=db.execute(sql)
	recordcount =rs(0)

	pagecount=int((recordcount-1)/pagesize)+1
	sql = "SELECT top " & pagesize & " idx,dbo.LecturTab_title(ca1),dbo.sectionTab_title(ca2),title,price,admin_gu,readnum,costnum,regdate,munje_time1,munje_time2,munje_bang1,munje_bang2,munje_date1,munje_date2,munje_repeat,dbo.quiz_category_title(tca1),dbo.quiz_category_title(tca2),sec,state,dbo.quiz_munje_list_count(idx) from quiz_munje where idx not in"
	sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from quiz_munje) order by idx desc"
	set rs=db.execute(sql)

else

	searchstr=request("searchstr")
	searchpart=request("searchpart")

	sql = "select count(idx) as reccount from quiz_munje where "& searchpart &" like '%"& searchstr &"%'"
	set rs=db.execute(sql)
	recordcount =rs(0)

	pagecount=int((recordcount-1)/pagesize)+1
	sql = "SELECT top " & pagesize & " idx,dbo.LecturTab_title(ca1),dbo.sectionTab_title(ca2),title,price,admin_gu,readnum,costnum,regdate,munje_time1,munje_time2,munje_bang1,munje_bang2,munje_date1,munje_date2,munje_repeat,dbo.quiz_category_title(tca1),dbo.quiz_category_title(tca2),sec,state,dbo.quiz_munje_list_count(idx) from quiz_munje where "& searchpart &" like '%"& searchstr &"%' and idx not in"
	sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from quiz_munje where "& searchpart &" like '%"& searchstr &"%') order by idx desc"
	set rs=db.execute(sql)

end if
%>
<!-- #include file = "../main/top.asp" -->
<script>
function quiz_del(idx,page,searchpart,searchstr){
		var bool = confirm("삭제하시겠습니까?");
		if (bool){
			location.href = "del.asp?idx="+idx+"&page="+page+"&searchpart="+searchpart+"&searchstr="+searchstr;
		}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>시험지관리</h2>

<form name="form1" method="post" action="list.asp">
		<div class="schWrap1">
			<h3>검색</h3>
			<div class="sch_area1">
				<select id="searchpart" name="searchpart" class="seltxt">
					<option value="title" <%If request("searchpart") = "title" Then Response.write"selected" End if%>>제목</option>
				</select>
				<input type="text" name="searchstr" id="searchstr" class="inptxt" value="<%=request("searchstr")%>" /></div>
			<a href="javascript:document.form1.submit();" class="btn_search1">검색</a>		
		</div>
</form>

		<div class="tbl_top">
			<a href="input.asp" class="fbtn1">시험 등록하기</a>	
			<span class="tbl_total">전체 <%=recordcount%>건 (<%=page%>page/<%=pagecount%>pages)</span>		
		</div>

<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col style="width:10%" />
			<col style="width:15%" />
			<col />
			<col style="width:10%" />
			<col style="width:8%" />
			<col style="width:15%" />
			<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>카테고리</th>
					<th>선택강좌</th>
					<th>제목</th>	
					<th>형태</th>								
					<th>문항</th>
					<th>구분</th>
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
idx = rs(0)
ca1 = rs(1)
ca2 = rs(2)
title = rs(3)
price = rs(4)
admin_gu = rs(5)
readnum = rs(6)
costnum = rs(7)
regdate = rs(8)
munje_time1 = rs(9)
munje_time2 = rs(10)
munje_bang1 = rs(11)
munje_bang2 = rs(12)
munje_date1 = rs(13)
munje_date2 = rs(14)
munje_repeat = rs(15)
tca1 = rs(16)
tca2 = rs(17)
sec = rs(18)
munje_count = rs(20)
%>
				<tr>
					<td><%=index%></td>
					<td><%=tca1%><%If Len(tca2) > 0 Then %> &gt; <%=tca2%><%End if%></td>
					<td><%If IsNull(ca1) then%>-<%else%><%=ca1%> &gt; <%=ca2%><%End if%></td>
					<td class="tl"><a href="edit.asp?idx=<%=idx%>&page=<%=page%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>"><%If rs(19) = 1 Then Response.write"[숨김]&nbsp;" End if%><%=title%></a></td>
					<td><%if price = 0 then response.write"무료" End if%><%if price = 1 then response.write"프리패스" End if%><%if price = 2 then response.write"쿠폰번호("& sec &")" End if%></td>
					<td><%=munje_count%>문제</td>
					<td><%if munje_date1=1 then%><%=munje_date2%><%if munje_time1<>"0" then response.write "("& munje_time1 &"~"& munje_time2 &")" end if%>/<%end if%><%if munje_repeat=0 then response.write"반복" else response.write"1회" end if%>/<%if munje_bang1=0 then response.write"순차" else response.write"랜덤" end if%>(<%if munje_bang2=0 then response.write"전체" else response.write"한문제" end if%>)</td>
					<td height="30" width="13%">
					<a href="../quiz_munje_list/list.asp?q_idx=<%=idx%>" target="_blank" class="btns trans">문제관리</a>
					<a href="edit.asp?idx=<%=idx%>&page=<%=page%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>" class="btns">수정</a>
					<a href="javascript:quiz_del('<%=idx%>','<%=page%>','<%=request("searchpart")%>','<%=request("searchstr")%>');" class="btns">삭제</a></td>
				</tr>
<%
rs.movenext
loop
rs.close
end if
%>
			</tbody>
		</table>

<div class="cbtn mb80">
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