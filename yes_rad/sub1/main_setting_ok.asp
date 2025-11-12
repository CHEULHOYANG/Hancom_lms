<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/fso.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs
Dim mtitle1,mtitle2,mtitle3,mtitle4,mtitle5,mtitle6,mtitle7,mtitle8,mtitle9,mtitle10
Dim mlink1,mlink2,mlink3,mlink4,mlink5,mlink6,mlink7,mlink8,mlink9,mlink10

mtitle1 = request("mtitle1")
mtitle2 = request("mtitle2")
mtitle3 = request("mtitle3")
mtitle4 = request("mtitle4")
mtitle5 = request("mtitle5")
mtitle6 = request("mtitle6")
mtitle7 = request("mtitle7")
mtitle8 = request("mtitle8")
mtitle9 = request("mtitle9")
mtitle10 = request("mtitle10")

mlink1 = request("mlink1")
mlink2 = request("mlink2")
mlink3 = request("mlink3")
mlink4 = request("mlink4")
mlink5 = request("mlink5")
mlink6 = request("mlink6")
mlink7 = request("mlink7")
mlink8 = request("mlink8")
mlink9 = request("mlink9")
mlink10 = request("mlink10")

mtitle1 = Replace(mtitle1,"'","''")
mtitle2 = Replace(mtitle2,"'","''")
mtitle3 = Replace(mtitle3,"'","''")
mtitle4 = Replace(mtitle4,"'","''")
mtitle5 = Replace(mtitle5,"'","''")
mtitle6 = Replace(mtitle6,"'","''")
mtitle7 = Replace(mtitle7,"'","''")
mtitle8 = Replace(mtitle8,"'","''")
mtitle9 = Replace(mtitle9,"'","''")
mtitle10 = Replace(mtitle10,"'","''")

mlink1 = Replace(mlink1,"'","''")
mlink2 = Replace(mlink2,"'","''")
mlink3 = Replace(mlink3,"'","''")
mlink4 = Replace(mlink4,"'","''")
mlink5 = Replace(mlink5,"'","''")
mlink6 = Replace(mlink6,"'","''")
mlink7 = Replace(mlink7,"'","''")
mlink8 = Replace(mlink8,"'","''")
mlink9 = Replace(mlink9,"'","''")
mlink10 = Replace(mlink10,"'","''")

sql = "select count(*) from site_info"
Set rs=db.execute(sql)

If rs(0) = 0 then

	sql = "insert into site_info (mtitle1,mtitle2,mtitle3,mtitle4,mtitle5,mtitle6,mtitle7,mtitle8,mtitle9,mtitle10,mlink1,mlink2,mlink3,mlink4,mlink5,mlink6,mlink7,mlink8,mlink9,mlink10)values"
	sql = sql & "('" & mtitle1 & "'"
	sql = sql & ",'" & mtitle2 & "'"
	sql = sql & ",'" & mtitle3 & "'"
	sql = sql & ",'" & mtitle4 & "'"
	sql = sql & ",'" & mtitle5 & "'"
	sql = sql & ",'" & mtitle6 & "'"
	sql = sql & ",'" & mtitle7 & "'"
	sql = sql & ",'" & mtitle8 & "'"
	sql = sql & ",'" & mtitle9 & "'"
	sql = sql & ",'" & mtitle10 & "'"
	sql = sql & ",'" & mlink1 & "'"
	sql = sql & ",'" & mlink2 & "'"
	sql = sql & ",'" & mlink3 & "'"
	sql = sql & ",'" & mlink4 & "'"
	sql = sql & ",'" & mlink5 & "'"
	sql = sql & ",'" & mlink6 & "'"
	sql = sql & ",'" & mlink7 & "'"
	sql = sql & ",'" & mlink8 & "'"
	sql = sql & ",'" & mlink9 & "'"
	sql = sql & ",'" & mlink10 & "'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

Else

	sql = "update site_info set mtitle1 = '"& mtitle1 & "'"
	sql = sql & ",mtitle2 = '"& mtitle2 & "'"
	sql = sql & ",mtitle3 = '"& mtitle3 & "'"
	sql = sql & ",mtitle4 = '"& mtitle4 & "'"
	sql = sql & ",mtitle5 = '"& mtitle5 & "'"
	sql = sql & ",mtitle6 = '"& mtitle6 & "'"
	sql = sql & ",mtitle7 = '"& mtitle7 & "'"
	sql = sql & ",mtitle8 = '"& mtitle8 & "'"
	sql = sql & ",mtitle9 = '"& mtitle9 & "'"
	sql = sql & ",mtitle10 = '"& mtitle10 & "'"
	sql = sql & ",mlink1 = '"& mlink1 & "'"
	sql = sql & ",mlink2 = '"& mlink2 & "'"
	sql = sql & ",mlink3 = '"& mlink3 & "'"
	sql = sql & ",mlink4 = '"& mlink4 & "'"
	sql = sql & ",mlink5 = '"& mlink5 & "'"
	sql = sql & ",mlink6 = '"& mlink6 & "'"
	sql = sql & ",mlink7 = '"& mlink7 & "'"
	sql = sql & ",mlink8 = '"& mlink8 & "'"
	sql = sql & ",mlink9 = '"& mlink9 & "'"
	sql = sql & ",mlink10 = '"& mlink10 & "'"
	db.execute sql,,adexecutenorecords

End if


response.write"<script>"
response.write"alert('설정이 저장되었습니다.');"
response.write"self.location.href='main_setting.asp';"
response.write"</script>"
response.end

%>
<!-- #include file = "../authpg_2.asp" -->