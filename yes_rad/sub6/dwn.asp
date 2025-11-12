<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
	Dim DirectoryPath,download
	DirectoryPath = Server.MapPath("..\..\") & "\ahdma\pds\"

	Dim idxnm
	idxnm = Request("idx")

	Dim sql,Dr,file_nm,file_path
	sql = "select image1,image2 from board_board where idx=" & idxnm
	Set Dr = db.execute(sql)
	file_path = Dr(0)
	file_nm = Dr(1)
	Dr.Close
	Set Dr = Nothing
	db.Close
	Set db = Nothing

	Dim down_path
	down_path = DirectoryPath & file_path
	Response.clear
	Response.buffer = false
	Response.CacheControl = "public"
	Response.ContentType = "application/unknown"
	Response.AddHeader "Content-Disposition","attachment; filename=" & file_nm

	Dim objDownload
	Set objDownload = Server.CreateObject("ADODB.Stream")

	objDownload.Open
	objDownload.type =1
	objDownload.LoadFromFile(down_path)
	download = objDownload.Read
	Response.BinaryWrite download
	Response.Flush
	objDownload.Close
	set objDownload = Nothing
%>
<!-- #include file = "../authpg_2.asp" -->