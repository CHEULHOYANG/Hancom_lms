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

	clmn = theform.title;
	if(clmn.value==""){
		alert("쿠폰명을 입력해주세요!");
		return;
	}
	
	clmn = theform.lidx;
	if(clmn.value==""){
		alert("강좌를 선택해주세요!");
		return;
	}

	clmn = theform.make2;
	if(clmn.value==""){
		alert("쿠폰장수를 입력해주세요.");
		return;
	}

	theform.submit();
}

function OnlyNumber(el) {
	if(!IsNumeric(el.value)) {
		el.value = "";
		el.focus();
	}
}
function IsNumeric(sText)
{
   var ValidChars = "0123456789.";
   var IsNumber=true;
   var Char;

   for (i = 0; i < sText.length && IsNumber == true; i++) {
      Char = sText.charAt(i);
      if (ValidChars.indexOf(Char) == -1) {
         IsNumber = false;
      }
   }

   return IsNumber;
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span><%If request("gu") = 2 Then response.write"단과" Else response.write"패키지" End if%>무료수강 자동쿠폰생성</h2>

<form name="regfm" action="coupon_auto_ok.asp" method="post" style="display:inline;">
<input type="hidden" name="gu" value="<%=request("gu")%>">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>쿠폰제목</th>
						<td><input name="title" type="text" class="inptxt1 w400"></td>
					</tr>
					<tr>
						<th>유효기간</th>
						<td><input name="end_date" type="text" class="inptxt1 w100" id="end_date" size="20" readonly value="<%=Date()%>"></td>
					</tr>
					<tr>
							<th><%If request("gu") = 2 Then response.write"단과" Else response.write"패키지" End if%>선택</font></strong></th>
						  <td><select name="lidx" class="seltxt w400">
							<option value="">선택해주세요</option>
<%
If request("gu") = 2 Then
sql = "select idx,strnm from LecturTab order by idx desc"
Else
sql = "select idx,strnm from Lectmast order by ordn asc"
End if
set rs=db.execute(sql)

if rs.eof or rs.bof then
else
do until rs.eof
%>							
								<option value="<%=rs(0)%>"><%=rs(1)%></option>
<%
rs.movenext
loop
rs.close
end if
%>								
							</select>							</td>
						</tr>
					<tr>
						<th>생성수량</th>
						<td><input name="make2" type="text" class="inptxt1 w60" onKeyup="OnlyNumber(this)" value="10" size="5" maxlength="10"> 장</td>
					</tr>
				</tbody>
			</table>
</form>


		<div class="rbtn">
			<a href="javascript:go2Reg(regfm);" class="btn">저장하기</a>	
		</div>

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