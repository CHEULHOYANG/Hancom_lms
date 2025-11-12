<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim abc
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.MaxUploadSize = 1024 * 1024 * 100
abc.AbsolutePath = True
Dim perioArry,imgDot,DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\pds\"

dim tabnm : tabnm = abc.item("tabnm")
dim sql,dr

''board_board info
Dim ygbn
sql = "select ygbn from board_mast where idx=" & tabnm
set dr = db.execute(sql)
ygbn = dr(0)
dr.close

''업로드파일 처리*********************************************

dim filen : filen = 1024 * 1024 * 50

if ygbn < 2 then
	filen = 1024 * 1024 * 50
end if
Dim objSajin
Dim image1,image2
Set objSajin = abc("filenm")(1)
if objSajin.FileExists then
	if objSajin.Length < filen  then	''이미지 800KB, 자료 5MB
		image2 = objSajin.SafeFileName
		perioArry = Split(image2,".")
		imgDot = perioArry(Ubound(perioArry))	''확장자추출

		if saveDotChk(ygbn,imgDot) then	''파일 허용
			image1 = "f_" & svdatefomt & "." & imgDot
			objSajin.Save DirectoryPath & image1
		end if

	end if
end if



dim snimg : snimg = "-"
if int(ygbn) = 2 then		''갤러리 게시판인 경우 썸네일이미지

	Set objSajin = abc("snfile")(1)
	if objSajin.FileExists then
		if objSajin.Length < 1024 * 1024 * 10  then	''이미지 100KB
			perioArry = Split(objSajin.SafeFileName,".")
			imgDot = perioArry(Ubound(perioArry))	''확장자추출

			if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" then	''파일 허용
				snimg = "s_" & svdatefomt & "." & imgDot
				objSajin.Save DirectoryPath & snimg
			end if

		end if
	end if
end if

Set objSajin = Nothing
''***********************************************************

Dim re_step,re_level,ref,idx
Dim title,writer,content,notice,pwd

notice = abc.item("notice")
If Len(notice) = 0 Then notice = 0

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

if Not idx = "" then
	re_step = abc.item("re_step")
	re_level = abc.item("re_level")
	ref = abc.item("ref")

	re_step = Tag2Txt(re_step)
	re_level = Tag2Txt(re_level)
	ref = Tag2Txt(ref)
	sql = "UPDATE board_board SET re_step = re_step + 1 WHERE ref=" & ref & " AND re_step > " & re_step
	db.execute(sql)

	re_step = int(re_step) + 1
	re_level = int(re_level) + 1
	num = 0
else
	ref = num
	re_step=ref*(-100)-99
	re_level=0
end if

sql = "insert into board_board (title,content,writer,wrtid,image1,image2,ref,re_level,re_step,num,tabnm,snimg,notice,pwd) values ('"
sql = sql & title & "','"
sql = sql & content & "','"
sql = sql & writer & "','관리자','"
sql = sql & image1 & "','"
sql = sql & image2 & "',"
sql = sql & ref & ","
sql = sql & re_level & ","
sql = sql & re_step & ","
sql = sql & num & ","
sql = sql & tabnm & ",'"
sql = sql & snimg & "',"& notice &",'"& pwd &"')"
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

Function saveDotChk(gbn,imgd)
	Dim frg : frg = False
	if gbn < 2 then
		if LCase(imgd) = "docx" Or LCase(imgd) = "xlsx" Or LCase(imgd) = "pptx" Or LCase(imgd) = "doc" or LCase(imgd) = "hwp" or Lcase(imgd) = "zip" or Lcase(imgd) = "ppt" or Lcase(imgd) = "txt" or Lcase(imgd) = "xls" or Lcase(imgd) = "pdf" then
			frg = True
		end if
	else
		if LCase(imgd) = "gif" or LCase(imgd) = "jpg" or LCase(imgd) = "png" then
			frg = True
		end if
	end if
saveDotChk = frg
End Function
%>
<!-- #include file = "../authpg_2.asp" -->