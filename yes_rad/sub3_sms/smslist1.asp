<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<!-- #include file = "../../include/fso.asp" -->
<%
Dim sql,rs,idx,title,rs1,m_count
Dim sms_id,sms_tel

strTname="config"
strFile = Server.MapPath("..\..\") & "\ahdma\cfgini\"& strtname &".cfg"
arrConfig = Split(ReadTextFile(strFile),chr(13))

sms_id =			arrConfig(29)			''확장변수

If Len(sms_id) < 10 Then
	
	Response.write"<script>"
	Response.write"alert('문자발송정보를 먼저 입력후 이용해주세요.');"
	Response.write"self.location.href='../sub1/list.asp';"
	Response.write"</script>"
	Response.End
	
End If

sms_tel = Split(sms_id,",")
%>
<!--#include file="../main/top.asp"-->

<script>
function user_sms_send(){

	if (document.emoticon_form.send_tel.value == ""  )	{
	alert("보내는사람 연락처를 입력해주세요.");
	document.emoticon_form.send_tel.focus();
	return;
	}

	if (document.emoticon_form.group.value == "0"  )	{
	alert("그룹을선택해주세요.");
	return;
	}

	if (document.emoticon_form.message.value == ""  )	{
	alert("문자내용을 입력해주세요.")
	document.emoticon_form.message.focus();
	return;
	}

	document.emoticon_form.submit();
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>그룹문자발송</h2>

<form name="emoticon_form" method="post" action="sms_send2.asp">
<input type="hidden" name="ContentIdx">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>보내는사람</th>
						<td><input name="send_tel" class="inptxt1" value="<%=sms_tel(1)%>" readonly></td>
					</tr>
					<tr>
						<th>받는사람</th>
						<td><select name="group" id="group" class="seltxt">
								  <option value="0" <%if request("group")=0 then response.write"selected" end if%>>그룹을선택해주세요</option>
<% 
sql = "select idx,title from group_mast where gu = 1 order by idx desc"
set rs=db.execute(sql)

if rs.eof or rs.bof then
else
do until rs.eof

idx = rs(0)
title = rs(1)

sql="select count(idx) from member where sms_res = 1 and sp2 = '"& idx &"'"
set rs1 = db.execute(sql)

m_count = rs1(0)
rs1.close
%>									  
                                    <option value="<%=idx%>" <%if request("group") = ""& idx &"" then response.write"selected" end if%>><%=title%>(<%=m_count%>명)</option>
<%
rs.movenext
loop
rs.close
end if
%>									
                                  </select></td>
					</tr>
					<tr>
						<th>문자</th>
						<td><textarea cols="18" rows="6" class="inptxt1" style="width:230px;height:300px" oncontextmenu="return false" onselectstart="return false" ondragstart="return false" onKeyUp="javascript:cal_pre();" onMouseOver="this.style.color='cc0000';" onClick="javascript:clear2();" id="message" name="message" ></textarea><br />
						<input 
                                style="FONT-SIZE: 9pt; BACKGROUND: none transparent scroll repeat 0% 0%; HEIGHT: 15px;border:0;" 
                                readOnly size=2 value=0 name=cbyte>
                              <input 
                                onKeyUp=getByteLen(this.value) 
                                style="FONT-SIZE: 9pt; BACKGROUND: none transparent scroll repeat 0% 0%; WIDTH: 60px; HEIGHT: 15px;border:0;" 
                                size=2  value="/ 80Byte" name="Input"></td>
					</tr>

					


				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:user_sms_send();" class="btn">발송하기</a>
			<a href="javascript:Cancel();" class="btn trans">다시작성</a>
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

End Function
%>
<!-- #include file = "../authpg_2.asp" -->