<!-- #include file="../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file="../include/dbcon.asp" -->
<%
Dim intpg,blockPage,pagecount,recordcount,lyno,end_check
Dim tabnm : tabnm = "end_paper"

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 10

Dim strClmn : strClmn = " idx,title,regdate,files "

sql = "select Count(idx) from " & tabnm & " where id='" & str_User_ID & "'"
set dr = db.execute(sql)
recordcount = int(dr(0))
dr.close

if recordcount > 0 then
	isRecod = True
	pagecount=int((recordcount-1)/pagesize)+1
	lyno = recordcount - ((intpg - 1) * pagesize)
end if %>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">

function go2ListPage(pg){
	document.location.href="<%=nowPage%>?intpg=" + pg;
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
<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->

    <div class="content">
    	<div class="cont_tit">
        	<h3>수료증출력</h3>
        </div>
        <div class="scont">
			<table class="btbl mb80" style="width:830px">
					<colgroup>
						<col style="width:8%" />
						<col style="width:52%" />
						<col style="width:15%" />
						<col style="width:15%" />
						<col style="width:10%" />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>								
							<th>제목</th>
							<th>출력하기</th>
							<th>다운받기</th>
							<th>등록일</th>
						</tr>				
					</thead>
					<tbody>
<%
if isRecod Then

	sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where id='" & str_User_ID & "' and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " where id='" & str_User_ID & "' order by idx desc) order by idx desc"
	set dr = db.execute(sql)
	isRows = split(dr.GetString(2),chr(13))

		for ii = 0 to UBound(isRows) - 1
		isCols = split(isRows(ii),chr(9))
			 
%>
				<tr>
					<td>&nbsp;<%=lyno%></td>
					<td class="tl">&nbsp;<%=isCols(1)%></td>
					<td><a href="javascript:openWindow('10_end_print.asp?idx=<%=isCols(0)%>','1050','942');" class="sbtn modify">인쇄하기</a></td>
					<td><%If Len(isCols(3)) > 0 then%><a href="10_end_down.asp?idx=<%=isCols(0)%>" class="sbtn resgn">다운로드</a><%End if%></td>
					<td><%=replace(formatdatetime(isCols(2),2),"-",".")%></td>					
				</tr>
<%
					lyno = lyno - 1
		next
End If
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
	
if blockPage > pagecount Then
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
<% end if %>