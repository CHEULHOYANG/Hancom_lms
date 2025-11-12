<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,isRows,isCols,i,j
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim gbnS,strPart,strSearch
Dim tabnm : tabnm = "member"
Dim varPage
Dim check1,check2,check3,check4,check5,check6,check7,check8,check9,check10
Dim check11,check12,check13,check14,check15,check16,check17,check18,check19,check20
Dim check21,check22,check23,check24,check25,check26,check27,check28,check29,check30,check31
dim s_year,s_month,s_day,rs
Dim nowPage : nowPage = Request("URL")

Function Get_Lastday(nYear, nMonth)

    Get_Lastday = Day(DateSerial(nYear, nMonth + 1, 1 - 1))

End Function

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 30

Dim strClmn : strClmn = " idx,id,name,juminno2,email,regdate,login_count "


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

if request("syear")="" then
	s_year = left(date(),4)
else
	s_year = request("syear")	
end if
if request("smonth")="" then
	s_month = mid(date(),6,2)
else
	s_month = request("smonth")	
end If

Dim lastDate,kkk,chck_valu(31)

lastDate = Get_Lastday(""& s_year &"", ""& s_month &"")

varPage = "gbnS=" & gbnS & "&syear=" & s_year & "&smonth=" & s_month
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function go2ListPage(pg){
	document.location.href="<%=nowPage%>?intpg=" + pg + "&<%=varPage%>";
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>회원출석현황</h2>
<form name="form1" method="post">
		<div class="schWrap1">
			<h3>검색</h3>
			<div class="sch_area1">
				<select name="syear" class="seltxt w100">
					  <%for i = 0 to 5 %>
                          <option value="<%=left(DateAdd("yyyy",-i,date()),4)%>" <%if s_year=""& left(DateAdd("yyyy",-i,date()),4) &"" then response.write"selected" end if%>><%=left(DateAdd("yyyy",-i,date()),4)%></option>
					  <%next%>	  
                        </select>

                        <select name="smonth" class="seltxt w60">
						<% 
						dim smonth
						
						for i = 1 to 12
						
						if len(i)=1 then
						smonth = "0"& i &""
						else
						smonth = i
						end if						
						%>
                          <option value="<%=smonth%>" <%if s_month = ""&  smonth &"" then response.write"selected" end if%>><%=smonth%></option>
  <% next %> 
                        </select>
			</div>
			<a href="javascript:document.form1.submit();" class="btn_search1">검색</a>		
		</div>
</form>

		<div class="tbl_top">
			<a href="excel_chulsuk1.asp?syear=<%=s_year%>&smonth=<%=s_month%>&intpg=<%=intpg%>" class="sbtn">엑셀로저장하기</a>
			<span class="tbl_total"><%=s_year%>년<%=s_month%>월 출석결과입니다.</span>
		</div>


<% if isRecod then

				set dr = db.execute(sql)
				isRows = split(dr.GetString(2),chr(13)) %>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col style="width:5%" />
			<%For kkk = 1 To lastDate%>
			<col style="width:3%" />
			<%next%>
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>성명</th>
					<%For kkk = 1 To lastDate%>
					<th><%=kkk%></th>
					<%next%>								
				</tr>				
			</thead>
			<tbody>
<% for ii = 0 to UBound(isRows) - 1
						isCols = split(isRows(ii),chr(9))							
						

sql = "select count(idx)"
For kkk = 2 To lastDate
	If Len(kkk) = 1 then
		sql = ""& sql &",(select count(idx) from user_ip_check where DateDiff(dd, '"& s_year &"-"& s_month &"-0"& kkk &"',regdate) =0 and uid = '"& isCols(1) &"')"
	Else
		sql = ""& sql &",(select count(idx) from user_ip_check where DateDiff(dd, '"& s_year &"-"& s_month &"-"& kkk &"',regdate) =0 and uid = '"& isCols(1) &"')"
	End if
next
sql = ""& sql &" from user_ip_check where DateDiff(dd, '"& s_year &"-"& s_month &"-01',regdate) =0 and uid = '"& isCols(1) &"'"
set rs=db.execute(sql)

For kkk = 0 To lastDate-1
chck_valu(kkk) = rs(kkk)	
next					
%>
						<tr>
							<td><%=lyno%></td>
							<td><%=isCols(2)%></td>
							<%For kkk = 0 To lastDate-1%>
						  <td><%if chck_valu(kkk) > 0 then response.write"O" end if%></td>
						    <%next%>
</tr><% lyno = lyno - 1
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