<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim tabnm : tabnm = Request("tabnm")
dim sql,dr
dim idx,intpg
idx = request("idx")
intpg = request("intpg")

Dim bbsJemok,pgbn,ygbn,mgbn
sql = "select jemok,pgbn,ygbn,mgbn from board_mast where idx=" & tabnm
set dr = db.execute(sql)
bbsJemok = dr(0)
pgbn = dr(1)
ygbn = dr(2)
mgbn = dr(3)
dr.close

Dim title,writer,content,re_step,re_level,ref
Dim btnm : btnm = " 등록 "
Dim repage : repage = "list.asp?tabnm=" & tabnm & "&intpg=" & intpg

Dim gbnS,strPart,strSearch
gbnS = request("gbnS")
strPart = request("strPart")
strSearch = request("strSerach")

if not idx = "" then
	sql = "select title,writer,content,re_step,re_level,ref from board_board where idx=" & idx
	set dr = db.execute(sql)
	title = dr(0)
	writer = dr(1)
	content = dr(2)
	re_step = dr(3)
	re_level = dr(4)
	ref = dr(5)
	btnm = " 답글 "
	repage = "content.asp?idx=" & idx & "&tabnm=" & tabnm & "&intgp=" & intpg & "&gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch
end if %>

<!--#include file="../main/top.asp"-->

<script type="text/javascript" src="/nicedit/nicEdit.js"></script>
<script type="text/javascript">
bkLib.onDomLoaded(function() {
	new nicEditor({fullPanel : true,maxHeight : 320}).panelInstance('content');
});
</script>
<script language="javascript">
function go2WriteOk(theform){
	var clmn;
	clmn = theform.title;
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
	clmn = theform.writer;
	if(clmn.value==""){
		alert("글쓴이를 입력해주세요!");
		clmn.focus();
		return;
	}
	if(clmn.value.replace(/ /g,"")==""){
		alert("글쓴이를 입력해주세요!");
		clmn.select();
		return;
	}

	clmn = theform.content;
	clmn.value = nicEditors.findEditor('content').getContent();
	if(clmn.value==""  || clmn.value=="<br>") {
	alert("내용을 입력해주세요");
	return;
	}
	
	<% if int(ygbn) < 3 then %>
	clmn = theform.filenm;<% select case int(ygbn)
	case 1 %>
	if(clmn.value==""){
		alert("자료파일을 등록하세요!");
		clmn.focus();
		return;
	}
	if(!clmn.value.match(/\.(doc|hwp|zip|ppt|txt|xls|pdf|docx|pptx|xlsx)$/i)) {
	 	alert("허용되지 않는 파일 입니다! \n\n파일확장자를 확인하세요\n\n허용된 파일 : doc,hwp,zip,ppt,txt,xls,pdf,docx,pptx,xlsx          ");
	 	clmn.select();
	 	return;
	 }
	<% case 2 %>
	if(clmn.value==""){
		alert("포토이미지를 등록하세요!");
		clmn.focus();
		return;
	}
	if(!clmn.value.match(/\.(gif|jpg|png)$/i)) {
		alert("포토이미지 파일은 이미지파일(*.gif,*.jpg)만 등록할 수 있습니다!");
		clmn.select();
		return;
	}

	clmn = theform.snfile;
	 if(clmn.value){
	 	if(!clmn.value.match(/\.(gif|jpg|png)$/i)) {
			alert("썸네일 파일은 이미지파일(*.gif,*.jpg)만 등록할 수 있습니다!");
			clmn.select();
			return;
		}
	 }
	<% end select
	end if %>

	theform.submit();
}

function bbsDel(bbcn){
	if(bbcn < 2){
		alert("게시판은 최소 1개 이상이 있어야 합니다!");
		return;
	}

	var delok = confirm("이 <%=bbsJemok%> 게시판을 정말로 삭제하시겠습니까?");
	if(delok){
		location.href="deleteb.asp?tabnm=<%=tabnm%>";
	}
}
</script>
<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span><%=bbsJemok%></h2>
<form name="fm" action="write_ok.asp" method="post" enctype="multipart/form-data" style="display:inline;">
					<input type="hidden" name="tabnm" value="<%=tabnm%>">
					<input type="hidden" name="idx" value="<%=idx%>">
					<input type="hidden" name="re_step" value="<%=re_step%>">
					<input type="hidden" name="re_level" value="<%=re_level%>">
					<input type="hidden" name="ref" value="<%=ref%>">     
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>제목</th>
						<td><input type="text" name="title" class="inptxt1 w400" value="<%=title%>"><%If ygbn <> 2 then%>&nbsp;<input type="checkbox" name="notice" id="checkbox" value="1" /> 공지<%End if%></td>
					</tr>
					<tr>
						<th>작성자</th>
						<td><input type="text" name="writer" class="inptxt1 w200" value="<%=writer%>"></td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td><input type="text" name="pwd" class="inptxt1 w100" > <span class="stip">* 입력시 비밀번호를 입력해야 해당 글을 볼수 있습니다.</span></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><a href="javascript:popenWindow('/nicedit/upimg.asp?box=content','390','290');"><img src="/nicedit/bt1.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/vod.asp?box=content','390','290');"><img src="/nicedit/bt2.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/files.asp?box=content','390','290');"><img src="/nicedit/bt3.gif" border="0"></a><textarea name="content" id="content" rows="2" cols="20" style="width:600px; height:300px;"><%=content%></textarea></td>
					</tr>
					<% select case int(ygbn)
										case 1 %>
										<tr>
											<th><span class="style5">자료파일</span></th>
											<td><input type="file" name="filenm" class="inptxt1" style="width:470px;" ></td>
										</tr><% case 2 %>
										<tr>
											<th><span class="style5">포토이미지</span></th>
											<td><input type="file" name="filenm" class="inptxt1" style="width:470px;" ></td>
										</tr>
										<tr>
											<th><span class="style5">썸네일</span></th>
											<td><input type="file" name="snfile" class="inptxt1" style="width:470px;" ></td>
										</tr><% end select %>
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:go2WriteOk(fm);" class="btn">저장하기</a>
			<a href="javascript:history.back();" class="btn trans">목록보기</a>		
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->