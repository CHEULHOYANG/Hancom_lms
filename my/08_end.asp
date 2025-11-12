<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then%>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim rs,reply_ok

sql = "select reply_ok from order_mast where reply_ok = 0 and order_id = '"& request("order_id") &"'"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then

	response.write"<script>"
	response.write"alert('구매확인에러!!');"
	response.write"self.location.href='08_list.asp';"
	response.write"</script>"
	response.End

rs.close
End if
%>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function go2Write(fm){
	var clmn;
	var fm = document.wform;
	clmn = fm.jemok;

	clmn = fm.neyong;
	if(clmn.value==""){
		alert("구매후기를 작성해주세요!");
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
        	<h3>구매확정</h3>
        </div>
        <div class="scont">

<form name="wform" action="08_end_ok.asp" method="post" style="display:inline;">	
<input type="hidden" name="order_id" value="<%=request("order_id")%>">
            <table class="ftbl" style="width:830px">
                <colgroup>
                <col style="width:22%" />
                <col style="width:78%" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>만족도</th>
                        <td><input type="radio" name="reply_star" id="reply_star" value="5" checked />매우만족 <input type="radio" name="reply_star" id="reply_star" value="4" />만족 <input type="radio" name="reply_star" id="reply_star" value="3" />보통 <input type="radio" name="reply_star" id="reply_star" value="2" />불만족 <input type="radio" name="reply_star" id="reply_star" value="1" />매우불만족</td>
                    </tr>
                    <tr>
                        <th>구매후기</th>
                        <td><textarea name="neyong" id="neyong" cols="45" rows="5" class="txtarea"></textarea></td>
                    </tr>
                </tbody>
            </table>
</form>

            <div class="cbtn"> <a href="javascript:go2Write();" class="mbtn grey">구매확정</a> <a href="08_list.asp" class="mbtn">목록으로</a> </div>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->
<% else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>