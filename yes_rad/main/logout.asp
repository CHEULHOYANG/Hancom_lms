<%
Response.Cookies("strInfo") = ""
Response.Cookies("adminid") = ""
Response.Cookies("strInfo").expires = Date - 1
Response.Cookies("adminid").expires = Date - 1

Response.Redirect "login.asp"
%>