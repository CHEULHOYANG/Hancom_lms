<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim ca1,ca2,ca3,title,content,price,admin_gu,munje_total,munje_gesu,munje_gu,munje_dap,munje_end_time,sungjuk_show
dim sql,munje_repeat,munje_date1,munje_date2
dim munje_time1,munje_time2,munje_bang1,munje_bang2,tca1,tca2,mem_group,sec,state

Dim DirectoryPath,abc
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\quiz\"
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.MaxUploadSize = 1024 * 1024 * 100
abc.AbsolutePath = True



tca1 = abc("ca1")(1)
tca2 = abc("ca2")(1)

If Len(tca1) = 0 Then tca1 = 0
If Len(tca2) = 0 Then tca2 = 0

ca1 = abc("cca1")(1)
ca2 = abc("cca2")(1)

If Len(ca1) = 0 Then ca1 = 0
If Len(ca2) = 0 Then ca2 = 0

ca3 = 0

state = abc("state")(1)
sec = abc.item("sec")

title = abc.item("title")
content = abc("content")(1)
price = abc("price")(1)
admin_gu = abc.item("admin_gu")
munje_total = 0
munje_gesu = abc.item("munje_gesu")
munje_gu = abc.item("munje_gu")
munje_dap = ""

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

title = replace(title,"'","")
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

image1 = ""
image2 = ""
image4 = ""

sql = "insert into quiz_munje (ca1,ca2,ca3,title,content,price,admin_gu,munje_total,munje_gesu,munje_gu,munje_dap,munje_img,munje_haedap,munje_attach,munje_listen,munje_repeat,munje_date1,munje_date2,munje_time1,munje_time2,munje_bang1,munje_bang2,munje_end_time,sungjuk_show,tca1,tca2,mem_group,sec,state)values"
sql = sql & "(" & ca1
sql = sql & "," & ca2
sql = sql & "," & ca3
sql = sql & ",'" & title & "'"
sql = sql & ",'" & content & "'"
sql = sql & "," & price
sql = sql & ",'" & admin_gu &"'"
sql = sql & "," & munje_total
sql = sql & "," & munje_gesu
sql = sql & "," & munje_gu
sql = sql & ",'" & munje_dap & "'"
sql = sql & ",'" & image1 & "'"
sql = sql & ",'" & image2 & "'"
sql = sql & ",'" & image3 & "'"
sql = sql & ",'" & image4 & "'"
sql = sql & "," & munje_repeat
sql = sql & ",'" & munje_date1 & "'"
sql = sql & ",'" & munje_date2 & "'"
sql = sql & ",'" & munje_time1 & "'"
sql = sql & ",'" & munje_time2 & "'"
sql = sql & "," & munje_bang1
sql = sql & "," & munje_bang2
sql = sql & "," & munje_end_time
sql = sql & "," & sungjuk_show
sql = sql & "," & tca1
sql = sql & "," & tca2
sql = sql & ",'" & mem_group & "'"
sql = sql & ",'" & sec & "'"
sql = sql & "," & state
sql = sql & ")"
db.execute sql,,adexecutenorecords

Response.write "<script>"
Response.write "alert('등록되었습니다');"
Response.write "self.location.href='list.asp';"
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