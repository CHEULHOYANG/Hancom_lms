<%
	Dim sql,file_path
	file_path = request("filename")

	Dim down_path,download
	down_path = Server.MapPath("..\..\") & "\ahdma\quiz\" & file_path

	Response.clear
	Response.buffer = false
	Response.CacheControl = "public"
	Response.ContentType = "application/unknown"
	Response.AddHeader "Content-Disposition","attachment; filename=" & file_path
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