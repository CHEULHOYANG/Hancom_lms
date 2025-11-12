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
	alert("설문질문을 입력해주세요.");
	f.title.focus();
	return;
	}

	f.submit();
}

function dandisplay(flag){

	if (flag==0)
	{
		mview_divList1.style.display = "";
		mview_divList2.style.display = "";
		mview_divList3.style.display = "";
		mview_divList4.style.display = "";
		mview_divList5.style.display = "";
		mview_divList6.style.display = "";
		mview_divList7.style.display = "";
		mview_divList8.style.display = "";
		mview_divList9.style.display = "";
		mview_divList10.style.display = "";
	}
	else
	{
		mview_divList1.style.display = "none";
		mview_divList2.style.display = "none";
		mview_divList3.style.display = "none";
		mview_divList4.style.display = "none";
		mview_divList5.style.display = "none";
		mview_divList6.style.display = "none";
		mview_divList7.style.display = "none";
		mview_divList8.style.display = "none";
		mview_divList9.style.display = "none";
		mview_divList10.style.display = "none";	
	}

} 
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>설문지항목관리</h2>

<form action="input_ok.asp" method="post" name="fm">
			<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>설문지선택</th>
						<td><select name="ca" class="seltxt" >
  <option value="0">분류를선택하세요.</option>
<%
sql="select idx,title from question_list order by idx desc"
set rs=db.execute(sql)
if rs.eof or rs.bof then
else
do until rs.eof
%>
      <option value="<%=rs(0)%>" <%If request("question_idx") = ""& rs(0) &"" Then Response.write"selected" End if%>><%=rs(1)%></option>
<%
rs.movenext
Loop
rs.close
end if
%>
    </select></td>
					</tr>
					<tr>
						<th>설문순서</th>
						<td><input type="text" name="ordnum" class="inptxt1 w60" size="5" onKeyUp="onlynum(fm.ordnum);" value="<%=ordnum%>">
							<span class="stip">* 0부터 정렬이 됩니다.</span></td>
					</tr>
					<tr>
						<th>설문구분</th>
						<td><input name="r_gu" type="radio" value="0" checked onClick="dandisplay(0);"> 
선택형&nbsp;&nbsp;
<input type="radio" name="r_gu" value="1" onClick="dandisplay(1);"> 
입력형</td>
					</tr>
					<tr>
						<th>설문질문</th>
						<td><textarea name="title" cols="80" class="inptxt1 w500" id="title" style="height:70px"></textarea></td>
					</tr>
<tr style="display:;" id="mview_divList1">
                    <th>1번 항목</th>
                    <td>
                      <input name="r1" type="text" class="inptxt1 w400" id="r1" size="80"></td>
                  </tr>
                  <tr style="display:;" id="mview_divList2">
                    <th>2번 항목</th>
                    <td>
                      <input name="r2" type="text" class="inptxt1 w400" id="r2" size="80"></td>
                  </tr>
                  <tr style="display:;" id="mview_divList3">
                    <th>3번 항목</th>
                    <td>
                      <input name="r3" type="text" class="inptxt1 w400" id="r3" size="80"></td>
                  </tr>
                  <tr style="display:;" id="mview_divList4">
                    <th>4번 항목</th>
                    <td>
                      <input name="r4" type="text" class="inptxt1 w400" id="r4" size="80"></td>
                  </tr>
                  <tr style="display:;" id="mview_divList5">
                    <th>5번 항목</th>
                    <td>
                      <input name="r5" type="text" class="inptxt1 w400" id="r5" size="80"></td>
                  </tr>
                  <tr style="display:;" id="mview_divList6">
                    <th>6번 항목</th>
                    <td>
                      <input name="r6" type="text" class="inptxt1 w400" id="r6" size="80"></td>
                  </tr>
                  <tr style="display:;" id="mview_divList7">
                    <th>7번 항목</th>
                    <td>
                      <input name="r7" type="text" class="inptxt1 w400" id="r7" size="80"></td>
                  </tr>
                  <tr style="display:;" id="mview_divList8">
                    <th>8번 항목</th>
                    <td>
                      <input name="r8" type="text" class="inptxt1 w400" id="r8" size="80"></td>
                  </tr>
                  <tr style="display:;" id="mview_divList9">
                    <th>9번 항목</th>
                    <td>
                      <input name="r9" type="text" class="inptxt1 w400" id="r9" size="80"></td>
                  </tr>
                  <tr style="display:;" id="mview_divList10">
                    <th>10번 항목</th>
                    <td>
                      <input name="r10" type="text" class="inptxt1 w400" id="r10" size="80"></td>
                  </tr>			
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:input_quiz();" class="btn">저장하기</a>
			<a href="list.asp" class="btn trans">목록보기</a>		
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->
