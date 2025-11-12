<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim jemok,pgbn,mgbn,tabnm,logincheck,mem_group
Dim top_message,bottom_message

jemok = Request.Form("jemok")
jemok = Tag2Txt(jemok)

pgbn = Request.Form("pgbn")
mgbn = Request.Form("mgbn")
tabnm = Request.Form("tabnm")
logincheck = Request.Form("logincheck")
mem_group = Trim(request("mem_group"))
mem_group = ", "& mem_group &","

top_message = request("top_message")
bottom_message = request("bottom_message")

top_message = replace(top_message,"'","")
bottom_message = replace(bottom_message,"'","")

dim sql

sql = "update board_mast set top_message = '"& top_message &"', bottom_message = '"& bottom_message &"', mem_group = '"& mem_group &"',jemok='" & jemok & "',pgbn=" & pgbn & ",mgbn=" & mgbn & ",logincheck="& logincheck &" where idx=" & tabnm
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