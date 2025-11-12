<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

Sub Email_Send(Text,Title,UserEmail,UserName,Fromail,FroName)

Dim ToEmail    : ToEmail        = UserEmail	'받는이 이메일
Dim FromEmail    : FromEmail    = Fromail
Dim EmailTitle              : EmailTitle     = Title	'요청하신 자료에 대한 답변 입니다
Dim EmailText    : EmailText     = Text	'내용
Dim ToName    : ToName        = UserName	' 받는이 이름
Dim FromName    : FromName    = FroName

Dim myMail
Dim iConf
   set myMail = Server.CreateObject("CDO.Message")
   Set iConf = Server.CreateObject("CDO.Configuration")

Set iConf = myMail.Configuration
With iConf.Fields
.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")       =1
.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")      ="127.0.0.1"
.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")  =25
.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverpickupdirectory")= "C:\Inetpub\mailroot\Pickup"
.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30
.Update
End with
myMail.To = ToName & "<" & ToEmail & ">"
myMail.From = FromName & "<" & FromEmail & ">"
myMail.Subject = EmailTitle
myMail.HTMLBody = EmailText
myMail.BodyPart.Charset="ks_c_5601-1987"         '/// 한글을 위해선 꼭 넣어 주어야 합니다.
myMail.HTMLBodyPart.Charset="ks_c_5601-1987" '/// 한글을 위해선 꼭 넣어 주어야 합니다.
myMail.Send
set myMail = Nothing

End Sub



dim Form_Content,from_email,Form_title,objMail,To_email,i
dim sql,rs,groub
dim bdate

groub=request("groub")
Form_title=request("Form_title")
Form_Content=request("Form_Content")
from_email=request("from_email")

if groub="1" then

To_email=""

bdate = left(now(),10)
bdate = split(bdate,"-")

sql="select email from member where b_year='"& bdate(0) &"' and b_month='"& bdate(1) &"' and b_day='"& bdate(2) &"' order by idx desc"
set rs=db.execute(sql)

i=1
do while not rs.eof
if i=1 then
	To_email = rs(0)
else
	To_email = To_email & rs(0) & ","
end if
	rs.movenext
i=i+1
loop

elseif groub="2" then

To_email=""

sql="select email from member where email_res=1 order by idx desc"
set rs=db.execute(sql)

i=1
do while not rs.eof
if i=1 then
	To_email = rs(0)
else
	To_email = ""& To_email & ","& rs(0) & ""
end if
	rs.movenext
i=i+1
loop

elseif groub="3" then

to_email=request("to_email")

end if

call Email_Send(form_content,form_title,to_email,to_email,from_email,from_email)

Response.Write "<script>"
Response.Write "alert('메일발송이 되었습니다');"
Response.Write "self.location.href='mlist.asp';"
Response.Write "</script>"
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->