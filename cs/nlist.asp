<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<%
Dim sql1,rs1
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim tabnm : tabnm = "notice"
Dim sq : sq = ""
Dim j,k

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 20

Dim strClmn : strClmn = " idx,jemok,wday,readnum "

If Len(request("searchstr")) > 0 then
	
	If request("searchpart") = "0" Then	sq = " jemok like '%"& request("searchstr") &"%'"
	If request("searchpart") = "1" Then	sq = " neyong like '%"& request("searchstr") &"%'"
	If request("searchpart") = "2" Then	sq = " (jemok like '%"& request("searchstr") &"%' or neyong like '%"& request("searchstr") &"%') "

	sql = "select Count(idx) from " & tabnm &" where notice = 0 and "& sq &""
else
	sql = "select Count(idx) from " & tabnm &" where notice = 0"
End If

set dr = db.execute(sql)
recordcount = int(dr(0))
dr.close

if recordcount > 0 then
	isRecod = True
	pagecount=int((recordcount-1)/pagesize)+1
	lyno = recordcount - ((intpg - 1) * pagesize)
end if
%>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function go2ListPage(pg){
	document.location.href="<%=nowPage%>?searchpart=<%=request("searchpart")%>&searchstr=<%=request("searchstr")%>&intpg=" + pg;
}
function go3Search(){
	var clmn = sform.searchstr;
	if(clmn.value==""){
		alert("조회할 단어를 입력해주세요!");
		clmn.focus();
		return false;
	}

	if(clmn.value.replace(/ /g,"")==""){
		alert("조회할 단어를 입력해주세요!");
		clmn.select();
		return false;
	}

	if(clmn.value.length< 2){
		alert("조회할 단어는 2자 이상 입력해야 합니다.");
		clmn.select();
		return false;
	}

	document.sform.submit();

}
</script>

<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>공지사항</h3>
        </div>
        <div class="scont">

<table class="btbl" style="width:830px">
                        <colgroup>
                        <col style="width:10%" />
                        <col style="width:75%" />
                        <col style="width:10%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>제목</th>
                                <th class="bkn">등록일</th>
                            </tr>
                        </thead>
                        <tbody>

<%
	If Len(request("searchstr")) > 0 then
		sql1 = "select  " & strClmn & "from " & tabnm & " where notice = 1 and "& sq &" order by idx desc"
	Else
		sql1 = "select  " & strClmn & "from " & tabnm & " where notice = 1 order by idx desc"
	End If
	Set rs1 = db.execute(sql1)

	If rs1.eof Or rs1.bof Then
	Else
	Do Until rs1.eof
%>

				<tr>
					<td><strong>공지</strong></td>
					<td class="tl"><a href="nneyong.asp?idx=<%=rs1(0)%>&intpg=<%=intpg%>&searchpart=<%=request("searchpart")%>&searchstr=<%=request("searchstr")%>"><%=rs1(1)%><%if DateDiff("h",rs1(2),Now()) < 6 then 
response.write"&nbsp;&nbsp;<img src=../img/new.gif align=absmiddle>"
	end if%></a></td>
					<td><%=replace(formatdatetime(rs1(2),2),"-",".")%></td>
				</tr>
<%
	rs1.movenext
	Loop
	rs1.close
	End if
 
if isRecod then

	If Len(request("searchstr")) > 0 then
		sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where notice = 0 and "& sq &" and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " where notice = 0 and "& sq &" order by idx desc) order by idx desc"
	Else
		sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where notice = 0 and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " where notice = 0 order by idx desc) order by idx desc"
	End If

	set dr = db.execute(sql)
	isRows = split(dr.GetString(2),chr(13)) 

	for ii = 0 to UBound(isRows) - 1
	isCols = split(isRows(ii),chr(9))
%>
				<tr>
					<td><%=lyno%></td>
					<td class="tl"><a href="nneyong.asp?idx=<%=isCols(0)%>&intpg=<%=intpg%>&searchpart=<%=request("searchpart")%>&searchstr=<%=request("searchstr")%>"><%=isCols(1)%><%if DateDiff("h",isCols(2),Now()) < 6 then 
response.write"&nbsp;&nbsp;<img src=../img/new.gif align=absmiddle>"
	end if%></a></td>
					<td><%=replace(formatdatetime(isCols(2),2),"-",".")%></td>
				</tr>
<%
	lyno = lyno - 1
	Next

else
End if%>

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


<form name="sform" method="post" action="?">
                <div class="boardSch">
                    <fieldset>
                        <select id="searchpart" name="searchpart" class="seltxt1 w100">
							<option value="0" <%If request("searchpart") = "0" Then response.write"selected" End if%>>제목</option>
							<option value="1" <%If request("searchpart") = "1" Then response.write"selected" End if%>>내용</option>
							<option value="2" <%If request("searchpart") = "2" Then response.write"selected" End if%>>제목+내용</option>
                        </select>
                        <input type="text" name="searchstr" id="searchstr" class="inptxt1" value="<%=request("searchstr")%>" />
                        <a href="javascript:go3Search();" class="fbtn grey">검색하기</a>
                    </fieldset>
                </div>
</form>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->