<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs,name,ordnum,gu
Dim DirectoryPath,abc

DirectoryPath = Server.MapPath("..\..\") & "\ahdma\quiz\"

Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.MaxUploadSize = 1024 * 1024 * 100
abc.AbsolutePath = True

Dim filen : filen = 1024 * 1024 * 10
Dim objSajin,imgDot,perioArry,img_imsi,state
Dim image1

Set objSajin = abc("img")(1)
if objSajin.FileExists then
 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
  img_imsi = objSajin.SafeFileName
  perioArry = Split(img_imsi,".")
  imgDot = perioArry(Ubound(perioArry)) ''확장자추출

  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "pdf" or LCase(imgDot) = "docx" or LCase(imgDot) = "doc" or LCase(imgDot) = "hwp" or LCase(imgDot) = "xls" or LCase(imgDot) = "txt" or LCase(imgDot) = "ppt" then ''파일 허용
   image1 = "dca_" & svdatefomt & "." & imgDot
   objSajin.Save DirectoryPath & image1
  end if

 end if
end if

state = abc("state")(1)
name = abc("name")(1)

sql = "select top 1 ordnum from mscate order by ordnum desc"
set rs=db.execute(sql)

if rs.eof or rs.bof then
	ordnum = 0
else
	ordnum = rs(0) + 1
rs.close
end if

sql = "insert into mscate (bname,ordnum,img,state)values"
sql = sql & "('" & name & "'"
sql = sql & "," & ordnum
sql = sql & ",'" & image1 &"'"
sql = sql & "," & state &""
sql = sql & ")"
db.execute sql,,adexecutenorecords

response.write"<script language='javascript'>"
response.write"self.location.href='list.asp';"
response.write"</script>"
response.End

Function svdatefomt()			''파일네임 중복 안되게 처리 함수
	Dim dt1,dt2,dt3
	dt1 = FormatDateTime(now(),2)
	dt2 = FormatDateTime(now(),4)
	dt3 = second(now)
	dt1 = replace(dt1,"-","")
	dt2 = replace(dt2,":","")
	if dt3 < 10 then
		dt3 = "0" & dt3
	end if
	svdatefomt = dt1 & dt2 & dt3
End Function
%>
<!-- #include file = "../authpg_2.asp" -->