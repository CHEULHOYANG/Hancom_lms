<% 
Else 

	Response.write"<script>"
	Response.write"alert('접근권한이 없습니다.');"
	Response.write"self.location.href='/yea_rad/default.asp';"
	Response.write"</script>"
	Response.end

End IF 
%>