<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim YY, MM, DD
dim sql ,rs, allRs, rows, rowsCount, cols, i, j
dim sumCount, maxCount, minCount
dim arrData(31,3), curSize, curPer, curDW, curCount
dim dataLength
dim addSize

call PageLoad()
call Manage()
call PageUnLoad()

'---------------------------------------------------------------------------------------------------------------
' 프로시저,함수
'---------------------------------------------------------------------------------------------------------------
sub PageLoad()

	YY = request ("YY")
	MM = request ("MM")

	call CheckDate(YY,MM,DD)

end sub
'---------------------------------------------------------------------------------------------------------------
sub PageUnLoad()
end sub
'---------------------------------------------------------------------------------------------------------------
sub Manage()

	dim sqlValue

	sqlValue = ""
	if YY <> "" then
		sqlValue = " vYY = "&YY&""
	end if

	if MM <> "" then
		if sqlValue <> "" then sqlValue = sqlValue & " and " end if
		sqlValue = sqlValue & " vMM = "&MM&""
	end if

	if sqlValue <> "" then sqlValue = " where " & sqlValue

	'카운터 수의 합을 구한다
	sql = "select count(vNum) from "&theTable&sqlValue&""
	set rs = db.execute(sql)

		if rs.eof or rs.bof then
		else
			sumCount = rs(0)
			rs.close()
		end if


	'일별 카운터를 구한다
	sql = "select vDW,count(vNum) from "&theTable&sqlValue&" group by vDW order by vDW"
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

		curSize		= int(((curCount/sumCount) * 550))
		curPer		= round(((curCount/sumCount) * 100),2)

		if cdbl(maxCount) < cdbl(curCount) then
			maxCount = curCount
		end if

		if cdbl(minCount) > cdbl(curCount) then
			minCount = curCount
		end if

		arrData(curDW,0) = curCount
		arrData(curDW,1) = curSize
		arrData(curDW,2) = curPer

	next

	dataLength = 7

	if minCount = 100000 then minCount = 0
	if cint(rowsCount) < cint(dataLength) then minCount = 0

	addSize = resizingGraph(maxCount,sumCount)

end sub
'---------------------------------------------------------------------------------------------------------------
function GetData(theNum)

	cols			= split(rows(theNum),chr(9)&chr(10))
	curDW		= cols(0)
	curCount	= cols(1)

end function
'---------------------------------------------------------------------------------------------------------------
function SetDetail(theNum)

	if arrData(theNum,0) = maxCount and maxCount <> 0 then
		arrData(theNum,0) = arrData(theNum,0)
	end if

	select case cint(theNum)
	case 1 curDW = "일"
	case 2 curDW = "월"
	case 3 curDW = "화"
	case 4 curDW = "수"
	case 5 curDW = "목"
	case 6 curDW = "금"
	case 7 curDW = "토"
	end select

end function

dim color_bar : color_bar = "#76A7FA,#CC0000,#FF6633,#76A7FA,#C5A5CF,#BC5679,#b87333,#cc9966,#009999,#cc99cc,#669933,#76A7FA,#CC0000,#FF6633,#76A7FA,#C5A5CF,#BC5679,#b87333,#cc9966,#009999,#cc99cc,#669933"
color_bar = split(color_bar,",")

%>

<!--#include file="../main/top.asp"-->

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>요일별통계</h2>

<form action="./dayOfWeek.asp" method="post" name="Form1">
		<div class="schWrap1">
			<h3>검색</h3>
			<div class="sch_area1">
						<select name="YY" onChange="document.Form1.submit();" class="seltxt w100">
                            <option value="">전체</option>
                            <%for i = year(date)-5 to year(date) + 5%>
                            <option value="<%=i%>"><%=i%>년</option>
                            <%next%>
                          </select>
                          <select name="MM" onChange="document.Form1.submit();" class="seltxt w80">
                            <option value="">전체</option>
                            <%for i = 1 to 12%>
                            <option value="<%=i%>"><%=i%>월</option>
                            <%next%>
                          </select>
			</div>
			
		</div>
</form>		
<script language="javascript">

	form = document.Form1;
	form.YY.value = '<%=YY%>';
	form.MM.value = '<%=MM%>';

</script>

		<div class="tbl_top">			
			<span class="tbl_total">전체 : <%=sumCount%></span>
			<%=ChangeDate("이전해","다음해","이전달","다음달","이전날","다음날")%>
		</div>

		<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);

   function drawChart() {
      var data = google.visualization.arrayToDataTable([
        ['요일', '방문자', { role: 'style' } ],
<%for i = 1 to dataLength : SetDetail(i)%>		
        ['<%=curDW%> (<%=round(arrData(i,2),1)%>%)', <%=arrData(i,0)%>, 'color: <%=color_bar(i)%>'],
<%next%>		
     
      ]);


        var options = {
          title: '요일별접속자',
          vAxis: {title: '',  titleTextStyle: {color: 'red'}}
        };


        var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>           
     <div id="chart_div" style="width:100%; height: 400px;"></div>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->