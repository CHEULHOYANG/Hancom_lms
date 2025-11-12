<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/fso.asp" -->
<%
Dim sms_id,sms_tel

strTname="config"
strFile = Server.MapPath("..\..\") & "\ahdma\cfgini\"& strtname &".cfg"
arrConfig = Split(ReadTextFile(strFile),chr(13))

sms_id =			arrConfig(29)			''확장변수

If Len(sms_id) < 10 Then
	
	Response.write"<script>"
	Response.write"alert('문자발송정보를 먼저 입력후 이용해주세요.');"
	Response.write"self.close();"
	Response.write"</script>"
	Response.End
	
End If

sms_tel = Split(sms_id,",")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<title>문자보내기</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="imagetoolbar" content="no" />
<link rel="stylesheet" type="text/css" href="../rad_img/pop.css" />

<script>
function user_sms_send(){

	if (document.form.help_tel.value == ""  )	{
	alert("보내는사람 휴대폰번호를 입력해주세요");
	document.form.help_tel.focus();
	return;
	}

	if (document.form.tel.value == ""  )	{
	alert("받는사람 휴대폰번호를 입력해주세요");
	document.form.tel.focus();
	return;
	}

	if (document.form.content.value == ""  )	{
	alert("문자내용을 입력해주세요.")
	document.form.content.focus();
	return;
	}

	document.form.submit();
}
function fc_chk_byte(aro_name,ari_max) {
   var ls_str     = aro_name.value;
   var li_str_len = ls_str.length;
   var li_max      = ari_max * 2;
   var i           = 0;
   var li_byte     = 0;
   var li_len      = 0;
   var ls_one_char = "";
   var ls_str2     = "";

   for(i=0; i< li_str_len; i++) {
      ls_one_char = ls_str.charAt(i);
      if (escape(ls_one_char).length > 4) li_byte += 2;
      else li_byte++;
      if (li_byte <= li_max) li_len = i + 1;
   }
   if(li_byte > li_max) {
      alert("한글 " +  ari_max + "글자를 초과 입력할수 없습니다. 초과된 내용은 자동으로 삭제 됩니다.");
      ls_str2 = ls_str.substr(0, li_len);
      aro_name.value = ls_str2;
      
   }
   aro_name.focus();   
}
</script>
</head>
<body> 

<div class="laypop">
	<div class="lay_tit">
		<h2>문자보내기</h2>
		<a href="javascript:self.close();" class="btn_close"><img src="../rad_img/img/btn_close.png" alt="창닫기" /></a>
	</div>
	<div class="lay_cont">

<form name="form" method="post" action="sms_send3.asp">
		<table class="ptbl" style="width:656px">
			<colgroup>
			<col style="width:22%" />
			<col style="width:78%" />
			</colgroup>
			<tbody>
				<tr>
					<th>발신번호</th>
					<td><input name="help_tel" type="text" class="inptxt" id="help_tel" value="<%=sms_tel(1)%>" readonly></td>
				</tr>
				<tr>
					<th>수신번호</th>
					<td><input name="tel" type="text" class="inptxt" id="tel" value="<%=request("to_id")%>"></td>
				</tr>
				<tr>
					<th>문자내용</th>
					<td><textarea name="content" cols="45" rows="15" class="inptxt" onKeyUp='fc_chk_byte(this,80);' style="height:180px"></textarea></td>
				</tr>
			</tbody>
		</table>
</form>
		<div class="btn_wrap bw1">
			<a href="javascript:user_sms_send();" class="btn_pop red">보내기</a>
		</div>
	</div>		
</div>

</body>
</html>
<%
Function ReadTextFile(fpath)
	Dim objFile,strReturnString
	Set objFile = objFso.OpenTextFile(fpath , 1)

	if objFile.AtEndOfStream then

		Dim aryNum

		for aryNum = 0 to 32
			strReturnString = strReturnString & chr(13)
		Next

	else

		strReturnString = objFile.readAll

	end if

ReadTextFile = strReturnString

objFile.Close

Set objFile = Nothing

End Function %>
<!-- #include file = "../authpg_2.asp" -->