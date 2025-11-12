<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
	Dim idx,tabnm

	idx = Request("idx")
	tabnm = Request("tabnm")

	sql = "select image1,wrtid from board_board where idx=" & idx
	set dr = db.execute(sql)
	Dim wrtid,image1
	image1 = dr(0)
	wrtid = dr(1)
	dr.close

	Dim writeOk
	if wrtid = str_User_ID then

		Dim DirectoryPath : DirectoryPath = Server.MapPath("..\") & "\ahdma\pds\"
		set objFso = server.CreateObject("scripting.filesystemobject")

		strFile = DirectoryPath & image1
		if objFso.FileExists(strFile) then
			objFso.DeleteFile(strFile)
		end if
		set objFso = Nothing

		db.execute("delete board_board where idx = " & idx)
	else %>
	<!-- #include file="../include/false_pg.asp" --><%
	end if
	db.close
	set db = nothing
	response.redirect "list.asp?tabnm=" & tabnm
else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>