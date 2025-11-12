<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,isRows,isCols
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim tabnm : tabnm = "faqTab"
Dim strPart,strSearch,varPage

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 20

Dim strClmn : strClmn = " idx,jemok,wday "

strPart = Request("strPart")
strSearch = Request("strSearch")

if strPart = "" then
	varPage = "strPart=&strSearch="

	sql = "select Count(idx) from " & tabnm
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " order by idx desc) order by idx desc"
	end if

else
	varPage = "strPart=" & strPart & "&strSearch=" & strSearch

	dim query
	query = " jemok like '%" & Replace(strSearch,"'","''") & "%'"

	sql = "select count(idx) from " & tabnm & " where " & query
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where " & query & " and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " where " & query & " order by idx desc) order by idx desc"
	end if
end if %>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function go2ListPage(pg){
	document.location.href="<%=Request("URL")%>?intpg=" + pg + "&<%=varPage%>";
}

function go2Search(fm){
	var clmn;
	clmn = fm.strSearch;
	if(clmn.value==""){
		alert("조회하실 검색어를 입력하세요!");
		clmn.focus();
		return false;
	}
	if(clmn.value.replace(/ /g,"")==""){
		alert("조회하실 검색어를 입력하세요!");
		clmn.select();
		return false;
	}
return true;
}

function delLicen(idxn){
	delok = confirm("정말로 삭제하시겠습니까?");
	if(delok){
		location.href="fdel.asp?<%=varPage%>&idx=" + idxn;
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>자주묻는질문</h2>

<form name="form1" method="post" action="?">
		<div class="schWrap1">
			<h3>검색</h3>
			<div class="sch_area1">
				<select id="strPart" name="strPart" class="seltxt">
					<option value="jemok" >제목</option>
				</select>
				<input type="text" name="strSearch" id="strSearch" class="inptxt" value="<%=request("strSearch")%>" /></div>
			<a href="javascript:document.form1.submit();" class="btn_search1">검색</a>		
		</div>
</form>

		<div class="tbl_top">
			<a href="fwrite.asp" class="fbtn1">등록하기</a>
			<span class="tbl_total">전체 <%=recordcount%>건 (<%=intpg%>page/<%=pagecount%>pages)</span>
		</div>
<% if isRecod Then

				set dr = db.execute(sql)
				isRows = split(dr.GetString(2),chr(13)) 
%>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:8%" />
			<col />
			<col style="width:15%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>제목</th>
					<th>등록일</th>
					<th>기능</th>	
				</tr>				
			</thead>
			<tbody>
<%
				for ii = 0 to UBound(isRows) - 1
						isCols = split(isRows(ii),chr(9))
%>
				<tr>
					<td><%=lyno%></td>
					<td class="tl"><a href="fneyong.asp?idx=<%=isCols(0)%>&intpg=<%=intpg%>&<%=varPage%>"><%=isCols(1)%></a></td>
					<td><%=formatdatetime(isCols(2),2)%></td>
					<td><a href="javascript:delLicen('<%=isCols(0)%>');" class="btns trans">삭제</a></td>					
				</tr>
<% lyno = lyno - 1
						Next %>
			</tbody>
		</table>

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