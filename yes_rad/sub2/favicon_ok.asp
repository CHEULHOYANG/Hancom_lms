<!-- #include file = "../authpg_1.asp" -->
<%
Dim abc
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

Dim perioArry,imgDot,DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma/logo\"

Dim objSajin,errorNum,logonum,idx

Set objSajin = abc("pto")(1)
Dim sajin,imgok
imgok = False

if objSajin.FileExists then
	if objSajin.Length < 1024 * 1024 * 2  then	''800kb 이상 제한
		perioArry = Split(objSajin.SafeFileName,".")
		imgDot = perioArry(Ubound(perioArry))	''확장자추출
		if LCase(imgDot) = "ico" then	''이미지파일만 허용
			sajin = "favicon_" & svdatefomt & "." & imgDot
			imgok = True
			objSajin.Save DirectoryPath & sajin
		end if
	end if
end if
Set objSajin = Nothing

%><!-- #include file="../../include/dbcon.asp" --><%

	dim sql,rs

	sql = "select count(*) from site_info"
	Set rs=db.execute(sql)

	If rs(0) = 0 then

		sql = "insert into site_info (favicon) values ('" & sajin & "')"
		db.execute(sql)

	Else

		sql = "update site_info set favicon='" & sajin & "'"
		db.execute(sql)

	rs.close
	End if

	response.redirect "favicon.asp"

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
%>
<!-- #include file = "../authpg_2.asp" -->