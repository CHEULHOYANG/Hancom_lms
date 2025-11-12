<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,nan,jumsu,code,mname,dap1,i,j
Dim make2,lidx,number,gu,title,random,cnumber,end_date

lidx = request.form("lidx")
gu = request.form("gu")
end_date = request.form("end_date")

title = request.form("title")
title = replace(title,"'","")

make2 = request.form("make2")
If Len(make2) = 0 Then make2 = 10

For j = 1 To make2


	randomize
	
	Random = array(int((122-97)*rnd + 97),int((122-97)*rnd + 97),int((122-97)*rnd + 97),int((122-97)*rnd + 97),int((9999-1000)*rnd + 1000))

	cnumber = UCase(chr(random(0))&""&chr(random(1))&""&chr(random(2))&""&chr(random(3))&random(4))

	sql = "select count(idx) from coupon_mast where cnum = '"& cnumber &"'"
	Set rs=db.execute(sql)

	If rs(0) = 0 Then
	
		sql = "insert into coupon_mast (cnum,lidx,title,gu,end_date)values"
		sql = sql & "('" & cnumber &"'"
		sql = sql & "," & lidx
		sql = sql & ",'" & title &"'"
		sql = sql & "," & gu
		sql = sql & ",'" & end_date &"'"
		sql = sql & ")"
		db.execute sql,,adexecutenorecords

	rs.close
	End if
		
next


			Response.write "<script>"
If gu = 2 then
			Response.write "alert('단과수강 쿠폰 "& make2 &"장이 등록되었습니다.');"
Else
			Response.write "alert('패키지수강 쿠폰 "& make2 &"장이 등록되었습니다.');"
End if
			Response.write "self.location.href='coupon_list.asp?gu="& gu &"';"
			Response.write "</script>"
			Response.End
%> 
<!-- #include file = "../authpg_2.asp" -->