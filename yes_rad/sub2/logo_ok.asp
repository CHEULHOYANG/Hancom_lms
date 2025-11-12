<!-- #include file = "../authpg_1.asp" -->
<%
Dim abc
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

Dim perioArry,imgDot,DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma/logo\"

Dim objSajin,errorNum,logonum,idx

idx = abc.item("idx")
idx = Tag2Txt(idx)
logonum = abc.item("gbn")

Set objSajin = abc("logo")(1)
Dim sajin,imgok


if objSajin.FileExists then
	if objSajin.Length < 1024 * 1024 * 5  then	''800kb 이상 제한
		perioArry = Split(objSajin.SafeFileName,".")
		imgDot = perioArry(Ubound(perioArry))	''확장자추출
		if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or Lcase(imgDot) = "bmp" or Lcase(imgDot) = "png" then	''이미지파일만 허용
			sajin = "logo_" & svdatefomt & "." & imgDot
			imgok = True
			objSajin.Save DirectoryPath & sajin
		end if
	end if
end if
Set objSajin = Nothing

%><!-- #include file="../../include/dbcon.asp" --><%

	dim sql,dr

	if idx = "" then
		sql = "insert into logoTab (imgsrc,gbn) values ('" & sajin & "'," & logonum & ")"
		db.execute(sql)
	else
		sql = "select imgsrc from logoTab where idx=" & idx
		set dr = db.execute(sql)
		dim imgsrc
		imgsrc = dr(0)
		dr.close
		set dr = nothing

		''기존 파일 삭제
		Dim objFso,strFile
		set objFso = server.CreateObject("scripting.filesystemobject")
		strFile = DirectoryPath & imgsrc

		if objFso.FileExists(strFile) then
			objFso.DeleteFile(strFile)
		end if
		set objFso = Nothing

		sql = "update logoTab set imgsrc='" & sajin & "' where idx=" & idx
		db.execute(sql)
	end If
	
db.close
set db = nothing

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

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function

response.redirect "list.asp"
%>
<!-- #include file = "../authpg_2.asp" -->