<% Session.CodePage = 949
Response.CharSet = "euc-kr"
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Expires","0"
''********************************************************************************************************************************************************
Sub sql_CheckInj

	Dim sql_injdata
	sql_injdata = "'|xp_cmdshell|exec|insert|select|delete|drop|backup|update|count|*|%|chr|mid|truncate|char|declare|sysobject|;|--|create"
	sql_injdata = sql_injdata & "|information_schema.tables|xp_|sp_|dtproperties|syscolumns|syscomments|sysdepends|sysfilegroups|sysfiles|sysfiles1"
	sql_injdata = sql_injdata & "|sysforeignkeys|sysfulltextcatalogs|sysfulltextnotify|sysindexes|sysindexkeys|sysmembers|sysobjects|syspermissions"
	sql_injdata = sql_injdata & "|sysproperties|sysprotects|sysreferences|systypes|sysusers|master.dbo.|master..|union|'or''='|'or1=1;--|<script|<object|<iframe|varchar(|exec("

	Dim sql_inj			: sql_inj = Split(sql_injdata,"|")
	Dim sql_get
	Dim sql_data
	if Not Request.Form = "" then
		For Each sql_get In Request.Form
			for sql_data = 0 to UBound(sql_inj)
if instr(1,Request.Form(sql_get),sql_inj(sql_data), vbTextCompare) > 0 then Response.End
			Next
		Next
	elseif Not Request.QueryString = "" then
		for Each sql_get in Request.QueryString
			for sql_data = 0 to UBound(sql_inj)
if instr(1,Request.QueryString(sql_get),sql_inj(sql_data), vbTextCompare) > 0 then Response.End
			Next
		Next
	end if
End Sub

Call sql_CheckInj	''sql 인젝션 처리

dim sql,rs,cnum,v_time,check_t

cnum = request("key")

'0	section번호		v_idx
'1	아이디			id
'2	v_sesstion값		
'3	oder_mast_idx값
'4	lecturbtab번호값	gang_idx
'5	v_time값	재생시간


if cnum = "" then response.end %>
<!-- #include file = "../include/dbcon.asp" -->
<%
cnum = split(cnum,"|")

If int(cnum(5)) = 0 Then

	Response.write "0"
	Response.End

End if

sql = "select strtime,view_time,view_count from SectionTab where idx=" & cnum(0)
set rs = db.execute(sql)

If rs.eof Or rs.bof Then

	Response.write "1"
	Response.End
	
Else

	check_time  = split(rs(0),":")
	check_time1 = (int(check_time(0)) * 60) + int(check_time(1))
	view_time = rs(1)
	view_count = rs(2)

rs.close
End If

If Int(view_time) > 0 Then

		sql = "select isnull(sum(v_time),0) from view_mast where id='"& cnum(1) &"' and v_idx = "& cnum(0) &""
		Set dr = db.execute(sql)

		If Int(dr(0)) > 0 then

			If Int(dr(0)) >= Int(view_time*60) Then
				
				Response.write "1"
				Response.end

			End if
			
		dr.close
		End If

End If

If Int(view_count) > 0 Then

		sql = "select count(idx) from view_mast where end_check = 1 and id='"& cnum(1) &"' and v_idx = "& cnum(0) &""
		Set dr = db.execute(sql)

		If Int(dr(0)) > 0 then

			If Int(dr(0)) >= Int(view_count) Then
				
				Response.write "1"
				Response.end

			End if
			
		dr.close
		End If

End If

sql = "select count(idx) from view_mast where end_check = 0 and id='" & cnum(1) & "' and v_idx = "& cnum(0) &" and order_mast_idx="& cnum(3) &""
Set dr = db.execute(sql)

If dr(0) = 0 then

	sql = "insert into view_mast (id,v_idx,v_time,v_date,ip,gang_idx,order_mast_idx,v_sesstion)values"
	sql = sql & "('" & cnum(1) & "'"
	sql = sql & ","& cnum(0)
	sql = sql & ","& cnum(5)
	sql = sql & ",'"& date() &"'"
	sql = sql & ",'"& Request.ServerVariables("REMOTE_ADDR") &"'"
	sql = sql & ","& cnum(4)
	sql = sql & ","& cnum(3)
	sql = sql & ","& cnum(2)
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

	Response.write "0"
	Response.end	

Else

	db.execute("update view_mast set v_time = "& cnum(5) &" where end_check = 0 and id='" & cnum(1) & "' and v_idx = "& cnum(0) &" and order_mast_idx="& cnum(3) &"")

dr.close
End if

sql = "select top 1 idx,v_time from view_mast where end_check = 0 and id='" & cnum(1) & "' and v_idx = "& cnum(0) &" and order_mast_idx="& cnum(3) &" order by idx desc"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
else

		If Int(rs(1)) >= Int(check_time1) Then

			db.execute("update view_mast set end_check = 1,v_time="& check_time1 &" where idx = "& rs(0) &" ")

			Response.write "1"
			Response.End
				
		End If

End if

Response.write "0"
Response.end	
%>