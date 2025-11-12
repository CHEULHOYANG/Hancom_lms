<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,pop_nm,size_width,size_height,size_top,size_left,popcont,pop_cookie,pop_gu
idx = Request.Form("idx")
pop_nm = Request.Form("pop_nm")
size_width = Request.Form("size_width")
size_height = Request.Form("size_height")
size_top = Request.Form("size_top")
size_left = Request.Form("size_left")
popcont = Request.Form("popcont")
pop_cookie = Request.Form("pop_cookie")
pop_gu = Request.Form("pop_gu")

pop_nm = tag2Txt(pop_nm)
size_width = tag2Txt(size_width)
size_height = tag2Txt(size_height)
size_top = tag2Txt(size_top)
size_left = tag2Txt(size_left)
popcont = Replace(popcont,"'","''")
pop_cookie = tag2Txt(pop_cookie)

if size_top = "" then
	size_top = 0
end if

if size_left = "" then
	size_left = 0
end if

if pop_cookie = "on" then
	pop_cookie = 1
else
	pop_cookie = 0
end if

dim sql
sql = "update PopInfoTab set "
sql = sql & "pop_nm='" & pop_nm & "',"
sql = sql & "pop_width=" & size_width & ","
sql = sql & "pop_height=" & size_height & ","
sql = sql & "pop_top=" & size_top & ","
sql = sql & "pop_left=" & size_left & ","
sql = sql & "pop_cookie=" & pop_cookie & ","
sql = sql & "pop_gu=" & pop_gu & ","
sql = sql & "pop_neyong='" & popcont & "'"
sql = sql & " where pop_idx=" & idx
db.execute(sql)

db.close
Set db = Nothing

Response.Redirect "popup_list.asp"

Function tag2Txt(str)
	str = Replace(str,"'","''")
	str = Replace(str,"<","&lt;")
	str = Replace(str,">","&gt;")
	tag2Txt = str
End Function

%>
<!-- #include file = "../authpg_2.asp" -->