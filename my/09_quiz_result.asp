<!-- #include file="../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file="../include/dbcon.asp" -->
<%
Dim intpg,blockPage,pagecount,recordcount,lyno,rs,rs1,title,ca1,ca2,ca3,rank,ex_time,ok_count,no_count,sungjuk_show,i
Dim tabnm : tabnm = "quiz_result"

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 4

Dim strClmn : strClmn = " idx,id,regdate,user_dap,ok_dap,jumsu,g_idx,rank,ex_time,ok_count,no_count,dbo.quiz_title(g_idx),isnull(dbo.quiz_rank(g_idx,jumsu),1),dbo.quiz_sungjuk_show(g_idx) "

sql = "select Count(idx) from " & tabnm & " where id='" & str_User_ID & "'"
set dr = db.execute(sql)
recordcount = int(dr(0))

isRecod = True
pagecount=int((recordcount-1)/pagesize)+1
lyno = recordcount - ((intpg - 1) * pagesize)

sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where id='" & str_User_ID & "' and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " where id='" & str_User_ID & "' order by idx desc) order by idx desc"
set rs = db.execute(sql)
%>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function go2ListPage(pg){
	document.location.href="<%=nowPage%>?intpg=" + pg;
}
function quiz_pop(idx){ 

	document.form22.idx.value = idx;
	
	 TG_PAY = window.open("","yesoft_quiz", "height=30,width=30,scrollbars=yes");
     TG_PAY.focus();        
     document.form22.target="yesoft_quiz";
     document.form22.action="/quiz/quiz_again.asp";
	 document.form22.submit();
} 
</script>

<!-- #include file="../include/top.asp" -->
<form name="form22" method="post">
<input type="hidden" name="idx">
</form>
<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>문제풀이결과</h3>
        </div>
        <div class="scont">

			<table class="btbl mb80" style="width:830px">
					<colgroup>
						<col style="width:12.5%" />
						<col style="width:12.5%" />
						<col style="width:12.5%" />
						<col style="width:12.5%" />
						<col style="width:12.5%" />
						<col style="width:12.5%" />
						<col style="width:12.5%" />
						<col style="width:12.5%" />
					</colgroup>
					<tbody>
<%
if rs.eof or rs.bof then
Else
i = 1
do until rs.eof		 

if rs(13) = 0 then
%>
						  <tr>
							<th <%If i Mod 2 = 0 then response.write"style='background:#E3FDEE;'" End if%>>문제지정보</th>
							<td colspan="7" class="tl fr">[<%=replace(formatdatetime(rs(2),2),"-",".")%>]&nbsp;<%=rs(11)%></td>
						  </tr>
						  <tr>
							<th <%If i Mod 2 = 0 then response.write"style='background:#E3FDEE;'" End if%>>작성답안</th>
							<td colspan="7" class="tl"><%=rs(3)%></td>
						  </tr>
						  <tr>
							<th <%If i Mod 2 = 0 then response.write"style='background:#E3FDEE;'" End if%>>정답</th>
							<td colspan="7" class="tl"><%=rs(4)%></td>
						  </tr>
						  <tr>
							<th <%If i Mod 2 = 0 then response.write"style='background:#E3FDEE;'" End if%>>맞은갯수</th>
							<td><%=rs(9)%></td>
							<th <%If i Mod 2 = 0 then response.write"style='background:#E3FDEE;'" End if%>>틀린갯수</th>
							<td><%=rs(10)%></td>
							<th <%If i Mod 2 = 0 then response.write"style='background:#E3FDEE;'" End if%>>점수</th>
							<td><%=rs(5)%>점(<%=rs(12)%>등)</td>
							<th <%If i Mod 2 = 0 then response.write"style='background:#E3FDEE;'" End if%>>풀이시간</th>
							<td><%=rs(8)%></td>
						  </tr>
						  <tr>
							<td colspan="8"><%If rs(10) > 0 then%><a href="javascript:quiz_pop(<%=rs(0)%>);" class="fbtn">오답노트</a> <%End if%><a href="/quiz/view.asp?idx=<%=rs(6)%>" class="fbtn">다시풀기</a></td>
						  </tr>
<%else%>
						  <tr>
							<td colspan="8" class="tl fr">[<%=replace(formatdatetime(rs(2),2),"-",".")%>]&nbsp;<%=rs(11)%> 해당 시험 결과는 비공개입니다</td>
						  </tr>
<%
end if

rs.movenext
i = i + 1
loop
end if
%>	
					</tbody>
				</table>

<%if isRecod then%>
		<div class="paging">
<%
blockPage = int((intpg-1)/10) * 10 + 1

if blockPage = 1 Then
else %>
			<a href="javascript:go2ListPage('1');"><img src="../img/img/a_prev2.gif" alt="처음페이지"></a>			
			<a href="javascript:go2ListPage('<%=int(blockPage-1)%>');"><img src="../img/img/a_prev1.gif" alt="이전페이지"></a>
<% end if

ii = 1
Do Until ii > 10 or blockPage > pagecount
	if blockPage = int(intpg) then 
%>
			<strong><%=blockPage%></strong>
<%	else	%>
			<a href="javascript:go2ListPage('<%=blockPage%>');" class="pnum"><%=blockPage%></a>
<%
end if
	blockPage = blockPage + 1
    ii = ii + 1
	Loop
	
if blockPage > pagecount then 
else %>
			<a href="javascript:go2ListPage('<%=blockPage%>');"><img src="../img/img/a_next1.gif" alt="다음페이지"></a>			
			<a href="javascript:go2ListPage('<%=pagecount%>');"><img src="../img/img/a_next2.gif" alt="마지막페이지"></a>
<%End if%>
		</div>		
<%End if%>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->
<% else %><!-- #include file = "../include/false_pg.asp" -->
<% end if 

Function cutStr(str, cutLen)
	Dim strLen, strByte, strCut, strRes, char, i
	strLen = 0
	strByte = 0
	strLen = Len(str)
	for i = 1 to strLen
		char = ""
		strCut = Mid(str, i, 1)
		char = Asc(strCut)
		char = Left(char, 1)
		if char = "-" then
			strByte = strByte + 2
		else
			strByte = strByte + 1
		end if
		if cutLen < strByte then
			strRes = strRes & ".."
			exit for
		else
			strRes = strRes & strCut
		end if
	next
	cutStr = strRes
End Function
%>