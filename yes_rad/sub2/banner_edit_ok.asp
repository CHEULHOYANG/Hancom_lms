<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim abc
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

Dim DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\banner\"

''받아온 정보 처리
Dim sql,dr
Dim banner_url,banner,filegbn,idx,intpg,ordnum,target,bgcolor,title
idx = abc.item("idx")
intpg = abc.item("intpg")
banner_url = abc.item("banner_url")
ordnum = abc.item("ordnum")
target = abc.item("target")
bgcolor = abc.item("bgcolor")
idx =  ReplaceTag2Text(idx)
intpg = ReplaceTag2Text(intpg)
banner_url = ReplaceTag2Text(banner_url)
title = abc.item("title")

sql = "select banner,filegbn from banner where idx=" & idx
set dr = db.execute(sql)
banner = dr(0)
filegbn = dr(1)
dr.close

Dim objSajin
Dim sajin_path,perioArry,imgDot
Set objSajin = abc("fileb")(1)

if objSajin.FileExists then	''파일이 첨부되었다면...

	if objSajin.Length < 1024 * 1024 * 4  then		''파일용량 4MB 체크

		perioArry = Split(objSajin.SafeFileName,".")
		imgDot = perioArry(Ubound(perioArry))

		if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "swf" or LCase(imgDot) = "png" then	''허용파일체크
			dim objfso,strFile
			set objfso = server.CreateObject("scripting.filesystemobject")
			strFile = DirectoryPath & banner

			if objfso.FileExists(strFile) then
				objfso.DeleteFile(strFile)
			end if
			Set objfso = Nothing

			filegbn = LCase(imgDot)
			banner = "ban_" & svdatefomt & "." & imgDot
			objSajin.Save DirectoryPath & banner

		end if

	end if

end if
Set objSajin = Nothing

sql = "update banner set title='"& title &"',bgcolor='"& bgcolor &"',banner='" & banner & "',banner_url='" & banner_url & "',filegbn='" & filegbn & "',ordnum='" & ordnum & "',target='" & target & "' where idx=" & idx
db.execute(sql)

db.close
set db = Nothing

response.redirect "banner_list.asp?intpg=" & intpg
Response.End

Function ReplaceTag2Text(str)
	str = replace(str, "'", "''")
	str = replace(str, "&", "&amp;")
	str = replace(str, "<", "&lt;")
	str = replace(str, ">", "&gt;")
	ReplaceTag2Text = str
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