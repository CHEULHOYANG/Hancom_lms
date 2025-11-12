<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim g_title
Dim sql,rs
Dim mem1,mem2,mem3,mem4,mem5
Dim visit1,visit2,visit3,visit4,visit5
Dim login1,login2,login3,login4,login5
Dim buy1,buy2,buy3,buy4,buy5

mem1 = 0
mem2 = 0
mem3 = 0
mem4 = 0
mem5 = 0
visit1 = 0
visit2 = 0
visit3 = 0
visit4 = 0
visit5 = 0
login1 = 0
login2 = 0
login3 = 0
login4 = 0
login5 = 0
buy1 = 0
buy2 = 0
buy3 = 0
buy4 = 0
buy5 = 0

sql="select count(idx) from member where convert(varchar(10),regdate, 121) = '"& left(now(),10) &"'"
set rs=db.execute(sql)

mem1 = rs(0)
rs.close

sql="select count(idx) from member where convert(varchar(10),regdate, 121) = '"& left(DateAdd("d",-1,now()),10) &"'"
set rs=db.execute(sql)

mem2 = rs(0)
rs.close 

sql="select count(idx) from member where convert(varchar(10),regdate, 121) = '"& left(DateAdd("d",-2,now()),10) &"'"
set rs=db.execute(sql)

mem3 = rs(0)
rs.close

sql="select count(idx) from member where convert(varchar(10),regdate, 121) = '"& left(DateAdd("d",-3,now()),10) &"'"
set rs=db.execute(sql)

mem4 = rs(0)
rs.close

sql="select count(idx) from member where convert(varchar(10),regdate, 121) = '"& left(DateAdd("d",-4,now()),10) &"'"
set rs=db.execute(sql)

mem5 = rs(0)
rs.close

sql="select count(vNum) from Visit_Counter where vYY = "&year(date)&" and vMM = "&month(date)&" and vDD = "&day(date)&""
set rs=db.execute(sql)

visit1 = rs(0)
rs.close

sql="select count(vNum) from Visit_Counter where vYY = "&year(date)&" and vMM = "&month(date)&" and vDD = "&day(date-1)&""
set rs=db.execute(sql)

visit2 = rs(0)
rs.close

sql="select count(vNum) from Visit_Counter where vYY = "&year(date)&" and vMM = "&month(date)&" and vDD = "&day(date-2)&""
set rs=db.execute(sql)

visit3 = rs(0)
rs.close

sql="select count(vNum) from Visit_Counter where vYY = "&year(date)&" and vMM = "&month(date)&" and vDD = "&day(date-3)&""
set rs=db.execute(sql)

visit4 = rs(0)
rs.close

sql="select count(vNum) from Visit_Counter where vYY = "&year(date)&" and vMM = "&month(date)&" and vDD = "&day(date-4)&""
set rs=db.execute(sql)

visit5 = rs(0)
rs.close
%>
<!--#include file="../main/top.asp"-->
<div class="container">
	<!--#include file="../main/left.asp"-->
	<div class="content">

<h2 class="cTit"><span class="bullet"></span>회원가입현황</h2>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawVisualization);


      function drawVisualization() {
        // Some raw data (not necessarily accurate)
        var data = google.visualization.arrayToDataTable([
         ['일', '회원가입', '방문'],
         ['<%=left(DateAdd("d",-4,now()),10)%>',  <%=mem5%>,      <%=visit5%>],
         ['<%=left(DateAdd("d",-3,now()),10)%>',  <%=mem4%>,      <%=visit4%>],
         ['<%=left(DateAdd("d",-2,now()),10)%>',  <%=mem3%>,      <%=visit3%>],
         ['<%=left(DateAdd("d",-1,now()),10)%>',  <%=mem2%>,      <%=visit2%>],
         ['<%=left(now(),10)%>',  <%=mem1%>,      <%=visit1%>]
      ]);

    var options = {
      title : '회원가입/방문현황',
      vAxis: {title: ''},
      hAxis: {title: ''},
      seriesType: 'bars',
      series: {5: {type: 'line'}}
    };

    var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
    chart.draw(data, options);
  }
    </script>
	<div id="chart_div" style="width: 100%; height: 500px;"></div>

		<h2 class="cTit"><span class="bullet"></span>강좌서비스현황</h2>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:50%" />
			<col style="width:20%" />
			<col style="width:15%" />
			<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th>강좌명</th>	
					<th>구매자ID(이름)</th>	
					<th>결제방법</th>	
					<th>결제일</th>
				</tr>				
			</thead>
			<tbody>
			<%
			sql = "select top 5 idx,id + '(' + dbo.MemberNm(id) + ')',titlen = dbo.LectuTitle(tabidx,buygbn),sday,dbo.PayTypeStr(paytype),payday,state from order_mast where bookidx=0 order by idx desc"
			set rs=db.execute(sql)						

			if rs.eof or rs.bof then
			else
			do until rs.eof

			If Len(rs(2)) > 0 Then 
				g_title = cutStr(rs(2),100)
			Else
				g_title = "삭제된 강좌/상품"
			End if
			%>
				<tr>
					<td class='tl'><%=g_title%></td>
					<td><%=rs(1)%></td>
					<td><%=rs(4)%></td>
					<td><%=formatdatetime(rs(3),2)%></td>
				</tr>
				<%
				rs.movenext
				Loop
				rs.close
				End If
				%>
			</tbody>
		</table>


		<h2 class="cTit"><span class="bullet"></span>질문과답변</h2>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:50%" />
			<col style="width:20%" />
			<col style="width:15%" />
			<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th>제목</th>	
					<th>아이디</th>	
					<th>등록일</th>	
					<th>처리상태</th>
				</tr>				
			</thead>
			<tbody>
			<%
			sql = "select top 5 qidx,quserid,qtitle,qansgbn=case qansgbn when 1 then 'O' else 'X' end,regdate from oneone order by regdate desc"
			set rs=db.execute(sql)

			if rs.eof or rs.bof then
			else
			do until rs.eof		
			%>
				<tr onclick="self.location.href='/yes_rad/sub5/qneyong.asp?idx=<%=rs(0)%>';" style="cursor:pointer;">
					<td class='tl'><%=rs(2)%></td>
					<td><%=rs(1)%></td>
					<td><%=formatdatetime(rs(4),2)%></td>
					<td><%=rs(3)%></td>
				</tr>
				<%
				rs.movenext
				Loop
				rs.close
				End If
				%>
			</tbody>
		</table>

		<h2 class="cTit"><span class="bullet"></span>상품주문내역</h2>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:10%" />
			<col style="width:35%" />
			<col style="width:20%" />
			<col style="width:10%" />
			<col style="width:15%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>주문번호</th>	
					<th>상품명</th>	
					<th>상품가격(수량)</th>	
					<th>구매자ID(이름)</th>
					<th>결제정보</th>
					<th>배송현황</th>
				</tr>				
			</thead>
			<tbody>
			<%
			sql = "select top 5 idx,id + '(' + dbo.MemberNm(id) + ')',title,sday,dbo.PayTypeStr(paytype),payday,state,eday,order_id,s_name,s_tel1,s_tel2,s_email,s_zipcode1,s_zipcode2,s_juso1,s_juso2,s_memo,s_state,s_tak_info1,s_tak_info2,s_return,intprice,bookidx,bcount from order_mast where bookidx=1 order by idx desc"
			set rs=db.execute(sql)

			if rs.eof or rs.bof then
			else
			do until rs.eof	
			%>
				<tr onclick="self.location.href='/yes_rad/shop/order_view.asp?idx=<%=rs(0)%>';" style="cursor:pointer;">
					<td><%=rs(8)%></td>
					<td class='tl'><%=rs(2)%></td>
					<td><%=formatnumber(rs(22),0)%>원(<%=rs(24)%>개)</td>
					<td><%=rs(1)%></td>
					<td><%=formatdatetime(rs(3),2)%>(<%if rs(6)=0 Or rs(6)=2 then response.write"결제완료" else response.write"미결제" end if%>)</td>
					<td><%If rs(18) = 0 Then response.write"배송전" End if%><%If rs(18) = 1 Then response.write"배송중" End if%><%If rs(18) = 2 Then response.write"배송완료" End if%><%If rs(18) = 3 Then response.write"주문취소" End if%><%If rs(18) = 4 Then response.write"환불" End if%><%If rs(18) = 5 Then response.write"반품" End if%></td>
				</tr>
				<%
				rs.movenext
				Loop
				rs.close
				End If
				%>
			</tbody>
		</table>


	</div>
</div>

<iframe frameborder='0' width='0' height='0' id=gogo name='main' scrolling='no'
src='top1.asp' marginheight='0' marginwidth='0' ></iframe>
</body>
</html><%
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
<!-- #include file = "../authpg_2.asp" -->