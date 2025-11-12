<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim rs,sql,idx
idx = Request("idx")
sql = "select banner from banner where idx=" & idx
set rs = db.execute(sql)
Dim file_nm
file_nm = rs(0)
rs.close
set rs = nothing

Dim DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\banner\"

Dim objfso,strFile
set objfso = server.CreateObject("scripting.filesystemobject")
strFile = DirectoryPath & file_nm

if objfso.FileExists(strFile) then
	objfso.DeleteFile(strFile)
end if

Set objfso = Nothing


sql = "delete banner where idx=" & idx
db.execute(sql)

db.close
set db = nothing

response.redirect "banner_list.asp"
%>
<!-- #include file = "../authpg_2.asp" -->