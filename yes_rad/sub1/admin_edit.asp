<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs,id,pwd,manage

sql = "select manage,id,pwd from admin_mast where id = '"& request("id") &"'"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then

	response.write"<script>"
	response.write"alert('데이터에러!!');"
	response.write"history.back();"
	response.write"</script>"
	response.end

Else

	manage = rs(0)
	id = rs(1)
	pwd = rs(2)

rs.close
End if
%>

<!--#include file="../main/top.asp"-->

<script language="javascript">
function InputChk(){

	var clmn = form1.id;
	if(clmn.value==""){
		alert("추가할 관리자 아이디를 입력해주세요!");
		clmn.focus();
		return;
	}

	clmn = form1.pwd;
	if(clmn.value==""){
		alert("패스워드를 입력해주세요!");
		clmn.focus();
		return;
	}
	
	document.form1.submit();
}

function AllCheck(thisimg,chekID){
	var srcAry = thisimg.src.split("/");
	if(srcAry[srcAry.length-1] == "noncheck.gif"){
		thisimg.src = "../rad_img/allcheck.gif";
		isChecked(true,chekID);
	}else{
		thisimg.src = "../rad_img/noncheck.gif";
		isChecked(false,chekID);
	}
}

function isChecked(cmd,chekID){
	var chekLen=chekID.length;
	if(chekLen){
		for (i=0;i<chekLen;i++){
			chekID[i].checked=cmd;
		}
	}
	else{
		chekID.checked=cmd;
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>관리자설정</h2>

		<form name="form1" method="post" action="admin_result.asp">
		<input type="hidden" name="id" value="<%=id%>">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>아이디</th>
						<td><strong><%=id%></strong></td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td><input type="text" id="pwd" name="pwd" class="inptxt1" value="<%=pwd%>" /></td>
					</tr>
					<tr>
						<th>권한설정</th>
						<td><img src="/yes_rad/rad_img/img/noncheck.gif" align="absmiddle" style="cursor:pointer;" onClick="AllCheck(this,document.all.manage);"> <font color='#cc0000'>전체항목선택</font><br />
						<input name="manage" type="checkbox" id="manage" value="a1" <%If InStr(manage,", a1,") Then response.write"checked" End if%> >
                        사이트정보관리
                        <input name="manage" type="checkbox" id="manage" value="a2" <%If InStr(manage,", a2,") Then response.write"checked" End if%>>
                        관리자설정
                        <input name="manage" type="checkbox" id="manage" value="a3" <%If InStr(manage,", a3,") Then response.write"checked" End if%>>
                        관리자접속허용
                        <input name="manage" type="checkbox" id="manage" value="a4" <%If InStr(manage,", a4,") Then response.write"checked" End if%>>
                        사용자접속차단
                        <input name="manage" type="checkbox" id="manage" value="a5" <%If InStr(manage,", a5,") Then response.write"checked" End if%>>
                        입금은행관리
                        <input name="manage" type="checkbox" id="manage" value="a6" <%If InStr(manage,", a6,") Then response.write"checked" End if%>>
                        팝업창설정
                        <input name="manage" type="checkbox" id="manage" value="a7" <%If InStr(manage,", a7,") Then response.write"checked" End if%>>
                        강의아이콘설정
                        <input name="manage" type="checkbox" id="manage" value="a8" <%If InStr(manage,", a8,") Then response.write"checked" End if%>>
                        모바일웹설정<br />
						<input name="manage" type="checkbox" id="manage" value="b1" <%If InStr(manage,", b1,") Then response.write"checked" End if%>>
                        파비콘관리
                          <input name="manage" type="checkbox" id="manage" value="b2" <%If InStr(manage,", b2,") Then response.write"checked" End if%>>
                          로고관리<br />
						  <input name="manage" type="checkbox" id="manage" value="c1" <%If InStr(manage,", c1,") Then response.write"checked" End if%>>
                        회원그룹관리
                          <input name="manage" type="checkbox" id="manage" value="c2" <%If InStr(manage,", c2,") Then response.write"checked" End if%>>
                          회원목록
                        <input name="manage" type="checkbox" id="manage" value="c3" <%If InStr(manage,", c3,") Then response.write"checked" End if%>>
                        회원대량등록
                        <input name="manage" type="checkbox" id="manage" value="c4" <%If InStr(manage,", c4,") Then response.write"checked" End if%>>
                        마일리지내역
                        <input name="manage" type="checkbox" id="manage" value="c5" <%If InStr(manage,", c5,") Then response.write"checked" End if%>>
                        회원출석현황
                        <input name="manage" type="checkbox" id="manage" value="c6" <%If InStr(manage,", c6,") Then response.write"checked" End if%>>
                        탈퇴회원관리
                        <input name="manage" type="checkbox" id="manage" value="c7" <%If InStr(manage,", c7,") Then response.write"checked" End if%>>
                        금지아이디관리
                        <input name="manage" type="checkbox" id="manage" value="c8" <%If InStr(manage,", c8,") Then response.write"checked" End if%>>
                        이메일발송관리
                        <input name="manage" type="checkbox" id="manage" value="c9" <%If InStr(manage,", c9,") Then response.write"checked" End if%>>
                        문자발송그룹관리
                        <input name="manage" type="checkbox" id="manage" value="c10" <%If InStr(manage,", c10,") Then response.write"checked" End if%>>
                        문자발송관리<br />
						<input name="manage" type="checkbox" id="manage" value="d1" <%If InStr(manage,", d1,") Then response.write"checked" End if%>>
                        과목관리
                        <input name="manage" type="checkbox" id="manage" value="d2" <%If InStr(manage,", d2,") Then response.write"checked" End if%>>
                        선생님관리
                        <input name="manage" type="checkbox" id="manage" value="d3" <%If InStr(manage,", d3,") Then response.write"checked" End if%>>
                        선생님등록
                        <input name="manage" type="checkbox" id="manage" value="d4" <%If InStr(manage,", d4,") Then response.write"checked" End if%>>
                        공지사항
                        <input name="manage" type="checkbox" id="manage" value="d5" <%If InStr(manage,", d5,") Then response.write"checked" End if%>>
                        자료실
                        <input name="manage" type="checkbox" id="manage" value="d6" <%If InStr(manage,", d6,") Then response.write"checked" End if%>>
                        질문과답변
                        <input name="manage" type="checkbox" id="manage" value="d7" <%If InStr(manage,", d7,") Then response.write"checked" End if%>>
                        수강후기<br />
						<input name="manage" type="checkbox" id="manage" value="e1" <%If InStr(manage,", e1,") Then response.write"checked" End if%>>
                        상품카테고리
                        <input name="manage" type="checkbox" id="manage" value="e2" <%If InStr(manage,", e2,") Then response.write"checked" End if%>>
                        상품목록
                        <input name="manage" type="checkbox" id="manage" value="e3" <%If InStr(manage,", e3,") Then response.write"checked" End if%>>
                        상품등록
                        <input name="manage" type="checkbox" id="manage" value="e4" <%If InStr(manage,", e4,") Then response.write"checked" End if%>>
                        상품대량등록
                        <input name="manage" type="checkbox" id="manage" value="e5" <%If InStr(manage,", e5,") Then response.write"checked" End if%>>
                        주문/배송관리<br />
						<input name="manage" type="checkbox" id="manage" value="f1" <%If InStr(manage,", f1,") Then response.write"checked" End if%>>
                        강좌관리
                          <input name="manage" type="checkbox" id="manage" value="f2" <%If InStr(manage,", f2,") Then response.write"checked" End if%>>
                          카테고리관리
                          <input name="manage" type="checkbox" id="manage" value="f3" <%If InStr(manage,", f3,") Then response.write"checked" End if%>>
                          쿠폰관리
                          <input name="manage" type="checkbox" id="manage" value="f4" <%If InStr(manage,", f4,") Then response.write"checked" End if%>>
                          수강관리
                          <input name="manage" type="checkbox" id="manage" value="f5" <%If InStr(manage,", f5,") Then response.write"checked" End if%>>
                        매출통계<br />
						<input name="manage" type="checkbox" id="manage" value="g1" <%If InStr(manage,", g1,") Then response.write"checked" End if%>>
                        시험카테고리
                          <input name="manage" type="checkbox" id="manage" value="g2" <%If InStr(manage,", g2,") Then response.write"checked" End if%>>
                          시험목록
                        <input name="manage" type="checkbox" id="manage" value="g3" <%If InStr(manage,", g3,") Then response.write"checked" End if%>>
                        시험만들기
                        <input name="manage" type="checkbox" id="manage" value="g4" <%If InStr(manage,", g4,") Then response.write"checked" End if%>>
                        시험결과보기<br />
						<input name="manage" type="checkbox" id="manage" value="h1" <%If InStr(manage,", h1,") Then response.write"checked" End if%>>
                        공지사항
                        <input name="manage" type="checkbox" id="manage" value="h2" <%If InStr(manage,", h2,") Then response.write"checked" End if%>>
                        질문과답변
                        <input name="manage" type="checkbox" id="manage" value="h3" <%If InStr(manage,", h3,") Then response.write"checked" End if%>>
                        자주묻는질문
                        <input name="manage" type="checkbox" id="manage" value="h4" <%If InStr(manage,", h4,") Then response.write"checked" End if%>>
                        안내문편집
                        <input name="manage" type="checkbox" id="manage" value="h5" <%If InStr(manage,", h5,") Then response.write"checked" End if%>>
                        배너관리
                        <input name="manage" type="checkbox" id="manage" value="h6" <%If InStr(manage,", h6") Then response.write"checked" End if%>>
                        시험일정<br />
						<input name="manage" type="checkbox" id="manage" value="i1" <%If InStr(manage,", i1,") Then response.write"checked" End if%>>
                        게시판관리<br />
						<input name="manage" type="checkbox" id="manage" value="j1" <%If InStr(manage,", j1,") Then response.write"checked" End if%>>
                        접속자분석
                        <input name="manage" type="checkbox" id="manage" value="j2" <%If InStr(manage,", j2,") Then response.write"checked" End if%>>
                        월별분석
                        <input name="manage" type="checkbox" id="manage" value="j3" <%If InStr(manage,", j3,") Then response.write"checked" End if%>>
                        일별분석
                        <input name="manage" type="checkbox" id="manage" value="j4" <%If InStr(manage,", j4,") Then response.write"checked" End if%>>
                        요일별분석
                        <input name="manage" type="checkbox" id="manage" value="j5" <%If InStr(manage,", j5,") Then response.write"checked" End if%>>
                        시간별분석
                        <input name="manage" type="checkbox" id="manage" value="j6" <%If InStr(manage,", j6,") Then response.write"checked" End if%>>
                        분기별분석
                        <input name="manage" type="checkbox" id="manage" value="j7" <%If InStr(manage,", j7,") Then response.write"checked" End if%>>
                        접속경로분석
                        <input name="manage" type="checkbox" id="manage" value="j8" <%If InStr(manage,", j8,") Then response.write"checked" End if%>>
                        접속초기화</td>
					</tr>
				</tbody>
			</table>

		<div class="rbtn">
			<a href="javascript:InputChk();" class="btn">저장하기</a>		
			<a href="admin_list.asp" class="btn trans">목록보기</a>
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->