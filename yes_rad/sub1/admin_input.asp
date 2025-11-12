<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,recodnum
recodnum = 0
sql="select idx,id,pwd,regdate from admin_mast order by idx desc"
set dr = db.execute(sql)
if Not Dr.Bof or Not Dr.Eof then
	isRecod = True
	Dim isRows
	isRows = Split(Dr.GetString(2),chr(13))
	recodnum = UBound(isRows)
end if

Dr.Close
Set Dr = Nothing
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
function DeleteAdm(idxnum){
	var adLevel =<%=recodnum%>;
	if(adLevel< 2){
		alert("관리자 계정은 최소 1개 이상 있어야 합니다.\n\n관리자 계정을 1개 이상 추가하신 후에 삭제 해주세요!");
	}
	else{
		del_ck = confirm("해당 관리자 계정을 삭제하시겠습니까?");
		if(del_ck){
			document.location.href="admin_del.asp?idxnum=" + idxnum;
		}
	}
}

function AllCheck(thisimg,chekID){
	var srcAry = thisimg.src.split("/");
	if(srcAry[srcAry.length-1] == "noncheck.gif"){
		thisimg.src = "/yes_rad/rad_img/img/allcheck.gif";
		isChecked(true,chekID);
	}else{
		thisimg.src = "/yes_rad/rad_img/img/noncheck.gif";
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
			<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>아이디</th>
						<td><input type="text" id="id" name="id" class="inptxt1" /></td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td><input type="text" id="pwd" name="pwd" class="inptxt1" /></td>
					</tr>
					<tr>
						<th>권한설정</th>
						<td><img src="/yes_rad/rad_img/img/noncheck.gif" align="absmiddle" style="cursor:pointer;" onClick="AllCheck(this,document.all.manage);"> <font color='#cc0000'>전체항목선택</font><br />
						<input name="manage" type="checkbox" id="manage" value="a1">
                        사이트정보관리
                        <input name="manage" type="checkbox" id="manage" value="a2">
                        관리자설정
                        <input name="manage" type="checkbox" id="manage" value="a3">
                        관리자접속허용
                        <input name="manage" type="checkbox" id="manage" value="a4">
                        사용자접속차단
                        <input name="manage" type="checkbox" id="manage" value="a5">
                        입금은행관리
                        <input name="manage" type="checkbox" id="manage" value="a6">
                        팝업창설정
                        <input name="manage" type="checkbox" id="manage" value="a7">
                        강의아이콘설정
                        <input name="manage" type="checkbox" id="manage" value="a8">
                        모바일웹설정<br />
						<input name="manage" type="checkbox" id="manage" value="b1">
                        파비콘관리
                          <input name="manage" type="checkbox" id="manage" value="b2">
                          로고관리<br />
						  <input name="manage" type="checkbox" id="manage" value="c1">
                        회원그룹관리
                          <input name="manage" type="checkbox" id="manage" value="c2">
                          회원목록
                        <input name="manage" type="checkbox" id="manage" value="c3">
                        회원대량등록
                        <input name="manage" type="checkbox" id="manage" value="c4">
                        마일리지내역
                        <input name="manage" type="checkbox" id="manage" value="c5">
                        회원출석현황
                        <input name="manage" type="checkbox" id="manage" value="c6">
                        탈퇴회원관리
                        <input name="manage" type="checkbox" id="manage" value="c7">
                        금지아이디관리
                        <input name="manage" type="checkbox" id="manage" value="c8">
                        이메일발송관리
                        <input name="manage" type="checkbox" id="manage" value="c9">
                        문자발송그룹관리
                        <input name="manage" type="checkbox" id="manage" value="c10">
                        문자발송관리<br />
						<input name="manage" type="checkbox" id="manage" value="d1">
                        과목관리
                        <input name="manage" type="checkbox" id="manage" value="d2">
                        선생님관리
                        <input name="manage" type="checkbox" id="manage" value="d3">
                        선생님등록
                        <input name="manage" type="checkbox" id="manage" value="d4">
                        공지사항
                        <input name="manage" type="checkbox" id="manage" value="d5">
                        자료실
                        <input name="manage" type="checkbox" id="manage" value="d6">
                        질문과답변
                        <input name="manage" type="checkbox" id="manage" value="d7">
                        수강후기<br />
						<input name="manage" type="checkbox" id="manage" value="e1">
                        상품카테고리
                        <input name="manage" type="checkbox" id="manage" value="e2">
                        상품목록
                        <input name="manage" type="checkbox" id="manage" value="e3">
                        상품등록
                        <input name="manage" type="checkbox" id="manage" value="e4">
                        상품대량등록
                        <input name="manage" type="checkbox" id="manage" value="e5">
                        주문/배송관리<br />
						<input name="manage" type="checkbox" id="manage" value="f1">
                        강좌관리
                          <input name="manage" type="checkbox" id="manage" value="f2">
                          카테고리관리
                          <input name="manage" type="checkbox" id="manage" value="f3">
                          쿠폰관리
                          <input name="manage" type="checkbox" id="manage" value="f4">
                          수강관리
                          <input name="manage" type="checkbox" id="manage" value="f5">
                        매출통계<br />
						<input name="manage" type="checkbox" id="manage" value="g1">
                        시험카테고리
                          <input name="manage" type="checkbox" id="manage" value="g2">
                          시험목록
                        <input name="manage" type="checkbox" id="manage" value="g3">
                        시험만들기
                        <input name="manage" type="checkbox" id="manage" value="g4">
                        시험결과보기<br />
						<input name="manage" type="checkbox" id="manage" value="h1">
                        공지사항
                        <input name="manage" type="checkbox" id="manage" value="h2">
                        질문과답변
                        <input name="manage" type="checkbox" id="manage" value="h3">
                        자주묻는질문
                        <input name="manage" type="checkbox" id="manage" value="h4">
                        안내문편집
                        <input name="manage" type="checkbox" id="manage" value="h5">
                        배너관리
                        <input name="manage" type="checkbox" id="manage" value="h6">
                        시험일정<br />
						<input name="manage" type="checkbox" id="manage" value="i1">
                        게시판관리<br />
						<input name="manage" type="checkbox" id="manage" value="j1">
                        접속자분석
                        <input name="manage" type="checkbox" id="manage" value="j2">
                        월별분석
                        <input name="manage" type="checkbox" id="manage" value="j3">
                        일별분석
                        <input name="manage" type="checkbox" id="manage" value="j4">
                        요일별분석
                        <input name="manage" type="checkbox" id="manage" value="j5">
                        시간별분석
                        <input name="manage" type="checkbox" id="manage" value="j6">
                        분기별분석
                        <input name="manage" type="checkbox" id="manage" value="j7">
                        접속경로분석
                        <input name="manage" type="checkbox" id="manage" value="j8">
                        접속초기화




						
						</td>
					</tr>					
				</tbody>
			</table>
		</form>

		<div class="rbtn">
			<a href="javascript:InputChk();" class="btn">저장하기</a>		
			<a href="admin_list.asp" class="btn trans">목록보기</a>
		</div>


	</div>
</div>


</body>
</html>
<%
db.Close
Set db = Nothing
%>
<!-- #include file = "../authpg_2.asp" -->