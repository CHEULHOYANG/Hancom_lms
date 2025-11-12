<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs,rs1
dim page,recordcount,pagecount,totalpage,i,blockpage,pagesize
dim searchstr,searchpart
dim idx,title,gu,bun,m_level,s_type,main,sid

if request("page")="" then
   page=1
   else 
   page=request("page")
end if

pagesize = 20

sql = "select count(idx) as reccount from cal_mast"
set rs=db.execute(sql)
	
recordcount =rs(0)	
pagecount=int((recordcount-1)/pagesize)+1
	
sql = "SELECT top " & pagesize & " idx,title,gu,bun,m_level,s_type,main,sid from cal_mast where idx not in"
sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from cal_mast order by idx desc ) order by idx desc"
set rs=db.execute(sql)
%>

<!--#include file="../main/top.asp"-->

<script>
function check_del(theForm){

var num = <%=recordcount%>;
var sel_check = false;

if(num == 0) alert("삭제할 달력이 없습니다");


else if(num == 1) {


    if(frmlist.idx.checked) sel_check = true;
    if(sel_check){
            var del_check = window.confirm("체크한 달력을 일괄삭제합니다");
            if(del_check) 
			document.frmlist.action="check_del.asp";
			document.frmlist.submit();
    } else alert("삭제할 달력을 선택해주세요.");


} else if(num > 1) {


    var idx_len = theForm.idx.length;

    for (i=0; i < idx_len; i++){
         if(theForm.idx[i].checked){
            sel_check = true;
            break;
         }
    }
    if(sel_check){
         var del_check = window.confirm("체크한 달력을 일괄삭제합니다"); 
         if(del_check)
		 document.frmlist.action="check_del.asp";
		 document.frmlist.submit();
     } else alert("삭제할 달력을 선택해주세요");


}


} 
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>일정관리</h2>

		<div class="tbl_top">
			<a href="input.asp" class="fbtn1">일정등록</a>	
		</div>

<form name="frmlist" method="post" >
<input type="hidden" name="page" value="<%=page%>">
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th><input type="checkbox" name="CheckAll" onClick="ToggleCheckAll(this)"></th>	
					<th>일정제목</th>
					<th>일정보기</th>
					<th>스킨형태</th>	
					<th>기능</th>								
				</tr>				
			</thead>
			<tbody>
<%
if rs.eof or rs.bof then
else
i=1
do until rs.eof

idx = rs(0)
title = rs(1)
gu = rs(2)
bun = rs(3)
m_level = rs(4)
s_type = rs(5)
main = rs(6)
sid = rs(7)
%>
				<tr>
					<td><input type="checkbox" name="idx" value="<%=sid%>"></td>					
					<td class="tl"><strong class="fb"><%=title%></strong><br />표시사항 : <%if bun = 0 then response.write"사용" else response.write"미사용" end if%>&nbsp;,&nbsp;<%if s_type = 0 then response.write"분류명" end if%><%if s_type = 1 then response.write"제목" end if%><%if s_type = 2 then response.write"분류명+제목" end if%><%
		sql="select idx,title,bg_color,font_color from cal_gu_mast where sid = '"& sid &"' order by ordnum asc,idx desc"
		set rs1 = db.execute(sql)
		if rs1.eof or rs1.bof then
		Else
		Response.write"<br />"
		do until rs1.eof						
						%><span style="padding:5px 5px;background-color:<%=rs1(2)%>;font-size:8pt; color:<%=rs1(3)%>;letter-spacing:-1px;"><%=rs1(1)%></span>&nbsp;<%
						rs1.movenext
						loop
						rs1.close
						end if
						%></td>
					<td><a href="view.asp?sid=<%=sid%>" class="btns">일정보기</a></td>
					<td><%if gu=0 then response.write"달력형" else response.write"목록형" end if%></td>
					<td><a href="edit.asp?idx=<%=idx%>&page=<%=page%>&searchpart=<%=request("searchpart")%>&searchstr=<%=request("searchstr")%>" class="btns trans">수정</a></td>
				</tr>
<%
			  rs.movenext
			  i=i+1
			  Loop
			  rs.close
			  end if
%>
			</tbody>
		</table>
</form>

			<div class="tbl_btm mb80">
			<div class="paging">
				<a href="?page=1"><img src="/yes_rad/rad_img/img/a_prev2.gif" alt="처음페이지"></a>
<%
blockPage=Int((page-1)/10)*10+1
if blockPage = 1 Then
Else
%>
<a href="?page=<%=blockPage-10%>"><img src="/yes_rad/rad_img/img/a_prev1.gif" alt="이전페이지" /></a>
<%
End If
   i=1
   Do Until i > 10 or blockPage > pagecount
      If blockPage=int(page) Then
%>
<strong><%=blockPage%></strong>
<%Else%>
<a href="?page=<%=blockPage%>" class="num"><%=blockPage%></a>
<%
End If    
blockPage=blockPage+1
i = i + 1
Loop

if blockPage > pagecount Then
Else
%>
<a href="?page=<%=blockPage%>"><img src="/yes_rad/rad_img/img/a_next1.gif" alt="다음페이지"></a>
<%
End If
%>	
				<a href="?page=<%=pagecount%>"><img src="/yes_rad/rad_img/img/a_next2.gif" alt="마지막페이지"></a>			
			</div>
			<div class="rbtn">
				<a href="javascript:check_del(document.frmlist);" class="btn trans">선택삭제</a>			
			</div>
		</div>

	</div>
</div>
                
</body>
</html>
<!-- #include file = "../authpg_2.asp" -->