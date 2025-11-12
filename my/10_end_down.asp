<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<%
if len(str_User_ID) = 0 Then

	response.write"<script>"
	response.write"alert('로그인후 서비스 이용이 가능합니다.');"
	response.write"history.back();"
	response.write"</script>"
	response.End

end If

Dim files,rs

sql="select files from end_paper where id = '"& str_User_ID &"' and idx = "& request("idx")
set rs=db.execute(sql)

if rs.eof or rs.bof Then

	response.write"<script>"
	response.write"alert('디비에러!!');"
	response.write"history.back();"
	response.write"</script>"
	response.end

Else

	files = rs(0)

rs.close
end If

sql = "Update end_paper set down_check = down_check + 1 where idx = "& request("idx")
db.Execute sql,,adexecutenorecords

response.redirect "/ahdma/quiz/"& files &""
%>