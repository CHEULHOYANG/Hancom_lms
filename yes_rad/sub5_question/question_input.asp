<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs,ordnum

sql = "select count(idx) from question_mast"
Set rs=db.execute(sql)

ordnum = rs(0)+1
rs.close
%>

<!--#include file="../main/top.asp"-->

<script>
function input_quiz(){

	var f = window.document.fm;

	if(f.title.value==""){
	alert("설문지 제목을 입력해주세요.");
	f.title.focus();
	return;
	}

	f.submit();
}

</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>설문지관리</h2>

<form action="question_input_ok.asp" method="post" name="fm">
			<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>설문 제목</th>
						<td><textarea name="title" cols="80" class="inptxt1 w500" id="title" style="height:70px"></textarea></td>
					</tr>
					<tr>
						<th>설문 기간</th>
						<td><input name="date1" type="text" class="inptxt1 w100" id="date1" />
                      ~
                      <input name="date2" type="text" class="inptxt1 w100" id="date2" /></td>
					</tr>
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:input_quiz();" class="btn">저장하기</a>
			<a href="question_list.asp" class="btn trans">목록보기</a>		
		</div>

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
        field: document.getElementById('date1'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)-10%>,<%=left(date(),4)+10%>]
    });
    var picker1 = new Pikaday(
    {
        field: document.getElementById('date2'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)-10%>,<%=left(date(),4)+10%>]
    });
</script>