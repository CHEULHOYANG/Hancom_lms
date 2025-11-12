<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,btname,jemok,neyong,gbn
Dim sql,dr

idx = Request("idx")

if idx = "" then
	btname = "작성"
else 
	sql = "select jemok,neyong,gbn from guideTab where idx=" & idx
	Set Dr = db.execute(sql)

	If dr.eof Or dr.bof Then

		response.write"<script>"
		response.write"alert('데이터에러!!');"
		response.write"history.back();"
		response.write"</script>"
		response.end

	Else

		jemok = Dr(0)
		neyong = Dr(1)
		gbn = Dr(2)
		
		btname = "수정"

	Dr.Close
	End If
	
end If

Dim t_menu1

sql = "select t_menu1 from site_info"
Set dr=db.execute(sql)

If dr.eof Or dr.bof Then
	t_menu1 = "학원소개"
Else
	t_menu1 = dr(0)
dr.close
End if
%>
<!--#include file="../main/top.asp"-->

<script type="text/javascript" src="/nicedit/nicEdit.js"></script>
<script type="text/javascript">
bkLib.onDomLoaded(function() {
	new nicEditor({fullPanel : true}).panelInstance('neyong');
});
</script>

<script language="javascript">
function go2WriteOk(theform){
	clmn = theform.jemok;
	if(clmn.value==""){
		alert("제목을 입력하세요!");
		clmn.focus();
		return;
	}
	if(clmn.value.replace(/ /g,"") == ""){
		alert("제목을 입력하세요!");
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
		<h2 class="cTit"><span class="bullet"></span>안내문관리(<%=btname%>)</h2>

<form name="faqfm" action="guidewrite_ok.asp" method="post" style="display:inline;">
<input type="hidden" name="idx" value="<%=idx%>">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>구분</th>
						<td><select name="gbn" id="gbn"  class="seltxt">
											<option value="0" <%If gbn=0 Then response.write"selected" End if%>>사이트하단</option>
  <option value="1" <%If gbn=1 Then response.write"selected" End if%>>고객센터</option>
  <option value="2" <%If gbn=2 Then response.write"selected" End if%>><%=t_menu1%></option>
</select></td>
					</tr>
					<tr>
						<th>기본값입력</th>
						<td><input type="radio" name="aaa" onclick="document.faqfm.jemok.value='';" checked> 없음<br />
											<input type="radio" name="aaa" onclick="document.faqfm.jemok.value='개인정보처리방침';"> 개인정보처리방침<br />
											<input type="radio" name="aaa" onclick="document.faqfm.jemok.value='사이트이용약관';"> 사이트이용약관<br />
											<input type="radio" name="aaa" onclick="document.faqfm.jemok.value='개인정보수집및이용안내에 대한 동의';"> 개인정보수집및이용안내에 대한 동의</td>
					</tr>
					<tr>
						<th>제목</th>
						<td><input type="text" name="jemok" class="inptxt1 w500" value="<%=jemok%>"></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><a href="javascript:popenWindow('/nicedit/upimg.asp?box=neyong','390','290');"><img src="/nicedit/bt1.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/vod.asp?box=neyong','390','290');"><img src="/nicedit/bt2.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/files.asp?box=neyong','390','290');"><img src="/nicedit/bt3.gif" border="0"></a><textarea name="neyong" id="neyong" rows="2" cols="20" style="width:600px; height:200px;"><%=neyong%></textarea></td>
					</tr>

				</tbody>
			</table>
</form>
		<div class="rbtn">
			<a href="javascript:go2WriteOk(document.faqfm);" class="btn">저장하기</a>
			<a href="guide.asp" class="btn trans">돌아가기</a>		
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->