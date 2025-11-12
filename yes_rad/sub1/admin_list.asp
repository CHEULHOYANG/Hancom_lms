<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,recodnum
recodnum = 0
sql="select idx,id,pwd,regdate,manage from admin_mast order by idx desc"
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
function InputChk(theform){
	var clmn = theform.id;
	if(clmn.value==""){
		alert("추가할 관리자 아이디를 입력해주세요!");
		clmn.focus();
		return false;
	}
	clmn = theform.pwd;
	if(clmn.value==""){
		alert("패스워드를 입력해주세요!");
		clmn.focus();
		return false;
	}
return true;
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
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>관리자설정</h2>

		<div class="tbl_top">
			<a href="admin_input.asp" class="fbtn1">관리자등록</a>
		</div>

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:10%" />
			<col style="width:10%" />
			<col />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>아이디</th>	
					<th>비밀번호</th>
					<th>권한</th>
					<th>기능</th>
				</tr>				
			</thead>
			<tbody>
<%
                    Dim isCols
                    for ii = 0 to Ubound(isRows) - 1
                    isCols = split(isRows(ii),chr(9)) 
%>
				<tr>
					<td><%=isCols(1)%></td>
					<td><%=left(isCols(2),2)%>XXXX</td>
					<td class="tl">
					<input name="manage" type="checkbox" id="manage" value="a1" disabled <%If instr(isCols(4),", a1,") Then response.write"checked" End if%> >
                      </label>
                      사이트정보관리
                      <input name="manage2" type="checkbox" id="manage" value="a2" disabled <%If instr(isCols(4),", a2,") Then response.write"checked" End if%>>
                      관리자설정
                      <input name="manage2" type="checkbox" id="manage" value="a3" disabled <%If instr(isCols(4),", a3,") Then response.write"checked" End if%>>
                      관리자접속허용
                      <input name="manage2" type="checkbox" id="manage" value="a4" disabled <%If instr(isCols(4),", a4,") Then response.write"checked" End if%>>
                      사용자접속차단
                      <input name="manage2" type="checkbox" id="manage" value="a5" disabled <%If instr(isCols(4),", a5,") Then response.write"checked" End if%>>
                      입금은행관리
                      <input name="manage2" type="checkbox" id="manage" value="a6" disabled <%If instr(isCols(4),", a6,") Then response.write"checked" End if%>>
                      팝업창설정
                      <input name="manage2" type="checkbox" id="manage" value="a7" disabled <%If instr(isCols(4),", a7,") Then response.write"checked" End if%>>
                      강의아이콘설정
                      <input name="manage2" type="checkbox" id="manage" value="a8" disabled <%If instr(isCols(4),", a8,") Then response.write"checked" End if%>>
                      모바일웹설정<br />

<input name="manage2" type="checkbox" id="manage" value="b1" disabled <%If instr(isCols(4),", b1,") Then response.write"checked" End if%>>
                      파비콘관리
                      <input name="manage2" type="checkbox" id="manage" value="b2" disabled <%If instr(isCols(4),", b2,") Then response.write"checked" End if%>>
                      로고관리<br />					

					
					<input name="manage2" type="checkbox" id="manage" value="c1" disabled <%If instr(isCols(4),", c1,") Then response.write"checked" End if%>>
                      회원그룹관리
                      <input name="manage2" type="checkbox" id="manage" value="c2" disabled <%If instr(isCols(4),", c2,") Then response.write"checked" End if%>>
                      회원목록
                      <input name="manage2" type="checkbox" id="manage" value="c3" disabled <%If instr(isCols(4),", c3,") Then response.write"checked" End if%>>
                      회원대량등록
                      <input name="manage2" type="checkbox" id="manage" value="c4" disabled <%If instr(isCols(4),", c4,") Then response.write"checked" End if%>>
                      마일리지내역
                      <input name="manage2" type="checkbox" id="manage" value="c5" disabled <%If instr(isCols(4),", c5,") Then response.write"checked" End if%>>
                      회원출석현황
                      <input name="manage2" type="checkbox" id="manage" value="c6" disabled <%If instr(isCols(4),", c6,") Then response.write"checked" End if%>>
                      탈퇴회원관리
                      <input name="manage2" type="checkbox" id="manage" value="c7" disabled <%If instr(isCols(4),", c7,") Then response.write"checked" End if%>>
                      금지아이디관리
                      <input name="manage2" type="checkbox" id="manage" value="c8" disabled <%If instr(isCols(4),", c8,") Then response.write"checked" End if%>>
                      이메일발송관리
                      <input name="manage2" type="checkbox" id="manage" value="c9" disabled <%If instr(isCols(4),", c9,") Then response.write"checked" End if%>>
                      문자발송그룹관리
                      <input name="manage2" type="checkbox" id="manage" value="c10" disabled <%If instr(isCols(4),", c10,") Then response.write"checked" End if%>>
                      문자발송관리<br />

					<input name="manage2" type="checkbox" id="manage" value="d1" disabled <%If instr(isCols(4),", d1,") Then response.write"checked" End if%>>
                      과목관리
                      <input name="manage2" type="checkbox" id="manage" value="d2" disabled <%If instr(isCols(4),", d2,") Then response.write"checked" End if%>>
                      선생님관리
                      <input name="manage2" type="checkbox" id="manage" value="d3" disabled <%If instr(isCols(4),", d3,") Then response.write"checked" End if%>>
                      선생님등록
                      <input name="manage2" type="checkbox" id="manage" value="d4" disabled <%If instr(isCols(4),", d4,") Then response.write"checked" End if%>>
                      공지사항
                      <input name="manage2" type="checkbox" id="manage" value="d5" disabled <%If instr(isCols(4),", d5,") Then response.write"checked" End if%>>
                      자료실
                      <input name="manage2" type="checkbox" id="manage" value="d6" disabled <%If instr(isCols(4),", d6,") Then response.write"checked" End if%>>
                      질문과답변
                      <input name="manage2" type="checkbox" id="manage" value="d7" disabled <%If instr(isCols(4),", d7,") Then response.write"checked" End if%>>
                      수강후기<br />
					  
					  <input name="manage2" type="checkbox" id="manage" value="e1" disabled <%If instr(isCols(4),", e1,") Then response.write"checked" End if%>>
                      상품카테고리
                      <input name="manage2" type="checkbox" id="manage" value="e2" disabled <%If instr(isCols(4),", e2,") Then response.write"checked" End if%>>
                      상품목록
                      <input name="manage2" type="checkbox" id="manage" value="e3" disabled <%If instr(isCols(4),", e3,") Then response.write"checked" End if%>>
                      상품등록
                      <input name="manage2" type="checkbox" id="manage" value="e4" disabled <%If instr(isCols(4),", e4,") Then response.write"checked" End if%>>
                      상품대량등록
                      <input name="manage2" type="checkbox" id="manage" value="e5" disabled <%If instr(isCols(4),", e5,") Then response.write"checked" End if%>>
                      주문/배송관리<br />

					<input name="manage2" type="checkbox" id="manage" value="f1" disabled <%If instr(isCols(4),", f1,") Then response.write"checked" End if%>>
                      강좌관리
                      <input name="manage2" type="checkbox" id="manage" value="f2" disabled <%If instr(isCols(4),", f2,") Then response.write"checked" End if%>>
                      카테고리관리
                      <input name="manage2" type="checkbox" id="manage" value="f3" disabled <%If instr(isCols(4),", f3,") Then response.write"checked" End if%>>
                      쿠폰관리
                      <input name="manage2" type="checkbox" id="manage" value="f4" disabled <%If instr(isCols(4),", f4,") Then response.write"checked" End if%>>
                      수강관리
                      <input name="manage2" type="checkbox" id="manage" value="f5" disabled <%If instr(isCols(4),", f5,") Then response.write"checked" End if%>>
                      매출통계<br />
					  
					  <input name="manage2" type="checkbox" id="manage" value="g1" disabled <%If instr(isCols(4),", g1,") Then response.write"checked" End if%>>
                      시험카테고리
                      <input name="manage2" type="checkbox" id="manage" value="g2" disabled <%If instr(isCols(4),", g2,") Then response.write"checked" End if%>>
                      시험목록
                      <input name="manage2" type="checkbox" id="manage" value="g3" disabled <%If instr(isCols(4),", g3,") Then response.write"checked" End if%>>
                      시험만들기
                      <input name="manage2" type="checkbox" id="manage" value="g4" disabled <%If instr(isCols(4),", g4,") Then response.write"checked" End if%>>
                      시험결과보기<br />
					  <input name="manage2" type="checkbox" id="manage" value="h1" disabled <%If instr(isCols(4),", h1,") Then response.write"checked" End if%>>
                      공지사항
                      <input name="manage2" type="checkbox" id="manage" value="h2" disabled <%If instr(isCols(4),", h2,") Then response.write"checked" End if%>>
                      질문과답변
                      <input name="manage2" type="checkbox" id="manage" value="h3" disabled <%If instr(isCols(4),", h3,") Then response.write"checked" End if%>>
                      자주묻는질문
                      <input name="manage2" type="checkbox" id="manage" value="h4" disabled <%If instr(isCols(4),", h4,") Then response.write"checked" End if%>>
                      안내문편집
                      <input name="manage2" type="checkbox" id="manage" value="h5" disabled <%If instr(isCols(4),", h5,") Then response.write"checked" End if%>>
                      배너관리
                      <input name="manage2" type="checkbox" id="manage" value="h6" disabled <%If instr(isCols(4),", h6") Then response.write"checked" End if%>>
                      시험일정<br />
					  <input name="manage2" type="checkbox" id="manage" value="i1" disabled <%If instr(isCols(4),", i1,") Then response.write"checked" End if%>>
                      게시판관리<br />
					  <input name="manage2" type="checkbox" id="manage" value="j1" disabled <%If instr(isCols(4),", j1,") Then response.write"checked" End if%>>
                      접속자분석
                      <input name="manage2" type="checkbox" id="manage" value="j2" disabled <%If instr(isCols(4),", j2,") Then response.write"checked" End if%>>
                      월별분석
                      <input name="manage2" type="checkbox" id="manage" value="j3" disabled <%If instr(isCols(4),", j3,") Then response.write"checked" End if%>>
                      일별분석
                      <input name="manage2" type="checkbox" id="manage" value="j4" disabled <%If instr(isCols(4),", j4,") Then response.write"checked" End if%>>
                      요일별분석
                      <input name="manage2" type="checkbox" id="manage" value="j5" disabled <%If instr(isCols(4),", j5,") Then response.write"checked" End if%>>
                      시간별분석
                      <input name="manage2" type="checkbox" id="manage" value="j6" disabled <%If instr(isCols(4),", j6,") Then response.write"checked" End if%>>
                      분기별분석
                      <input name="manage2" type="checkbox" id="manage" value="j7" disabled <%If instr(isCols(4),", j7,") Then response.write"checked" End if%>>
                      접속경로분석
                      <input name="manage2" type="checkbox" id="manage" value="j8" disabled <%If instr(isCols(4),", j8,") Then response.write"checked" End if%>>
                      접속초기화</td>
					<td><a href="admin_edit.asp?id=<%=isCols(1)%>" class="btns">수정</a> <a href="javascript:DeleteAdm(<%=isCols(0)%>);" class="btns trans">삭제</a></td>
				</tr>
				<% Next  %>
			</tbody>
		</table>


		<div class="caution"><p>관리자 계정은 원하는 만큼 등록하고 삭제 할 수 있습니다. 단 <strong>최소 1개 이상</strong>의 관리자 아이디가 등록되어 있어야 합니다.</p></div>

		<div class="caution"><p><font color="#CC0000"><strong>등록된 계정의 패스워드를 변경</strong></font> 하시려면 현재 사용하고 있는 아이디와 새로운 패스워드를 입력하고 [<strong>관리자등록</strong>]버튼을 클릭하세요!</p></div>

		<div class="caution"><p>관리자의 아이디와 패스워드가 <strong>타인에게 노출되지 않도록 주의하십시오!</strong></p></div>

	</div>
</div>



</body>
</html>
<!-- #include file = "../authpg_2.asp" -->