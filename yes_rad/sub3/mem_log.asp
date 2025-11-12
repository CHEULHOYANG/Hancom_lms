<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,isRows,isCols,rs1,pagesize
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim gbnS,strsday,streday,strPart,strSearch
Dim tabnm : tabnm = "user_ip_check"
Dim varPage
Dim v_time,v_date,time1,time2,v_title
dim v1,h,m,s

Dim nowPage : nowPage = Request("URL")

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
Dim strClmn : strClmn = " idx,uid,uname,ip,regdate "

gbnS = Request("gbnS")
strsday = Request("strsday")
streday = Request("streday")
strPart = Request("strPart")
strSearch = Request("strSearch")

if strsday = "" then
	strsday = DateAdd("m",-1,date)
	streday = date
end if

if gbnS = "" then
	varPage = "gbnS=&strsday=&streday=&strPart=&strSearch="

	sql = "select Count(idx) from " & tabnm & ""
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
	varPage = "gbnS=" & gbnS & "&strsday=" & strsday & "&streday=" & streday & "&strPart=" & strPart & "&strSearch=" & strSearch

	dim query
	query = ""
	query = query & " regdate between convert(smalldatetime,'" & strsday & " 00:00')" & " and convert(smalldatetime,'" & streday & " 23:59')"

	if Not strSearch = "" then
		query = query & " and " & strPart & " like '%" & Replace(strSearch,"'","''") & "%' "
	end if

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
end if
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
		return ;
	}
	document.form1.submit();
}

</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>회원접속로그</h2>
<form name="form1" method="get" action="<%=Request("URL")%>">
<input type="hidden" name="gbnS" value="1">
		<div class="schWrap">
			<h3>검색</h3>
			<div class="sch_area" style="line-height:40px">
				<input class="inptxt1 w100" id="strsday" value="<%=strsday%>" name="strsday" readonly /> ~ <input class="inptxt1 w100" id="streday" value="<%=streday%>" name="streday" readonly /><br />
				<select name="strPart" class="seltxt">
                      <option value="uid" <%if strPart="uid" then response.write"selected" end if%>>아이디</option>
					  <option value="uname" <%if strPart="uname" then response.write"selected" end if%>>이름</option>
                </select>
				<input type="text" id="strSearch" name="strSearch" class="inptxt" value="<%=strSearch%>" /></div>
			<a href="javascript:go2Search();" class="btn_search">검색하기</a>		
		</div>
</form>

		<div class="tbl_top">
<form name="gm_form1" method="post" action="?">
<input type="hidden" name="intpg" value="<%=intpg%>">
<input type="hidden" name="gbnS" value="<%=request("gbnS")%>">
<input type="hidden" name="strPart" value="<%=request("strPart")%>">
<input type="hidden" name="strSearch" value="<%=request("strSearch")%>">
				<select name="gm1" id="gm1" onChange="document.gm_form1.submit();">
                <option<% if request("gm1") = "20" then response.write " selected" %> value="20">20</option>
				<option<% if request("gm1") = "50" then response.write " selected" %> value="50">50</option>
				<option<% if request("gm1") = "70" then response.write " selected" %> value="70">70</option>
				<option<% if request("gm1") = "100" then response.write " selected" %> value="100">100</option>
              </select>
</form>

			<span class="tbl_total">전체 <%=recordcount%>건 (<%=intpg%>page/<%=pagecount%>pages)</span>
		</div>
<% 
if isRecod then
set dr = db.execute(sql)
isRows = split(dr.GetString(2),chr(13))
%>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:12%" />
			<col style="width:22%" />
			<col style="width:22%" />
			<col style="width:22%" />
			<col style="width:22%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>아이디</th>
					<th>이름</th>
					<th>아이피</th>	
					<th>접속일시</th>								
				</tr>				
			</thead>
			<tbody>
<% 
for ii = 0 to UBound(isRows) - 1
isCols = split(isRows(ii),chr(9)) 
%>
				<tr>
					<td><%=lyno%></td>
					<td><%=isCols(1)%></td>
					<td><%=isCols(2)%></td>
					<td><%=isCols(3)%></td>
					<td><%=right(FormatDateTime(isCols(4),2),8)%>&nbsp;<%=FormatDateTime(isCols(4),4)%></td>
				</tr>
<% lyno = lyno - 1
						Next %>
			</tbody>
		</table>
<%End if%>

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

<link rel="stylesheet" href="../../include/pikaday.css">
<script src="../../include/moment.js"></script>
<script src="../../include/pikaday.js"></script>

<script>
    var picker = new Pikaday(
    {
        field: document.getElementById('strsday'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)-10%>,<%=left(date(),4)+10%>]
    });
    var picker1 = new Pikaday(
    {
        field: document.getElementById('streday'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)-10%>,<%=left(date(),4)+10%>]
    });
</script>