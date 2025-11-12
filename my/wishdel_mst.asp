<!-- #include file = "../include/set_loginfo.asp" -->
<!-- #include file = "../include/dbcon.asp" -->
<% if isUsr then

dim idx,idx_check

idx = request("idx")

sql = "delete wish_list where userid='" & str_User_ID & "' and idx=" & idx
db.execute(sql)

response.redirect "03_bguny.asp"

else %><!-- #include file = "../include/false_pg.asp" -->
<% end if %>