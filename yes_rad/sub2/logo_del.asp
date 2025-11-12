<!-- #include file = "../authpg_1.asp" -->
<!-- #include file="../../include/dbcon.asp" -->
<%
Dim sql,dr,imgsrc,idx
idx = Request("idx")
Dim DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma/logo\"

sql = "select imgsrc from logoTab where idx=" & idx
set dr = db.execute(sql)
imgsrc = dr(0)
dr.close
set dr = nothing

''기존 파일 삭제
Dim objFso,strFile
set objFso = server.CreateObject("scripting.filesystemobject")
strFile = DirectoryPath & imgsrc

if objFso.FileExists(strFile) then
	objFso.DeleteFile(strFile)
end if
set objFso = Nothing

sql = "delete logoTab where idx=" & idx
db.execute(sql)

db.close
set db = nothing

response.redirect "list.asp"
%>
<!-- #include file = "../authpg_2.asp" -->