<!-- #include file = "../include/set_loginfo.asp" -->
<!-- #include file = "../include/dbcon.asp" -->
<% if isUsr then

dim idx,idx_check

for each idx in request.form("II")
idx_check = split(idx,".")

	sql = "delete wish_list where userid='" & str_User_ID & "' and tabidx=" & idx_check(0) 
	db.execute(sql)
   
Next

for each idx in request.form("JJ")
idx_check = split(idx,".")

	sql = "delete wish_list where userid='" & str_User_ID & "' and tabidx=" & idx_check(0) 
	db.execute(sql)
   
Next

response.redirect "03_bguny.asp"

else %><!-- #include file = "../include/false_pg.asp" -->
<% end if %>