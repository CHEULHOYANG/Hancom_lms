<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx : idx = Request("idx")
Dim sql,dr,isRecod,isRows,isCols,rs,rs1
Dim gbnS,strPart,strSearch,intpg,idxnum

intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")

sql = "select strnm,strteach,tinfo,icon,intprice,intgigan,categbn,teach_id,book_idx,group_idx,sub_title,mem_group,ordn,step_check,ca1,ca2,sajin from LecturTab where idx = "& idx
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else

	sql = "insert into LecturTab (strnm,strteach,tinfo,icon,intprice,intgigan,categbn,teach_id,book_idx,group_idx,sub_title,mem_group,ordn,step_check,ca1,ca2,sajin) values ('"
	sql = sql & Replace(rs(0),"'","''") & "','"
	sql = sql & Replace(rs(1),"'","''") & "','"
	sql = sql & Replace(rs(2),"'","''") & "','"
	sql = sql & Replace(rs(3),"'","''") & "',"
	sql = sql & rs(4) & ","
	sql = sql & rs(5) & ","
	sql = sql & rs(6) & ",'"
	sql = sql & Replace(rs(7),"'","''") & "','"
	sql = sql & Replace(rs(8),"'","''") & "',"
	sql = sql & rs(9) & ",'"& Replace(rs(10),"'","''") &"','"& Replace(rs(11),"'","''") &"',"& rs(12) &","& rs(13) &","& rs(14) &","& rs(15) &",'"
	sql = sql & Replace(rs(16),"'","''") & "'"
	sql = sql & ")"
	db.execute(sql)

	sql = "select isNull(Max(idx),0) from LecturTab"
	set dr = db.execute(sql)
	idxnum = dr(0)
	dr.close

	sql = "select strnm,ordnum,strtime,movlink,flshlink,lecsum,sumpath,lecsrc,srcpath,movlink1,movlink2,freelink,view_count,view_time,l_idx from sectionTab where l_idx = "& idx &" order by idx desc"
	Set rs1 = db.execute(sql)

	If rs1.eof Or rs1.bof Then
	Else
	Do Until rs1.eof

	sql = "insert into sectionTab (strnm,ordnum,strtime,movlink,flshlink,lecsum,sumpath,lecsrc,srcpath,movlink1,movlink2,freelink,view_count,view_time,l_idx) values ('"
	sql = sql & Replace(rs1(0),"'","''") & "',"
	sql = sql & rs1(1) & ",'"
	sql = sql & Replace(rs1(2),"'","''") & "','"
	sql = sql & Replace(rs1(3),"'","''") & "','"
	sql = sql & Replace(rs1(4),"'","''") & "','"
	sql = sql & Replace(rs1(5),"'","''") & "','"
	sql = sql & Replace(rs1(6),"'","''") & "','"
	sql = sql & Replace(rs1(7),"'","''") & "','"
	sql = sql & Replace(rs1(8),"'","''") & "','"
	sql = sql & Replace(rs1(9),"'","''") & "','"
	sql = sql & Replace(rs1(10),"'","''") & "','"
	sql = sql & Replace(rs1(11),"'","''") & "',"
	sql = sql & rs1(12) & ","
	sql = sql & rs1(13) & ","
	sql = sql & idxnum
	sql = sql & ")"
	db.execute(sql)

	rs1.movenext
	Loop
	rs1.close
	End if

rs.close
End if

response.redirect "dan_list.asp?intpg="& intpg &"&gbnS="& gbnS &"&strPart="& strPart &"&strSearch="& strSearch &""
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->