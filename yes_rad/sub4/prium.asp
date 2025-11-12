<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,isRows,isCols
sql = "select idx,strnm,intgigan,intprice from premTab order by idx"
set dr = db.execute(sql)
if Not dr.Bof or Not dr.Eof then
	isRecod = True
	isRows = split(dr.getString(2),chr(13))
end if
dr.close
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function setPriminput(){
	var clmn
	clmn = document.fminput.strnm;
	if(clmn.value == ""){
		alert("프리패스명을 입력하세요!");
		clmn.focus();
		return;
	}
	if(clmn.value.replace(/ /g,"") == ""){
		alert("프리패스명을 입력하세요!");
		clmn.select();
		return;
	}

	clmn = document.fminput.intgigan;
	if(clmn.value == ""){
		alert("프리패스명 기간을 입력하세요!");
		clmn.focus();
		return;
	}

	clmn = document.fminput.intprice;
	if(clmn.value == ""){
		alert("프리패스명 가격을 입력하세요!");
		clmn.focus();
		return;
	}

	document.fminput.submit();
}

function setPrim_del(idx){
		var bool = confirm("삭제하시겠습니까?");
		if (bool){
			location.href = "prium_del.asp?idx="+idx;
		}
}

function setPrim(i,idxn){
	var clmn
	clmn = eval("document.all.strnm" + i);
	if(clmn.value == ""){
		alert("프리패스명을 입력하세요!");
		clmn.focus();
		return;
	}
	if(clmn.value.replace(/ /g,"") == ""){
		alert("프리패스명을 입력하세요!");
		clmn.select();
		return;
	}

	clmn = eval("document.all.intgigan" + i);
	if(clmn.value == ""){
		alert("프리패스명 기간을 입력하세요!");
		clmn.focus();
		return;
	}

	clmn = eval("document.all.intprice" + i);
	if(clmn.value == ""){
		alert("프리패스명 가격을 입력하세요!");
		clmn.focus();
		return;
	}

	document.fm.idx.value=idxn;
	document.fm.requn.value=i;
	document.fm.submit();
}

function onlynum(objtext1){
				var inText = objtext1.value;
				var ret;
				for (var i = 0; i < inText.length; i++) {
				    ret = inText.charCodeAt(i);
					if (!((ret > 47) && (ret < 58)))  {
						alert("숫자만을 입력해주세요.");
						objtext1.value = "";
						objtext1.focus();
						return false;
					}
				}
				return true;
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>프리패스가격관리</h2>

<form name="fminput" method="post" action="prium_input.asp" style="display:inline;">
<input type="hidden" name="idx">
<input type="hidden" name="requn">
			<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>프리패스 상품등록</th>
						<td><input type="text" class="inptxt1 w200" style="text-align:center;" name="strnm" placeholder="상품명" >
						<input type="text" class="inptxt1 w100" style="text-align:center;" name="intgigan" maxlength="3" onKeyUp="onlynum(fminput.intgigan);" placeholder="기간">
						<input type="text" class="inptxt1 w100" style="text-align:center;" name="intprice" onKeyUp="onlynum(fminput.intprice);" placeholder="가격">
						<a href="javascript:setPriminput();" class="fbtn">등록하기</a></td>
					</tr>
				</tbody>
			</table>
</form>

<% if isRecod then %>
<form name="fm" method="post" action="prium_ok.asp" style="display:inline;">
<input type="hidden" name="idx"><input type="hidden" name="requn">
		<table class="tbl" style="width:100%">
			<colgroup>
			<col />
			<col style="width:20%" />
			<col style="width:20%" />
			<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th>프리패스명</th>	
					<th>기 간</th>
					<th>가격</th>
					<th>기능</th>	
				</tr>				
			</thead>
			<tbody>
			<% for ii = 0 to UBound(isRows) - 1
						isCols = split(isRows(ii),chr(9))%>
						<tr>
							<td><input type="text" class="inptxt1 w300" style="text-align:center;" name="strnm<%=ii%>" value="<%=isCols(1)%>"></td>
							<td><input type="text" class="inptxt1 w100" style="text-align:center;" name="intgigan<%=ii%>" value="<%=isCols(2)%>" maxlength="3" onKeyUp="onlynum(fm.intgigan<%=ii%>);"></td>
							<td><input type="text" class="inptxt1 w100" style="text-align:center;" name="intprice<%=ii%>" value="<%=isCols(3)%>" onKeyUp="onlynum(fm.intprice<%=ii%>);"></td>
							<td><a href="javascript:setPrim('<%=ii%>','<%=isCols(0)%>');" class="btns trans">수정</a> <a href="javascript:setPrim_del('<%=isCols(0)%>');" class="btns trans">삭제</a></td>
						</tr><% Next %>
			</tbody>
		</table>
</form>
<%End if%>

<div class="caution"><p>모든 강의를 기간동안 제한없이 이용할수 있는 프리패스상품을 만들수 있습니다</p></div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->