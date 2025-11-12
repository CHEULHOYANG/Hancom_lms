<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<!-- #include file="../main/top.asp"-->

<script language="javascript">
function visit_del(idx){
		var bool = confirm("정말로 접속자초기화를 하시겠습니까?");
		if (bool){
			var params = "key=" +  escape(idx);
			sndReq("resetxml.asp",params,toDwnGo,"POST");
			//location.href="resetxml.asp?" + params;
		}
}

function toDwnGo(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var rowtag = xmlDoc.getElementsByTagName("isrows").item(0);
			var strRetun = rowtag.firstChild.nodeValue;

			if(parseInt(strRetun,10) > 0) {
				alert("초기화 되었습니다.\n\n오늘 일자로 접속분석이  시작됩니다.");
				self.location.href="list.asp";
			}

		}
		else{
			alert("시스템에러!");
		}
	}

}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>접속초기화</h2>

		<div class="caution"><p>모든 접속정보를 초기화합니다.</p></div>
		<div class="caution"><p>삭제된 정보는 복구가 되지않습니다.</p></div>

		<div class="rbtn">
			<a href="javascript:visit_del('visit');" class="btn">초기화하기</a>
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->