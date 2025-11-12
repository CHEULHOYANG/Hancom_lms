<!-- #include file = "../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim rs,neyong,reply_star,order_id

order_id = request.form("order_id")
reply_star = request.form("reply_star")
neyong = request.form("neyong")

order_id = Tag2Txt(order_id)
reply_star = Tag2Txt(reply_star)
neyong = Tag2Txt(neyong)

sql = "select reply_ok from order_mast where reply_ok = 0 and order_id = '"& order_id &"'"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then

	response.write"<script>"
	response.write"alert('구매확인에러!!');"
	response.write"self.location.href='08_list.asp';"
	response.write"</script>"
	response.End

else

	sql = "update order_mast set reply_ok = 1, reply_content = '"& neyong &"', reply_star = "& reply_star &" where order_id = '"& order_id &"' and bookidx=1"
	db.execute(sql)

	response.write"<script>"
	response.write"alert('구매확인이 완료되었습니다.');"
	response.write"self.location.href='08_list.asp';"
	response.write"</script>"
	response.End

rs.close
End if

db.close
set db = Nothing

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function



ELSE %>
<!-- #include file = "../include/false_pg.asp" -->
<% End IF %>