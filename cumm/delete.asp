<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
dim tabnm,idx
tabnm = Request("tabnm")
idx = Request("idx")

dim wrtid
sql = "select wrtid from board_board where idx=" & idx
set dr = db.execute(sql)
wrtid = dr(0)

	if str_User_ID = wrtid then

sql = "select image1,ref,re_level,snimg from board_board where idx=" & idx
set dr = db.execute(sql)

dim image1,ref,re_level,snimg
image1 = dr(0)
ref = dr(1)
re_level = dr(2)
snimg = dr(3)
dr.close

Dim DirectoryPath : DirectoryPath = Server.MapPath("..\") & "\ahdma\pds\"
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
response.redirect "list.asp?tabnm=" & tabnm
	else %><!-- #include file="../include/false_pg.asp" --><% end if

db.close
set db = Nothing

else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>