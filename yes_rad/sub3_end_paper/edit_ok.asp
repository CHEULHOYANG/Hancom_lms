<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs,title,id,info1,info2,info3,info4,info5,info6,info7,info8,info9,info10
Dim DirectoryPath,abc
Dim idx,page,searchstr,searchpart,file3_del

DirectoryPath = Server.MapPath("..\..\") & "\ahdma\quiz\"
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

idx = abc("idx")(1)
page = abc("page")(1)
searchstr = abc("searchstr")(1)
searchpart = abc("searchpart")(1)
file3_del = abc("file3_del")(1)

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
id = Tag2Txt(id)
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
end if

if Len(image3) > 0 then
	sql = "update end_paper set files = '"& image3 & "' where idx = '"& idx &"'"
	db.execute sql,,adexecutenorecords
end if

if Len(file3_del) > 0 then
	sql = "update end_paper set files ='' where idx = '"& idx &"'"
	db.execute sql,,adexecutenorecords
end if

sql = "update end_paper set title = '"& title &"', id = '"& id &"',info1 = '"& info1 &"',info2 = '"& info2 &"',info3 = '"& info3 &"',info4 = '"& info4 &"',info5 = '"& info5 &"',info6 = '"& info6 &"',info7 = '"& info7 &"',info8 = '"& info8 &"',info9 = '"& info9 &"',info10 = '"& info10 &"'  where idx= '"& idx &"'"
db.execute sql,,adexecutenorecords

Response.write "<script>"
Response.write "alert('수정되었습니다');"
Response.write "self.location.href='list.asp?page="& page &"&searchpart="& searchpart &"&searchstr="& searchstr &"';"
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