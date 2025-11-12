<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim ca1,ca2,ca3,title,content,price,admin_gu,munje_total,munje_gesu,munje_gu,munje_dap,idx,munje_end_time,sungjuk_show,mem_group
dim sql,rs
dim file2_del,file3_del,file4_del
dim page,searchpart,searchstr
dim munje_repeat,munje_date1,munje_date2
dim munje_time1,munje_time2,munje_bang1,munje_bang2,tca1,tca2,sec,state

Dim DirectoryPath,abc
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\quiz\"
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

state = abc("state")(1)

tca1 = abc("ca1")(1)
tca2 = abc("ca2")(1)

If Len(tca1) = 0 Then tca1 = 0
If Len(tca2) = 0 Then tca2 = 0

ca1 = abc("cca1")(1)
ca2 = abc("cca2")(1)

If Len(ca1) = 0 Then ca1 = 0
If Len(ca2) = 0 Then ca2 = 0

ca3 = 0

sec = abc.item("sec")
title = abc.item("title")
content = abc("content")(1)
price = abc("price")(1)
admin_gu = abc.item("admin_gu")
munje_total = 0
munje_gesu = abc.item("munje_gesu")
munje_gu = abc.item("munje_gu")
munje_dap = ""
idx = abc.item("idx")

page = abc.item("page")
searchpart = abc.item("searchpart")
searchstr = abc.item("searchstr")

file2_del = abc.item("file2_del")
file3_del = abc.item("file3_del")
file4_del = abc.item("file4_del")

munje_repeat = abc.item("munje_repeat")
munje_date1 = abc.item("munje_date1")
munje_date2 = abc.item("sdate")

munje_time1 = abc.item("munje_time1")
munje_time2 = abc.item("munje_time2")
munje_bang1 = abc.item("munje_bang1")
munje_bang2 = abc.item("munje_bang2")

munje_end_time = abc.item("munje_end_time")
sungjuk_show = abc.item("sungjuk_show")

mem_group = Trim(abc.item("mem_group"))
mem_group = ", "& mem_group &","

title = replace(title,"'","''")
content = replace(content,"'","")

Dim filen : filen = 1024 * 1024 * 5
Dim objSajin,imgDot,perioArry,img_imsi
Dim image1,image2,image3,image4

Set objSajin = abc("File3")(1)
if objSajin.FileExists then
 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
  img_imsi = objSajin.SafeFileName
  perioArry = Split(img_imsi,".")
  imgDot = perioArry(Ubound(perioArry)) ''확장자추출

  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "pdf" or LCase(imgDot) = "docx" or LCase(imgDot) = "doc" or LCase(imgDot) = "hwp" or LCase(imgDot) = "xls" or LCase(imgDot) = "xlsx" or LCase(imgDot) = "txt" or LCase(imgDot) = "ppt" or LCase(imgDot) = "pptx" or LCase(imgDot) = "zip" then ''파일 허용
   image3 = "f3_" & svdatefomt & "." & imgDot
   objSajin.Save DirectoryPath & image3
  end if

 end if
end if

if image3 <> "" then
sql = "update quiz_munje set munje_attach ='"& image3 & "' where idx = '"& idx &"'"
db.execute sql,,adexecutenorecords
end if

if file3_del = "Y" then
sql = "update quiz_munje set munje_attach ='' where idx = '"& idx &"'"
db.execute sql,,adexecutenorecords
end if

sql = "update quiz_munje set state="& state &",sec = '"& sec &"', tca1 = "& tca1 &", tca2 = "& tca2 &",munje_end_time = '"& munje_end_time &"' , sungjuk_show = '"& sungjuk_show &"' , ca1 = '"& ca1 & "' , ca2 = '"& ca2 &"' , ca3 = '"& ca3 &"' , title = '"& title &"' , content = '"& content &"' , price = '"& price &"' , admin_gu = '"& admin_gu &"' , munje_total = '"& munje_total &"' , munje_gesu = '"& munje_gesu &"', munje_gu = '"& munje_gu &"' , munje_dap ='"& munje_dap &"', munje_repeat ='"& munje_repeat &"', munje_date1 ='"& munje_date1 &"', munje_date2 ='"& munje_date2 &"', munje_time1 ='"& munje_time1 &"', munje_time2 ='"& munje_time2 &"', munje_bang1 ='"& munje_bang1 &"',munje_bang2 ='"& munje_bang2 &"',mem_group ='"& mem_group &"' where idx= '"& idx &"'"
db.execute sql,,adexecutenorecords

Response.write "<script>"
Response.write "alert('수정되었습니다');"
Response.write "self.location.href='list.asp?page="& page &"&searchpart="& searchpart &"&searchstr="& searchstr &"';"
Response.write "</script>"
Response.End

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