<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,tabnm
dim sql,dr
Dim intpg,gbnS,strPart,strSearch

idx = Request("idx")
tabnm = Request("tabnm")
intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")


sql = "select image1,ref,re_level,snimg from board_board where idx=" & idx
set dr = db.execute(sql)

dim image1,ref,re_level,snimg
image1 = dr(0)
ref = dr(1)
re_level = dr(2)
snimg = dr(3)
dr.close

Dim DirectoryPath : DirectoryPath = Server.MapPath("..\..\") & "\ahdma\pds\"
Dim objFso,strFile
set objFso = server.CreateObject("scripting.filesystemobject")

strFile = DirectoryPath & image1	''메인이미지
if objFso.FileExists(strFile) then
	objFso.DeleteFile(strFile)
end if

strFile = DirectoryPath & snimg	''썸네일이미지
if objFso.FileExists(strFile) then
	objFso.DeleteFile(strFile)
end if
set objFso = Nothing


if int(re_level) = 0 then
  sql = "delete board_board where ref = " & ref
else
  sql = "delete board_board where idx = " & idx
end if

db.execute(sql)

db.execute("delete replyTab where tabidx=" & idx & " and tabnm=" & tabnm)
db.close
set db = Nothing

response.redirect "list.asp?intpg="& intpg &"&gbnS="& gbnS &"&strPart="& strPart &"&strSearch="& strSearch &"&tabnm=" & tabnm
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->