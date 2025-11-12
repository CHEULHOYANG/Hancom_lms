<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim info1,info2,info3,info4,info5,info6,info7,info8,info9,info10
Dim sql,rs
Dim link1,link2,link3,link4,link5,link6
Dim link1_etc,link2_etc,link3_etc,link4_etc,link5_etc,link6_etc

sql="select info1,info2,info3,info4,info5,info6,info7,info8,info9,info10,link1,link2,link3,link4,link5,link6,link1_etc,link2_etc,link3_etc,link4_etc,link5_etc,link6_etc from end_paper_config"
set rs=db.execute(sql)

if rs.eof or rs.bof Then

	info1 = "타이틀1"
	info2 = "타이틀2"
	info3 = "타이틀3"
	info4 = "타이틀4"
	info5 = "타이틀5"
	info6 = "타이틀6"
	info7 = "타이틀7"
	info8 = "타이틀8"
	info9 = "타이틀9"
	info10 = "타이틀10"
	link1 = ""
	link2 = ""
	link3 = ""
	link4 = ""
	link5 = ""
	link6 = ""

Else

	info1 = rs(0)
	info2 = rs(1)
	info3 = rs(2)
	info4 = rs(3)
	info5 = rs(4)
	info6 = rs(5)
	info7 = rs(6)
	info8 = rs(7)
	info9 = rs(8)
	info10 = rs(9)
	link1 = rs(10)
	link2 = rs(11)
	link3 = rs(12)
	link4 = rs(13)
	link5 = rs(14)
	link6 = rs(15)
	link1_etc = rs(16)
	link2_etc = rs(17)
	link3_etc = rs(18)
	link4_etc = rs(19)
	link5_etc = rs(20)
	link6_etc = rs(21)

rs.close
end if
%>
<!--#include file="../main/top.asp"-->
<script>
function edit_quiz(){

	var f = window.document.fm;

	f.submit();
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>수료증설정</h2>
		
		<form action="config_ok.asp" method="post" enctype="multipart/form-data" name="fm" >
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>타이틀1번 명칭</th>
						<td><input name="info1" type="text" class="inptxt1" id="info1" value="<%=info1%>" ></td>
					</tr>
					<tr>
						<th>타이틀2번 명칭</th>
						<td><input name="info2" type="text" class="inptxt1" id="info2" value="<%=info2%>" ></td>
					</tr>
					<tr>
						<th>타이틀2번 수료증 발급 연동</th>
						<td><input type="radio" name="link1" value="" <%If link1="" Then Response.write"checked" End if%>> 미연동 
				  <input type="radio" name="link1" value="name" <%If link1="name" Then Response.write"checked" End if%>> 이름 
				  <input type="radio" name="link1" value="jumin1" <%If link1="jumin1" Then Response.write"checked" End if%>>생년월일 
				  <input type="radio" name="link1" value="lec" <%If link1="lec" Then Response.write"checked" End if%>>수강강의 
				  <input type="radio" name="link1" value="etc" <%If link1="etc" Then Response.write"checked" End if%>> 기타(<input name="link1_etc" type="text" class="inptxt1" id="link1_etc" value="<%=link1_etc%>" size="50">)</td>
					</tr>
					<tr>
						<th>타이틀3번 명칭</th>
						<td><input name="info3" type="text" class="inptxt1" id="info3" value="<%=info3%>" ></td>
					</tr>
					<tr>
						<th>타이틀3번 수료증 발급 연동</th>
						<td><input type="radio" name="link2" value="" <%If link2="" Then Response.write"checked" End if%>> 미연동 
				  <input type="radio" name="link2" value="name" <%If link2="name" Then Response.write"checked" End if%>> 이름 
				  <input type="radio" name="link2" value="jumin1" <%If link2="jumin1" Then Response.write"checked" End if%>>생년월일 
				  <input type="radio" name="link2" value="lec" <%If link2="lec" Then Response.write"checked" End if%>>수강강의 
				  <input type="radio" name="link2" value="etc" <%If link2="etc" Then Response.write"checked" End if%>> 기타(<input name="link2_etc" type="text" class="inptxt1" id="link2_etc" value="<%=link2_etc%>" size="50">)</td>
					</tr>
					<tr>
						<th>타이틀4번 명칭</th>
						<td><input name="info4" type="text" class="inptxt1" id="info4" value="<%=info4%>" ></td>
					</tr>
					<tr>
						<th>타이틀4번 수료증 발급 연동</th>
						<td><input type="radio" name="link3" value="" <%If link3="" Then Response.write"checked" End if%>> 미연동 
				  <input type="radio" name="link3" value="name" <%If link3="name" Then Response.write"checked" End if%>> 이름 
				  <input type="radio" name="link3" value="jumin1" <%If link3="jumin1" Then Response.write"checked" End if%>>생년월일 
				  <input type="radio" name="link3" value="lec" <%If link3="lec" Then Response.write"checked" End if%>>수강강의 
				  <input type="radio" name="link3" value="etc" <%If link3="etc" Then Response.write"checked" End if%>> 기타(<input name="link3_etc" type="text" class="inptxt1" id="link3_etc" value="<%=link3_etc%>" size="50">)</td>
					</tr>

					<tr>
						<th>타이틀5번 명칭</th>
						<td><input name="info5" type="text" class="inptxt1" id="info5" value="<%=info5%>" ></td>
					</tr>
					<tr>
						<th>타이틀5번 수료증 발급 연동</th>
						<td><input type="radio" name="link4" value="" <%If link4="" Then Response.write"checked" End if%>> 미연동 
				  <input type="radio" name="link4" value="name" <%If link4="name" Then Response.write"checked" End if%>> 이름 
				  <input type="radio" name="link4" value="jumin1" <%If link4="jumin1" Then Response.write"checked" End if%>>생년월일 
				  <input type="radio" name="link4" value="lec" <%If link4="lec" Then Response.write"checked" End if%>>수강강의 
				  <input type="radio" name="link4" value="etc" <%If link4="etc" Then Response.write"checked" End if%>> 기타(<input name="link4_etc" type="text" class="inptxt1" id="link4_etc" value="<%=link4_etc%>" size="50">)</td>
					</tr>
					<tr>
						<th>타이틀6번 명칭</th>
						<td><input name="info6" type="text" class="inptxt1" id="info6" value="<%=info6%>" ></td>
					</tr>
					<tr>
						<th>타이틀6번 수료증 발급 연동</th>
						<td><input type="radio" name="link5" value="" <%If link5="" Then Response.write"checked" End if%>> 미연동 
				  <input type="radio" name="link5" value="name" <%If link5="name" Then Response.write"checked" End if%>> 이름 
				  <input type="radio" name="link5" value="jumin1" <%If link5="jumin1" Then Response.write"checked" End if%>>생년월일 
				  <input type="radio" name="link5" value="lec" <%If link5="lec" Then Response.write"checked" End if%>>수강강의 
				  <input type="radio" name="link5" value="etc" <%If link5="etc" Then Response.write"checked" End if%>> 기타(<input name="link5_etc" type="text" class="inptxt1" id="link5_etc" value="<%=link5_etc%>" size="50">)</td>
					</tr>
					<tr>
						<th>타이틀7번 명칭</th>
						<td><input name="info7" type="text" class="inptxt1" id="info7" value="<%=info7%>" ></td>
					</tr>
					<tr>
						<th>타이틀7번 수료증 발급 연동</th>
						<td><input type="radio" name="link6" value="" <%If link6="" Then Response.write"checked" End if%>> 미연동 
				  <input type="radio" name="link6" value="name" <%If link6="name" Then Response.write"checked" End if%>> 이름 
				  <input type="radio" name="link6" value="jumin1" <%If link6="jumin1" Then Response.write"checked" End if%>>생년월일 
				  <input type="radio" name="link6" value="lec" <%If link6="lec" Then Response.write"checked" End if%>>수강강의 
				  <input type="radio" name="link6" value="etc" <%If link6="etc" Then Response.write"checked" End if%>> 기타(<input name="link6_etc" type="text" class="inptxt1" id="link6_etc" value="<%=link6_etc%>" size="50">)</td>
					</tr>
					<tr>
						<th>내용</th>
						<td><textarea name="info8" cols="80" class="inptxt1" wrap="hard" id="info8" style="width:560px;height:100px"><%=info8%></textarea></td>
					</tr>
					<tr>
						<th>직인</th>
						<td><input type="file" name="file1" id="file1" class="inptxt1">
                    <%if len(info9) > 0 then%><input name="check_del1" type="checkbox" id="check_del1" value="1"> 
                    삭제<%end if%></td>
					</tr>
					<tr>
						<th>업체이름</th>
						<td><input name="info10" type="text" class="inptxt1" id="info10" value="<%=info10%>" ></td>
					</tr>

				</tbody>
			</table>
		<div class="rbtn">
			<a href="javascript:edit_quiz();" class="btn">저장하기</a>
		</div>


<div class="caution"><p>입력칸을 미입력시 미사용을 하게 됩니다.</p></div>

		<iframe src="print_view.asp" width="1100" height="1300" frameborder='0'></iframe>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->