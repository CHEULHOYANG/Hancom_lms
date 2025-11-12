<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs,favicon

sql = "select favicon from site_info"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
	favicon = ""
Else
	favicon = rs(0)
rs.close
End if
%>

<!--#include file="../main/top.asp"-->

<script language="javascript">
function delLogo(){
		var bool = confirm("해당 태그를 삭제하시겠습니까?");
		if (bool){
			location.href = "favicon_del.asp";
		}
}
function go2Logo(){
	var f = window.document.lfom;
	if(f.pto.value==""){
	alert("파비콘을 선택해주세요.");
	return;
	}
	f.submit();
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>파비콘설정</h2>
			
			<form name="lfom" action="favicon_ok.asp" method="post" enctype="multipart/form-data" style="display:inline;">
			<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
<%If len(favicon) > 0 then%>
					<tr>
						<th>등록이미지</th>
						<td><img src="../../ahdma/logo/<%=favicon%>">
							<a href="javascript:delLogo();" class="fbtn">삭제</a></td>
					</tr>
<%End if%>
					<tr>
						<th>파일선택</th>
						<td><input type="file" id="pto" name="pto" class="inptxt1 w400" />
							<a href="javascript:go2Logo();" class="fbtn">저장하기</a></td>
					</tr>

				</tbody>
			</table>
			</form>

			<div class="caution"><p>아이콘 제네레이터를 이용해서 제작하기 http://www.xiconeditor.com</p></div>
			<div class="caution"><p>이미지파일 포맷을 변환하기 http://www.smoothdraw.com/product/freeware.htm</p></div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->