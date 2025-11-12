<!-- #include file = "../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim idx,return_bankinfo,return_state,return_price
Dim rs


idx = request.form("idx")
return_bankinfo = ""& request.form("bankinfo1") &" / "& request.form("bankinfo2") &" / "& request.form("bankinfo3") &""


sql = "select return_state,intprice from order_mast where idx = "& idx &" and id = '"& str_User_ID &"' "
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then

	response.write"<script>"
	response.write"alert('수강내역 오류!!');"
	response.write"self.location.href='01_main.asp';"
	response.write"</script>"
	response.End

Else

	return_state = rs(0)
	return_price = rs(1)

rs.close
End if

If return_state > 0 then

	response.write"<script>"
	response.write"alert('환불신청이 불가능합니다.');"
	response.write"self.location.href='01_main.asp';"
	response.write"</script>"
	response.End

End if

db.execute("update order_mast set return_state = 1, return_price = "& return_price &" , return_bankinfo = '"& return_bankinfo &"' , return_memo = '' where idx = "& idx &" and id = '"& str_User_ID &"' ")

response.write"<script>"
response.write"alert('환불신청이 완료되었습니다.');"
response.write"self.location.href='01_main.asp';"
response.write"</script>"
response.End

ELSE %>
<!-- #include file = "../include/false_pg.asp" -->
<% End IF %>