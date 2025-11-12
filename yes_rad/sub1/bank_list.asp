<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,recodnum
sql="select idx,bankname,banknumber,use_name from bank"
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

	var clmn = form1.bankname;
	if(clmn.value==""){
		alert("은행명을 입력해주세요!");
		clmn.focus();
		return;
	}
	clmn = form1.banknumber;
	if(clmn.value==""){
		alert("계좌번호를 입력해주세요!");
		clmn.focus();
		return;
	}
	clmn = form1.use_name;
	if(clmn.value==""){
		alert("예금주를 입력해주세요!");
		clmn.focus();
		return;
	}
	document.form1.submit();
}

function DeleteAdm(idxnum){
	del_ck = confirm("해당 은행계좌를 삭제하시겠습니까?");
	if(del_ck){
		document.location.href="bank_del.asp?idx=" + idxnum;
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>입금은행관리</h2>

<form name="form1" method="post" action="bank_ok.asp">
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:30%" />
			<col style="width:30%" />
			<col style="width:30%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>은행명</th>	
					<th>계좌번호</th>
					<th>예금주</th>
					<th>추가</th>	
								
				</tr>				
			</thead>
			<tbody>
				<tr>
					<td><input type="text" name="bankname" class="inptxt1" style="text-align:center;" ></td>
					<td><input type="text" name="banknumber" class="inptxt1" style="text-align:center;" ></td>
					<td><input type="text" name="use_name" class="inptxt1" style="text-align:center;" ></td>
					<td><a href="javascript:InputChk();" class="fbtn">저장하기</a></td>
				</tr>
			</tbody>
		</table>
</form>

<%If isRecod Then %>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:30%" />
			<col style="width:30%" />
			<col style="width:30%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>은행명</th>	
					<th>계좌번호</th>
					<th>예금주</th>
					<th>기능</th>	
								
				</tr>				
			</thead>
			<tbody>
              <% 
 
			  Dim isCols
							 for ii = 0 to Ubound(isRows) - 1
							 isCols = split(isRows(ii),chr(9)) %>
<form name="bedit<%=isCols(0)%>" method="post" action="bank_edit.asp">
<input type="hidden" name="idx" value="<%=isCols(0)%>">
				<tr>
					<td><input type="text" name="bankname" class="inptxt1" style="text-align:center;" value="<%=isCols(1)%>"></td>
					<td><input type="text" name="banknumber" class="inptxt1" style="text-align:center;" value="<%=isCols(2)%>"></td>
					<td><input type="text" name="use_name" class="inptxt1" style="text-align:center;" value="<%=isCols(3)%>"></td>
					<td><a href="javascript:document.bedit<%=isCols(0)%>.submit();" class="btns trans">수정</a>&nbsp;<a href="javascript:DeleteAdm(<%=isCols(0)%>);" class="btns">삭제</a></td>
				</tr>
</form>              
              <% Next %>
			</tbody>
		</table>
<%End if%>
	</div>
</div>

</body>
</html>
<%
db.Close
Set db = Nothing
%>
<!-- #include file = "../authpg_2.asp" -->