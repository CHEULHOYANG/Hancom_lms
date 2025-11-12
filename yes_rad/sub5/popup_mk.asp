<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<!--#include file="../main/top.asp"-->

<script language="javascript">
function NumKeyOnly(){
	if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;
}
function goPopup_Edite(theform){
	var clmn;
	var maxsize = 900;
	var minsize = 900;

	clmn = theform.pop_nm;
	if(clmn.value == ""){
		alert("팝업창에 보일 타이틀을  입력하세요!");
		clmn.focus();
		return;
	}
	if(clmn.value.replace(/ /g,"") == ""){
		alert("팝업창에 보일 타이틀을 입력해주세요!");
		clmn.select();
		return;
	}

	clmn = theform.size_width;
	if(clmn.value == ""){
		alert("팝업창 가로크기를 입력하세요!");
		clmn.focus();
		return;
	}

	if(parseInt(clmn.value,100) > maxsize){
		alert("창의 가로크기는 최대 " + maxsize + " 까지 입력할 수 있습니다.");
		clmn.select();
		return;
	}

	if(parseInt(clmn.value,100) < minsize){
		alert("창의 가로크기는 최소 " + minsize + " 이상 입력해야 합니다.");
		clmn.select();
		return;
	}

	clmn = theform.size_height;
	if(clmn.value == ""){
		alert("팝업창 세로크기를 입력하세요!");
		clmn.focus();
		return;
	}

	if(parseInt(clmn.value,100) > maxsize){
		alert("창의 세로크기는 최대 " + maxsize + " 까지 입력할 수 있습니다.");
		clmn.select();
		return;
	}

	if(parseInt(clmn.value,100) < minsize){
		alert("창의 세로크기는 최소 " + minsize + " 이상 입력해야 합니다.");
		clmn.select();
		return;
	}

	clmn = theform.popcont;
	clmn.value = nicEditors.findEditor('popcont').getContent();
	if(clmn.value==""  || clmn.value=="<br>") {
	alert("내용을 입력해주세요");
	return;
	}

theform.submit();
}
</script>

<script type="text/javascript" src="/nicedit/nicEdit.js"></script>
<script type="text/javascript">
bkLib.onDomLoaded(function() {
	new nicEditor({fullPanel : true}).panelInstance('popcont');
});
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>팝업창관리</h2>
<form name="popform" method="post" action="popup_mk_ok.asp" style="display:inline;">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>팝업창구분</th>
						<td><input type="radio" name="pop_gu" value="0" checked>&nbsp;웹&nbsp;&nbsp;<input type="radio" name="pop_gu" value="1">&nbsp;모바일</td>
					</tr>
					<tr>
						<th>팝업창타이틀</th>
						<td><input type="text" class="inptxt1 w400" name="pop_nm"></td>
					</tr>
					<tr>
						<th>팝업창크기</th>
						<td><input type="text" class="inptxt1 w60" size="5" maxlength="3" name="size_width" onKeyPress="NumKeyOnly();">
                           *
                            <input type="text" class="inptxt1 w60" size="5" maxlength="3" name="size_height" onKeyPress="NumKeyOnly();">
                            (가로 X 세로)</td>
					</tr>
					<tr>
						<th>팝업위치</th>
						<td><input type="text" class="inptxt1 w60" size="5" maxlength="3" name="size_top" onKeyPress="NumKeyOnly();">
                            /
                            <input type="text" class="inptxt1 w60" size="5" maxlength="3" name="size_left" onKeyPress="NumKeyOnly();">
                            (상단 X 좌측)</td>
					</tr>
					<tr>
						<th>찹업내용</th>
						<td><a href="javascript:popenWindow('/nicedit/upimg.asp?box=popcont','390','290');"><img src="../../nicedit/bt1.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/vod.asp?box=popcont','390','290');"><img src="../../nicedit/bt2.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/files.asp?box=popcont','390','290');"><img src="../../nicedit/bt3.gif" border="0"></a><textarea name="popcont" id="popcont" rows="2" cols="20" style="width:780px; height:390px;"></textarea></td>
					</tr>
					<tr>
						<th>옵션</th>
						<td><input type="checkbox" name="pop_cookie"> [오늘은 이 창을 다시 열지 않음] 기능 사용함</td>
					</tr>
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:goPopup_Edite(document.popform);" class="btn">저장하기</a>		
			<a href="popup_list.asp" class="btn  trans">목록보기</a>
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->