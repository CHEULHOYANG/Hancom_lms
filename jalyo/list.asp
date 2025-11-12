<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<%
dim tabnm : tabnm = Request("tabnm")
Dim perioArry,imgDot,rs4,r_count
Dim sql1,rs1
Dim intpg,blockPage,pagecount,recordcount,lyno,pagesize
Dim gbnS,strPart,strSearch
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")

Dim nowPage : nowPage = Request("URL")

''비밀번호 쿠키 리셋
Response.Cookies("user_pwd") = ""

if tabnm = "" then
	sql = "select top 1 idx from board_mast where ygbn=1 order by ordnum asc,idx desc"
	set dr = db.execute(sql)
	if not dr.bof or not dr.eof then
		tabnm = dr(0)
	end if
	dr.close
end if

If Len(tabnm) = 0 Then

	response.write"<script>"
	response.write"alert('생성된 게시판이 없습니다!!');"
	response.write"self.location.href='/main/index.asp';"
	response.write"</script>"
	response.End
	
End If

Dim varPage : varPage = "tabnm=" & tabnm & "&gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch

Dim bbsJemok,pgbn,ygbn,mgbn,categbn,i,mem_group,logincheck,top_message,bottom_message

sql = "select jemok,pgbn,ygbn,mgbn,mem_group,logincheck,top_message,bottom_message from board_mast where idx=" & tabnm
set dr = db.execute(sql)
bbsJemok = dr(0)
pgbn = dr(1)
ygbn = dr(2)
mgbn = dr(3)
mem_group = dr(4)
logincheck = dr(5)
top_message = dr(6)
bottom_message = dr(7)
dr.close

''회원만
If (logincheck) = 1 Then

	If Len(str_User_ID) = 0 Then

			response.redirect "/member/login.asp?str__Page="& server.urlencode(nowPage) &"?"& server.urlencode(Request.ServerVariables("QUERY_STRING")) &""
			response.End

	End If
	
End If

''수강회원만
If (logincheck) = 2 Then

		sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and eday > convert(smalldatetime,getdate()) and state=0 and holdgbn=0"
		set dr = db.execute(sql)
	
		If dr(0) = 0 Then

			response.write"<script>"
			response.write"alert('해당 게시판은 수강회원만 이용이 가능합니다.');"
			response.write"self.location.href='../main/index.asp';"
			response.write"</script>"
			response.End
			
		End If
		
End if


pagesize = 10

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

if int(ygbn) = 2 then
	pagesize = 25
end if

If Len(mem_group) > 3 Then

	sql = "select sp1 from member where id = '"& str_User_ID &"'"
	Set dr = db.execute(sql)

	If dr.eof Or dr.bof Then

			response.redirect "/member/login.asp?str__Page="& server.urlencode(nowPage) &"?"& server.urlencode(Request.ServerVariables("QUERY_STRING")) &""
			response.End

	Else

		if instr(mem_group,", "& dr(0) &",") Then
		else

			response.write"<script>"
			response.write"alert('해당 게시판은 그룹권한을 가진 회원만 접속이 가능합니다.');"
			response.write"history.back();"
			response.write"</script>"
			response.End
			
		End If
		
	dr.close
	End if

End if

dim query
if gbnS = "s" then
	query = " and " & strPart & " like '%" & Replace(strSearch,"'","''") & "%'"
end if

Dim strClmn : strClmn = " idx,title,regdate,readnum,writer,image1,re_level,num,sni=case snimg when '-' then 'unknown.png' else snimg end,image2,pwd "

sql = "select count(idx) from board_board where notice=0 and tabnm=" & tabnm & query
set dr = db.execute(sql)
recordcount = dr(0)
dr.close

if int(recordcount) > 0 then
	isRecod = True
	pagecount = int((recordcount-1)/pagesize) + 1
	lyno = recordcount - ((intpg - 1) * pagesize)
	sql = "select top " & pagesize & strClmn & " from board_board where notice=0 and tabnm=" & tabnm & query & " and idx Not in (select top " & ((intpg - 1) * pagesize) & " idx from board_board where notice=0 and tabnm=" & tabnm & query & ")"
	set dr = db.execute(sql)
	isRows = split(dr.GetString(2),chr(13))
	dr.close
end if

dim wid
%>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">

function go3Search(){
	var clmn = sform.strSearch;
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
return true;
}

function go2ListPage(pg){
	document.location.href="<%=nowPage%>?intpg=" + pg + "&<%=varPage%>";
}
function go2Write(flg){
	if(flg){
		alert("로그인 하신 후 이용하실 수 있습니다!");
	}else{
		location.href="write.asp?<%=varPage%>&intpg=<%=intpg%>";
	}
}
</script>

<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3><%=bbsJemok%></h3>
        </div>
        <div class="scont">

		<%If Len(top_message) > 0 then%>
		<p style="margin:0 0 20px 0"><%=top_message%></p>
        <%End if%>      

            <table class="btbl" style="width:830px">
                    <colgroup>
                    <col style="width:12%" />
                    <col style="width:44%" />
                    <col style="width:16%" />
                    <col style="width:16%" />
                    <col style="width:12%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>등록일</th>
                            <th class="bkn">조회수</th>
                        </tr>
                    </thead>
                    <tbody>
<%
sql1 = "select " & strClmn & " from board_board where notice=1 and tabnm=" & tabnm & query & ""
Set rs1 = db.execute(sql1)

If rs1.eof Or rs1.bof Then
Else
Do Until rs1.eof

						sql = "select count(idx) from replyTab where tabidx = "& rs1(0)
						Set rs4 = db.execute(sql)

						r_count = rs4(0)
%>
				<tr>
					<td><strong>[공지]</strong></td>
					<td class="tl"><% if Not rs1(5) = "" then
                perioArry = split(rs1(5),".")
                imgDot = perioArry(UBound(perioArry)) %>
                  <img src="../img/icon/<%=imgDot%>.gif" align="absmiddle">
                  <% end if %>&nbsp;<span onclick="self.location.href='content.asp?idx=<%=rs1(0)%>&intpg=<%=intpg%>&<%=varpage%>';" style="cursor:pointer;"><%=rs1(1)%><%if r_count > 0 Then response.write"&nbsp;("& r_count &")" End if%><%if len(rs1(10)) > 0 then%>&nbsp;<img src='../img/secret_head.gif' align='absmiddle'><%end if%><%if DateDiff("h",rs1(2),Now()) < 6 then 
response.write"&nbsp;&nbsp;<img src=../img/new.gif align=absmiddle>"
	end if%></span></td>
					<td><%=rs1(4)%></td>
					<td><%=formatdatetime(rs1(2),2)%></td>
					<td><%=rs1(3)%></td>
				</tr>
<%
rs1.movenext
Loop
rs1.close
End if

if isRecod Then 
	
			for ii = 0 to UBound(isRows) - 1
			isCols = split(isRows(ii),chr(9))


						sql = "select count(idx) from replyTab where tabidx = "& isCols(0)
						Set rs4 = db.execute(sql)

						r_count = rs4(0)
	%>
				<tr>
					<td><%=lyno%></td>
					<td class="tl"><% if Not isCols(5) = "" then
                perioArry = split(isCols(5),".")
                imgDot = perioArry(UBound(perioArry)) %>
                  <img src="../img/icon/<%=imgDot%>.gif" align="absmiddle">
                  <% end if %>&nbsp;<span onclick="self.location.href='content.asp?idx=<%=isCols(0)%>&intpg=<%=intpg%>&<%=varpage%>';" style="cursor:pointer;"><%=isCols(1)%><%if r_count > 0 Then response.write"&nbsp;("& r_count &")" End if%><%if len(isCols(10)) > 0 then%>&nbsp;<img src='../img/secret_head.gif' align='absmiddle'><%end if%><%if DateDiff("h",isCols(2),Now()) < 6 then 
response.write"&nbsp;&nbsp;<img src=../img/new.gif align=absmiddle>"
	end if%></span></td>
					<td><%=isCols(4)%></td>
					<td><%=formatdatetime(isCols(2),2)%></td>
					<td><%=isCols(3)%></td>
				</tr>
	<%
			lyno = lyno - 1
			Next

	Else
	End if%>
                    </tbody>
                </table>

<!--  테이블 Paging 부분시작           -->	
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
		end If

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
<!--  테이블 Paging 부분끝           -->	    

    <form name="sform" method="post" action="?" onsubmit="return go3Search();">		
    <input type="hidden" name="gbnS" value="s">
    <input type="hidden" name="tabnm" value="<%=tabnm%>">    
            <div class="boardSch">
                <fieldset>
                    <select name="strPart" id="strPart" class="seltxt1 w100">
						<option value="writer" <%If request("strPart") = "writer" Then response.write"selected" End if%>>이름</option>
						<option value="wrtid" <%If request("strPart") = "wrtid" Then response.write"selected" End if%>>아이디</option>
						<option value="title" <%If request("strPart") = "title" Then response.write"selected" End if%>>제목</option>
                    </select>
                    <input type="text" name="strSearch" class="inptxt1" value="<%=request("strSearch")%>" />
                    <a href="javascript:document.sform.submit();" class="fbtn grey">검색하기</a>
                </fieldset>
            </div>
    </form>
    
            <div class="cbtn"> <% if int(pgbn) > 0 then %><a href="javascript:go2Write(<%=strProg%>);" class="mbtn grey">글쓰기</a><%End if%> <a href="?tabnm=<%=tabnm%>&intpg=<%=intpg%>" class="mbtn">목록으로</a> </div> 

        <%If Len(bottom_message) > 0 then%>
                <p style="margin:0 0 10px 0"><%=bottom_message%></p>
        <%End if%>        

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" --><%
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
End Function %>
