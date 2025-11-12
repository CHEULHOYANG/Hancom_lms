<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<!-- #include file="../include/head1.asp" -->
<!-- #include file="../include/top.asp" -->
<%
dim user_name

sql = "select name from member where id='" & str_User_ID & "'"
set dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('회원정보 오류!!');"
	response.write"self.location.href='/member/logout.asp';"
	response.write"</script>"
	response.End

Else

	user_name = dr(0)

dr.close
End If

dim return_title

sql = "select titlenm = title + dbo.LectuTitle(tabidx,buygbn) from order_mast where idx="& request("idx") &" and id='" & str_User_ID & "'"
set dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('회원정보 오류!!');"
	response.write"self.location.href='/member/logout.asp';"
	response.write"</script>"
	response.End

Else

	return_title = dr(0)

dr.close
End if
%>
<script language="javascript">
function reply_send(){

	var f = window.document.fm;

	if(f.bankinfo1.value==""){
	alert("환불 은행명을 입력해주세요.");
	f.bankinfo1.focus();
	return;
	}

	if(f.bankinfo2.value==""){
	alert("환불 계좌번호를 입력해주세요.");
	f.bankinfo2.focus();
	return;
	}

	f.submit();

}
</script>

<div class="smain">    
	<!-- #include file="left.asp" -->	
    <div class="content">
    	<div class="cont_tit">
        	<h3>환불신청</h3>
        </div>

        <div class="scont">
<form name="fm" action="01_return_ok.asp" method="post">
<input type="hidden" name="idx" value="<%=request("idx")%>">
<input type="hidden" name="bankinfo3" value="<%=user_name%>">
            <table class="ftbl" style="width:830px">
                <colgroup>
                <col style="width:22%" />
                <col style="width:78%" />
                </colgroup>
                <tbody>
					<tr>
						<th>신청과목</th>
						<td><strong><%=return_title%></strong></td>		
					</tr>
                    <tr>
                        <th>환불계좌정보</th>
                        <td><input type="text" name="bankinfo1" class="inptxt1" placeholder="은행명" style="width:100px" />
						<input type="text" name="bankinfo2" class="inptxt1" placeholder="계좌번호" />						
						
						<span class="stip pl10">* 환불은 본인 소유 계좌로만 가능합니다.</span></td>
                    </tr>
                </tbody>
            </table>
</form>
            <div class="cbtn"> <a href="javascript:reply_send();" class="mbtn grey">환불신청</a> <a href="01_main.asp" class="mbtn">취소하기</a> </div>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" --><% else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>