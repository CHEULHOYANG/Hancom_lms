<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr
Dim yy,mm

yy = Request("yy")
mm = Request("mm")

If Len(yy) = 0 then
	yy = Left(Date,4)
	mm = right(Left(Date,7),2)
End If

	yy = int(yy)
	mm = int(mm)

sql = "dbo.sp_Mesu " & yy & "," & mm & ",0"
set dr = db.execute(sql)
Dim isRecod,isRows,isCols
if Not dr.Bof or Not dr.Eof then
	isRecod = True
	isRows = split(dr.getString(2),chr(13))
end if
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function Location_Cal(thM){
	location.href="<%=Request("URL")%>?thisMonth=" + thM;
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>프리패스매출통계</h2>

		<div class="tbl_top">
			<form name="form" method="post" action="premilist.asp"><select name="yy" class="seltxt w100"><%
										dim y : y = 0
										dim startYY : startYY = 2008
										dim endYY : endYY = Year(Now) + 2
										for ii = startYY to endYY %>
										<option<% if int(yy) = ii + y then response.write " selected"%> value="<%=ii + y%>"><%=ii + y%></option><% Next %>
									</select> <select name="mm" onChange="document.form.submit();" class="seltxt w60">
										<option<% if int(mm) = 1 then response.write " selected"%> value="1">1</option>
										<option<% if int(mm) = 2 then response.write " selected"%> value="2">2</option>
										<option<% if int(mm) = 3 then response.write " selected"%> value="3">3</option>
										<option<% if int(mm) = 4 then response.write " selected"%> value="4">4</option>
										<option<% if int(mm) = 5 then response.write " selected"%> value="5">5</option>
										<option<% if int(mm) = 6 then response.write " selected"%> value="6">6</option>
										<option<% if int(mm) = 7 then response.write " selected"%> value="7">7</option>
										<option<% if int(mm) = 8 then response.write " selected"%> value="8">8</option>
										<option<% if int(mm) = 9 then response.write " selected"%> value="9">9</option>
										<option<% if int(mm) = 10 then response.write " selected"%> value="10">10</option>
										<option<% if int(mm) = 11 then response.write " selected"%> value="11">11</option>
										<option<% if int(mm) = 12 then response.write " selected"%> value="12">12</option>
									</select></form>
		</div>

<table class="tbl" style="width:100%">
			<colgroup>
			<col />
			<col style="width:25%" />
			<col style="width:25%" />
			</colgroup>
			<thead>
				<tr>
					<th>프리패스명</th>	
					<th>수량</th>
					<th>가격</th>						
				</tr>				
			</thead>
			<tbody>
<% if isRecod then
						dim suHap,mnyHap
						suHap = 0
						mnyHap = 0
						for ii = 0 to UBound(isRows) - 1
						isCols = split(isRows(ii),chr(9))
						suHap = suHap + int(isCols(2))
						mnyHap = mnyHap + int(isCols(3))%>
						<tr>
							<td><%=isCols(1)%></td>
							<td><%=FormatNumber(isCols(2),0)%></td>
							<td><%=FormatNumber(isCols(3),0)%>원</td>
						</tr><% Next %>
	
						<tr>
							<td>합계</td>
						  <td><strong class="fb"><%=formatNumber(suHap,0)%></strong></td>
							<td><strong class="fo"><%=formatNumber(mnyHap,0)%>원</strong></td>
						</tr><% end if %>
			</tbody>
		</table>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->