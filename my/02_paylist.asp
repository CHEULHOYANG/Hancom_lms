<!-- #include file="../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file="../include/dbcon.asp" -->
<%
Dim intpg,blockPage,pagecount,recordcount,lyno,end_check
Dim tabnm : tabnm = "order_mast"

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 10

Dim strClmn : strClmn = " titlenm = dbo.LectuTitle(tabidx,buygbn),title,regdate,(intprice-cprice-cash)+send_price,paytype=dbo.PayTypeStr(paytype),state=case state when 0 then 'btn_11.gif' else 'btn_10.gif' end,state,eday,bookidx,s_state "

sql = "select Count(idx) from " & tabnm & " where id='" & str_User_ID & "' "
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
</script>

<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>결제내역</h3>
        </div>
        <div class="scont">

			<table class="btbl mb80" style="width:830px">
					<colgroup>
						<col style="width:8%" />
						<col style="width:42%" />
						<col style="width:14%" />
						<col style="width:12%" />
						<col style="width:10%" />
						<col style="width:14%" />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>								
							<th>강좌명</th>
							<th>결제금액</th>
							<th>결제방식</th>
							<th>상태</th>		
							<th>결제일</th>
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
			 
		end_check = DateDiff("d", date(),isCols(7))
%>
				<tr>
					<td><%=lyno%></td>
					<td class="tl"><%If isCols(8) = 1  Then response.write"<font color='#CC0000'>[교재]</font>&nbsp;" Else response.write"<font color='#336699'>[강의]</font>&nbsp;" End if%><%=isCols(1)%><%=isCols(0)%></td>
					<td><strong class="fs-red1"><%=formatnumber(isCols(3),0)%></strong>원</td>
					<td><%=isCols(4)%></td>
					<td><%if isCols(6)=0 or isCols(6)=2 then%><font color='#000000'>결제완료</font><%else%><font color='#cc0000'>미결제</font><%end if%></td>
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
%>
			<img src="../img/img/a_prev2.gif" alt="처음페이지">
			<img src="../img/img/a_prev1.gif" alt="이전페이지">
<% else %>
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
	
if blockPage > pagecount then %>
			<img src="../img/img/a_next1.gif" alt="다음페이지">
			<img src="../img/img/a_next2.gif" alt="마지막페이지">
<% else %>
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