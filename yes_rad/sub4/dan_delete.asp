<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx : idx = Request("idx")
Dim sql,dr,isRecod,isRows,isCols
Dim gbnS,strPart,strSearch,intpg

intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")

''sectionTab 颇老 昏力
sql = "select sumpath,srcpath from sectionTab where l_idx=" & idx
set dr = db.execute(sql)
if Not Dr.Bof or Not dr.Eof then
	isRecod = True
	isRows = split(dr.GetString(2),chr(13))
end if
dr.Close

Dim objFso,strFile1,strFile2,DirectoryPath
set objFso = server.CreateObject("scripting.filesystemobject")
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\studimg\"

if isRecod then

	for ii = 0 to UBound(isRows) - 1
		isCols = split(isRows(ii),chr(9))
		strFile1 = DirectoryPath & isCols(0)
		strFile2 = DirectoryPath & isCols(1)

		if objFso.FileExists(strFile1) then
			objFso.DeleteFile(strFile1)
		end if

		if objFso.FileExists(strFile2) then
			objFso.DeleteFile(strFile2)
		end if
	Next

end if

''LecturTab 颇老 昏力
sql = "select sajin from LecturTab where idx=" & idx
set dr = db.execute(sql)
Dim sajin : sajin = dr(0)
dr.close
set dr = nothing

if Not sajin = "noimg.gif" then
	strFile1 = DirectoryPath & sajin
	if objFso.FileExists(strFile1) then
		objFso.DeleteFile(strFile1)
	end if
end if
set objFso = nothing

db.execute("delete LecturTab where idx=" & idx)
db.execute("delete sectionTab where l_idx=" & idx)
db.execute("delete  LectAry where lectidx=" & idx)

db.close
set db = nothing

response.redirect "dan_list.asp?intpg="& intpg &"&gbnS="& gbnS &"&strPart="& strPart &"&strSearch="& strSearch &""
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->