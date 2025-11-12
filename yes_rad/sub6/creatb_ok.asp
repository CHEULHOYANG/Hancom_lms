<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim jemok,pgbn,ygbn,mgbn,tabnm,logincheck,mem_group
Dim top_message,bottom_message

jemok = Request.Form("jemok")
jemok = Tag2Txt(jemok)

pgbn = Request.Form("pgbn")
ygbn = Request.Form("ygbn")
mgbn = Request.Form("mgbn")
tabnm = Request.Form("tabnm")
logincheck = Request.Form("logincheck")
mem_group = Trim(request("mem_group"))
mem_group = ", "& mem_group &","

top_message = request("top_message")
bottom_message = request("bottom_message")

top_message = replace(top_message,"'","")
bottom_message = replace(bottom_message,"'","")

dim sql,rs,ordnum


sql = "select count(idx) from board_mast"
set rs=db.execute(sql)

ordnum = rs(0) + 1
rs.close

sql = "insert into board_mast (jemok,pgbn,ygbn,mgbn,logincheck,ordnum,mem_group,top_message,bottom_message) values ('" & jemok & "'," & pgbn & "," & ygbn & "," & mgbn & ","& logincheck &","& ordnum &",'"& mem_group &"','"& top_message &"','"& bottom_message &"')"

db.execute(sql)
db.close
set db = nothing


response.redirect "blist.asp"

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function
%>
<!-- #include file = "../authpg_2.asp" -->