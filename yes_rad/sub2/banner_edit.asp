<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx : idx = Request("idx")
Dim intpg : intpg = Request("intpg")

Dim sql,dr,banner,banner_url,bangbn,areagbn,filegbn,ordnum,target,title,bgcolor
sql = "select banner,banner_url,bangbn,areagbn,filegbn,ordnum,target,title,bgcolor from banner where idx=" & idx
set dr = db.execute(sql)
banner = dr(0)
banner_url = dr(1)
bangbn = dr(2)
areagbn = dr(3)
filegbn = dr(4)
ordnum = dr(5)
target = dr(6)
title = dr(7)
bgcolor = dr(8)
dr.close

Dim inSize,imgsize

select case areagbn
	case "010"
		inSize = "width = 1080 , height = 380"
		imgsize = "width=""1080"" * height=""380"""
	case "011"
			inSize = "width = 190 , height = 300"
		imgsize = "width=""190"" * height=""300"""
	case "012"
			inSize = "width = 190 , height = 300"
		imgsize = "width=""190"" * height=""300"""
	case "013"
			inSize = "width = 260 , height = 70"
		imgsize = "width=""260"" * height=""70"""

	case "041"
		inSize = "width < 200"
		imgsize = "width=""200"""
	case "042"
		inSize = "width < 200"
		imgsize = "width=""200"""
	case "043"
		inSize = "width < 200"
		imgsize = "width=""200"""
	case "044"
		inSize = "width < 200"
		imgsize = "width=""200"""
	case "045"
		inSize = "width < 200"
		imgsize = "width=""200"""
	case "046"
		inSize = "width < 200"
		imgsize = "width=""200"""
	case "047"
		inSize = "width < 200"
		imgsize = "width=""200"""
	case "048"
		inSize = "width < 200"
		imgsize = "width=""200"""


	case "051"
		inSize = "width = 780"
		imgsize = "width=""780"""
	case "052"
		inSize = "width = 780"
		imgsize = "width=""780"""
	case "053"
		inSize = "width = 780"
		imgsize = "width=""780"""
	case "054"
		inSize = "width = 780"
		imgsize = "width=""780"""
	case "055"
		inSize = "width = 780"
		imgsize = "width=""780"""
	case "056"
		inSize = "width = 780"
		imgsize = "width=""780"""
	case "057"
		inSize = "width = 780"
		imgsize = "width=""780"""
	case "058"
		inSize = "width = 780"
		imgsize = "width=""780"""

	case "060"
		inSize = "width = 780"
		imgsize = "width=""780"""

	case "061"
		inSize = "width < 200"
		imgsize = "width=""200"""	
		
	case else
		inSize = "width < 200"
		imgsize = "width=""185"""
end select

Function strBanGbn(gbncod)
	select case int(gbncod)
		case 1
			strBanGbn = "메인"
		case 2
			strBanGbn = "서브"
	end select
End Function

Function strAreaGbn(areacod)
	select case areacod
		case "010"
			strareaGbn = "메인중앙"
		case "012"
			strareaGbn = "메인이벤트배너"
		case "014"
			strareaGbn = "상단로그왼쪽"			
		case "041"
			strareaGbn = "강의실왼쪽"
		case "042"
			strareaGbn = "학원소개왼쪽"
		case "043"
			strareaGbn = "자료실왼쪽"
		case "044"
			strareaGbn = "커뮤니티왼쪽"
		case "045"
			strareaGbn = "고객센터왼쪽"
		case "046"
			strareaGbn = "마이페이지왼쪽"
		case "047"
			strareaGbn = "테스트왼쪽"
		case "048"
			strareaGbn = "선생님왼쪽"
		case "051"
			strareaGbn = "강의실상단"
		case "052"
			strareaGbn = "학원소개상단"
		case "053"
			strareaGbn = "자료실상단"
		case "054"
			strareaGbn = "커뮤니티상단"
		case "055"
			stra6eaGbn = "고객센터상단"
		case "056"
			strareaGbn = "마이페이지상단"
		case "057"
			strareaGbn = "무료강좌상단"
		case "058"
			strareaGbn = "선생님상단"
		case "060"
			strareaGbn = "선생님메인"
		case "061"
			strareaGbn = "교재소개왼쪽"
	end select
End Function %>

<!--#include file="../main/top.asp"-->

<script language="javascript">
function go2BannerReg(f){
	var clmn;
	var f = document.banner_form;
	clmn = f.fileb;
	if(clmn.value){
		 if(!clmn.value.match(/\.(gif|jpg|swf|png)$/i)){
			alert("배너파일은 플래쉬(swf),이미지(gif,jpg,png) 파일만 등록하실 수 있습니다.");
			clmn.select();
			return;
		 }
	}
f.submit();
}

function go2DelBan(){
	var delok = confirm("정말로 삭제하시겠습니까?");
	if(delok){
		location.href="banner_del.asp?idx=<%=idx%>";
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>배너설정</h2>

<form name="banner_form" method="post" action="banner_edit_ok.asp" enctype="multipart/form-data">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="intpg" value="<%=intpg%>">   		
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>이미지</th>
						<td><img src="/ahdma/banner/<%=banner%>"></td>
					</tr>
					<tr>
						<th>배너위치</th>
						<td><%=strBanGbn(bangbn)%> > <%=strAreaGbn(areagbn)%></td>
					</tr>
					<tr>
						<th>배너파일</th>
						<td><input type="file" name="fileb" size="30" class="inptxt1 w400" > <p class="stip">최적사이즈 : <%=inSize%></p></td>
					</tr>
					<tr>
						<th>연결주소</th>
						<td><input type="text" name="banner_url" class="inptxt1 w400" value="<%=banner_url%>"></td>
					</tr>
					<tr>
						<th>배너설명</th>
						<td><input type="text" name="title" class="inptxt1 w400" value="<%=title%>"></td>
					</tr>
					<tr>
						<th>배너바탕컬러</th>
						<td><input type="text" name="bgcolor" class="inptxt1 w100" value="<%=bgcolor%>"> <span class="stip">* 바탕컬러가 필요할경우 사용 참고사이트 (https://html-color-codes.info/Korean/)</span></td>
					</tr>		
					<tr>
						<th>배너순서</th>
						<td><input name="ordnum" type="text" class="inptxt1 w100" id="ordnum" value="<%=ordnum%>" > <span class="stip">0번 이 가장 높습니다. </td>
					</tr>	
					<tr>
						<th>배너타겟</th>
						<td><input name="target" type="radio" value="_self" <%if target="_self" then response.write"checked" end if%>> 
현재창&nbsp;&nbsp;&nbsp;
  <input type="radio" name="target" value="_blank" <%if target="_blank" then response.write"checked" end if%>> 
새창</td>
					</tr>						
				</tbody>
			</table>
</form>


		<div class="rbtn">
			<a href="javascript:go2BannerReg(this.form);" class="btn trans">저장하기</a>		
			<a href="banner_list.asp" class="btn">목록으로</a>
		</div>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->