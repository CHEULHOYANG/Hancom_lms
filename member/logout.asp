<!-- #include file = "../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
sql = "Update member set login_check = '' where id='"& str_User_ID &"'"
db.execute sql,,adexecutenorecords

Response.Cookies("userInfo") = ""
Response.Cookies("userInfo").expires = Date - 1
Response.Redirect "../main/index.asp"
Session.Abandon

else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>