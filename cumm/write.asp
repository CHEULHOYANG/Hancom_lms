<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
dim tabnm : tabnm = Request("tabnm")
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

if int(pgbn) > 0  then

Dim title,writer,content,re_step,re_level,ref
Dim btnm : btnm = "bt_write.gif"
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
	btnm = "bt_reply.gif"
	repage = "content.asp?idx=" & idx & "&tabnm=" & tabnm & "&intgp=" & intpg & "&gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch
end if %>
<!-- #include file="../include/head1.asp" -->


<script type="text/javascript" src="/nicedit/nicEdit.js"></script>
<script type="text/javascript">
bkLib.onDomLoaded(function() {
	new nicEditor({fullPanel : true}).panelInstance('content');
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
	
	<% if int(ygbn) = 2 then %>

	clmn = theform.filenm1;
	if(clmn.value==""){
		alert("포토이미지를 등록하세요!");
		clmn.focus();
		return;
	}
	if(!clmn.value.match(/\.(gif|jpg|png)$/i)) {
		alert("포토이미지 파일은 이미지파일(*.gif,*.jpg,*.png)만 등록할 수 있습니다!");
		clmn.select();
		return;
	}

	clmn = theform.filenm2;
	 if(clmn.value){
	 	if(!clmn.value.match(/\.(gif|jpg|png)$/i)) {
			alert("썸네일 파일은 이미지파일(*.gif,*.jpg)만 등록할 수 있습니다!");
			clmn.select();
			return;
		}
	 }
	<% end if %>


	theform.submit();
}
</script>

<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3><%=bbsJemok%></h3>
        </div>
        <div class="scont">
            
            <form name="fm" action="write_ok.asp" method="post" enctype="multipart/form-data" style="display:inline;">
            <input type="hidden" name="tabnm" value="<%=tabnm%>">
            <input type="hidden" name="idx" value="<%=idx%>">
            <input type="hidden" name="re_step" value="<%=re_step%>">
            <input type="hidden" name="re_level" value="<%=re_level%>">
            <input type="hidden" name="ref" value="<%=ref%>">            
            <table class="ftbl" style="width:830px">
                <colgroup>
                <col style="width:22%" />
                <col style="width:78%" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>제목</th>
                        <td><input name="title" type="text" id="title" class="inptxt1 w500" value="<%If Len(title) > 0 Then response.write "[답변] "& title &"" End if%>"></td>		
                    </tr>
                    <tr>
                        <th>글쓴이</th>
                        <td><input name="writer" type="text" id="writer" class="inptxt1 w100" value="<%=str_User_Nm%>"></td>		
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td><img src="/nicedit/bt1.gif" border="0" onclick="javascript:popenWindow('/nicedit/upimg.asp?box=content','390','290');" style="cursor:pointer;"><img src="/nicedit/bt2.gif" border="0" onclick="javascript:popenWindow('/nicedit/vod.asp?box=content','390','290');" style="cursor:pointer;"><img src="/nicedit/bt3.gif" border="0" onclick="javascript:popenWindow('/nicedit/files.asp?box=content','390','290');" style="cursor:pointer;"><textarea name="content" id="content" rows="2" cols="20" style="width:600px; height:200px;"></textarea></td>		
                    </tr>	
    <% if int(ygbn) = 2 then %>	
                    <tr>
                        <th>이미지</th>
                        <td><input name="filenm1" type="file" id="filenm1" class="inptxt1 w300"><p style="margin:5px 0" class="stip">* jpg,png,gif 5MB이하만 가능</p></td>		
                    </tr>	
                    <tr>
                        <th>썸네일</th>
                        <td><input name="filenm2" type="file" id="filenm2" class="inptxt1 w300"><p style="margin:5px 0" class="stip">* jpg,png,gif 5MB이하만 가능</p></td>		
                    </tr>		
    <%End if%>
                    <tr>
                        <th>비밀번호</th>
                        <td><input name="pwd" type="text" id="pwd" class="inptxt1 w100"></td>		
                    </tr>
                </tbody>
            </table>
            </form>   
            
            <div class="cbtn"> <a href="javascript:go2WriteOk(fm);" class="mbtn grey">작성완료</a> <a href="<%=repage%>" class="mbtn">목록으로</a> </div>
        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->
<% else %>
<!-- #include file="../include/false_pg.asp" --> <% end if
else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>