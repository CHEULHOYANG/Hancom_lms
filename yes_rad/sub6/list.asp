<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim tabnm : tabnm = Request("tabnm")
dim sql,dr
Dim perioArry,imgDot

if tabnm = "" then
	sql = "select top 1 idx from board_mast order by idx"
	set dr = db.execute(sql)
	tabnm = dr(0)
end if

Dim bbsJemok,pgbn,ygbn,mgbn
sql = "select jemok,pgbn,ygbn,mgbn from board_mast where idx=" & tabnm
set dr = db.execute(sql)
bbsJemok = dr(0)
pgbn = dr(1)
ygbn = dr(2)
mgbn = dr(3)
dr.close


Dim intpg,blockPage,pagecount,recordcount,lyno,pagesize,rs4,r_count
Dim gbnS,strPart,strSearch,sql1,rs1

gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")
Dim varPage : varPage = "tabnm=" & tabnm & "&gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch
Dim nowPage : nowPage = Request("URL")
pagesize = 20

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

if int(ygbn) = 2 then
	pagesize = 25
end if

dim query
if gbnS = "s" then
	query = " and " & strPart & " like '" & Replace(strSearch,"'","''") & "%'"
end if

Dim strClmn : strClmn = " idx,title,regdate,readnum,writer,image1,re_level,num,sni=case snimg when '-' then 'noimg.gif' else snimg end,pwd,(select count(idx) from replyTab where tabidx=A.idx) "

Dim isRecod,isRows,isCols
sql = "select count(idx) from board_board where notice = 0 and tabnm=" & tabnm & query
set dr = db.execute(sql)
recordcount = dr(0)
dr.close

if int(recordcount) > 0 then
	isRecod = True
	pagecount = int((recordcount-1)/pagesize) + 1
	lyno = recordcount - ((intpg - 1) * pagesize)
	sql = "select top " & pagesize & strClmn & " from board_board A where notice = 0 and tabnm=" & tabnm & query & " and idx Not in (select top " & ((intpg - 1) * pagesize) & " idx from board_board where notice = 0 and tabnm=" & tabnm & query & ")"
	set dr = db.execute(sql)
	isRows = split(dr.GetString(2),chr(13))
	dr.close
end if

dim wid
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function go2Search(){

	var clmn = document.form1.strSearch;

	if(clmn.value==""){
		alert("조회할 단어를 입력해주세요!");
		clmn.focus();
		return;
	}

	if(clmn.value.replace(/ /g,"")==""){
		alert("조회할 단어를 입력해주세요!");
		clmn.select();
		return;
	}

	if(clmn.value.length < 2){
		alert("조회할 단어는 2자 이상 입력해야 합니다.");
		clmn.select();
		return;
	}

	document.form1.submit();
}

function go2ListPage(pg){
	document.location.href="<%=nowPage%>?intpg=" + pg + "&<%=varPage%>";
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span><%=bbsJemok%></h2>

<form name="form1" method="get" action="list.asp" >
<input type="hidden" name="gbnS" value="s">
<input type="hidden" name="tabnm" value="<%=tabnm%>">

		<div class="schWrap1">
			<h3>검색</h3>
			<div class="sch_area1">
				<select id="strPart" name="strPart" class="seltxt">
                    <option value="wrtid" <%If request("strPart") = "wrtid" Then Response.write"selected" End if%>>아이디</option>
					<option value="writer" <%If request("strPart") = "writer" Then Response.write"selected" End if%>>이름</option>
					<option value="title" <%If request("strPart") = "title" Then Response.write"selected" End if%>>제목</option>
				</select>
				<input type="text" name="strSearch" id="strSearch" class="inptxt" value="<%=request("strSearch")%>" /></div>
			<a href="javascript:go2Search();" class="btn_search1">검색</a>		
		</div>
</form>

		<div class="tbl_top">
			<a href="write.asp?tabnm=<%=tabnm%>" class="fbtn1">글 등록하기</a>	
			<span class="tbl_total"><%=recordcount%>건 (<%=intpg%>page/<%=pagecount%>pages)</span>
		</div>
		

<%
sql1 ="select " & strClmn & " from board_board A where notice = 1 and tabnm=" & tabnm & query & ""
Set rs1 = db.execute(sql1)

If rs1.eof Or rs1.bof Then
Else
%>
<p style="height:20px"></p>
<%
Do Until rs1.eof
%>
		<div class="caution"><p><a href="content.asp?idx=<%=rs1(0)%>&intpg=<%=intpg%>&<%=varpage%>"><strong>[공지] <%=rs1(1)%><%if rs1(10) > 0 Then response.write"&nbsp;("& rs1(10) &")" End if%></strong></a></p></div>
<%
rs1.movenext
Loop
rs1.close
End if
%>


<%
if int(ygbn) > 2 Then 
%>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:10%" />
			<col />
			<col style="width:15%" />
			<col style="width:15%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th class="tl">제목</th>
					<th>글쓴이</th>
					<th>작성일</th>	
					<th>읽음</th>								
				</tr>				
			</thead>
			<tbody>
<% 
if isRecod then 						
for ii = 0 to UBound(isRows) - 1
isCols = split(isRows(ii),chr(9))
%>
				<tr>
					<td><%=lyno%></td>
							<td class="tl"><%if len(isCols(9)) > 0 then%><img src='secret_head.gif'>&nbsp;<%end if%><span style="cursor:pointer;" onMouseOver="this.style.textDecoration='underline';" onMouseOut="this.style.textDecoration='none';" onClick="location.href='content.asp?idx=<%=isCols(0)%>&intpg=<%=intpg%>&<%=varpage%>';"><% if int(isCols(6)) > 0 then
							wid = int(isCols(6)) * 5 %><img src="level.gif" width="<%=wid%>" height="10">[Re]<% end if %><%=isCols(1)%><%if isCols(10) > 0 Then response.write"&nbsp;("& isCols(10) &")" End if%></span></td>
							<td><%=isCols(4)%></td>
							<td><%=right(FormatDateTime(isCols(2),2),10)%>&nbsp;<%=FormatDateTime(isCols(2),4)%></td>
							<td><%=isCols(3)%></td>					
				</tr>
<%
lyno = lyno - 1
Next 
End if
%>
			</tbody>
		</table>
<%
elseif int(ygbn) < 2 then
%>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:10%" />
			<col />
			<col style="width:10%" />
			<col style="width:15%" />
			<col style="width:15%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th class="tl">제목</th>
					<th>파일</th>	
					<th>글쓴이</th>
					<th>작성일</th>	
					<th>읽음</th>								
				</tr>				
			</thead>
			<tbody>
<% 
if isRecod then 						
for ii = 0 to UBound(isRows) - 1
isCols = split(isRows(ii),chr(9))
%>
				<tr>
							<td><%=lyno%></td>
							<td class="tl"><%if len(isCols(9)) > 0 then%><img src='secret_head.gif'>&nbsp;<%end if%><span style="cursor:pointer;" onMouseOver="this.style.textDecoration='underline';" onMouseOut="this.style.textDecoration='none';" onClick="location.href='content.asp?idx=<%=isCols(0)%>&intpg=<%=intpg%>&<%=varpage%>';"><%=isCols(1)%><%if isCols(10) > 0 Then response.write"&nbsp;("& isCols(10) &")" End if%></span></td>
							<td><% if Not isCols(5) = "" then
							perioArry = split(isCols(5),".")
							imgDot = perioArry(UBound(perioArry)) %><img src="/img/icon/<%=imgDot%>.gif"><% end if %></td>
							<td><%=isCols(4)%></td>
							<td><%=right(FormatDateTime(isCols(2),2),10)%>&nbsp;<%=FormatDateTime(isCols(2),4)%></td>
							<td><%=isCols(3)%></td>
				</tr>
<%
lyno = lyno - 1
Next 
End if
%>
			</tbody>
		</table>
<%
else
%>
<div class="photo">
<% 
if isRecod then 						
for ii = 0 to UBound(isRows) - 1
isCols = split(isRows(ii),chr(9))
%>
        	<a href="content.asp?idx=<%=isCols(0)%>&intpg=<%=intpg%>&<%=varpage%>">
				<dl>
					<dt ><img src="/ahdma/pds/<%=isCols(8)%>" /></dt>
					<dd><div class="pho_txt"><%=isCols(1)%> <span class="fo f12"><%if isCols(10) > 0 Then response.write"&nbsp;("& isCols(10) &")" End if%></span></div>
						<div class="info"><span><%=isCols(4)%></span><em class="f12"><%=right(FormatDateTime(isCols(2),2),10)%>&nbsp;<%=FormatDateTime(isCols(2),4)%></em></div></dd>
				</dl>
			</a> 
<%
lyno = lyno - 1
Next 
End if
%>				
            </div>
<%
End If
%>


<% if isRecod Then%>
		<div class="cbtn mb80">
<%
blockPage = int((intpg-1)/10) * 10 + 1
%>
			<div class="paging">
			<% if blockPage > 1 Then %>
				<a href="javascript:go2ListPage('1');"><img src="/yes_rad/rad_img/img/a_prev2.gif" alt="처음페이지"></a>
				<a href="javascript:go2ListPage('<%=int(blockPage-1)%>');"><img src="/yes_rad/rad_img/img/a_prev1.gif" alt="이전페이지" /></a>
			<%End if%>
			<% ii = 1
									Do Until ii > 10 or blockPage > pagecount
									if blockPage = int(intpg) then %>
				<strong><%=blockPage%></strong><% else %>
				<a href="javascript:go2ListPage('<%=blockPage%>');" class="num"><%=blockPage%></a>
				<% end if
									blockPage = blockPage + 1
									ii = ii + 1
									Loop %>
			<% if blockPage > pagecount then 
			else
			%>
				<a href="javascript:go2ListPage('<%=blockPage%>');"><img src="/yes_rad/rad_img/img/a_next1.gif" alt="다음페이지"></a>
				<a href="javascript:go2ListPage('<%=pagecount%>');"><img src="/yes_rad/rad_img/img/a_next2.gif" alt="마지막페이지"></a>
			<%End if%>
			</div>
		</div>
<%End if%>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->