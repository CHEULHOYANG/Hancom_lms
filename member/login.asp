<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file = "../include/dbcon.asp" -->
<% if isUsr then
	response.redirect "../main/index.asp"
	response.end
end If
%>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function strOnLogin(isKey,theform){
if(isKey || event) event.returnValue = false;

	clmn = theform.usrid;
	if(clmn.value==""){
		alert("아이디를 입력하세요!!");
		clmn.focus();
		return;
	}
	clmn = theform.usrpwd;
	if(clmn.value == ""){
		alert("비밀번호를 입력해주세요!");
		clmn.focus();
		return;
	}
theform.submit();
}
</script>

<!-- #include file = "../include/top.asp" -->
<div class="scontent">
    	<div class="logcont">
        	<div class="logtit">
                <h3>LOGIN</h3>
            </div>
<form name="logfm" action="login_ok.asp" method="post" style="display:inline;">
<input type="hidden" name="str__Page" value="<%=request("str__Page")%>">
            <div class="log_box">
            	<p>아이디가 없으시면 무료 회원가입을 해주시기 바랍니다.</p>
                <ul>
	                <li><input type="text" name="usrid" class="inptxt2"  tabindex="11" placeholder="아이디"  /></li>
    	            <li><input type="password" name="usrpwd" class="inptxt2" tabindex="12" placeholder="비밀번호"  onkeypress="if(event.keyCode==13){javascript:strOnLogin(false,logfm);}"  /></li>
                </ul>
                <a href="javascript:strOnLogin(false,logfm);" class="btn_login">로그인</a>
            </div>
</form>
			<div class="find_blk">
                <a href="/member/agree.asp">무료회원가입</a><a href="/member/cmsid.asp">아이디/비밀번호찾기</a>
            </div>

            <ul class="btns">
<%If Len(sns_naver1) > 0 And Len(sns_naver2) > 0 then%>
                <li><span>네이버 아이디로 편리하게 로그인 할 수 있습니다.</span><a href="/sns_naver/naver_login.asp"><img src="../img/img/btn_naver.gif" alt="네이버 로그인" /></a></li>
<%End if%>
<%If Len(sns_kakao) > 0 then%>
				<li><span>카카오톡 아이디로 편리하게 로그인 할 수 있습니다.</span><a href="javascript:createKakaotalkLogin();"><img src="../img/img/btn_kakao.gif" alt="카카오 로그인" /></a></li>                
<%End if%>
            </ul>
        </div>
    </div>

<!-- #include file = "../include/bottom.asp" -->