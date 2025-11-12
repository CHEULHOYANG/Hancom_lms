<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,recodnum

sql="select idx,ip from ip_mast where gu = "& request("gu")
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
	var clmn = form1.ip;
	if(clmn.value==""){
		alert("아이피주소를 입력해주세요!");
		clmn.focus();
		return;
	}
	document.form1.submit();
}

function DeleteAdm(idxnum){
	del_ck = confirm("삭제하시겠습니까?");
	if(del_ck){
		document.location.href="ip_del.asp?gu=<%=request("gu")%>&idx=" + idxnum;
	}
}
</script>


<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span><%If request("gu") = 0 Then response.write"관리자접속허용" Else response.write"사용자접속차단" End if%></h2>

<form name="form1" method="post" action="ip_ok.asp">
<input type="hidden" name="gu" value="<%=request("gu")%>">
			<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>아이피주소</th>
						<td><input type="text" id="ip" name="ip" class="inptxt1 w200" /> <a href="javascript:InputChk();" class="fbtn">등록하기</a> <span class="stip">* <%If request("gu") = 0 Then response.write"등록한 아이피만 관리자페이지 접속허용" Else response.write"등록한 아이피 사용자페이지 접속차단" End if%> 기능으로 형식(222.105.216.33)에 맞춰서 입력</span></td>
					</tr>
				</tbody>
			</table>
</form>
<%if isRecod then%>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:80%" />
			<col style="width:20%" />
			</colgroup>
			<thead>
				<tr>
					<th>아이피</th>	
					<th>기능</th>
				</tr>				
			</thead>
			<tbody>
<% 
	Dim isCols

	for ii = 0 to Ubound(isRows) - 1
	isCols = split(isRows(ii),chr(9)) 
%>
<form name="bedit<%=isCols(0)%>" method="post" action="ip_edit.asp">
<input type="hidden" name="idx" value="<%=isCols(0)%>">
<input type="hidden" name="gu" value="<%=request("gu")%>">
				<tr>
					<td><input name="ip" type="text" class="inptxt1 w400" id="ip" value="<%=isCols(1)%>" style="text-align:center;"></td>
					<td><a href="javascript:document.bedit<%=isCols(0)%>.submit();" class="btns trans">수정</a> <a href="javascript:DeleteAdm(<%=isCols(0)%>);" class="btns">삭제</a></td>
				</tr>
</form>              
<% Next %>
			</tbody>
		</table>
<%end if%> 

	</div>
</div>
</body>
</html>
<%
db.Close
Set db = Nothing
%>
<!-- #include file = "../authpg_2.asp" -->