<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<%
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim tabnm : tabnm = "oneone"
Dim gbnS,strPart,strSearch
Dim varPage

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 10

Dim strClmn : strClmn = " qidx,quserid,qgbn,qtitle,qansgbn=case qansgbn when 1 then 'o' else 'x' end,regdate,uname "

dim ssqll
if Len(Request("searchstr")) = 0 Then

	varPage = "searchpart=&searchstr="

	sql = "select Count(qidx) from " & tabnm
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		ssqll = "select  top " & pagesize & strClmn & "from " & tabnm & " where qidx not in (select top " & ((intpg -1 ) * pagesize) & " qidx from " & tabnm & " order by qidx desc) order by qidx desc"
	end If
	
Else

	varPage = "searchpart=" & request("searchpart") & "&searchstr=" & request("searchstr") & ""

	dim query
	If request("searchpart") = "0" then	query = " qtitle like '%" & Replace(request("searchstr"),"'","''") & "%'"
	If request("searchpart") = "1" then	query = " qcont like '%" & Replace(request("searchstr"),"'","''") & "%'"
	If request("searchpart") = "2" then	query = " (qtitle like '%" & Replace(request("searchstr"),"'","''") & "%' or qcont like '%" & Replace(request("searchstr"),"'","''") & "%')"

	sql = "select count(qidx) from " & tabnm & " where " & query
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		ssqll = "select  top " & pagesize & strClmn & "from " & tabnm & " where " & query & " and qidx not in (select top " & ((intpg -1 ) * pagesize) & " qidx from " & tabnm & " where " & query & " order by qidx desc) order by qidx desc"
	end If
	
end if %>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function go2ListPage(pg){
	document.location.href="<%=nowPage%>?intpg=" + pg + "&<%=varPage%>";
}

function go2Neyong(idxn,vgbn){
	var vnum = parseInt(vgbn,10);

	if(vnum < 1){
		location.href="qneyong.asp?idx=" + idxn + "&intpg=<%=intpg%>&<%=varPage%>";
	}else{
		if(vnum == 1){
			alert("로그인 후에 이용하실 수 있습니다");
		}else{
			alert("비공개 글이므로 글쓴이 본인 이외에는 보실 수 없습니다!");
		}
	}
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
        	<h3>문의게시판</h3>
        </div>
        <div class="scont">

<table class="btbl" style="width:830px">
                        <colgroup>
                        <col style="width:10%" />
                        <col />
                        <col style="width:16%" />
                        <col style="width:16%" />
                        <col style="width:10%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>등록일</th>
                                <th class="bkn">답변</th>
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
					<td class="tl"><a href="javascript:go2Neyong('<%=isCols(0)%>',<%=viewProg(isCols(2),isCols(1))%>);"><%=isCols(3)%><%if DateDiff("h",isCols(5),Now()) < 6 then 
response.write"&nbsp;&nbsp;<img src=../img/new.gif align=absmiddle>"
	end if%></a></td>
					<td><%=Left(isCols(6),1)%>**</td>
					<td><%=replace(formatdatetime(isCols(5),2),"-",".")%></td>
					<td><%If isCols(4) = "o" Then response.write "<span class='dbtn blue'>답변</span>" Else response.write "<span class='dbtn'>대기</span>" End if%></td>
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
		<div class="cbtn"> <a href="javascript:go2Logpg(<%=strProg%>,'/cs/qwrite.asp');" class="mbtn grey">문의하기</a> <a href="qlist.asp" class="mbtn">목록으로</a> </div>

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
<%
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

Function viewProg(v,u)
	if isUsr then
		viewProg = 0
		if int(v) > 1 and Not u = str_User_ID then
			viewProg = 2
		end if
	else
		viewProg = 1
	end if
End Function
%>
