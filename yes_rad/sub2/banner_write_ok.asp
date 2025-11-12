<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim abc
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

Dim DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\banner\"


Dim objSajin
Dim sajin_path,perioArry,imgDot
Set objSajin = abc("fileb")(1)

if objSajin.FileExists then	''파일이 첨부되었다면...

	if objSajin.Length < 1024 * 1024 * 4  then		''파일용량 4MB 체크

		perioArry = Split(objSajin.SafeFileName,".")
		imgDot = perioArry(Ubound(perioArry))

		if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "swf" or LCase(imgDot) = "png" then	''허용파일체크

			''받아온 정보 처리
			Dim sql,dr
			Dim upgbn,bangbn,areagbn,banner_url,banner,filegbn,ordnum,target,bgcolor,title


			title = abc.item("title")
			upgbn = abc.item("upgbn")
			bangbn = abc.item("bangbn")
			areagbn = abc.item("areagbn")
			banner_url = abc.item("banner_url")
			ordnum = abc.item("ordnum")
			target = abc.item("target")
			bgcolor = abc.item("bgcolor")
			filegbn = LCase(imgDot)

			upgbn =  ReplaceTag2Text(upgbn)
			bangbn = ReplaceTag2Text(bangbn)
			areagbn = ReplaceTag2Text(areagbn)
			banner_url = ReplaceTag2Text(banner_url)

			banner = "ban_" & svdatefomt & "." & imgDot
			objSajin.Save DirectoryPath & banner

			sql = "insert into banner (banner,banner_url,bangbn,areagbn,filegbn,ordnum,target,bgcolor,title) values ('" & banner & "','" & banner_url & "'," & bangbn & ",'" & areagbn & "','" & filegbn & "',"& ordnum &",'"& target &"','"& bgcolor &"','"& title &"')"
			db.execute(sql)


		end if

	end if

end if
Set objSajin = Nothing

db.close
set db = Nothing

response.redirect "banner_list.asp"
Response.end

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