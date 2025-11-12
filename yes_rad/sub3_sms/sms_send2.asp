<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<!-- #include file = "../../include/fso.asp" -->
<%
Dim send_tel,res_tel,id,sql,rs,return_url,sms_count,i,sms_id,shop_url
Dim group

strTname="config"
strFile = Server.MapPath("..\..\") & "\ahdma\cfgini\"& strtname &".cfg"
arrConfig = Split(ReadTextFile(strFile),chr(13))

sms_id =			arrConfig(29)			''확장변수

if len(sms_id) < 10 Then

	response.write"<script language='javascript'>"
	response.write"alert('문자발송보안아이디/보안키를 정확히 입력해주세요.');"
	response.write"self.location.href='../sub1/list.asp';"
	response.write"</script>"
	response.end	

end if

sms_id = split(sms_id,",")

send_tel = request("send_tel")
res_tel = ""
msg = request("message")
group = request("group")

sql="select tel2 from member where sms_res = 1 and sp2 = "& group
set rs=db.execute(sql)

if rs.eof or rs.bof Then

	response.write"<script language='javascript'>"
	response.write"alert('발송회원목록이 없어서 문자메시지를 발송할수가 없습니다.\n단건문자를 보내시려면 단건문자서비스를 이용해주시기 바랍니다.');"
	response.write"self.location.href='../sub1/list.asp';"
	response.write"</script>"
	response.End
	
Else

i=1
do until rs.eof

	if i=1 then
		res_tel = replace(rs(0),"-","")
	else
		res_tel = res_tel &"|"& replace(rs(0),"-","")
	end If

rs.movenext
i=i+1
loop
end if

Dim api_url
api_url = "https://www.ppurio.com/api/send_euckr_text.php"

Dim userid, callback, phone, msg, names, appdate, subject
userid = ""& sms_id(0) &""                           ' [필수] 뿌리오 아이디
callback = ""& sms_id(1) &""                    ' [필수] 발신번호 - 숫자만
phone = ""& res_tel &""                       ' [필수] 수신번호 - 여러명일 경우 |로 구분 "010********|010********|010********"
msg = Server.URLEncode(""& msg &"") ' [필수] 문자내용 - 이름(names)값이 있다면 [*이름*]가 치환되서 발송됨
names = Server.URLEncode("")          ' [선택] 이름 - 여러명일 경우 |로 구분 "홍길동|이순신|김철수"
subject = Server.URLEncode("")        ' [선택] 제목 (30byte)

Dim xmlHttp, result
SET xmlHttp = Server.CreateObject("Microsoft.XMLHTTP")
xmlHttp.open "POST", api_url, False
xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
xmlHttp.setRequestHeader "Accept-Language","ko"
xmlHttp.send "userid="&userid&"&callback="&callback&"&phone="&phone&"&msg="&msg&"&names="&names&"&appdate="&appdate&"&subject="&subject

if xmlHttp.status = 200 then
	result = xmlHttp.responseText
Else
	result = "server_error"
End if
SET xmlHttp = Nothing

Response.write"<script language='javascript'>"
Response.write"alert('"& result &"');"
Response.write"self.location.href='smslist1.asp';"
Response.write"</script>"
Response.End

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