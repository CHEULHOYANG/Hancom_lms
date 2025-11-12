<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,dr,rs
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function RdoBtnn(r){
	rdobj = eval("fm." + r);

	fq = true;
	for(i=0;i<rdobj.length;i++){
		if(rdobj[i].checked){
			fq = false;
			break;
		}
	}
return fq;
}

function go2WriteOk(thefm){
	var clmn;
	clmn = thefm.jemok;
	if(clmn.value==""){
		alert("게시판 제목을 입력하세요!");
		clmn.focus();
		return;
	}
	if(clmn.value.replace(/ /g,"")==""){
		alert("게시판 제목을 입력하세요!");
		clmn.select();
		return;
	}

	if(RdoBtnn("pgbn")){
		alert("권한을 선택해주세요!");
		return;
	}

	if(RdoBtnn("ygbn")){
		alert("용도를 선택해주세요!");
		return;
	}

	if(RdoBtnn("mgbn")){
		alert("댓글을 선택해주세요!");
		return;
	}

thefm.submit();
}

</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>게시판생성</h2>
<form name="fm" action="creatb_ok.asp" method="post" style="display:inline;">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>회원그룹</th>
						<td><%
sql = "select idx,title from group_mast where gu = 0 "
set rs=db.execute(sql)

if rs.eof or rs.bof then
else
do until rs.eof
%>
<input type="checkbox" name="mem_group" id="mem_group" value="<%=rs(0)%>" /> <%=rs(1)%>&nbsp;<%
rs.movenext
loop
rs.close
end if
%></td>
					</tr>
					<tr>
						<th>제목</th>
						<td><input type="text" name="jemok" class="inptxt1 w200"></td>
					</tr>
					<tr>
						<th>보기제한</th>
						<td><input type="radio" name="logincheck" value="0" checked> 없음
                          <input type="radio" name="logincheck" value="1"> 회원만
                          <input type="radio" name="logincheck" value="2"> 수강회원만</td>
					</tr>
					<tr>
						<th>작성권한</th>
						<td><input type="radio" name="pgbn" value="0"> 관리자전용
                          <input type="radio" name="pgbn" value="1">  회원전용</td>
					</tr>
					<tr>
						<th>구분</th>
						<td><input type="radio" name="ygbn" value="1"> 자료실
                          <input type="radio" name="ygbn" value="2"> 커뮤니티(갤러리)
                          <input type="radio" name="ygbn" value="3"> 커뮤니티(일반)</td>
					</tr>
					<tr>
						<th>댓글</th>
						<td><input type="radio" name="mgbn" value="0"> 허용 안함
						<input type="radio" name="mgbn" value="1"> 허용</td>
					</tr>
					<tr>
						<th>상단내용</th>
						<td><textarea name="top_message" class="inptxt1" id="top_message" style="width:600px;height:100px"></textarea></td>
					</tr>					
					<tr>
						<th>하단내용</th>
						<td><textarea name="bottom_message" class="inptxt1" id="bottom_message" style="width:600px;height:100px"></textarea></td>
					</tr>		
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:go2WriteOk(fm);" class="btn">저장하기</a>
			<a href="javascript:history.back();" class="btn trans">목록보기</a>		
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->