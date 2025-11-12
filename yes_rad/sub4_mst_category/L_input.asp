<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs,name,m_idx,idx,s_idx,ordnum,deep
Dim dr,rownum,isRecod,isRows,isCols
%>

<!--#include file="../main/top.asp"-->

<script>
function input_it(){
	var f = window.document.form1;
	if(f.name.value==""){
	alert("분류생성명을 입력해주세요.");
	f.name.focus();
	return;
	}	
	f.submit();
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>패키지카테고리</h2>

<form name="form1" method="post" action="L_input_ok.asp" enctype="multipart/form-data">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
                  <tr>
                    <th>숨김</th>
                    <td><input type="radio" name="state" value="0" checked> 아니오
						<input type="radio" name="state" value="1" > 예</td>
                  </tr>
					<tr>
						<th>분류명</th>
						<td><input type="text" id="name" name="name" class="inptxt1 w200" /></td>
					</tr>
                  <tr>
                    <th>상단이미지</th>
                    <td>
                      <input type="file" name="img" class="inptxt1 w200"> <span class="stip">* 분류목록 상단에 보여지는 이미지입니다.</span></td>
                  </tr>
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:input_it();" class="btn">저장하기</a>
			<a href="list.asp" class="btn trans">목록으로</a>		
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->