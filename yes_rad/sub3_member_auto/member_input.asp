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

	clmn = theform.file;
	if(clmn.value==""){
		alert("회원목록이 입력된 엑셀파일을 선택해주세요.");
		return;
	}

	theform.submit();
}

</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>회원대량등록</h2>
<form name="regfm" action="member_ok.asp" method="post" enctype="multipart/form-data" style="display:inline;">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>회원그룹 선택</th>
						<td><select name="sp1" class="seltxt w200">
							<option value="0">미선택</option>
<%
sql = "select idx,title from group_mast where gu = 0"
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
							</select></td>
					</tr>
					<tr>
						<th>문자발송그룹 선택</th>
						<td><select name="sp2" class="seltxt w200">
                              <option value="0">미선택</option>
                              <%
sql = "select idx,title from group_mast where gu = 1"
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
                            </select></td>
					</tr>
					<tr>
						<th>회원파일</th>
						<td><input name="file" type="file" class="inptxt1 w300" id="file">
							  <a href="/xls_sample.zip" target="_blank" class="fbtn">예제파일다운로드</a></td>
					</tr>
				
				</tbody>
			</table>
</form>
		<div class="rbtn">
			<a href="javascript:go2Reg(regfm);" class="btn">등록하기</a>
		</div>

		<div class="caution mt80"><p>회원대량등록은 꼭 첨부된 파일로 작업을 해주시기 바랍니다. </p></div>
		<div class="caution mt80"><p>연락처가 없는경우 -- 만 입력해주시면 됩니다.</p></div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->