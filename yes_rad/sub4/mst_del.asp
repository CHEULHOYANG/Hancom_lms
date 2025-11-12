<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,sajin,dr,sql
idx = Request("idx")

''»çÁø
sql = "select sajin from Lectmast where idx=" & idx
set dr = db.execute(sql)
sajin = dr(0)
dr.close
set dr = nothing

if Not sajin = "noimg.gif" then
	Dim objFso,strFile,DirectoryPath
	set objFso = server.CreateObject("scripting.filesystemobject")
	DirectoryPath = Server.MapPath("..\..\") & "\ahdma\studimg\"
	strFile = DirectoryPath & sajin

	if objFso.FileExists(strFile) then
		objFso.DeleteFile(strFile)
	end if
	set objFso = nothing

end if

db.execute("delete Lectmast where idx=" & idx)
db.execute("delete LectAry where mastidx=" & idx)

db.close
set db = nothing

response.redirect "mst_list.asp"
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->