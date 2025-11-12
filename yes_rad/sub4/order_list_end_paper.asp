<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs,title,id,info1,info2,info3,info4,info5,info6,info7,info8,info9,info10
Dim idx
Dim link1,link2,link3,link4,link5,link6
Dim link1_etc,link2_etc,link3_etc,link4_etc,link5_etc,link6_etc
Dim gbnS,strsday,streday,strPart,strSearch,intpg

idx = request("idx")
intpg = request("intpg")
gbnS = request("gbnS")
strsday = request("strsday")
streday = request("streday")
strPart = request("strPart")
strSearch = request("strSearch")

sql="select link1,link2,link3,link4,link5,link6,link1_etc,link2_etc,link3_etc,link4_etc,link5_etc,link6_etc from end_paper_config"
set rs=db.execute(sql)

if rs.eof or rs.bof Then

	Response.write"<script>"
	Response.write"alert('수료증 세팅을 먼저 해주시기 바랍니다.');"
	Response.write"history.back();"
	Response.write"</script>"
	Response.End
	
Else

	link1 = rs(0)
	link2 = rs(1)
	link3 = rs(2)
	link4 = rs(3)
	link5 = rs(4)
	link6 = rs(5)
	link1_etc = rs(6)
	link2_etc = rs(7)
	link3_etc = rs(8)
	link4_etc = rs(9)
	link5_etc = rs(10)
	link6_etc = rs(11)

rs.close
End If

sql = "select id,titlen = dbo.LectuTitle(tabidx,buygbn),dbo.Memberjuminno1(id),dbo.MemberNm(id) from order_mast where idx = "& idx
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
	title = rs(1)
	id = rs(0)

	If link1 = "name" Then info2 = rs(3)
	If link1 = "jumin1" Then info2 = rs(2)
	If link1 = "lec" Then info2 = rs(1)
	If link1 = "etc" Then info2 = link1_etc

	If link2 = "name" Then info3 = rs(3)
	If link2 = "jumin1" Then info3 = rs(2)
	If link2 = "lec" Then info3 = rs(1)
	If link2 = "etc" Then info3 = link2_etc

	If link3 = "name" Then info4 = rs(3)
	If link3 = "jumin1" Then info4 = rs(2)
	If link3 = "lec" Then info4 = rs(1)
	If link3 = "etc" Then info4 = link3_etc

	If link4 = "name" Then info5 = rs(3)
	If link4 = "jumin1" Then info5 = rs(2)
	If link4 = "lec" Then info5 = rs(1)
	If link4 = "etc" Then info5 = link4_etc

	If link5 = "name" Then info6 = rs(3)
	If link5 = "jumin1" Then info6 = rs(2)
	If link5 = "lec" Then info6 = rs(1)
	If link5 = "etc" Then info6 = link5_etc

	If link6 = "name" Then info7 = rs(3)
	If link6 = "jumin1" Then info7 = rs(2)
	If link6 = "lec" Then info7 = rs(1)
	If link6 = "etc" Then info7 = link6_etc

rs.close
End If


info1 = ""
info8 = ""
info9 = ""
info10 = ""

title = Replace(title,"'","''")
info2 = Replace(info2,"'","''")
info3 = Replace(info3,"'","''")
info4 = Replace(info4,"'","''")
info5 = Replace(info5,"'","''")
info6 = Replace(info6,"'","''")
info7 = Replace(info7,"'","''")

sql = "insert into end_paper (title,id,info1,info2,info3,info4,info5,info6,info7,info8,info9,info10,files)values"
sql = sql & "('" & title &"'"
sql = sql & ",'" & id & "'"
sql = sql & ",'" & info1 & "'"
sql = sql & ",'" & info2 & "'"
sql = sql & ",'" & info3 & "'"
sql = sql & ",'" & info4 & "'"
sql = sql & ",'" & info5 & "'"
sql = sql & ",'" & info6 & "'"
sql = sql & ",'" & info7 & "'"
sql = sql & ",'" & info8 & "'"
sql = sql & ",'" & info9 & "'"
sql = sql & ",'" & info10 & "'"
sql = sql & ",''"
sql = sql & ")"
db.execute sql,,adexecutenorecords


Response.write "<script>"
Response.write "alert('수료증이 발급되었습니다.');"
Response.write "self.location.href='order_list.asp?intpg="& intpg &"&gbnS=" & gbnS & "&strsday=" & strsday & "&streday=" & streday & "&strPart=" & strPart & "&strSearch=" & strSearch &"';"
Response.write "</script>"
response.end

Function Tag2Txt(s)
		s = Replace(s,"'","''")
		s = Replace(s,"<","&lt;")
		s = Replace(s,">","&gt;")
		s = Replace(s,"&","&amp;")
		Tag2Txt = s
End Function
%> 
<!-- #include file = "../authpg_2.asp" -->