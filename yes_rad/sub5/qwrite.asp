<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,idx,intpg,qanscont,check_del
Dim abc
Dim gbnS,strPart,strSearch,varPage

Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True
Dim perioArry,imgDot,DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\pds\"

idx = abc.item("idx")
intpg = abc.item("intpg")
qanscont = abc.item("qanscont")
check_del = abc.item("check_del")

gbnS = abc.item("gbnS")
strSearch = abc.item("strSearch")
strPart = abc.item("strPart")
varPage = "gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch

dim filen
filen = 1024 * 1024 * 20
Dim objSajin
Dim image1,image2
Set objSajin = abc("files2")(1)
if objSajin.FileExists then
	if objSajin.Length < filen  then	''이미지 800KB, 자료 5MB
		image2 = objSajin.SafeFileName
		perioArry = Split(image2,".")
		imgDot = perioArry(Ubound(perioArry))	''확장자추출

		if LCase(imgDot) = "doc" or LCase(imgDot) = "hwp" or Lcase(imgDot) = "zip" or Lcase(imgDot) = "ppt" or Lcase(imgDot) = "txt" or Lcase(imgDot) = "xls" or Lcase(imgDot) = "pdf" or Lcase(imgDot) = "jpg" or Lcase(imgDot) = "gif" or Lcase(imgDot) = "png" or Lcase(imgDot) = "xlsx" or Lcase(imgDot) = "docx" or Lcase(imgDot) = "alz" then	''파일 허용
			image1 = "oa_" & svdatefomt & "." & imgDot
			objSajin.Save DirectoryPath & image1
		end if

	end if
end if

if len(image1) > 0 then
	sql = "update oneone set files2='"& image1 &"' where qidx=" & idx
	db.execute(sql)
end if

if len(check_del) > 0 then
	sql = "update oneone set files2='' where qidx=" & idx
	db.execute(sql)
end if

sql = "update oneone set qansgbn=1,qanscont='" & Tag2Txt(qanscont) & "',ansdate=GetDate() where qidx=" & idx
db.execute(sql)
db.close
set db = nothing

response.redirect "qneyong.asp?idx=" & idx & "&intpg=" & intpg & "&" & varPage
Response.end

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