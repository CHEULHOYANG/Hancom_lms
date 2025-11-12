<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim YY, MM, DD
dim sql ,rs, allRs, rows, rowsCount, cols, i
dim sumCount
dim vIP, vBrowser, vOS, vReferer, vTarget, vHH, vMT


call PageLoad()
call Manage()
call PageUnLoad()

'---------------------------------------------------------------------------------------------------------------
' 프로시저,함수
'---------------------------------------------------------------------------------------------------------------
sub PageLoad()

	
	YY = request("YY")
	MM = request("MM")
	DD = request("DD")

	if YY = "" then
		YY = year(date)
	end if

	if MM = "" then
		MM = month(date)
	end if

	if DD = "" then
		DD = day(date)
	end if

end sub
'---------------------------------------------------------------------------------------------------------------
sub PageUnLoad()
end sub
'---------------------------------------------------------------------------------------------------------------
sub Manage()
	
	'카운터 수의 합을 구한다
	sql = "select count(vNum) from " & theTable & " where vYY = "&YY&" and vMM = "&MM&" and vDD = "&DD&""
	set rs = db.execute(sql)

		if rs.eof or rs.bof then
		else
			sumCount = rs(0)
		end if

	rs.close()
	set rs = nothing	
	
	sql = "select vIP,vBrowser,vOS,vReferer,vTarget,vHH,vMT from " & theTable & " where vYY = "&YY&" and vMM = "&MM&" and vDD = "&DD&" order by vNum desc"
	set rs = db.execute(sql)

		if rs.eof or rs.bof then
		else
			allRs = rs.getstring(2,,chr(9)&chr(10),chr(11)&chr(12))
			rows = split(allRs,chr(11)&chr(12))
			rowsCount = ubound(rows)		
		end if

	rs.close()
	set rs = nothing

end sub
'---------------------------------------------------------------------------------------------------------------
function GetData(theNum)

	cols					= split(rows(theNum),chr(9)&chr(10))
	vIP					= cols(0)
	vBrowser			= cols(1)
	vOS					= cols(2)
	vReferer			= cols(3)
	vTarget			= cols(4)
	vHH					= cols(5)
	vMT					= cols(6)

	if trim(vBrowser) = "" then
		vBrowser = "unKnown"
	end if

	select case lcase(trim(vOS))
	case "" 
		vOS = "unKnown"

	case "windows nt 5.0" 
		vOS = "Windows 2000"

	case "windows nt 5.1" 
		vOS = "Windows XP"

	end select

end function
'---------------------------------------------------------------------------------------------------------------
function SetSize(theNum)

	if cint(theNum) < 10 then
		theNum = "0" & theNum
	end if

	SetSize = theNum	

end function
'---------------------------------------------------------------------------------------------------------------
function fncPreDay(theText)

	dim preMM

	preMM = dateadd("d",-1,cdate(YY&"-"&MM&"-"&DD))

	fncPreDay = "<a href='./list.asp?YY="&year(preMM)&"&MM="&month(preMM)&"&DD="&day(preMM)&"' class='btn_search3'>" & theText & "</a>"

end function
'---------------------------------------------------------------------------------------------------------------
function fncNextDay(theText)

	dim nextMM

	nextMM = dateadd("d",1,cdate(YY&"-"&MM&"-"&DD))

	fncNextDay = "<a href='./list.asp?YY="&year(nextMM)&"&MM="&month(nextMM)&"&DD="&day(nextMM)&"' class='btn_search2'>" & theText & "</a>"

end function

Function cutStr(str, cutLen)
	Dim strLen, strByte, strCut, strRes, char, i
	strLen = 0
	strByte = 0
	strLen = Len(str)
	for i = 1 to strLen
		char = ""
		strCut = Mid(str, i, 1)	'	일단 1만큼 잘라서 strRes에 저장한다.
		char = Asc(strCut)		'	아스키 코드값 읽어오기
		char = Left(char, 1)
		if char = "-" then			'	"-"이면 2바이트 문자임
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
	cutStr = strRes				'사용방법 cutstr(title,15)
End Function
%>

<!--#include file="../main/top.asp"-->


<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>접속주소정보</h2>

<form action="./list.asp" method="post" name="Form1">
		<div class="schWrap1">
			<h3>검색</h3>
			<div class="sch_area1">
				<select name="YY" class="seltxt w100">
                        <%for i = year(date)-5 to year(date) + 5%>
                        <option value="<%=i%>"><%=i%>년</option>
                        <%next%>
                      </select>
                      <select name="MM" class="seltxt w80">
                        <%for i = 1 to 12%>
                        <option value="<%=i%>"><%=i%>월</option>
                        <%next%>
                      </select>
                      <select name="DD" onChange="document.Form1.submit();" class="seltxt w80">
                        <%for i = 1 to 31%>
                        <option value="<%=i%>"><%=i%>일</option>
                        <%next%>
                      </select>
			</div>
					
		</div>
</form>

		<div class="tbl_top">			
			<span class="tbl_total">전체 : <%=sumCount%></span>
			<%=fncPreDay("이전날")%><%=fncNextDay("다음날")%>
		</div>

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col style="width:25%" />
			<col style="width:25%" />
			<col style="width:25%" />
			<col style="width:20%" />
			</colgroup>
			<thead>
				<tr>
					<th rowspan="2" >번호</th>	
					<th>시간</th>
					<th colspan="3" >이전주소</th>
					<th>브라우져</th>	
				</tr>		
				<tr>
					<th>아이피</th>
					<th colspan="3" >접속주소</th>
					<th>OS</th>	
				</tr>				
			</thead>
			<tbody>
<%
if rowsCount < 1 Then
Else

	for i = 0 to rowsCount - 1 : GetData(i)
%>
				<tr>
					<td rowspan="2"><%=rowsCount - i%></td>
					<td><%=SetSize(vHH)&":"&SetSize(vMT)%></td>
					<td colspan="3"><a href="<%=vReferer%>" target="_blank"><%=cutstr(vReferer,100)%></a></td>
					<td><%=vBrowser%></td>
				</tr>
				<tr>
					<td><%=vIP%></td>
					<td colspan="3"><a href="<%=vTarget%>"><%=cutstr(vTarget,100)%></a></td>
					<td><%=vOS%></td>
				</tr>
<%
	Next
	
end if
%>
			</tbody>
		</table>

	</div>
</div>


<script language="javascript">

	form = document.Form1;
	form.YY.value = '<%=YY%>';
	form.MM.value = '<%=MM%>';
	form.DD.value = '<%=DD%>';

</script>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->