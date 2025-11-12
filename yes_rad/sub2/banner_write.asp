<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<!--#include file="../main/top.asp"-->

<script language="javascript">
function go2BannerReg(){
	var clmn;
	var f = document.fm;
	clmn = f.bangbn;
	 var chked = true;
	 for(i=0;i<clmn.length;i++){
	 	if(clmn[i].checked){
	 		chked = false;
	 		break;
	 	}
	 }

	 if(chked){
	 	alert("배너위치를 선택해주세요!");
	 	return;
	 }

	clmn = document.all.keygbn;
	 if(!clmn.value){
		alert("적용될 페이지를 선택해주세요!");
		return;
	}

	clmn = f.fileb;
	 if(!clmn.value){
	 	alert("이미지파일을 첨부 해주세요!");
	 	return;
	 }

	 if(!clmn.value.match(/\.(gif|jpg|swf|png)$/i)){
	 	alert("배너파일은 플래쉬(swf),이미지(gif,jpg,png) 파일만 등록하실 수 있습니다.");
	 	clmn.select();
	 	return;
	 }
	 fm.submit();
}

function thisAreaView(){
	var args = thisAreaView.arguments;
	var cheknum = parseInt(args[0].value,10);

	var obj1
	obj1 = document.all.applyBan;
	obj2 = document.all.bstsize;

	var inHtm = "";
	inHtm +="";

	switch(cheknum){
		case 1:
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"010\" onclick=\"areaRidoIn(this);\"> 메인#1(무제한)&nbsp;&nbsp;";
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"011\" onclick=\"areaRidoIn(this);\"> 메인#2(1개)&nbsp;&nbsp;";
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"012\" onclick=\"areaRidoIn(this);\"> 메인#3(1개)&nbsp;&nbsp;";
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"013\" onclick=\"areaRidoIn(this);\"> 로고오른쪽(1개)&nbsp;&nbsp;";
			document.all.keygbn.value="";
			break;
		case 2:
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"041\" onclick=\"areaRidoIn(this);\"> 강의실왼쪽&nbsp;&nbsp;";
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"042\" onclick=\"areaRidoIn(this);\"> 학원소개왼쪽&nbsp;&nbsp;";
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"043\" onclick=\"areaRidoIn(this);\"> 자료실왼쪽&nbsp;&nbsp;";
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"044\" onclick=\"areaRidoIn(this);\"> 커뮤니티왼쪽&nbsp;&nbsp;";
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"045\" onclick=\"areaRidoIn(this);\"> 고객센터왼쪽&nbsp;&nbsp;";
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"046\" onclick=\"areaRidoIn(this);\"> 마이페이지왼쪽&nbsp;&nbsp;";
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"047\" onclick=\"areaRidoIn(this);\"> 테스트왼쪽&nbsp;&nbsp;";
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"048\" onclick=\"areaRidoIn(this);\"> 선생님왼쪽&nbsp;&nbsp;";
			inHtm +="<input name=\"areagbn\" type=\"radio\" value=\"061\" onclick=\"areaRidoIn(this);\"> 교재소개왼쪽&nbsp;&nbsp;";
			document.all.keygbn.value="";
			break;
	}
	inHtm +="";

	obj1.innerHTML = inHtm;
	obj2.innerHTML = "";
	document.all.key.value=cheknum;
}

function areaRidoIn(){
	var argss = areaRidoIn.arguments;
	var inSize = "";
	var chekedvalue = argss[0].value;
	//document.fm.areagbn.value = chekedvalue;
	document.all.keygbn.value=chekedvalue;

	var inSize = "";
	obj2 = document.all.bstsize;

	switch(chekedvalue){
		case "010":
			inSize = "width = 1080 , height = 380";
			break;
		case "011":
			inSize = "width = 190 , height = 300";
			break;
		case "012":
			inSize = "width = 190 , height = 300";
			break;
		case "013":
			inSize = "width = 260 , height = 70";
			break;

		case "041":
			inSize = "width = 200";
			break;	
		case "042":
			inSize = "width = 200";
			break;
		case "043":
			inSize = "width = 200";
			break;
		case "044":
			inSize = "width = 200";
			break;
		case "045":
			inSize = "width = 200";
			break;
		case "046":
			inSize = "width = 200";
			break;
		case "047":
			inSize = "width = 200";
			break;
		case "048":
			inSize = "width = 200";
			break;

		case "051":
			inSize = "width = 780";
			break;	
		case "052":
			inSize = "width = 780";
			break;
		case "053":
			inSize = "width = 780";
			break;
		case "054":
			inSize = "width = 780";
			break;
		case "055":
			inSize = "width = 780";
			break;
		case "056":
			inSize = "width = 780";
			break;
		case "057":
			inSize = "width = 780";
			break;
		case "058":
			inSize = "width = 780";
			break;
		case "060":
			inSize = "width = 780";
			break;
			
		default:
			inSize = "width = 285 , height = 255";
			break;
	}

	obj2.innerHTML = inSize;
}
</script>
</head>

<input type="hidden" name="key">
<input type="hidden" name="keygbn">

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>배너설정</h2>

<form name="fm" method="post" action="banner_write_ok.asp" enctype="multipart/form-data">
<input type="hidden" name="upgbn" value="0">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>배너위치</th>
						<td><input name="bangbn" type="radio" value="1" onClick="thisAreaView(this);"> 메인&nbsp;&nbsp;&nbsp;<input name="bangbn" type="radio" value="2" onClick="thisAreaView(this);"> 서브</td>
					</tr>
					<tr>
						<th>적용위치</th>
						<td ID="applyBan"></td>
					</tr>
					<tr>
						<th>배너파일</th>
						<td><input type="file" name="fileb" size="30" class="inptxt1 w400" > <p class="stip">최적사이즈 : <span ID="bstsize">&nbsp;</span></p></td>
					</tr>
					<tr>
						<th>연결주소</th>
						<td><input type="text" name="banner_url" class="inptxt1 w400" ></td>
					</tr>
					<tr>
						<th>배너설명</th>
						<td><input type="text" name="title" class="inptxt1 w400"></td>
					</tr>
					<tr>
						<th>배너바탕컬러</th>
						<td><input type="text" name="bgcolor" class="inptxt1 w100"> <span class="stip">* 바탕컬러가 필요할경우 사용 참고사이트 (https://html-color-codes.info/Korean/)</span></td>
					</tr>		
					<tr>
						<th>배너순서</th>
						<td><input name="ordnum" type="text" class="inptxt1 w100" id="ordnum" value="0" > <span class="stip">0번 이 가장 높습니다. </td>
					</tr>	
					<tr>
						<th>배너타겟</th>
						<td><input name="target" type="radio" value="_self" checked> 
현재창&nbsp;&nbsp;&nbsp;
  <input type="radio" name="target" value="_blank"> 
새창</td>
					</tr>						
				</tbody>
			</table>
</form>


		<div class="rbtn">
			<a href="javascript:go2BannerReg()" class="btn trans">저장하기</a>		
			<a href="banner_list.asp" class="btn">목록으로</a>
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->