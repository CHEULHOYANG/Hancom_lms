<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,isRows,isCols,rs
sql = "select idx,bname from dancate order by ordnum"
set dr = db.execute(sql)
if Not dr.bof or Not dr.Eof then
	isRecod = True
	isRows = split(dr.GetString(2),chr(13))
end if
dr.close
set dr = nothing
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function NumKeyOnly(){
	if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;
}

function go2Reg(theform){

	var clmn;

	clmn = theform.file;
	if(clmn.value==""){
		alert("쿠폰목록이 입력된 엑셀파일을 선택해주세요.");
		return;
	}

	theform.submit();
}

function FormatCutterny(number){
	var rValue = "";
	var EnableChar = "0123456789";
	var Chr='';
	var EnableNumber = '';

	for (i=0;i<number.length;i++) {
		Chr = number.charAt(i);
		if (EnableChar.indexOf(Chr) != -1){
			EnableNumber += Chr;
		}
	}

	var ABSNumber = '';
	ABSNumber = EnableNumber;

	if (ABSNumber.length < 4) {			//총길이가 3이하면 탈출
		rValue = ABSNumber;
		return rValue;
	}

	var ReverseWords = '';			//ReverseWords : 뒤집어진 '-'를 제외한 문자열

	for(i=ABSNumber.length;i>=0;i--){
			ReverseWords += ABSNumber.charAt(i);
	}

	rValue = ReverseWords.substring(0, 3);

	var dotCount = ReverseWords.length/3-1;
	for (j=1;j<=dotCount;j++){
		for(i=0;i<ReverseWords.length;i++){
			if (i==j*3)
				rValue+=","+ReverseWords.substring(i, i+3)
		}
	}

	var elseN = ReverseWords.length%3;
	if (elseN!=0){
		rValue+= ","+ReverseWords.substring(ReverseWords.length-elseN,ReverseWords.length)
	}

	ReverseWords = rValue;
	rValue = '';
	for(i=ReverseWords.length;i>=0;i--){
			rValue += ReverseWords.charAt(i);
	}

	return rValue;
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>할인쿠폰등록</h2>

<form name="regfm" action="coupon_price_ok.asp" method="post" enctype="multipart/form-data">
<input type="hidden" name="gu" value="<%=request("gu")%>">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>쿠폰파일</th>
						<td><input name="file" type="file" class="inptxt1" id="file" style="width:350px;" maxlength="50"> <a href="/xls_sample.zip" class="fbtn">예제파일다운</a></td>
					</tr>
					<tr>
						<th>유효기간</th>
						<td><input name="end_date" type="text" class="inptxt1 w100" id="end_date" readonly value="<%=Date()%>"></td>
					</tr>
					
				</tbody>
			</table>

		<div class="rbtn">
			<a href="javascript:go2Reg(regfm);" class="btn">저장하기</a>
		</div>

		<div class="caution"><p>파일형식은 xls파일로 제작</p></div>
		<div class="caution"><p>한줄에 하나씩 A 쿠폰번호 , B 할인금액순서로 입력</p></div>
		<div class="caution"><p>쉬트이름은 꼭 Sheet1로 만들어주세요</p></div>

	</div>
</div>


</body>
</html>

<link rel="stylesheet" href="../../include/pikaday.css">
<script src="../../include/moment.js"></script>
<script src="../../include/pikaday.js"></script>

<script>
    var picker = new Pikaday(
    {
        field: document.getElementById('end_date'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)-10%>,<%=left(date(),4)+10%>]
    });
</script>

<!-- #include file = "../authpg_2.asp" -->