<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,id,files,title,regdate,info1,info2,info3,info4,info5,info6,info7,info8,info9,info10,print_check,down_check
dim page,recordcount,pagecount,totalpage,i,blockpage,pagesize
dim searchstr,searchpart,sql,rs,index

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

if request("searchstr")="" Then

sql = "select count(idx) as reccount from end_paper"
set rs=db.execute(sql)
recordcount =rs(0)
pagecount=int((recordcount-1)/pagesize)+1
sql = "SELECT top " & pagesize & " idx,id,files,title,regdate,info1,info2,info3,info4,info5,info6,info7,info8,info9,info10,print_check,down_check from end_paper where idx not in"
sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from end_paper) order by idx desc"
set rs=db.execute(sql)

else

searchstr=request("searchstr")
searchpart=request("searchpart")

sql = "select count(idx) as reccount from end_paper where "& searchpart &" like '%"& searchstr &"%'"
set rs=db.execute(sql)
recordcount =rs(0)
pagecount=int((recordcount-1)/pagesize)+1
sql = "SELECT top " & pagesize & " idx,id,files,title,regdate,info1,info2,info3,info4,info5,info6,info7,info8,info9,info10,print_check,down_check from end_paper where "& searchpart &" like '%"& searchstr &"%' and idx not in"
sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from end_paper where "& searchpart &" like '%"& searchstr &"%') order by idx desc"
set rs=db.execute(sql)

end if
%>
<!--#include file="../main/top.asp"-->
<script>

function quiz_del(idx,page,searchpart,searchstr){
		var bool = confirm("삭제하시겠습니까?");
		if (bool){
			location.href = "del.asp?idx="+idx+"&page="+page+"&searchpart="+searchpart+"&searchstr="+searchstr;
		}
}

function openWindow(url,width,height) {
	var widths = width;
	var heights = height;
	var top = 0; // 창이 뜰 위치 지정
	var left = 0;
	var temp2 = 'toolbar=no, width='+widths+',height='+heights+',top='+top+',left='+left;
	var temp = url;
	window.open(temp, 'notice1', temp2);
}

</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>수료증관리</h2>

<form name="form1" method="get" action="list.asp">
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

<form name="gm_form1" method="post" action="?">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="searchpart" value="<%=request("searchpart")%>">
<input type="hidden" name="searchstr" value="<%=request("searchstr")%>">

				<select name="gm1" id="gm1" onChange="document.gm_form1.submit();" style="margin:0 10px 0 0">
                <option<% if request("gm1") = "20" then response.write " selected" %> value="20">20</option>
				<option<% if request("gm1") = "50" then response.write " selected" %> value="50">50</option>
				<option<% if request("gm1") = "70" then response.write " selected" %> value="70">70</option>
				<option<% if request("gm1") = "100" then response.write " selected" %> value="100">100</option>
              </select>
</form>

			<a href="input.asp" class="fbtn1">수료증 수동등록</a>
			<span class="tbl_total">전체 <%=recordcount%>개(<%=page%>/<%=recordcount%>)</span>
		</div>

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col style="width:10%" />
			<col />
			<col style="width:15%" />
			<col style="width:8%" />
			<col style="width:8%" />
			<col style="width:10%" />
			<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>아이디</th>
					<th>수료증제목</th>
					<th>파일</th>	
					<th>다운여부</th>		
					<th>출력체크</th>		
					<th>등록일</th>
					<th>기능</th>
				</tr>				
			</thead>
			<tbody>
<%
if rs.eof or rs.bof then
else

Index = (pagesize + recordcount) - (page * pagesize) + 1		
do until rs.eof
Index = Index - 1

idx = rs(0)
id = rs(1)
files = rs(2)
title = rs(3)
regdate = rs(4)
info1 = rs(5)
info2 = rs(6)
info3 = rs(7)
info4 = rs(8)
info5 = rs(9)
info6 = rs(10)
info7 = rs(11)
info8 = rs(12)
info9 = rs(13)
info10 = rs(14)
print_check = rs(15)
down_check = rs(16)
%>
				<tr>
					<td><%=Index%></td>
					<td><%=id%></td>
					<td class="tl"><%=title%></td>
					<td><%=files%></td>
					<td><%=down_check%></td>
					<td><%=print_check%></td>
					<td><%=right(FormatDateTime(regdate,2),10)%></td>
					<td><a href="javascript:openWindow('print.asp?idx=<%=idx%>','1050','900');" class="btns">미리보기</a>
					<a href="edit.asp?idx=<%=idx%>&page=<%=page%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>" class="btns trans">수정</a>
					<a href="javascript:quiz_del('<%=idx%>','<%=page%>','<%=request("searchpart")%>','<%=request("searchstr")%>');" class="btns trans">삭제</a></td>
					
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