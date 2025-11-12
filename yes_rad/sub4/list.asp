<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr
dim isCols1,isCols2,isCols3,isCols4
dim cnthap1,cnthap2,cnthap3,cnthap4
dim mnyhap1,mnyhap2,mnyhap3,mnyhap4
Dim yy : yy = Request("yy")

if yy = "" then
	yy = Year(now)
end if 

sql = "dbo.sp_Mesu_Month " & yy
set dr = db.execute(sql)
Dim isRows1
isRows1 = split(dr.getstring(2),chr(13))

set dr = dr.nextrecordset
Dim isRows2
isRows2 = split(dr.getstring(2),chr(13))

set dr = dr.nextrecordset
Dim isRows3
isRows3 = split(dr.getstring(2),chr(13))

set dr = dr.nextrecordset
Dim isRows4
isRows4 = split(dr.getstring(2),chr(13))
dr.close
%>
<!--#include file="../main/top.asp"-->

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>월별매출통계</h2>

		<div class="tbl_top">
			<select name="yy" onChange="location.href='list.asp?yy=' + this.value;" class="seltxt w100"><%
										dim y : y = 0
										dim startYY : startYY = 2008
										dim endYY : endYY = Year(Now) + 2
										for ii = startYY to endYY %>
										<option<% if int(yy) = ii + y then response.write " selected"%> value="<%=ii + y%>"><%=ii + y%>년</option><% Next %>
									</select>
		</div>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['월', '프리미엄', '과정',	'단과',	'교재'],
<%for ii = 0 to 11
						 	isCols1 = split(isRows1(ii),chr(9))
						 	isCols2 = split(isRows2(ii),chr(9))
						 	isCols3 = split(isRows3(ii),chr(9))
							isCols4 = split(isRows4(ii),chr(9))
%>
          ['<%=ii + 1 %>월',  <%=isCols1(2)%>,      <%=isCols2(2)%>,	<%=isCols3(2)%>,	<%=isCols4(2)%>]<%if ii < 11 then response.write"," end if%>
<%next%>
        ]);

        var options = {
          title: '월별매출통계',
          hAxis: {title: '',  titleTextStyle: {color: '#333'}},
          vAxis: {minValue: 0}
        };

        var chart = new google.visualization.AreaChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
	<div id="chart_div" style="width:100%;height:400px;"></div>

<table class="tbl" style="width:100%">
						<tr>
							<th width="4%">부문</th>
							<th colspan="2">프리패스</th>
							<th colspan="2">과정</th>
							<th colspan="2">단과</th>
							<th colspan="2">상품</th>
							<th colspan="2">합 계</th>
						</tr>
						<tr>
							<td>월</td>
							<td width="8%">수량</td>
							<td width="8%">가격</td>
							<td width="8%">수량</td>
							<td width="8%">가격</td>
							<td width="8%">수량</td>
							<td width="8%">가격</td>
							<td width="8%">수량</td>
							<td width="8%">가격</td>
							<td width="8%">수량</td>
							<td width="8%">가격</td>
						</tr><% 
						cnthap1 = 0
						cnthap2 = 0
						cnthap3 = 0
						cnthap4 = 0
						
						mnyhap1 = 0
						mnyhap2 = 0
						mnyhap3 = 0
						mnyhap4 = 0
						
						 for ii = 0 to 11
						 	isCols1 = split(isRows1(ii),chr(9))
						 	isCols2 = split(isRows2(ii),chr(9))
						 	isCols3 = split(isRows3(ii),chr(9))
							isCols4 = split(isRows4(ii),chr(9))
						 	
							cnthap1 = cnthap1 + int(isCols1(1))
							cnthap2 = cnthap2 + int(isCols2(1))
							cnthap3 = cnthap3 + int(isCols3(1))
							cnthap4 = cnthap4 + int(isCols4(1))
							
							mnyhap1 = mnyhap1 + int(isCols1(2))
							mnyhap2 = mnyhap2 + int(isCols2(2))
							mnyhap3 = mnyhap3 + int(isCols3(2))
							mnyhap4 = mnyhap4 + int(isCols4(2))%>
						<tr bgcolor="#FFFFFF" height="25" align="center">
							<td><%=ii + 1 %>월</td>
							<td><%=formatnumber(isCols1(1),0)%></td>
							<td><%=formatnumber(isCols1(2),0)%></td>
							<td><%=formatnumber(isCols2(1),0)%></td>
							<td><%=formatnumber(isCols2(2),0)%></td>
							<td><%=formatnumber(isCols3(1),0)%></td>
							<td><%=formatnumber(isCols3(2),0)%></td>
							<td><%=formatnumber(isCols4(1),0)%></td>
							<td><%=formatnumber(isCols4(2),0)%></td>
							<td><%=formatnumber(int(isCols1(1))+int(isCols2(1))+int(isCols3(1))+int(isCols4(1)),0)%></td>
							<td><%=formatnumber(int(isCols1(2))+int(isCols2(2))+int(isCols3(2))+int(isCols4(2)),0)%></td>
						</tr><% Next %>
						<tr bgcolor="#FFFFFF" align="center" height="30">
							<td height="40" bgcolor="f7f7f7">합 계</td>
							<td bgcolor="f7f7f7"><%=formatnumber(cnthap1,0)%></td>
							<td bgcolor="f7f7f7"><%=formatnumber(mnyhap1,0)%></td>
							<td bgcolor="f7f7f7"><%=formatnumber(cnthap2,0)%></td>
							<td bgcolor="f7f7f7"><%=formatnumber(mnyhap2,0)%></td>
							<td bgcolor="f7f7f7"><%=formatnumber(cnthap3,0)%></td>
							<td bgcolor="f7f7f7"><%=formatnumber(mnyhap3,0)%></td>
							<td bgcolor="f7f7f7"><%=formatnumber(cnthap4,0)%></td>
							<td bgcolor="f7f7f7"><%=formatnumber(mnyhap4,0)%></td>
							<td bgcolor="f7f7f7"><%=formatnumber(cnthap1+cnthap2+cnthap3+cnthap4,0)%></td>
							<td bgcolor="f7f7f7"><%=formatnumber(mnyhap1+mnyhap2+mnyhap3+mnyhap4,0)%></td>
						</tr>
				</table>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->