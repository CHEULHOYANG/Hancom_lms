<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,nan,jumsu,code,mname,dap1,i,j
Dim make2,lidx,number,gu,title,random,cnumber,make1,end_date

make1 = request.form("make1")
If Len(make1) = 0 Then make1 = 1000

make2 = request.form("make2")
If Len(make2) = 0 Then make2 = 10

end_date = request.form("end_date")

For j = 1 To make2

	randomize
	
	Random = array(int((122-97)*rnd + 97),int((122-97)*rnd + 97),int((122-97)*rnd + 97),int((122-97)*rnd + 97),int((9999-1000)*rnd + 1000))

	cnumber = UCase(chr(random(0))&""&chr(random(1))&""&chr(random(2))&""&chr(random(3))&random(4))

	sql = "select count(idx) from coupon_price_mast where cnumber = '"& cnumber &"'"
	Set rs=db.execute(sql)

	If rs(0) = 0 Then

	sql = "insert into coupon_price_mast (cnumber,price,end_date)values"
	sql = sql & "('" & cnumber &"'"
	sql = sql & "," & make1
	sql = sql & ",'" & end_date &"'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

	rs.close
	End if
		
next


			Response.write "<script>"
			Response.write "alert('"& make1 &"원 할인 쿠폰 "& make2 &"장이 등록되었습니다.');"
			Response.write "self.location.href='coupon_price_list.asp';"
			Response.write "</script>"
			Response.End
%> 
<!-- #include file = "../authpg_2.asp" -->