<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<%
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim tabnm : tabnm = "faqTab"
Dim gbnS,strSearch,varPage

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 20

Dim strClmn : strClmn = " idx,jemok "

dim ssqll
if Len(Request("searchstr")) = 0 then
	varPage = "gbnS=&strSearch="

	sql = "select Count(idx) from " & tabnm
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		ssqll = "select  top " & pagesize & strClmn & "from " & tabnm & " where idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " order by idx desc) order by idx desc"
	end if

else
	varPage = "searchpart=" & request("searchpart") & "&searchstr=" & request("searchstr")

	dim query
	If request("searchpart") = "0" then	query = " jemok like '%" & Replace(request("searchstr"),"'","''") & "%'"
	If request("searchpart") = "1" then	query = " neyong like '%" & Replace(request("searchstr"),"'","''") & "%'"
	If request("searchpart") = "2" then	query = " (jemok like '%" & Replace(request("searchstr"),"'","''") & "%' or neyong like '%" & Replace(request("searchstr"),"'","''") & "%')"

	sql = "select count(idx) from " & tabnm & " where " & query
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		ssqll = "select  top " & pagesize & strClmn & "from " & tabnm & " where " & query & " and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " where " & query & " order by idx desc) order by idx desc"
	end if
end if %>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function go2ListPage(pg){
	document.location.href="<%=nowPage%>?intpg=" + pg + "&<%=varPage%>";
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
        	<h3>자주묻는질문</h3>
        </div>
        <div class="scont">

<table class="btbl" style="width:830px">
                        <colgroup>
                        <col style="width:10%" />
                        <col />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th class="bkn">제목</th>
                            </tr>
                        </thead>
                        <tbody>

<% 
if isRecod then

	set dr = db.execute(ssqll)
	isRows = split(dr.GetString(2),chr(13))

	for ii = 0 to UBound(isRows) - 1
	isCols = split(isRows(ii),chr(9))
%>
				<tr>
					<td><%=lyno%></td>
					<td class="tl"><a href="fneyong.asp?idx=<%=isCols(0)%>&intpg=<%=intpg%>&<%=varPage%>"><%=isCols(1)%></a></td>
				</tr>
<%
	lyno = lyno - 1
	Next

else
End if%>

                        </tbody>
                    </table>

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

<form name="sform" method="post" action="?" onsubmit="return go3Search();">
                <div class="boardSch">
                    <fieldset>
                        <select name="searchpart" class="seltxt1 w100">
							<option value="0" <%If request("searchpart") = "0" Then response.write"selected" End if%>>제목</option>
							<option value="1" <%If request("searchpart") = "1" Then response.write"selected" End if%>>내용</option>
							<option value="2" <%If request("searchpart") = "2" Then response.write"selected" End if%>>제목+내용</option>
                        </select>
                        <input type="text" name="searchstr" class="inptxt1" value="<%=request("searchstr")%>" />
                        <a href="javascript:go3Search();" class="fbtn grey">검색하기</a>
                    </fieldset>
                </div>
</form>

        </div>
    </div>
</div>


<!-- #include file="../include/bottom.asp" -->