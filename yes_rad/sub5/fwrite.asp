<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" --><%
%>
<!--#include file="../main/top.asp"-->

<script type="text/javascript" src="/nicedit/nicEdit.js"></script>
<script type="text/javascript">
bkLib.onDomLoaded(function() {
	new nicEditor({fullPanel : true}).panelInstance('neyong');
});
</script>

<script language="javascript">
function go2Write(theform){
	var clmn;
	clmn = theform.jemok;
	if(clmn.value==""){
		alert("제목을 입력해주세요!");
		clmn.focus();
		return;
	}
	if(clmn.value.replace(/ /g,"")==""){
		alert("제목을 입력해주세요!");
		clmn.select();
		return;
	}

	clmn = theform.neyong;
	clmn.value = nicEditors.findEditor('neyong').getContent();
	if(clmn.value==""  || clmn.value=="<br>") {
	alert("내용을 입력해주세요");
	return;
	}
	
	theform.submit();
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>자주묻는질문</h2>

<form name="regfm" action="fwrite_ok.asp" method="post" style="display:inline;"> 
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>제목</th>
						<td><input type="text"  name="jemok" class="inptxt1 w400"></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><a href="javascript:popenWindow('/nicedit/upimg.asp?box=neyong','390','290');"><img src="/nicedit/bt1.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/vod.asp?box=neyong','390','290');"><img src="/nicedit/bt2.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/files.asp?box=neyong','390','290');"><img src="/nicedit/bt3.gif" border="0"></a><textarea name="neyong" id="neyong" rows="2" cols="20" style="width:700px; height:200px;"></textarea></td>
					</tr>
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:go2Write(regfm);" class="btn">저장하기</a>
			<a href="flist.asp" class="btn trans">목록보기</a>		
		</div>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->