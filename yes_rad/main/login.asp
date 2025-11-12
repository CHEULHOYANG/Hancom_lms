<%
Option Explicit

Response.Buffer=true
Response.Expires=0
Response.ExpiresAbsolute=Now()-1
Response.AddHeader"Pragma","no-cache"
Response.AddHeader"Cache-Control","private"
Response.CacheControl="no-cache"

Dim int_Cookies : int_Cookies = Request.Cookies("strInfo")

if int_Cookies = "0" Then

	Response.redirect "main.asp"
	Response.End
	
else
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="ko">
<head>
<title>예스소프트 솔루션관리자모드</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="imagetoolbar" content="no" />

<script type="text/javascript"> window.top.document.title = document.title </script>
<script type='text/javascript'>var domain = "http://"+document.domain+"/"</script>
<script type='text/javascript' src='/include/jquery.js'></script>
<link rel="stylesheet" type="text/css" href="../rad_img/default.css" />
<script language="javascript">
function strOnSubmit(isKey,theform){

	clmn = theform.strID;
	if(clmn.value==""){
		alert("아이디를 입력하세요.");
		clmn.focus();
		return;
	}
	clmn = theform.strPwd;
	if(clmn.value == ""){
		alert("비밀번호를 입력해주세요.");
		clmn.focus();
		return;
	}
theform.submit();
}
</script>
</head>

<body>
<div class="mlogin">
	<dl class="logTxt">
		<dt>예스소프트솔루션 관리자페이지에<br />오신 것을 환영합니다.</dt>
		<dd>로그인을 하셔야 관리시스템에 접근이 가능합니다.<br />
			입력란에 아이디와 비밀번호를 입력해 주세요!</dd>
	</dl>
	<div class="logbox">
<form name="theForm" method="post" action="login_ok.asp">
		<div class="login">
			<ul>
				<li><strong>아이디</strong><input type="text" name="strID" id="input" tabIndex="1" /></li>
				<li><strong>비밀번호</strong><input type="password" name="strPwd" id="input" onKeyPress="if(event.keyCode==13){javascript:strOnSubmit(false,document.theForm);}" tabIndex="2" /></li>
			</ul>
			<a href="javascript:strOnSubmit(false,document.theForm);" class="log_btn">로그인</a>
			<div class="id_save"><strong>접속중인 아이피 : <%=Request.Servervariables("REMOTE_ADDR")%></strong><br />보안을 위해 아이피를 저장합니다.</div>
		</div>
</form>
	</div>
</div>

</body>
</html>
<%End if%>