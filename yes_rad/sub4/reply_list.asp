<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim page,recordcount,pagecount,totalpage,blockpage,pagesize
dim rs,vidx,vcat,sq,i,stitle,rs1,sql

sq = ""

If Len(request("strSearch")) > 0 Then sq = ""& request("strPart") &" = '"& request("strSearch") &"'"

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

If Len(sq) > 0 then

	sql = "select count(idx) as reccount from lec_reply where "& sq &""
	set rs=db.execute(sql)
	recordcount =rs(0)
	pagecount=int((recordcount-1)/pagesize)+1
	sql = "SELECT top " & pagesize & " idx,id,name,content,regdate,star,vidx,vcat,dbo.LecturTab_title(vidx) from lec_reply where "& sq &" and idx not in"
	sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from lec_reply where "& sq &" order by idx desc ) order by idx desc"
	set rs=db.execute(sql)

Else

	sql = "select count(idx) as reccount from lec_reply "
	set rs=db.execute(sql)
	recordcount =rs(0)
	pagecount=int((recordcount-1)/pagesize)+1
	sql = "SELECT top " & pagesize & " idx,id,name,content,regdate,star,vidx,vcat,dbo.LecturTab_title(vidx) from lec_reply where idx not in"
	sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from lec_reply order by idx desc ) order by idx desc"
	set rs=db.execute(sql)

End if
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function go2Del(idxnm){
	var delok = confirm("정말로 삭제하시겠습니까?");
	if(delok){
		location.href="reply_list_del.asp?page=<%=page%>&strPart=<%=request("strPart")%>&strSearch=<%=request("strSearch")%>&idx=" + idxnm;
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>수강후기관리</h2>

<form name="form1" method="get" action="reply_list.asp">
		<div class="schWrap1">
			<h3>검색</h3>
			<div class="sch_area1">
				<select id="strPart" name="strPart" class="seltxt w200">
				<option value="id" <%if request("strPart") = "id" then response.write"selected" end if%>>아이디</option>
                <option value="name" <%if request("strPart") = "name" then response.write"selected" end if%>>이름</option>
				</select>
				<input type="text" name="strSearch" id="strSearch" class="inptxt" value="<%=request("strSearch")%>" /></div>
			<a href="javascript:document.form1.submit();" class="btn_search1">검색</a>		
		</div>
</form>

		<div class="tbl_top">

<form name="gm_form1" method="post" action="?">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="strPart" value="<%=request("strPart")%>">
<input type="hidden" name="strSearch" value="<%=request("strSearch")%>">
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
			<col style="width:8%" />
			<col style="width:20%" />
			<col />
			<col style="width:8%" />
			<col style="width:10%" />
			<col style="width:8%" />
			<col style="width:8%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>강좌명</th>
					<th>수강후기</th>
					<th>평점</th>	
					<th>작성자</th>
					<th>등록일</th>
					<th>삭제</th>
				</tr>				
			</thead>
			<tbody>
<%
If rs.eof Or rs.bof Then
Else
Do Until rs.eof
stitle = rs(8)
%>
						<tr>
							<td><%=rs(0)%></td>
							<td><%=stitle%></td>
							<td class="tl"><%=replace(rs(3),chr(13) & chr(10),"<br>")%></td>
							<td><%for i=1 to int(rs(5)) %><img src="../rad_img/star_b.gif" width="10" height="10"><%next%><%for i=1 to 5-int(rs(5)) %><img src="../rad_img/star_g.gif" width="10" height="10"><%next%></td>
							<td><%=rs(2)%></td>
						    <td><%=Replace(Left(rs(4),10),"-",".")%></td>
						    <td><a href="javascript:go2Del('<%=rs(0)%>');" class="btns trans">삭제</a></td>
						</tr>
<%
rs.movenext
Loop
rs.close
End if
%>
			</tbody>
		</table>

<%If recordcount > 0 then%>
		<div class="cbtn mb80">
			<div class="paging">
				<a href="?page=1&strPart=<%=request("strPart")%>&strSearch=<%=request("strSearch")%>"><img src="/yes_rad/rad_img/img/a_prev2.gif" alt="처음페이지"></a>
<%
blockPage=Int((page-1)/10)*10+1
if blockPage = 1 Then
Else
%>
<a href="?page=<%=blockPage-10%>&strPart=<%=request("strPart")%>&strSearch=<%=request("strSearch")%>"><img src="/yes_rad/rad_img/img/a_prev1.gif" alt="이전페이지" /></a>
<%
End If
   i=1
   Do Until i > 10 or blockPage > pagecount
      If blockPage=int(page) Then
%>
<strong><%=blockPage%></strong>
<%Else%>
<a href="?page=<%=blockPage%>&strPart=<%=request("strPart")%>&strSearch=<%=request("strSearch")%>" class="num"><%=blockPage%></a>
<%
End If    
blockPage=blockPage+1
i = i + 1
Loop

if blockPage > pagecount Then
Else
%>
<a href="?page=<%=blockPage%>&strPart=<%=request("strPart")%>&strSearch=<%=request("strSearch")%>"><img src="/yes_rad/rad_img/img/a_next1.gif" alt="다음페이지"></a>
<%
End If
%>	
				<a href="?page=<%=pagecount%>&strPart=<%=request("strPart")%>&strSearch=<%=request("strSearch")%>"><img src="/yes_rad/rad_img/img/a_next2.gif" alt="마지막페이지"></a>			
			</div>
		</div>
<%End if%>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->