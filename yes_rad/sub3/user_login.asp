<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs,usrid,usrnm

usrid = Request("usrid")

sql = "select name from member where id = '"& usrid &"'"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
	Response.write"<script>"
	Response.write"alert('회원정보에러!!');"
	Response.write""
	Response.write"</script>"
	Response.end
Else
	usrnm = rs(0)
rs.close
End if

dim login_new_ip
	
login_new_ip = Request.ServerVariables("HTTP_X_FORWARDED_FOR")'클라이언트의 리얼IP받음

If login_new_ip = "" Then '리얼Ip아닐때 동적IP받음(클라이언트)
   login_new_ip = Request.ServerVariables("REMOTE_ADDR")
end if

sql = "Update member set ins_my = '"& login_new_ip &"' where id='"& usrid &"'"
db.execute sql,,adexecutenorecords

Response.Cookies("userInfo") = usrid & "," & usrnm & ",,"

Response.redirect "/main/index.asp"
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->