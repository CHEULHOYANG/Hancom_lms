<!-- #include file = "../authpg_1.asp" -->
<!-- #include file="../../include/dbcon.asp" -->
<%
Dim sql,abc,oFile1,name
Dim DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\logo\"
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

Dim filen : filen = 1024 * 1024 * 5
Dim objSajin,imgDot,perioArry,img_imsi
Dim image1,image2

Set objSajin = abc("file")(1)
if objSajin.FileExists then
 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
  img_imsi = objSajin.SafeFileName
  perioArry = Split(img_imsi,".")
  imgDot = perioArry(Ubound(perioArry)) ''확장자추출

  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" then ''파일 허용
   image1 = "ico_" & svdatefomt & "." & imgDot
   objSajin.Save DirectoryPath & image1
  end if

 end if
end if

name = abc.item("name")

	sql = "insert into icon_mast (name,icon)values"
	sql = sql & "('" & name & "'"
	sql = sql & ",'" & image1 & "'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

response.redirect "list.asp"

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