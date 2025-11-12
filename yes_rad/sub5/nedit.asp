<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" --><%
Dim sql,dr,idx,intpg
dim jemok,neyong,wday,readnum,notice

idx = Request("idx")
intpg = Request("intpg")

sql = "select jemok,neyong,wday,readnum,notice from notice where idx=" & idx
set dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('데이터에러!!');"
	response.write"history.back();"
	response.write"</script>"
	response.end

Else

	jemok = dr(0)
	neyong = dr(1)
	wday = dr(2)
	readnum = dr(3)
	notice = dr(4)

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
		<h2 class="cTit"><span class="bullet"></span>공지사항</h2>

<form name="regfm" action="nedit_ok.asp" method="post" style="display:inline;">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="intpg" value="<%=intpg%>"> 
<input type="hidden" name="strPart" value="<%=request("strPart")%>"> 
<input type="hidden" name="strSearch" value="<%=request("strSearch")%>">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>제목</th>
						<td><input type="text"  name="jemok" class="inptxt1 w400" value="<%=jemok%>">&nbsp;<input type="checkbox" name="notice" id="checkbox" value="1" <%If notice=1 Then response.write"checked" End if%> /> 공지</td>
					</tr>
					<tr>
						<th>내용</th>
						<td><a href="javascript:popenWindow('/nicedit/upimg.asp?box=neyong','390','290');"><img src="/nicedit/bt1.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/vod.asp?box=neyong','390','290');"><img src="/nicedit/bt2.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/files.asp?box=neyong','390','290');"><img src="/nicedit/bt3.gif" border="0"></a><textarea name="neyong" id="neyong" rows="2" cols="20" style="width:700px; height:200px;"><%=neyong%></textarea></td>
					</tr>
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:go2Write(regfm);" class="btn">저장하기</a>
			<a href="nneyong.asp?idx=<%=idx%>&intpg=<%=intpg%>&strPart=<%=request("strPart")%>&strSearch=<%=request("strSearch")%>" class="btn trans">목록보기</a>		
		</div>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->