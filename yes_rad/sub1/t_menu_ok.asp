<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/fso.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs
Dim t_menu1,t_menu2,t_menu3,t_menu4,t_menu5,t_menu6,t_menu7,t_menu8,t_menu9,t_menu10
Dim t_menu_sub1,t_menu_sub2,t_menu_sub3,t_menu_sub4,t_menu_sub5,t_menu_sub6,t_menu_sub7,t_menu_sub8,t_menu_sub9,t_menu_sub10

t_menu1 = request("t_menu1")
t_menu2 = request("t_menu2")
t_menu3 = request("t_menu3")
t_menu4 = request("t_menu4")
t_menu5 = request("t_menu5")
t_menu6 = request("t_menu6")
t_menu7 = request("t_menu7")
t_menu8 = request("t_menu8")
t_menu9 = request("t_menu9")
t_menu10 = request("t_menu10")

t_menu_sub1 = request("t_menu_sub1")
t_menu_sub2 = request("t_menu_sub2")
t_menu_sub3 = request("t_menu_sub3")
t_menu_sub4 = request("t_menu_sub4")
t_menu_sub5 = request("t_menu_sub5")
t_menu_sub6 = request("t_menu_sub6")
t_menu_sub7 = request("t_menu_sub7")
t_menu_sub8 = request("t_menu_sub8")
t_menu_sub9 = request("t_menu_sub9")
t_menu_sub10 = request("t_menu_sub10")

sql = "select count(*) from site_info"
Set rs=db.execute(sql)

If rs(0) = 0 then

	sql = "insert into site_info (t_menu1,t_menu2,t_menu3,t_menu4,t_menu5,t_menu6,t_menu7,t_menu8,t_menu9,t_menu10,t_menu_sub1,t_menu_sub2,t_menu_sub3,t_menu_sub4,t_menu_sub5,t_menu_sub6,t_menu_sub7,t_menu_sub8,t_menu_sub9,t_menu_sub10)values"
	sql = sql & "('" & t_menu1 & "'"
	sql = sql & ",'" & t_menu2 & "'"
	sql = sql & ",'" & t_menu3 & "'"
	sql = sql & ",'" & t_menu4 & "'"
	sql = sql & ",'" & t_menu5 & "'"
	sql = sql & ",'" & t_menu6 & "'"
	sql = sql & ",'" & t_menu7 & "'"
	sql = sql & ",'" & t_menu8 & "'"
	sql = sql & ",'" & t_menu9 & "'"
	sql = sql & ",'" & t_menu10 & "'"
	sql = sql & ",'" & t_menu_sub1 & "'"
	sql = sql & ",'" & t_menu_sub2 & "'"
	sql = sql & ",'" & t_menu_sub3 & "'"
	sql = sql & ",'" & t_menu_sub4 & "'"
	sql = sql & ",'" & t_menu_sub5 & "'"
	sql = sql & ",'" & t_menu_sub6 & "'"
	sql = sql & ",'" & t_menu_sub7 & "'"
	sql = sql & ",'" & t_menu_sub8 & "'"
	sql = sql & ",'" & t_menu_sub9 & "'"
	sql = sql & ",'" & t_menu_sub10 & "'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

Else

	sql = "update site_info set t_menu1 = '"& t_menu1 & "'"
	sql = sql & ",t_menu2 = '"& t_menu2 & "'"
	sql = sql & ",t_menu3 = '"& t_menu3 & "'"
	sql = sql & ",t_menu4 = '"& t_menu4 & "'"
	sql = sql & ",t_menu5 = '"& t_menu5 & "'"
	sql = sql & ",t_menu6 = '"& t_menu6 & "'"
	sql = sql & ",t_menu7 = '"& t_menu7 & "'"
	sql = sql & ",t_menu8 = '"& t_menu8 & "'"
	sql = sql & ",t_menu9 = '"& t_menu9 & "'"
	sql = sql & ",t_menu10 = '"& t_menu10 & "'"
	sql = sql & ",t_menu_sub1 = '"& t_menu_sub1 & "'"
	sql = sql & ",t_menu_sub2 = '"& t_menu_sub2 & "'"
	sql = sql & ",t_menu_sub3 = '"& t_menu_sub3 & "'"
	sql = sql & ",t_menu_sub4 = '"& t_menu_sub4 & "'"
	sql = sql & ",t_menu_sub5 = '"& t_menu_sub5 & "'"
	sql = sql & ",t_menu_sub6 = '"& t_menu_sub6 & "'"
	sql = sql & ",t_menu_sub7 = '"& t_menu_sub7 & "'"
	sql = sql & ",t_menu_sub8 = '"& t_menu_sub8 & "'"
	sql = sql & ",t_menu_sub9 = '"& t_menu_sub9 & "'"
	sql = sql & ",t_menu_sub10 = '"& t_menu_sub10 & "'"
	db.execute sql,,adexecutenorecords

End if


response.write"<script>"
response.write"alert('설정이 저장되었습니다.');"
response.write"self.location.href='t_menu.asp';"
response.write"</script>"
response.end

%>
<!-- #include file = "../authpg_2.asp" -->