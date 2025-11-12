<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim YY, MM, DD
dim sql ,rs, allRs, rows, rowsCount, cols, i, j
dim sumCount, maxCount, minCount
dim arrData(31,3), curSize, curPer, curMM, curCount
dim dataLength
dim addSize


call PageLoad()
call Manage()

sub PageLoad()

	YY = request ("YY")

	call CheckDate(YY,MM,DD)

end sub

sub Manage()

	dim sqlValue

	sqlValue = ""
	if YY <> "" then
		sqlValue = " where vYY = "&YY&""
	end if

	'카운터 수의 합을 구한다
	sql = "select count(vNum) from "&theTable&sqlValue&""
	set rs = db.execute(sql)

		if rs.eof or rs.bof then
		else
			sumCount = rs(0)
		rs.close()
		end if

	'일별 카운터를 구한다
	sql = "select vMM,count(vNum) from "&theTable&sqlValue&" group by vYY,vMM order by vYY,vMM"
	set rs = db.execute(sql)

		if rs.eof or rs.bof then
		else
			allRs = rs.getstring(2,,chr(9)&chr(10),chr(11)&chr(12))
			rows = split(allRs,chr(11)&chr(12))
			rowsCount = ubound(rows)
			rs.close()
		end if

	'배열 초기화
	for i = 0 to ubound(arrData)
		for j = 0 to 2
			arrData(i,j) = 0
		next
	next

	'날짜변 데이터를 배열에 담는다
	maxCount = 0
	minCount = 100000
	for i = 0 to rowsCount - 1

		GetData(i)

		curSize		= int(((curCount/sumCount) * 560))
		curPer		= round(((curCount/sumCount) * 100),2)

		if cdbl(maxCount) < cdbl(curCount) then
			maxCount = curCount
		end if

		if cdbl(minCount) > cdbl(curCount) then
			minCount = curCount
		end if

		arrData(curMM,0) = curCount
		arrData(curMM,1) = curSize
		arrData(curMM,2) = curPer

	next

	dataLength = 12

	if minCount = 100000 then minCount = 0
	if cint(rowsCount) < cint(dataLength) then minCount = 0

	addSize = resizingGraph(maxCount,sumCount)

end sub
'---------------------------------------------------------------------------------------------------------------
function GetData(theNum)

	cols			= split(rows(theNum),chr(9)&chr(10))
	curMM		= cols(0)
	curCount	= cols(1)

end function
'---------------------------------------------------------------------------------------------------------------
function SetDetail(theNum)

	if arrData(theNum,0) = maxCount and maxCount <> 0 then
		arrData(theNum,0) = arrData(theNum,0)
	end if

end function


dim color_bar : color_bar = "#76A7FA,#CC0000,#FF6633,#76A7FA,#C5A5CF,#BC5679,#b87333,#cc9966,#009999,#cc99cc,#669933,#76A7FA,#CC0000,#FF6633,#76A7FA,#C5A5CF,#BC5679,#b87333,#cc9966,#009999,#cc99cc,#669933"
color_bar = split(color_bar,",")

%>

<!--#include file="../main/top.asp"-->

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>월별통계</h2>

<form action="./month.asp" method="post" name="Form1">
		<div class="schWrap1">
			<h3>검색</h3>
			<div class="sch_area1">
						<select name="YY" onChange="document.Form1.submit();" class="seltxt w100">
                            <option value="">전체</option>
                            <%for i = year(date)-5 to year(date) + 5%>
                            <option value="<%=i%>"><%=i%>년</option>
                            <%next%>
                          </select>
			</div>
			
		</div>
</form>		
<script language="javascript">

	form = document.Form1;
	form.YY.value = '<%=YY%>';

</script>

		<div class="tbl_top">			
			<span class="tbl_total">전체 : <%=sumCount%>&nbsp;, 최대 : <%=maxCount%>&nbsp;, 최소: <%=minCount%></span>
			<%=ChangeDate("이전해","다음해","이전달","다음달","이전날","다음날")%>
		</div>

		<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);

   function drawChart() {
      var data = google.visualization.arrayToDataTable([
        ['월', '방문자', { role: 'style' } ],
<%for i = 1 to dataLength : SetDetail(i)%>		
        ['<%=i%>월 (<%=round(arrData(i,2),1)%>%)', <%=arrData(i,0)%>, 'color: <%=color_bar(i)%>'],
<%next%>		
     
      ]);


        var options = {
          title: '월별접속자',
          vAxis: {title: '',  titleTextStyle: {color: 'red'}}
        };


        var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>          
    <div id="chart_div" style="width:100%; height: 500px;"></div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->