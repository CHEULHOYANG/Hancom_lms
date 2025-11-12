<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,rs,sql
Dim gbnS,strsday,streday,strPart,strSearch,intpg,cash,usrid,order_id

gbnS = Request("gbnS")
strsday = Request("strsday")
streday = Request("streday")
strPart = Request("strPart")
strSearch = Request("strSearch")
intpg = Request("intpg")

idx = Request("idx")

sql = "select (select isnull(sum(cash),0) from order_mast where order_id=A.order_id),usrid,order_id from bank_order A where idx = "& idx
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then

	Response.write"<script>"
	Response.write"alert('무통장입금정보에러!!');"
	Response.write"self.location.href='onlist.asp?intpg="& intpg &"&gbnS=" & gbnS & "&strsday=" & strsday & "&streday=" & streday & "&strPart=" & strPart & "&strSearch=" & strSearch &"';"
	Response.write"</script>"
	Response.End
	
Else

	cash = rs(0)
	usrid = rs(1)
	order_id = rs(2)

rs.close
End If

If cash > 0 Then

		sql = "Update member set mileage = mileage + "& cash &" where id='"& usrid &"'"
		db.execute sql,,adexecutenorecords

		sql = "insert into mileage (id,gu,price,g_title,otp)values"
		sql = sql & "('" & usrid &"'"
		sql = sql & ",2,"& cash &""
		sql = sql & ",'주문번호 #"& order_id &" 적립금사용 환불'"
		sql = sql & ",''"
		sql = sql & ")"
		db.execute sql,,adexecutenorecords

End if

db.execute("delete bank_order where idx=" & idx)
db.execute("delete order_mast where bankidx=" & idx)

db.close
set db = nothing

response.redirect "onlist.asp?intpg="& intpg &"&gbnS=" & gbnS & "&strsday=" & strsday & "&streday=" & streday & "&strPart=" & strPart & "&strSearch=" & strSearch &""
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->