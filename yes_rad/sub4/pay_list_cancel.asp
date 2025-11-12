<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,idx,rs,cash,id,order_id
Dim intpg,gbnS,strsday,streday,strPart,strSearch

intpg = request("intpg")
gbnS = request("gbnS")
strsday = request("strsday")
streday = request("streday")
strPart = request("strPart")
strSearch = request("strSearch")
idx = Request("idx")

sql = "select id,order_id,cash from order_mast where cash > 0 and idx = "& idx
Set rs = db.execute(sql)

If rs.eof Or rs.bof Then
Else

	id = rs(0)
	order_id = rs(1)
	cash = rs(2)

	sql = "Update member set mileage = mileage + "& cash &" where id='"& id &"'"
	db.execute sql,,adexecutenorecords

	sql = "insert into mileage (id,gu,price,g_title,otp)values"
	sql = sql & "('" & id &"'"
	sql = sql & ",2,"& cash &""
	sql = sql & ",'주문번호 #"& order_id &" 적립금환불'"
	sql = sql & ",''"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

rs.close
End if

sql = "update order_mast set state = 1 where idx=" & idx
db.execute(sql)

db.close
set db = nothing

response.redirect "pay_list.asp?intpg="& intpg &"&gbnS="& gbnS &"&strsday="& strsday &"&streday="& streday &"&strPart="& strPart &"&strSearch="& strSearch &""
Response.End

%>
<!-- #include file = "../authpg_2.asp" -->