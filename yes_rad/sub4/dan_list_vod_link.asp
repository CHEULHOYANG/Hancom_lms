<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<!--#include file="../main/top.asp"-->

<script language="javascript">

function vod_link_ch(){

	var f = window.document.regfm;

	if(f.link1.value == ""){
	alert("변경전 주소를 넣어주세요");
	return;
	}

	if(f.link2.value == ""){
	alert("변경할 주소를 넣어주세요");
	return;
	}

	f.submit();
		
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>동영상주소 일괄변경</h2>

<form name="regfm" action="dan_list_vod_link_ok.asp" method="post">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>					
					<tr>
						<th>동영상주소</th>
						<td><input type="text"  name="link1" class="inptxt1 w400" placeholder="변경전 값" > -> <input type="text"  name="link2" class="inptxt1 w400" placeholder="변경할 값" ></td>
					</tr>		
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:vod_link_ch();" class="btn">변경하기</a>
		</div>

<div class="caution"><p>해당 기능은 동영상주소가 변경될경우 한번에 변환을 위한 기능입니다. <strong>안녕</strong>이라는 글자를 <strong>안녕하세요</strong>로 변경하는 기능이라고 보시면 됩니다.</p></div>
<div class="caution"><p>사용후 일괄적으로 동일한 조건에 주소가 변경이 되므로 <font color='#cc0000'>복구는 불가능</font>합니다. 꼭 확인후 정확히 사용해주시기 바랍니다.</p></div>
<div class="caution"><p>변경전 값이  <strong>http://111.111.111.1111/test/test.mp4</strong> 인경우 변경할 값이 <strong>http://test.yesoft.net/test/test.mp4</strong> 인경우 변경전 값에는 <strong>http://111.111.111.1111/</strong>를 입력 변경할 값에는 <strong>http://test.yesoft.net/</strong> 를 입력해주시면 됩니다.</p></div>



	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->