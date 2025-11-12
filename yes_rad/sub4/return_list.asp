<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql1,rs1
Dim sql,dr,isRecod,isRows,isCols,pagesize
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim gbnS,strsday,streday,strPart,strSearch
Dim tabnm : tabnm = "order_mast"
Dim varPage
Dim mst_idx,dan_idx
Dim nowPage : nowPage = Request("URL")

mst_idx = request("mst_idx")
dan_idx = request("dan_idx")

If Len(mst_idx) = 0 Then mst_idx = 0
If Len(dan_idx) = 0 Then dan_idx = 0

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

If request("gm1") = 0 then

	pagesize = 50
	response.cookies("gm1") = 50

Else

	pagesize = request("gm1")
	response.cookies("gm1") = request("gm1")

End if

Dim strClmn : strClmn = " idx,id + '(' + dbo.MemberNm(id) + ')',titlen = title + dbo.LectuTitle(tabidx,buygbn),sday,dbo.PayTypeStr(paytype),payday,state,eday,buygbn,tabidx,id,intprice,DateDiff(day,GetDate(),eday),return_state,return_price,return_bankinfo  "

gbnS = Request("gbnS")
strsday = Request("strsday")
streday = Request("streday")
strPart = Request("strPart")
strSearch = Request("strSearch")

if strsday = "" then
	strsday = DateAdd("m",-1,date)
	streday = date
end if

if gbnS = "" Then

	varPage = "gbnS=&strsday=&streday=&strPart=&strSearch="

	sql = "select Count(idx) from " & tabnm & " where bookidx=0 and return_state > 0"
	set dr = db.execute(sql)
	recordcount = int(dr(0))
	dr.close

	if recordcount > 0 then
		isRecod = True
		pagecount=int((recordcount-1)/pagesize)+1
		lyno = recordcount - ((intpg - 1) * pagesize)
		sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where bookidx=0 and return_state > 0 and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " where bookidx=0 and return_state > 0 order by idx desc) order by idx desc"
	end if

else
	varPage = "mst_idx="& mst_idx &"&dan_idx="& dan_idx &"&gbnS=" & gbnS & "&strsday=" & strsday & "&streday=" & streday & "&strPart=" & strPart & "&strSearch=" & strSearch

	dim query
	query = "bookidx=0 and return_state > 0"
	query = query & " and payday between convert(smalldatetime,'" & strsday & " 00:00')" & " and convert(smalldatetime,'" & streday & " 23:59')"

	If strPart = "id" then

		if Not strSearch = "" then
			query = query & " and " & strPart & " like '%" & Replace(strSearch,"'","''") & "%' "
		end If
	
	Else

		if Not strSearch = "" then
			query = query & " and dbo.MemberNm(id) like '%" & Replace(strSearch,"'","''") & "%' "
		end If

	End If
	
	If mst_idx > 0 Then
		query = query & " and buygbn = 1 and tabidx = "& mst_idx &""
	End If
	
	If dan_idx > 0 Then
		query = query & " and buygbn = 2 and tabidx = "& dan_idx &""
	End if

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
end If
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function go2ListPage(pg){
	document.location.href="<%=Request("URL")%>?intpg=" + pg + "&<%=varPage%>";
}

function go2Search(){
	var ssday = document.form1.strsday;
	var eeday = document.form1.streday;
	var now = new Date();
	var startDay,endDay;

	strAry = ssday.value.split("-");
	startDay = now.setFullYear(strAry[0],strAry[1],strAry[2]);

	strAry = eeday.value.split("-");
	endDay = now.setFullYear(strAry[0],strAry[1],strAry[2]);

	if(endDay < startDay){
		alert("조회기간이 잘못되었습니다.");
		ssday.select();
		return;
	}
	document.form1.submit();
}

function go2Del1(idxnm){
	var delok = confirm("환불처리를  완료하시겠습니까?");
	if(delok){
		location.href="return_list_del.asp?gu=1&intpg=<%=intpg%>&<%=varPage%>&idx=" + idxnm;
	}
}
function go2Del2(idxnm){
	var delok = confirm("접수된 환불 신청을 취소하시겠습니까?");
	if(delok){
		location.href="return_list_del.asp?gu=2&intpg=<%=intpg%>&<%=varPage%>&idx=" + idxnm;
	}
}
function go2Del3(idxnm){
	var delok = confirm("환불이 완료된 목록입니다.\n삭제된 내역은 복구되지 않습니다.\n주문내역을 삭제하시겠습니까?");
	if(delok){
		location.href="return_list_del.asp?gu=3&intpg=<%=intpg%>&<%=varPage%>&idx=" + idxnm;
	}
}

function openWindow4(url,width,height) {
	var widths = width;
	var heights = height;
	var top = 30; // 창이 뜰 위치 지정
	var left = 30;
	var temp2 = 'toolbar=no, scrollbars=yes, width='+widths+',height='+heights+',top='+top+',left='+left;
	var temp = url;
	window.open(temp, 'view_info', temp2);
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>환불관리</h2>

<form name="form1" method="get" action="<%=Request("URL")%>">
<input type="hidden" name="gbnS" value="1">
		<div class="schWrap">
			<h3>검색</h3>
			<div class="sch_area" style="line-height:40px">
				<input class="inptxt1 w100" id="strsday" value="<%=strsday%>" name="strsday" readonly /> ~ <input class="inptxt1 w100" id="streday" value="<%=streday%>" name="streday" readonly />
				<br />
				<select name="strPart" class="seltxt w200">
                <option value="id" <%if strPart="id" then response.write"selected" end if%>>아이디</option>
					  <option value="name" <%if strPart="name" then response.write"selected" end if%>>이름</option>
                </select>
				<input type="text" id="strSearch" name="strSearch" class="inptxt" value="<%=strSearch%>" />
				</div>
			<a href="javascript:go2Search();" class="btn_search">검색하기</a>		
		</div>
</form>

		<div class="tbl_top">
<form name="gm_form1" method="post" action="?">
<input type="hidden" name="intpg" value="<%=intpg%>">
<input type="hidden" name="strsday" value="<%=request("strsday")%>">
<input type="hidden" name="streday" value="<%=request("streday")%>">
<input type="hidden" name="gbnS" value="<%=request("gbnS")%>">
<input type="hidden" name="strPart" value="<%=request("strPart")%>">
<input type="hidden" name="strSearch" value="<%=request("strSearch")%>">
<input type="hidden" name="mst_idx" value="<%=mst_idx%>">
<input type="hidden" name="dan_idx" value="<%=dan_idx%>">
				<select name="gm1" id="gm1" onChange="document.gm_form1.submit();">
                <option<% if request("gm1") = "20" then response.write " selected" %> value="20">20</option>
				<option<% if request("gm1") = "50" then response.write " selected" %> value="50">50</option>
				<option<% if request("gm1") = "70" then response.write " selected" %> value="70">70</option>
				<option<% if request("gm1") = "100" then response.write " selected" %> value="100">100</option>
              </select>
</form>			
			<span class="tbl_total">전체 <%=recordcount%>건 (<%=intpg%>page/<%=pagecount%>pages)&nbsp;<a href="return_list_excel.asp?intpg=<%=intpg%>&gbnS=<%=request("gbnS")%>&strsday=<%=request("strsday")%>&streday=<%=request("streday")%>&strPart=<%=request("strPart")%>&strSearch=<%=request("strSearch")%>&mst_idx=<%=mst_idx%>&dan_idx=<%=dan_idx%>" class="sbtn">엑셀로저장하기</a></span>
		</div>

<% if isRecod then
				set dr = db.execute(sql)
				isRows = split(dr.GetString(2),chr(13)) %>

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:7%" />
			<col />
			<col style="width:10%" />

			<col style="width:9%" />
			<col style="width:9%" />
			<col style="width:9%" />

			<col style="width:18%" />
			<col style="width:12%" />
			<col style="width:7%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>제목</th>
					<th>구매자</th>
					<th>결제금액</th>	
					<th>결제일</th>
					<th>만료일</th>

					<th>환불정보</th>
					<th>환불금액</th>
					<th>환불상태</th>
				</tr>				
			</thead>
			<tbody>
			<% for ii = 0 to UBound(isRows) - 1
						isCols = split(isRows(ii),chr(9)) %>
						<tr>
							<td><%=lyno%></td>
							<td class="tl">
							<%If isCols(13) = 2 then%><font color='#cc0000'>[환불완료]</font>&nbsp;<strike><%End if%>
							<%If isCols(8) > 0 Then %><a href="javascript:go2VewPlay('<%=isCols(9)%>',<%=isCols(8)%>,'<%=isCols(10)%>');"><%=isCols(2)%></a><%else%><%=isCols(2)%><%End if%>
							<%If isCols(13) = 2 then%></strike><%End if%>
							</td>
							<td><a href="../sub3/view.asp?userid=<%=isCols(10)%>" target="_blank"><%=isCols(1)%></a></td>
							<td><%=FormatNumber(isCols(11),0)%></td>
							<td><%=formatdatetime(isCols(3),2)%></td>
							<td><%=formatdatetime(isCols(7),2)%><br />(<%=isCols(12)%>일 남음)</td>
							<td><%=isCols(15)%></td>

							<td><form name="form<%=isCols(0)%>" method="post" action="return_list_price.asp?idx=<%=isCols(0)%>&intpg=<%=intpg%>&<%=varPage%>"><input name="return_price" value="<%=isCols(14)%>" class="inptxt1" style="width:60px"/>&nbsp;<a href="javascript:document.form<%=isCols(0)%>.submit();" class="fbtn">수정</a></form></td>

<%If isCols(13) = 1 then%>
							<td><a href="javascript:go2Del1(<%=isCols(0)%>);" class="btns">완료</a> <a href="javascript:go2Del2(<%=isCols(0)%>);" class="btns trans">취소</a></td>
<%End if%>
<%If isCols(13) = 2 then%>
							<td><a href="javascript:go2Del3(<%=isCols(0)%>);" class="btns trans">삭제</a></td>
<%End if%>

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

	<div class="caution"><p>제목을 클릭하시면 해당 회원의 진도율을 보실수 있습니다.</p></div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->

<script>
    var pickera = new Pikaday(
    {
        field: document.getElementById('strsday'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)-10%>,<%=left(date(),4)+10%>]
    });
    var pickerb = new Pikaday(
    {
        field: document.getElementById('streday'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)-10%>,<%=left(date(),4)+10%>]
    });
</script>