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
dim sql,dr,rs,edate,readnum

''board_board info
Dim ygbn
sql = "select ygbn from board_mast where idx=" & tabnm
set dr = db.execute(sql)
ygbn = dr(0)
dr.close

''넘어온 값
Dim title,writer,content,idx,notice,pwd,check_del1,check_del2

pwd = abc.item("pwd")
notice = abc.item("notice")
If Len(notice) = 0 Then notice = 0

idx = abc.item("idx")
title = abc.item("title")
writer = abc.item("writer")
content = abc("content")(1)

edate = abc.item("edate")
readnum = abc.item("readnum")

check_del1 = abc.item("check_del1")
check_del2 = abc.item("check_del2")

idx = Tag2Txt(idx)
title = Tag2Txt(title)
writer = Tag2Txt(writer )
content = replace(content,"'","''")

''페이지변수
Dim gbnS,strPart,strSearch,intpg
gbnS = abc.item("gbnS")
strPart = abc.item("strPart")
strSearch = abc.item("strSerach")
intpg = abc.item("intpg")

gbnS = Tag2Txt(gbnS)
strPart = Tag2Txt(strPart)
strSearch = Tag2Txt(strSearch)
intpg = Tag2Txt(intpg)
dim varPage : varPage = "tabnm=" & tabnm & "&gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch & "&intpg=" & intpg & "&idx=" & idx

''업로드파일 처리*********************************************

Dim objFso,strFile
set objFso = server.CreateObject("scripting.filesystemobject")

dim filen : filen = 1024 * 1024 * 50

if ygbn < 2 then
	filen = 1024 * 1024 * 50
end if

Dim objSajin

Set objSajin = abc("filenm")(1)
if objSajin.FileExists then

	if objSajin.Length < filen  then	''이미지 800KB, 자료 5MB
		Dim image1,image2
		image2 = objSajin.SafeFileName
		perioArry = Split(image2,".")
		imgDot = perioArry(Ubound(perioArry))	''확장자추출

		if saveDotChk(ygbn,imgDot) then	''파일 허용

			sql = "select image1 from board_board where idx=" & idx
			set dr = db.execute(sql)
			image1 = dr(0)
			dr.close

			''기존 파일 삭제
			strFile = DirectoryPath & image1
			if objFso.FileExists(strFile) then
				objFso.DeleteFile(strFile)
			end if
			image1 = "f_" & svdatefomt & "." & imgDot
			objSajin.Save DirectoryPath & image1	''파일업로드
			db.execute("update board_board set image1='" & image1 & "',image2='" & image2 & "' where idx=" & idx)	''파일명 저장

		end if

	end if
end If

If Len(check_del1) > 0 Then
	db.execute("update board_board set image1='',image2='' where idx=" & idx)
End If
If Len(check_del1) > 0 Then
	db.execute("update board_board set snimg='' where idx=" & idx)
End if

if int(ygbn) = 2 then		''갤러리 게시판인 경우 썸네일이미지

	Set objSajin = abc("snfile")(1)
	if objSajin.FileExists then
		if objSajin.Length < 1024 * 1024 * 10  then	''이미지 100KB
			perioArry = Split(objSajin.SafeFileName,".")
			imgDot = perioArry(Ubound(perioArry))	''확장자추출

			if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" then	''파일 허용
				dim snimg
				sql = "select snimg from board_board where idx=" & idx
				set dr = db.execute(sql)
				snimg = dr(0)
				dr.close

				''기존 파일 삭제
				strFile = DirectoryPath & snimg
				if objFso.FileExists(strFile) then
					objFso.DeleteFile(strFile)
				end if

				snimg = "s_" & svdatefomt & "." & imgDot
				objSajin.Save DirectoryPath & snimg
				db.execute("update board_board set snimg='" & snimg & "' where idx=" & idx)	''파일명 저장
			end if

		end if
	end if
end if

Set objSajin = Nothing
set objFso = Nothing
''***********************************************************

sql = "update board_board set "
sql = sql & "title='" & title & "',"
sql = sql & "pwd ='" & pwd & "',"
sql = sql & "content='" & content & "',"
sql = sql & "notice=" & notice & ","
sql = sql & "writer='" & writer & "'"
sql = sql & " where idx=" & idx
db.execute(sql)


dim o_regdate

sql = "select regdate from board_board where idx= '"& idx &"'"
set rs=db.execute(sql)

if rs.eof or rs.bof then
else
	o_regdate = FormatDateTime(edate,2) & " " & FormatDateTime(rs(0),4)  
end if

sql = "update board_board set readnum = "& readnum &",regdate = '"& o_regdate & "' where idx= '"& idx &"'"
db.execute sql,,adexecutenorecords



db.close
set db = nothing

response.redirect "content.asp?" & varPage

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