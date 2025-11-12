<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim abc
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.MaxUploadSize = 1024 * 1024 * 100
abc.AbsolutePath = True
Dim perioArry,imgDot,DirectoryPath
DirectoryPath = Server.MapPath("..\") & "\ahdma\pds\"

dim tabnm : tabnm = abc.item("tabnm")

''업로드파일 처리*********************************************
dim filen
filen = 1024 * 1024 * 30
Dim objSajin
Dim image1,image2
Set objSajin = abc("filenm")(1)
if objSajin.FileExists then
	if objSajin.Length < filen  then	''이미지 800KB, 자료 5MB
		image2 = objSajin.SafeFileName
		perioArry = Split(image2,".")
		imgDot = perioArry(Ubound(perioArry))	''확장자추출

		if LCase(imgDot) = "doc" or LCase(imgDot) = "hwp" or Lcase(imgDot) = "zip" or Lcase(imgDot) = "ppt" or Lcase(imgDot) = "txt" or Lcase(imgDot) = "xls" or Lcase(imgDot) = "pdf" or Lcase(imgDot) = "xlsx" or Lcase(imgDot) = "pptx" or Lcase(imgDot) = "docx" or Lcase(imgDot) = "alz" or Lcase(imgDot) = "hwp" then	''파일 허용
			image1 = "f_" & svdatefomt & "." & imgDot
			objSajin.Save DirectoryPath & image1
		end if

	end if
end if

Set objSajin = Nothing
''***********************************************************

Dim re_step,re_level,ref,idx,pwd
Dim title,writer,content

pwd = abc.item("pwd")
idx = abc.item("idx")
title = abc.item("title")
writer = abc.item("writer")
content = abc.item("content")

idx = Tag2Txt(idx)
title = Tag2Txt(title)
writer = Tag2Txt(writer )
content = replace(content,"'","''")

dim num
sql = "select isNull(max(num),0) + 1 from board_board"
set dr = db.execute(sql)
num = dr(0)
dr.close

ref = num
re_step=ref*(-100)-99
re_level=0

dim snimg : snimg = "-"

sql = "insert into board_board (title,content,writer,wrtid,image1,image2,ref,re_level,re_step,num,tabnm,snimg,pwd) values ('"
sql = sql & title & "','"
sql = sql & content & "','"
sql = sql & writer & "','" & str_User_ID & "','"
sql = sql & image1 & "','"
sql = sql & image2 & "',"
sql = sql & ref & ","
sql = sql & re_level & ","
sql = sql & re_step & ","
sql = sql & num & ","
sql = sql & tabnm & ",'"
sql = sql & snimg & "','"& pwd &"')"
db.execute(sql)
db.close
set db = nothing

response.redirect "list.asp?tabnm=" & tabnm

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

else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>