<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<!-- #include file="../include/head1.asp" -->

</head>
<script language="javascript">
function go2Write(fm){
	var fm = document.wform;
	var clmn;
	clmn = fm.jemok;
	if(clmn.value==""){
		alert("제목을 입력해주세요!");
		clmn.focus();
		return ;
	}
	if(clmn.value.replace(/ /g,"")==""){
		alert("제목을 입력해주세요!");
		clmn.select();
		return ;
	}
	clmn = fm.neyong;
	if(clmn.value==""){
		alert("내용을 입력해주세요!");
		clmn.focus();
		return ;
	}
	fm.submit();
}
</script>

<!-- #include file="../include/top.asp" -->

<div class="smain">
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>문의게시판</h3>
        </div>
        <div class="scont">

<form name="wform" action="qwrite_ok.asp" method="post" enctype="multipart/form-data" style="display:inline;">
            <table class="ftbl" style="width:830px">
                <colgroup>
                <col style="width:20%" />
                <col style="width:80%" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>문의제목</th>
                        <td><input type="text" name="jemok" class="inptxt1 w500" /></td>
                    </tr>
                    <tr>
                        <th>문의내용</th>
                        <td><textarea name="neyong" id="neyong" cols="45" rows="5" class="txtarea"></textarea></td>
                    </tr>
                    <tr>
                        <th>첨부파일</th>
                        <td><input type="file" name="files1" class="inptxt1 w400" /></td>
                    </tr>
                </tbody>
            </table>
</form>

            <div class="cbtn"> <a href="javascript:go2Write();" class="mbtn grey">문의하기</a> <a href="qlist.asp" class="mbtn">목록으로</a> </div>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" --><% else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>