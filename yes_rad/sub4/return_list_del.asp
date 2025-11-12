<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,idx,intpg,gbnS,strsday,streday,strPart,strSearch,gu

idx = request("idx")
intpg = request("intpg")
gbnS = request("gbnS")
strsday = request("strsday")
streday = request("streday")
strPart = request("strPart")
strSearch = request("strSearch")
gu = request("gu")

If gu = 1 Then

	sql = "update order_mast set return_state = 2, state = 1 where idx=" & idx
	db.execute(sql)

	Response.write"<script>"
	Response.write"alert('환불처리가 완료되었습니다.');"
	Response.write"self.location.href='return_list.asp?intpg="& intpg &"&gbnS="& gbnS &"&strsday="& strsday &"&streday="& streday &"&strPart="& strPart &"&strSearch="& strSearch &"';"
	Response.write"</script>"
	Response.end

End If

If gu = 2 Then

	sql = "update order_mast set return_state = 0 , return_price = intprice , return_bankinfo = '' where idx=" & idx
	db.execute(sql)

	Response.write"<script>"
	Response.write"alert('환불신청이 취소되었습니다.');"
	Response.write"self.location.href='return_list.asp?intpg="& intpg &"&gbnS="& gbnS &"&strsday="& strsday &"&streday="& streday &"&strPart="& strPart &"&strSearch="& strSearch &"';"
	Response.write"</script>"
	Response.end

End if

If gu = 3 Then

	sql = "delete from order_mast where idx=" & idx
	db.execute(sql)

	Response.write"<script>"
	Response.write"alert('주문내역이 삭제되었습니다.');"
	Response.write"self.location.href='return_list.asp?intpg="& intpg &"&gbnS="& gbnS &"&strsday="& strsday &"&streday="& streday &"&strPart="& strPart &"&strSearch="& strSearch &"';"
	Response.write"</script>"
	Response.end

End if

%>
<!-- #include file = "../authpg_2.asp" -->