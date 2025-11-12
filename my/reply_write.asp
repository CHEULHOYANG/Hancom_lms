<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<!-- #include file="../include/head1.asp" -->
<!-- #include file="../include/top.asp" -->

<script language="javascript">
function reply_send(){

	var f = window.document.fm;

	if(f.content.value==""){
	alert("수강후기를 작성해주세요.");
	f.content.focus();
	return;
	}
	f.submit();

}
</script>

<div class="smain">    
	<!-- #include file="left.asp" -->	
    <div class="content">
    	<div class="cont_tit">
        	<h3>수강후기작성</h3>
        </div>

        <div class="scont">
<form name="fm" action="reply_write_ok.asp" method="post">
<input type="hidden" name="repage" value="<%=request("repage")%>">
<input type="hidden" name="idx" value="<%=request("idx")%>">
<input type="hidden" name="lidx" value="<%=request("lidx")%>">
            <table class="ftbl" style="width:830px">
                <colgroup>
                <col style="width:22%" />
                <col style="width:78%" />
                </colgroup>
                <tbody>
					<tr>
						<th>평점</th>
						<td><input name="star" type="radio" id="radio" value="5" checked><img src="../img/img/5.png" >
						  <input type="radio" name="star" id="radio" value="4"><img src="../img/img/4.png" >
						  <input type="radio" name="star" id="radio" value="3"><img src="../img/img/3.png" >
						  <input type="radio" name="star" id="radio" value="2"><img src="../img/img/2.png" >
						  <input type="radio" name="star" id="radio" value="1"><img src="../img/img/1.png" ></td>		
					</tr>
                    <tr>
                        <th>후기</th>
                        <td><textarea name="content" id="content" cols="45" rows="5" class="txtarea"></textarea></td>
                    </tr>
                </tbody>
            </table>
</form>
            <div class="cbtn"> <a href="javascript:reply_send();" class="mbtn grey">작성완료</a> <a href="<%=request("repage")%>.asp?idx=<%=request("idx")%>" class="mbtn">취소하기</a> </div>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" --><% else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>