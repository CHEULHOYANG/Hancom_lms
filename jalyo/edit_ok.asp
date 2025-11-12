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

''넘어온 값
Dim title,writer,content,idx,pwd
idx = abc.item("idx")
title = abc.item("title")
writer = abc.item("writer")
content = abc("content")(1)

pwd = abc.item("pwd")
idx = Tag2Txt(idx)
title = Tag2Txt(title)
writer = Tag2Txt(writer )
content = replace(content,"'","''")

dim wrtid
sql = "select wrtid from board_board where idx=" & idx
set dr = db.execute(sql)
wrtid = dr(0)

	if str_User_ID = wrtid then
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
		set objFso = server.CreateObject("scripting.filesystemobject")

		dim filen
		filen = 1024 * 1024 * 30

		Dim objSajin

		Set objSajin = abc("filenm")(1)
		if objSajin.FileExists then

			if objSajin.Length < filen  then	''이미지 800KB, 자료 5MB
				Dim image1,image2
				image2 = objSajin.SafeFileName
				perioArry = Split(image2,".")
				imgDot = perioArry(Ubound(perioArry))	''확장자추출

				if LCase(imgDot) = "doc" or LCase(imgDot) = "hwp" or Lcase(imgDot) = "zip" or Lcase(imgDot) = "ppt" or Lcase(imgDot) = "txt" or Lcase(imgDot) = "xls" or Lcase(imgDot) = "pdf" or Lcase(imgDot) = "xlsx" or Lcase(imgDot) = "pptx" or Lcase(imgDot) = "docx" or Lcase(imgDot) = "alz" or Lcase(imgDot) = "hwp" then	''파일 허용

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
		end if

		Set objSajin = Nothing
		set objFso = Nothing
		''***********************************************************

		sql = "update board_board set "
		sql = sql & "title='" & title & "',"
		sql = sql & "pwd='" & pwd & "',"
		sql = sql & "content='" & content & "',"
		sql = sql & "writer='" & writer & "'"
		sql = sql & " where idx=" & idx

		db.execute(sql)
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
	else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if
else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>