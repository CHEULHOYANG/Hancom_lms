<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim pop_nm,size_width,size_height,size_top,size_left,popcont,pop_cookie,pop_gu
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
sql = "insert into PopinfoTab (pop_nm,pop_neyong,pop_width,pop_height,pop_top,pop_left,pop_cookie,pop_gu) values ('"
sql = sql & pop_nm & "','" & popcont & "'," & size_width & "," & size_height & "," & size_top & "," & size_left & "," & pop_cookie & "," & pop_gu & ")"
db.execute(sql)
db.close
set db = nothing

Response.Redirect "popup_list.asp"

Function tag2Txt(str)
	str = Replace(str,"'","''")
	str = Replace(str,"<","&lt;")
	str = Replace(str,">","&gt;")
	tag2Txt = str
End Function

%>
<!-- #include file = "../authpg_2.asp" -->