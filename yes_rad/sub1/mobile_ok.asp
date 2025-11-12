<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim abc,DirectoryPath
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\logo\"

dim sql,rs
dim info2,info3,info4,info5,info7
dim check_del1,check_del2

info2 = abc.item("info2")
info3 = abc.item("info3")
info4 = abc.item("info4")
info5 = abc.item("info5")
info7 = abc.item("info7")
check_del1 = abc.item("check_del1")
check_del2 = abc.item("check_del2")

Dim filen : filen = 1024 * 1024 * 5
Dim objSajin,imgDot,perioArry,img_imsi
Dim image1,image2

Set objSajin = abc("file1")(1)
if objSajin.FileExists then
 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
  img_imsi = objSajin.SafeFileName
  perioArry = Split(img_imsi,".")
  imgDot = perioArry(Ubound(perioArry)) ''확장자추출

  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" or LCase(imgDot) = "ico" then ''파일 허용
   image1 = "f_" & svdatefomt & "." & imgDot
   objSajin.Save DirectoryPath & image1
  end if

 end if
end if

Set objSajin = abc("file2")(1)
if objSajin.FileExists then
 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
  img_imsi = objSajin.SafeFileName
  perioArry = Split(img_imsi,".")
  imgDot = perioArry(Ubound(perioArry)) ''확장자추출

  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" or LCase(imgDot) = "ico" then ''파일 허용
   image2 = "l_" & svdatefomt & "." & imgDot
   objSajin.Save DirectoryPath & image2
  end if

 end if
end if


sql = "select count(idx) from m_config"
set rs=db.execute(sql)

if rs(0) = 0 then

	sql = "insert into m_config (info1,info2,info3,info4,info5,info6,info7)values"
	sql = sql & "('" & image1 & "'"
	sql = sql & ",'" & info2 & "'"
	sql = sql & ",'" & info3 & "'"
	sql = sql & ",'" & info4 & "'"
	sql = sql & ",'" & info5 & "'"
	sql = sql & ",'" & image2 & "'"
	sql = sql & ",'" & info7 & "'"	
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

	
else

if len(image1) > 0 then
	sql = "update m_config set info1 = '"& image1 & "'"
	db.execute sql,,adexecutenorecords
end if

if len(image2) > 0 then
	sql = "update m_config set info6 = '"& image2 & "'"
	db.execute sql,,adexecutenorecords
end if

if len(check_del1) > 0 then
	sql = "update m_config set info1 = ''"
	db.execute sql,,adexecutenorecords
end if

if len(check_del2) > 0 then
	sql = "update m_config set info6 = ''"
	db.execute sql,,adexecutenorecords
end if

sql = "update m_config set info2 = '"& info2 & "',info3 = '"& info3 & "',info4 = '"& info4 & "',info5 = '"& info5 & "',info7 = '"& info7 & "'"
db.execute sql,,adexecutenorecords

rs.close	
end if

response.write"<script>"
response.write"alert('적용되었습니다.');"
response.write"self.location.href='mobile.asp';"
response.write"</script>"

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

%>
<!-- #include file = "../authpg_2.asp" -->