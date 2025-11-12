<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs,title,id,info1,info2,info3,info4,info5,info6,info7,info8,info9,info10
Dim DirectoryPath,abc

DirectoryPath = Server.MapPath("..\..\") & "\ahdma\quiz\"
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True


title = abc("title")(1)
id = abc("id")(1)
info1 = abc("info1")(1)
info2 = abc("info2")(1)
info3 = abc("info3")(1)
info4 = abc("info4")(1)
info5 = abc("info5")(1)
info6 = abc("info6")(1)
info7 = abc("info7")(1)
info8 = abc("info8")(1)
info9 = abc("info9")(1)
info10 = abc("info10")(1)

title = Tag2Txt(title)
info1 = Tag2Txt(info1)
info2 = Tag2Txt(info2)
info3 = Tag2Txt(info3)
info4 = Tag2Txt(info4)
info5 = Tag2Txt(info5)
info6 = Tag2Txt(info6)
info7 = Tag2Txt(info7)
info8 = Tag2Txt(info8)
info9 = Tag2Txt(info9)
info10 = Tag2Txt(info10)

Dim filen : filen = 1024 * 1024 * 5
Dim objSajin,imgDot,perioArry,img_imsi
Dim image1,image2,image3,image4

Set objSajin = abc("files")(1)
if objSajin.FileExists then
 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
  img_imsi = objSajin.SafeFileName
  perioArry = Split(img_imsi,".")
  imgDot = perioArry(Ubound(perioArry)) ''확장자추출

  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "pdf" or LCase(imgDot) = "docx" or LCase(imgDot) = "doc" or LCase(imgDot) = "hwp" or LCase(imgDot) = "xls" or LCase(imgDot) = "xlsx" or LCase(imgDot) = "txt" or LCase(imgDot) = "ppt" or LCase(imgDot) = "pptx" then ''파일 허용
   image3 = "paper_" & svdatefomt & "." & imgDot
   objSajin.Save DirectoryPath & image3
  end if

 end if
end If

Dim id_count,jj

id = split(id,"^")
id_count = ubound(id)

For jj = 0 To id_count

	sql = "insert into end_paper (title,id,info1,info2,info3,info4,info5,info6,info7,info8,info9,info10,files)values"
	sql = sql & "('" & title &"'"
	sql = sql & ",'" & id(jj) & "'"
	sql = sql & ",'" & info1 & "'"
	sql = sql & ",'" & info2 & "'"
	sql = sql & ",'" & info3 & "'"
	sql = sql & ",'" & info4 & "'"
	sql = sql & ",'" & info5 & "'"
	sql = sql & ",'" & info6 & "'"
	sql = sql & ",'" & info7 & "'"
	sql = sql & ",'" & info8 & "'"
	sql = sql & ",'" & info9 & "'"
	sql = sql & ",'" & info10 & "'"
	sql = sql & ",'" & image3 & "'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

next

Response.write "<script>"
Response.write "alert('등록되었습니다');"
Response.write "self.location.href='list.asp';"
Response.write "</script>"
response.end

Function Tag2Txt(s)
		s = Replace(s,"'","''")
		s = Replace(s,"<","&lt;")
		s = Replace(s,">","&gt;")
		s = Replace(s,"&","&amp;")
		Tag2Txt = s
End Function

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