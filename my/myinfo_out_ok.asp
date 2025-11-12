<!-- #include file = "../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim out_reason,replcont
out_reason = Request.Form("out_reason")
replcont = Replace(Request.Form("replcont"),"'","''")
replcont = Replace(replcont,"<","&lt;")
replcont = Replace(replcont,">","&gt;")

''Å»ÅðÇÏ·Á´Â  È¸¿øÁ¤º¸ - ÁÖ¹Î¹øÈ£
   sql = "select b_year,b_month,b_day from member where id='" & str_User_ID & "'"
  set dr = db.execute(sql)
   Dim jumin
   jumin = dr(0) & "-" & dr(1) & "-" & dr(2)
   dr.close
   set dr = nothing

sql = "update member set tel1='',tel2='',email='',name='Å»Åð',pwd='12312454234',zipcode1='',juso1='',juso2='' where id='" & str_User_ID & "'"
db.execute(sql)

db.execute("delete wish_list where userid='" & str_User_ID & "'")
db.execute("delete bank_order where usrid='" & str_User_ID & "'")

sql = "insert into mem_out (id,uname,reason,etc,juminno) values ('" & str_User_ID & "','" & str_User_Nm & "','" & out_reason & "','" & replcont & "','" & jumin & "')"
db.execute(sql)

Response.Cookies("userInfo") = ""

db.close
set db = nothing

Response.Redirect "../main/index.asp"


ELSE %>
<!-- #include file = "../include/false_pg.asp" -->
<% End IF %>