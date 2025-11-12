<!-- #include file = "../include/set_loginfo.asp" -->
<!-- #include file = "../include/refer_check.asp" -->
<%
if isUsr then
vPage = vPage & "/cs/qwrite.asp"
''response.write vReferer & "<br>"
''response.write vPage & "<br>"
''response.write InStr(vReferer,vPage)

	if InStr(vReferer,vPage) > 0 then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim abc
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True
Dim perioArry,imgDot,DirectoryPath
DirectoryPath = Server.MapPath("..\") & "\ahdma\pds\"

Dim jemok,neyong,qgbn,qanscont
jemok = abc.item("jemok")

neyong = abc.item("neyong")
qgbn = abc.item("qgbn")
qanscont = ""
qgbn = 2

jemok = Tag2Txt(jemok)
neyong = Tag2Txt(neyong)
qgbn = Tag2Txt(qgbn)

dim filen
filen = 1024 * 1024 * 20
Dim objSajin
Dim image1,image2
Set objSajin = abc("files1")(1)
if objSajin.FileExists then
	if objSajin.Length < filen  then	''이미지 800KB, 자료 5MB
		image2 = objSajin.SafeFileName
		perioArry = Split(image2,".")
		imgDot = perioArry(Ubound(perioArry))	''확장자추출

		if LCase(imgDot) = "doc" or LCase(imgDot) = "hwp" or Lcase(imgDot) = "zip" or Lcase(imgDot) = "ppt" or Lcase(imgDot) = "txt" or Lcase(imgDot) = "xls" or Lcase(imgDot) = "pdf" or Lcase(imgDot) = "jpg" or Lcase(imgDot) = "gif" or Lcase(imgDot) = "png" or Lcase(imgDot) = "xlsx" or Lcase(imgDot) = "docx" or Lcase(imgDot) = "alz" then	''파일 허용
			image1 = "oq_" & svdatefomt & "." & imgDot
			objSajin.Save DirectoryPath & image1
		end if

	end if
end if

Set objSajin = Nothing

sql = "insert into oneone (uname,quserid,qgbn,qtitle,qcont,qanscont,files1) values ('"& str_User_Nm &"','" & str_User_ID & "'," & qgbn & ",'" & jemok & "','" & neyong & "','" & qanscont & "','" & image1 & "')"
''response.write sql

db.execute(sql)
db.close
set db = nothing

Response.Redirect "qlist.asp"


Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function

Function svdatefomt()
	Dim dt1,dt2,dt3
	dt1 = replace(Date,"-","")
	dt2 = FormatDateTime(now(),4)
	dt3 = second(now)
	dt1 = Right(dt1,8)
	dt2 = replace(dt2,":","")

	if dt3 < 10 then
		dt3 = "0" & dt3
	end if
svdatefomt = dt1 & dt2 & dt3
End Function

''******************************************
	else %>
<!-- #include file = "../include/false_pg.asp" -->
<% end if
else %>
<!-- #include file = "../include/false_pg.asp" -->
<% end if %>