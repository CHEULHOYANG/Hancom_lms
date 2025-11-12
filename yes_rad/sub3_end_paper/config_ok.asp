<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs
Dim info1,info2,info3,info4,info5,info6,info7,info8,info9,info10
Dim DirectoryPath
Dim abc,oFile1,check_del1
Dim link1,link2,link3,link4,link5,link6
Dim link1_etc,link2_etc,link3_etc,link4_etc,link5_etc,link6_etc

DirectoryPath = Server.MapPath("../../ahdma/") '파일이 저장될 로컬폴더 경로
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True
Set oFile1 = abc("file1")(1)

check_del1 = abc("check_del1")(1)
info1 = abc("info1")(1)
info2 = abc("info2")(1)
info3 = abc("info3")(1)
info4 = abc("info4")(1)
info5 = abc("info5")(1)
info6 = abc("info6")(1)
info7 = abc("info7")(1)
info8 = abc("info8")(1)
info10 = abc("info10")(1)

link1 = abc("link1")(1)
link1_etc = abc("link1_etc")(1)

link2 = abc("link2")(1)
link2_etc = abc("link2_etc")(1)

link3 = abc("link3")(1)
link3_etc = abc("link3_etc")(1)

link4 = abc("link4")(1)
link4_etc = abc("link4_etc")(1)

link5 = abc("link5")(1)
link5_etc = abc("link5_etc")(1)

link6 = abc("link6")(1)
link6_etc = abc("link6_etc")(1)

info1 = ReplaceTag2Text(info1)
info2 = ReplaceTag2Text(info2)
info3 = ReplaceTag2Text(info3)
info4 = ReplaceTag2Text(info4)
info5 = ReplaceTag2Text(info5)
info6 = ReplaceTag2Text(info6)
info7 = ReplaceTag2Text(info7)
info8 = Replace(info8,"'","''")
info10 = Replace(info10,"'","''")

dim strFileWholePath
Dim strFileName1, FileSize1, FileType1

If oFile1.FileExists Then 
    strFileName1 = lcase(oFile1.SafeFileName)
    FileSize1 = oFile1.Length
    FileType1 = oFile1.FileType

	If (right(strFileName1,3) = "jpg" Or right(strFileName1,3) = "gif" Or right(strFileName1,3) = "png") Then
		If Left(oFile1.MIMEType,5) <> "image" Then
			Response.Write "<script language=javascript>"
			Response.Write "alert(""이미지파일을 확인해주세요!! 파일형태에 문제가 발생했습니다!!"");"
			Response.Write "history.back();"
			Response.Write "</script>"
			Response.end
		End if
	End if

    if oFile1.Length > 4096000 or (right(strFileName1,3) <> "png" and right(strFileName1,3) <> "jpg" and right(strFileName1,3) <> "gif" and right(strFileName1,3) <> "swf") then
        Response.Write "<script language=javascript>"
        Response.Write "alert(""4M 이상의 사이즈인 파일은 업로드하실 수 없습니다"");"
        Response.Write "history.back();"
        Response.Write "</script>"
        Response.end
    else
        strFileWholePath = GetUniqueName(strFileName1, DirectoryPath)
        oFile1.Save strFileWholePath
    End if
End If

sql = "select count(*) from end_paper_config"
Set rs=db.execute(sql)

If rs(0) = 0 Then

	sql = "insert into end_paper_config (info1,info2,info3,info4,info5,info6,info7,info8,info9,info10,link1,link2,link3,link4,link5,link6,link1_etc,link2_etc,link3_etc,link4_etc,link5_etc,link6_etc)values"
	sql = sql & "('" & info1 &"'"
	sql = sql & ",'" & info2 & "'"
	sql = sql & ",'" & info3 & "'"
	sql = sql & ",'" & info4 & "'"
	sql = sql & ",'" & info5 & "'"
	sql = sql & ",'" & info6 & "'"
	sql = sql & ",'" & info7 & "'"
	sql = sql & ",'" & info8 & "'"
	sql = sql & ",'" & strFileName1 & "'"
	sql = sql & ",'" & info10 & "'"
	sql = sql & ",'" & link1 & "'"
	sql = sql & ",'" & link2 & "'"
	sql = sql & ",'" & link3 & "'"
	sql = sql & ",'" & link4 & "'"
	sql = sql & ",'" & link5 & "'"
	sql = sql & ",'" & link6 & "'"
	sql = sql & ",'" & link1_etc & "'"
	sql = sql & ",'" & link2_etc & "'"
	sql = sql & ",'" & link3_etc & "'"
	sql = sql & ",'" & link4_etc & "'"
	sql = sql & ",'" & link5_etc & "'"
	sql = sql & ",'" & link6_etc & "'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

Else

	If Len(strfilename1) > 0 Then
		sql = "update end_paper_config set info9 ='"& strfilename1 & "' "
		db.execute sql,,adexecutenorecords
	End If
	If Len(check_del1) > 0 Then
		sql = "update end_paper_config set info9 ='' "
		db.execute sql,,adexecutenorecords
	End if	

	sql = "update end_paper_config set link1 = '"& link1 &"',link2 = '"& link2 &"',link3 = '"& link3 &"',link4 = '"& link4 &"',link5 = '"& link5 &"',link6 = '"& link6 &"',link1_etc = '"& link1_etc &"',link2_etc = '"& link2_etc &"',link3_etc = '"& link3_etc &"',link4_etc = '"& link4_etc &"',link5_etc = '"& link5_etc &"',link6_etc = '"& link6_etc &"',info1 = '"& info1 &"',info2 = '"& info2 &"',info3 = '"& info3 &"',info4 = '"& info4 &"',info5 = '"& info5 &"',info6 = '"& info6 &"',info7 = '"& info7 &"',info8 = '"& info8 &"',info10 = '"& info10 &"'"
	db.execute sql,,adexecutenorecords

rs.close
End if

Response.write "<script>"
Response.write "alert('저장되었습니다.');"
Response.write "self.location.href='config.asp';"
Response.write "</script>"
Response.end

Function ReplaceTag2Text(str)
	str = replace(str, "'", "''")
	str = replace(str, "&", "&amp;")
	str = replace(str, "<", "&lt;")
	str = replace(str, ">", "&gt;")
	ReplaceTag2Text = str
End Function

Function GetUniqueName(byRef strFileName, DirectoryPath)

    Dim strName, strExt
    ' 확장자를 제외한 파일명을 얻는다.
    strName = Mid(strFileName, 1, InstrRev(strFileName, ".") - 1) 
         strExt = Mid(strFileName, InstrRev(strFileName, ".") + 1) '확장자를 얻는다


    Dim fso
    Set fso = Server.CreateObject("Scripting.FileSystemObject")

    Dim bExist : bExist = True 
    '우선 같은이름의 파일이 존재한다고 가정
    Dim strFileWholePath : strFileWholePath = DirectoryPath & "\" & strName & "." & strExt 
    '저장할 파일의 완전한 이름(완전한 물리적인 경로) 구성
    Dim countFileName : countFileName = 0 
    '파일이 존재할 경우, 이름 뒤에 붙일 숫자를 세팅함.

    Do While bExist ' 우선 있다고 생각함.
        If (fso.FileExists(strFileWholePath)) Then ' 같은 이름의 파일이 있을 때
            countFileName = countFileName + 1 '파일명에 숫자를 붙인 새로운 파일 이름 생성
            strFileName = strName & "_" & countFileName & "." & strExt
            strFileWholePath = DirectoryPath & "\" & strFileName
        Else
            bExist = False
        End If
    Loop
    GetUniqueName = strFileWholePath
End Function
%> 
<!-- #include file = "../authpg_2.asp" -->